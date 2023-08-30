Title: Full stack Django on k8s
Date: 2023-08-29 10:59
Slug: full stack django on k8s
Author: Feng Xia

Assuming you already know k8s basics. This article is for deploying a
full stack application, in this case my beloved [stock analyzer][1] on
k8s. In particular I'll talk about how to migrate a _legacy_ system
like this onto a k8s based on my experience. This would give many
systems out there a clue of how to design a roadmap for such end
state.

# App's architecture

Nothing special here: backend mainly as API, frontend React, celery worker
assuming a redis queue, redis, and DB.

# Migration steps

The entire stack has been [`docker-compose`][2]. So the question is
how to migrate these dockers onto k8s? In my case, three components
are going onto k8s: frontend, backend, celery.

1. **Registry**. In development mode, docker images are usually built
   and stored on the local where the `docker-compose` is
   launched. This is not the case in k8s anymore. Essential difference
   is that **k8s does not build image**. It's to take the artifact
   from some registry and deploy. Therefore, for the two
   application-specific images &mdash; Django app and frontend, the
   images must be **built beforehand** and pushed to a registry. In
   our case I'm using a private Harbor. Harbor is deployed outside the
   k8s cluster. I'm assuming it has its own admin, storage, and so
   on. The integration point is a Harbor user/token for k8s to pull
   image from it. I'll cover this later.

2. **Django setting**. Need to parameterize some settings and read
   them from env. The env would be fed by container launcher just like
   the `env:` list in compose. There are two sets of envs &mdash; one
   sensitive info such as password, and one not sensitive. The former
   will be in k8s secret, the latter as configmap. Which settings to
   be parameterized is subjective. See section for mine.

3. **React dotnev**. Frontend dotenv is **not dynamic**. It's baked
   inside the built image. Thus, you must **decide on** a deployment
   strategy for the Django api service, and coordinate this w/
   frontend's dotenv. The strategy will determine the service's uri,
   which then is baked into frontend's image. Because the
   k8s-generated uri is rather dynamic, eg. namespace, service name,
   this coordination **must be done offline** before frontend can be
   deployed.

4. **Celery workers**. Image is the same as the Django app, only the
   `command` is different. Key is to scale its replica so we can
   control how quickly to drain a queue. You can play w/ the launch
   command `-Q summary,stock,statement,price,news -l INFO` to decide
   how you want to deploy these workers. For example, should they all
   be watching the same queue, or one for each? and the log level?

5. **Redis, DB**. I call these common services. They **don't have to
   live on the same cluster**. If they already exist somewhere else,
   migration can use them directly. In my case, I'm leaving DB outside
   the k8s, thinking service such as RDS or a dedicated DBA is better
   than me administrating a DB. Redis will be moved to k8s because
   it's used as a message broker. So it's transient in nature for
   me. But if you use it for data records, it may be better off just
   like RDS service. In other words, I'm expecting k8s cluster to
   scale of application, frontend, transient services, but leaving
   persisted data to a _professional_.

6. **Customer A,B,C, ingress**. Imagine this application is sold
   to multiple customers.

      1. Backend, frontend, and celery will be in a namespace, whereas
         redis service is shared.
      2. Backend API is exposed in k8s ingress, and further config is
         required to be **accessible from the internet** such as using
         an [external node LB][4]. Each api's url will be different,
         eg. `app.client-a.feng.local`, `app.client-b.feng.local`. In
         production this will be customer's full domain.
      3. The api's url will be baked into frontend image via dotenv.

# End state

After everything is done:

![](images/django%20fullstack%20on%20k8s.png)

# Harbor

You need to configure Harbor project and access to this project. Then
add the access info to k8s:

```shell
kubectl create secret docker-registry harbor \
  --docker-server=blah \
  --docker-username=blah \
  --docker-password=blah \
  --docker-email=blah
```

Then, in helm `values.yaml`, specify the image to use:

```yaml
image:
  repository: harbor.feng.local:9800/library/frontend_stock
  pullPolicy: Always  <== Use this is best practice!!!
  tag: "v1.1.0.beta"
```

