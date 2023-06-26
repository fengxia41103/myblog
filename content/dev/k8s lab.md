Title: k8s lab
Date: 2023-06-26 08:47
Slug: k8s lab
Author: Feng Xia

I'm surprised that no article is giving a clear setup of a home k8s lab
w/ a Linux host. So here it is.

# On Dev node

On your dev node, which is a machine outside k8s cluster
node. Assuming you have the following installed already:

1. Python and python `venv` module.

2. Ansible. Install it in a `venv`.

3. KVM stuff. See my dev's `kvm` project for details. You could also
   use any VM framework as long as you could create 3 VMs.

4. `ssh-keygen` to create SSH key. If you already have a previous one,
   you could either use the same key, or create a new one dedicated
   for automation by changing the default value below:

      ```shell
      Enter file in which to save the key (/home/fengxia/.ssh/id_rsa):
      ```
5. Create a `$HOME/.kube`.

6. Install `kubectl`. I may ansible this later as well. For now a
   manual process.

7. In Ansible working directory, dump a vanilla ansible config file:
   `ansible-config init --disabled > ansible.cfg`. Change the line
   `private_key_file=/home/fengxia/.ssh/id_rsa_auto` to point it to
   the SSH key we are to use for.

8. Install `helm`.

# Bootstrap k8s cluster

We bootstrap using ansible.

1. Start three VMs, one control node and two worker nodes. Write their
   IPs in the `hosts`. You could either use the `cloud-init` to bake
   in the SSH's pub key, or do `ssh-copy-id -i ~/.ssh/id_rsa_auto.pub
   fengxia@ip` to copy them manually. Test `ssh
   fengxia@ip` after that keys are working.

2. Run ansible: `ansible-playbook -i hosts bootstrap.yml`

3. On your dev node, `scp fengxia@ip:~/.kube/config ~/.kube/config` to
   copy the cluster config to the dev machine. IP could be any of the
   k8s nodes because the same config are on

# k8s storage

For local dev purpose, use server disks on worker nodes, aka. local
storage, for data persistence.

## provisioner

**Note** that there is no `kubectl` command to list installed
provisioners.

1. Add static provisioner helm repo:

      ```shell
      helm repo add \
        sig-storage-local-static-provisioner \
        https://kubernetes-sigs.github.io/sig-storage-local-static-provisioner

      helm repo update
      ```

2. Re-generate a provisioner config:

      ```shell
      helm template --debug \
         sig-storage-local-static-provisioner/local-static-provisioner \
         --version 1 \
         --namespace default \
         > local-volume-provisioner.generated.yaml`
      ```

3. Install or delete this provisioner:

      ```shell
      kubectl apply -f local-volume-provisioner.generated.yaml
      kubectl delete -f local-volume-provisioner.generated.yaml
      ```

## storage class

The `metadata.name` value is **important**.

```shell
kubectl apply -f storage-class.yml

# to list all storage classes
kubectl get sc

# to delete a storage class
kubectl delete sc <name>
```

## PV

Now create a PV which can be claimed by deployments.


```shell
kubectl apply -f pv.yml

# to list all PVs
kubectl get pv
```

**Note** that `helm uninstall` does not delete PVC nor the actual
data. You could observe it by watching the data mount,
eg. `/mnt/disks`. Essentially it is not yet observing PV's retention
policy `Delete`. Therefore, it's advised to manually delete PVC first,
then delete PV, then `rm -r /mnt/disks/data`, if data cleanup is
needed.

```shell
# to delete a PV
kubectl delete pv <name>

# delete by force
kubectl delete pv local-pv-20g --grace-period=0 --force

# clear etcd record
kubectl patch pv local-pv-20g -p '{"metadata": {"finalizers": null}}'
```

# Deploy an app

This is easy w/ helm. You can set custom configs using a `values.yml`
file, eg. `wordpress-values.yml` in this case to specify the mariadb's
`storageClass`. It's deeply nested YAML structure, no fun if typing in
cmd.

```shell
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# install w/ customized config values
helm install -f wordpress-values.yml happy-panda bitnami/wordpress

# uninstall
helm uninstall happy-panda

# if setting configs on CLI:
helm install happy-pada bitnami/wordpress \
  --set mariadb.primary.persistence.enabled=true \
  --set mariadb.primary.persistence.storageClass=local-storage \
  --set mariadb.primary.persistence.size=20Gi \
  --set persistence.enabled=false
```

# Expose an app

There are two ways, both use nodeport. But who is behind the nodeport
is different. In the first method, the app itself is listenning a
nodeport, and in the 2nd method an ingress controller is.

## Nodeport directly

1. Get the name of your app service w/ `kubectl get svc`:

         ```
         NAME                                                  TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
         happy-panda-mariadb                                   ClusterIP      10.102.33.53    <none>        3306/TCP                     2d19h
         happy-panda-wordpress                                 LoadBalancer   10.97.29.91     <pending>     80:31142/TCP,443:30121/TCP   2d19h
         kubernetes                                            ClusterIP      10.96.0.1       <none>        443/TCP                      3d22h
         ```

2. You see the `80:31142` and `443:30121`. It's read as `<container
   port>:<node port>`. So this service is mapped to node port `31142`
   for http and `30121` for https. You can further confirm this w/
   `kubectl describe svc <svc name>`:

        ```
        ➜  ~ kubectl describe svc happy-panda-wordpress
        Name:                     happy-panda-wordpress
        Namespace:                default
        Labels:                   app.kubernetes.io/instance=happy-panda
                                  app.kubernetes.io/managed-by=Helm
                                  app.kubernetes.io/name=wordpress
                                  helm.sh/chart=wordpress-16.1.18
        Annotations:              meta.helm.sh/release-name: happy-panda
                                  meta.helm.sh/release-namespace: default
        Selector:                 app.kubernetes.io/instance=happy-panda,app.kubernetes.io/name=wordpress
        Type:                     LoadBalancer
        IP Family Policy:         SingleStack
        IP Families:              IPv4
        IP:                       10.97.29.91
        IPs:                      10.97.29.91
        Port:                     http  80/TCP
        TargetPort:               http/TCP
        NodePort:                 http  31142/TCP   <=== here
        Endpoints:                10.244.2.18:8080
        Port:                     https  443/TCP    <=== here
        TargetPort:               https/TCP
        NodePort:                 https  30121/TCP
        Endpoints:                10.244.2.18:8443
        Session Affinity:         None
        External Traffic Policy:  Cluster
        Events:                   <none>
        ```

3. Now w/ nodeport available, you could directly go to `http://<any node's
   IP>:31142` to see the app. The IP could be any of the cluster
   nodes, control plane or worker nodes, all the same.

The cons of this method is obvious &mdash; you need to keep a book of
all the apps and their nodeport assignments. If an application is
uninstalled and redeployed, its ports will change. This will be
especially so if k8s cluster is used for CICD purpose because
deployment happens dynamically in this case, thus port assignments
would be quite difficult to track.

Another con is that the number of apps deployed will be limited by the
number of ports (default port range `30000-32267`). This doesn't seem
to be an issue for small footprints, but will definitely a scalability
bottleneck for some good size deployment.

Last, if each app is listenning on a nodeport, it creates a large
attack surface in security. Essentially node/server must expose these
ports.

## ingress w/ an external LB

![](images/k8s%20expose%20app%20lb.png)


A better way is to deploy an ingress controller as a central
gate. Ingress comes w/ more features such as telemetry so it's
definitely the way to go.

1. Install nginx, `helm install my-ingress
   ingress-nginx/ingerss-nginx`.

2. Create a `ingress.yml` and create an ingress rule. The key is
   `ingressClassName` must be `nginx`, and `backend.service.name` be
   your app's service, in this case `happy-panda-wordpress`. Value for
   the `host` and `path` will be explained later.


        ```yml
        ---
        apiVersion: networking.k8s.io/v1
        kind: Ingress
        metadata:
          name: wp
          namespace: default
        spec:
          ingressClassName: nginx
          rules:
            - host: wp.myk8s.local
              http:
                paths:
                  - path: /
                    pathType: Prefix
                    backend:
                      service:
                        name: happy-panda-wordpress
                        port:
                          number: 80

        ```

      You can install `kubectl apply -f`, and delete `kubectl delete
      ingress wp` any number of times. No harm. I think behind the
      scene it adds a nginx rule and loads it automatically.

3. Find the nodeport this ingress is listenning: `kubectl describe svc
   my-ingress-nginx-ingress-controller`.

Now you need an **external load balancer**. This will be on your dev
node using a nginx.

1. Create a subdomain `wp.myk8s.local` in `/etc/hosts` w/ IP of `.1`
   (this IP needs to be the IP this dev node on the cluster nodes'
   network). We are using this dev node as a LB and DNS.

        ```
        # /etc/hosts

        192.168.122.1   myk8s.local wp.myk8s.local
        ```

2. Setup LB. The `upstream` block defines the load balancing
   act. Default is round-robin. The key is `server_name` which must
   match the DNS record above.

        ```conf
        upstream k8s {
            server 192.168.122.191:32536;   <== cluster node IP & ingress node port
            server 192.168.122.153:32536;
            server 192.168.122.172:32536;
        }

        server {
          server_name wp.myk8s.local;  <== dev's

          location / {
            proxy_pass http://k8s;
            proxy_redirect off;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";

            proxy_redirect off;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Host $host;

            # disable caching
            add_header Last-Modified $date_gmt;
            add_header Cache-Control 'no-store, no-cache';
            if_modified_since off;
            expires off;
            etag off;
          }
        }
        ```

3. Now on your dev node, `http://wp.myk8s.local`. Enjoy.