## tag and push

To push an image to harbor:

1. List the docker images you have on the server/dev machine, `docker
   image ls`.
2. Tag an image: `docker tag e6bbf5e4d606
   harbor.feng.local:9800/library/frontend_stock:v1.0.0`:

      1. `e6...`: is the image digest
      2. `harbor.feng.local:9800`: the harbor server & port. You should
         be able to see the web UI by going to
         `https://harbor.feng.local:9800`.
      3. `library`: is a `project` inside harbor.
      4. `frontend_stock`: your image name, could be anything. In harbor
         this is called a `repository`.
      5. `v1.0.0`: image tag.

3. Then, `docker push
   harbor.feng.local:9800/library/frontend_stock:v1.0.0`, and watch
   the image uloaded to harbor.
4. Goto harbor to double check.

# Parameterize frontend docker

In order to bake dotenv into frontend image:

1. [`yarn install -D env-cmd`][5].
2. Update `package.json`: `"start": "env-cmd -f
   envs/$ENV... craco..."`, whereas we dotenv files are under the
   `envs/` folder. Also, parameter `$ENV` so that cli becomes
   `ENV=blah yarn start`. Same goes to `build:`.

        ```json
        "scripts": {
          "start": "env-cmd -f envs/$ENV craco start",
        },
        ```

3. Add `arg` to Dockerfile. There is a good [article][6] about ARG
   vs. ENV. To build, `docker build --build-arg BUILD_FOR=a_value...`.

        ```
        # build environment
        FROM node:16.15.1 as builder

        ARG NPM_TOKEN  <== private npm registry token
        ARG BUILD_FOR  <== env parameter

        ...

        # npmrc
        RUN echo "//npm.pkg.github.com/:_authToken=${NPM_TOKEN}" >> ~/.npmrc
        RUN echo "//npm.pkg.github.com/:_authToken=${NPM_TOKEN}" >> ~/.yarnrc
        ...

        # build
        RUN env-cmd -f envs/${BUILD_FOR} yarn run build  <== use env parameter
        ...
        ```

4. (optional) Add the same Dockerfile args to `docker-compose`. This
   is really for convenience and consistency so that using compose
   will achieve the same effect as above. To use, `BUILD_FOR=blah
   NPM_TOKEN=blah docker-compose up --build frontend`.

        ```yaml
        frontend:
          image: frontend_stock
          build:
            context: ./frontend
            dockerfile: ./Dockerfile
            args:
              BUILD_FOR: ${BUILD_FOR}
              NPM_TOKEN: ${NPM_TOKEN}
        ```

Now you can build the image, tag it, then push to harbor. However you
are earmarking the image to be client-A's vs. B's is your choice
&larr; different tag, different project, whatever. Docker tagging is
itself a topic which is not covered here.

# Django setting params

There are endless options to parameterize Django app. For my purpose a
few things worth highlighting here:

```python
DJANGO_DEBUG = bool(int(os.environ.get("DJANGO_DEBUG") or 0))
DATABASE = os.environ.get("MYSQL_DATABASE")
DEPLOY_TYPE = os.environ.get("DEPLOY_TYPE", "dev")
DB_USER = os.environ.get("DJANGO_DB_USER")
DB_PWD = os.environ.get("DJANGO_DB_PWD")
DB_HOST = os.environ.get("DJANGO_DB_HOST")
DB_PORT = os.environ.get("DJANGO_DB_PORT")
REDIS_HOST = os.environ.get("DJANGO_REDIS_HOST")
```

## redis

`REDIS_HOST` is used as `BROKER_URL = "redis://%s:6379/0" %
REDIS_HOST`, whereas the value follows the format
`<user>:<pwd>@<server>`. Default user for redis is **`default`**, and
there seems to [only possible to change password by this helm][7]. For
example:

```
default:blah@redis-master.redis.svc.cluster.local
```

**Be sure** to use the `redis-master` because celery will require a
`write` access. Other replicas are for read-only.

# Provide env from k8s