## load balancing

k8s document quotes this a way to expose a deployment. However, this
is rather confusing because it's assuming a _cloud provider_ who then
assigns an **external IP** to the ingress controller. This is not how
a home lab dev node will be! Then somewhere it says something about
ingress controller being load balancer, or kubectl proxy being load
balancer... ?

Frist of all, there are three layers of load balancing: of the nodes,
of service, and of the pods. Request hits the server/node
eventually.

Balancing the nodes. So between outside world and the k8s cluster,
requests are balanced among nodes. This, of course, assumes these
nodes being **logically identical**, which is exactly how the ingress
nodeport can achieve!  Perfect. We set up an external nginx to do
this. This makes the nodeport of the ingress controller the only info
exposed to the outside world.

Balancing the services. Once the ingress controller receives the call,
it uses the ingress rules to know which service this is for by using
the `hostname` match, eg. `wp.myk8s.local`, then routes the
call. Here, the usage of _balance_ is different. You can spin up v1
and v2 of the same application but under different service name, then
ingress can now be used to route some pcnt of traffic to v1 vs. v2. Of
course, you could also spin up the same application over and over
under different service name and have them _routed/balanced_, but I
don't see a point here because of the next one.

Balancing the pods. There are number of pods behind a service. k8s is
doing the balance. So a call to a service will be automatically
balanced among the number of pods behind the scene. This is k8s
internal now, and is not of our concern anymore.

# Troubleshooting

## Reinstall Wordpress helm, service shows 503 unavailable

First of all, `helm uninstall` does not clean up PVC! This is a known
issue, and I have seen github feature request threads.

I think the cause is the local storage I'm using in lab. After `helm
uninstall`, the next `helm install` would show the web service can't
connect to DB, and DB service shows no node have `pv` meeting its
requirement.

To clean this up:

1. Clean up PVC: `kubectl get pvc`, then `kubectl delete pvc <name>`.
2. Clean up PV: `kubectl delete pv <name>`.
3. Recreate PV: `kubectl apply -f pv.yml`.

In an extreme case, also login worker nodes and delete the static
storage folders `rm -r ...`, then `mkdir ..` again. This, of course,
will result in data loss.

# Commands

To list cluster nodes' IP:

```
kubectl get nodes -o json | jq -rc '.items[].status.addresses[] | (select (.type == "Hostname" or .type == "InternalIP") | .address)'
```