1. Save the values in two files. Keys should be the env's key, thus be
   sure it's the same as the Python code `os.env["blah"]` key.

        ```conf
        # configmap

        DJANGO_DEBUG=1
        MYSQL_DATABASE=
        DEPLOY_TYPE=dev
        DJANGO_DB_HOST=
        DJANGO_DB_PORT=

        # secret

        MYSQL_USER=
        MYSQL_PASSWORD=
        MYSQL_ROOT_PASSWORD=
        DJANGO_DB_USER=
        DJANGO_DB_PWD=
        DJANGO_REDIS_HOST=
        ```

2. Create configmap and secret from the files. Note the names
   `stock-backend-env` and `stock-backend-secret`. They will be used
   next.

        ```shell
        kubectl create configmap stock-backend-env \
          --from-env-file=config-dotenv \
          --namespace client-a

        k create secret generic stock-backend-secret \
          --from-env-file=secret-dotenv \
          --namespace client-a
        ```

3. In helm's `values.yaml`:

        ```yml
        env:
          configmap: stock-backend-env
          secret: stock-backend-secret
        ```

4. In helm's `deployment.yaml`, use `envFrom` in the container section:

        ```yml
        containers:
          - name: {{ .Chart.Name }}
            envFrom:  <== Import k8s configmap & secret as env!!!
            {{- with .Values.env.configmap }}
            - configMapRef:
                name: "{{- toYaml . }}"
            {{- end }}
            {{- with .Values.env.secret }}
            - secretRef:
                name: "{{- toYaml . }}"
            {{- end }}
        ```

# frontend helm

A few special considerations:

1. By default I'm disabling ingress. This is just an extra layer of
   protection against accident in deployment.

        ```yml
        ingress:
          enabled: false
        ```

2. Then, I create a `profiles/` folder to hold ingress profile for
   each client. For example, client A's will be
   `profiles/client-a.yaml` as:

        ```yml
        ingress:
          enabled: true
          className: "nginx"
          annotations:
            nginx.ingress.kubernetes.io/rewrite-target: /
          hosts:
            - host: client-a.blah.com  <== A's domain
              paths:
                - path: /
                  pathType: Prefix

          tls: []
        ```

Now when I deploy for A using and enable its ingress:

```
helm install stock-frontend helm \
  -n client-a \
  -f path/to/profiles/client-a.yaml \
```

# now, deploy for client A

By now I have three helms: backend api, celery, and frontend.

1. Create/pick a namespace, say `client-a`.
2. Create envs as configmap & secret.
3. Backend api. In order to override list value `ingress.hosts[0]`,
   you **must use -f path/to/values.yaml` &larr; this is a helm known
   limitation.

        ```shell
        helm install stock-backend-api helm-stock-backend-api \
          -n client-a \
          -f helm-stock-backend-api/values.yaml \
          --set "ingress.hosts[0].host=client-a.blah.com" \
          --set image.tag="blah"
        ```

4. Backend celery. Easy.

        ```shell
        helm install stock-backend-celery helm-stock-backend-celery \
          -n client-a \
          --set image.tag="blah"
        ```

5. Frontend.

        ```shell
        helm install stock-frontend helm \
          -n client-a \
          -f helm/profiles/client-a.yaml \
          --set image.tag="blah"
        ```

6. If using an external nginx as LB to cluster nodes, add a `server`
   block:

        ```conf
        server {
          server_name client-a.blah.com;

          location / {
            include /etc/nginx/proxy_params;
            proxy_pass http://k8s;
          }
        }
        ```

Reload the LB nginx, and visit `http://client-a.blah.com`. You should
be good to go.

[1]: https://fengxia41103.github.io/stock/#/
[2]: https://github.com/fengxia41103/stock/blob/dev/docker-compose.yml
[3]: {filename}/dev/fullstack%20deployment%20nginx%20dotenv.md
[4]: {filename}/dev/k8s%20lab.md
[5]: https://www.npmjs.com/package/env-cmd
[6]: https://vsupalov.com/docker-arg-env-variable-guide/#arg-and-env
[7]: https://artifacthub.io/packages/helm/bitnami/redis
[8]: https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/
