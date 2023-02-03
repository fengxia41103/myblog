Title: New Dev
Date: 2022-03-29 14:50
Tags: dev
Slug: lucidum new dev
Author: Feng Xia
Status: Draft

# Online tool accounts

Make sure the get the `email` first because all followings would
either send an confirmation email to you, or can use the Offcie365 oauth.

1. email & calendar: office365
2. github to code repo (can your existing username, must set up 2-factor authentication)
3. VPN
4. zoom
5. slack
6. AWS access ID & key, AWS CLI, then `aws configure`
7. Atlassian Confluence
8. Atlassian Jira

# Configure AWS CLI

All build resources and test VMs are on AWS. Once you have the AWS
access ID & key, follow [AWS official
doc](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-config)
to setup the AWS cli:

```shell
$ aws configure
AWS Access Key ID [None]: <your ID>
AWS Secret Access Key [None]: <your key>
Default region name [None]: us-west-1 <-- use this!
Default output format [None]: json
```

On Linux, the values are saved in `.aws/config` and `./aws/recentials`.

# Configure AWS profiles w/ SSO

Assuming you have the AWS SSO already.

The easiest way to configure your profile is using
[aws-sso-util](https://github.com/benkehoe/aws-sso-util).

`aws-sso-util configure populate --region us-east-1
--existing-config-action keep`

This will populate your `.aws/config` with all the profiles you have
permission. You should see something like this in `.aws/config`:

```
[profile Network-Infra.Administrator]
sso_start_url = https://d-xxxx.awsapps.com/start
sso_region = us-east-1
sso_account_name = Network Infra
sso_account_id = xxxxx
sso_role_name = Administrator
region = us-west-1
credential_process = aws-sso-util credential-process --profile Network-Infra.Administrator
sso_auto_populated = true

```

With this, you can use
[aws2-wrap](https://github.com/linaro-its/aws2-wrap) to execute aws
command using any profile available to you using `aws2-wrap --profile
<profile> aws s3 cp ...`. See below "Release" section for examples.

## Find a valid EC2 instance

To search for an image by release version, eg. `V3.0.0` and get IPs:


To get a private IPs and version:

```shell
aws ec2 describe-instances \
  --region us-west-1 \
  --filters "Name=tag:owner,Values=devops-pipelines" \
  --filters "Name=instance-state-name,Values=running" \
  --filters "Name=tag:status,Values=ready" \
  --query 'Reservations[*].Instances[*].[PrivateIpAddress, [Tags[?Key==`product-version`].Value][0],[Tags[?Key==`repo-branch-name`].Value][0],[Tags[?Key==`last-upgraded-at`].Value][0]]' \
  --output table
```

## Find an image

To find an AMI images from dev. Replace the version and date string
to narrow down your search.

```shell
aws ec2 describe-images \
  --region us-west-1 \
  --filters "Name=tag:Name,Values=lucidum*-V3.1.0-2022-05-27*" \
    "Name=tag:owner,Values=devops-pipelines" \
    "Name=state,Values=available" \
  --query 'Images[*].[Name, ImageId]' \
  --output table

```

To find an release AMI in `us-east-1`. Replace the version
to narrow down the search:

```shell
aws ec2 describe-images \
  --region us-east-1 \
  --filters "Name=tag:product_version,Values=V3.1.0*" \
    "Name=tag:owner,Values=devops-pipelines" \
    "Name=tag:department,Values=eng" \
  --query 'Images[*].[Name, ImageId]' \
  --output table
```

To find an OVA image that have uploaded to S3 for release:

```shell
aws s3 ls s3://packer-ami-pipelines-ubuntu18-vmdk/release/lucidum-V3.1.0*/

Example output:

   PRE lucidum-V2.8.0-2022-01-14-08-32-02/
   PRE lucidum-V2.8.2/
   PRE lucidum-V2.8.3/
   PRE lucidum-V2.8.4/
   PRE lucidum-V3.0.0/
   PRE lucidum-V3.0.1/
2022-01-19 10:33:29          0
```

then you list the images:

```shell
aws s3 ls
s3://packer-ami-pipelines-ubuntu18-vmdk/release/lucidum-V3.1.0/

Example output:

2022-04-14 09:45:38 6655836160 export-i-0afea4e78f7c98bf6.ova
```

## Find default passwords

Replace the version to narrow down the search.

```shell
aws ssm describe-parameters \
  --region us-east-1 \
  --parameter-filters "Key=Name,Option=Contains,Values=v3.1.0" \
  --query "Parameters[*].[Name,LastModifiedDate]" \
  --output table
```

# SSH to AWS

1. Login VPN
2. Check AWS parameter store for the private key `*.pem`.
3. Save local to a file.
4. **MUST**: `chmod 600 <your key>.pem`
5. `ssh -i <path to pem> ubuntu@<remote host IP>`

# Use an virtual appliance locally as kvm

1. Download an `.ova` image from our S3.
2. Find the matching SSH and admin pwd.
3. Extract disk image file (`.vmdk`): `tar xvf <your image>.ova`
4. Convert `.vmdk` to `.qcow2`: `qemu-img convert -O qcow2
   <the disk image from OVA>.vmdk <your>.qcow2`
5. Launch `<your>.qcow2`.
6. Browse to `https://<kvm's ip>`.

If you launch > 1 instances, the `netplan` config in the image will
result in instances acquiring the same IP! To change that:

1. SSH to your instance.
2. Replace `/etc/netplan/50-cloud-init.yaml` with contents:

      ```yaml
      network:
          ethernets:
              ens3:
                  dhcp4: true
                  dhcp-identifier: mac <--- ADD THIS LINE!
                  match:
                      macaddress: 02:00:00:f8:b2:a5
                  set-name: ens3
          version: 2
      ```
3. Restart net: `sudo netplan apply`.

# Release process

## Images, Release notes

1. Check Jenkins pipeline to make sure each component has no error in
   build.
2. Create Jira `Cut release 123` and assign to myself.
3. `lucidum-deploy` create branch w/ Jira number.
4. Login as `aws sso login --profile=lucidum.Administrator`
5. Get sts `aws sts get-caller-identity --profile lucidum.Administrator`
6. Run `aws2-wrap --profile lucidum.Administrator python
   aws/update_versions_in_json.py <V3.2.0>` to update master JSON in place.
7. Raise PR and ping component owners to confirm version no.
8. After PR is merged, follow the [confluence
   page](https://luciduminc.atlassian.net/wiki/spaces/DEVOPS/pages/1509589018/Release+Process):

   1. Run Jenkins pipeline [`create-instance`](http://172.16.200.173:8080/job/image-builders/job/aws-create-instance/) w/ `create SaaS image` as
      `post_action`. This will build a SaaS AMI image.
   2. Run the same pipeline w/ `create image` as `post_action`. This
      will create a OVA AMI image.
   3. Go to logs of the SaaS image one, find the instance IP,
      `172....`, then find the SaaS image UI admin pwd under `lucidum`
      account, `us-west-1`, search by `V3.2.0-20220-07-13`:

         ```shell
         aws2-wrap --profile lucidum.Administrator \
         aws ssm describe-parameters \
         --region us-west-1 \
         --parameter-filters "Key=Name,Option=Contains,Values=V3.2.0-2022-07-13" \
         --query "Parameters[*].[Name,LastModifiedDate]" \
         --output table
         ```


   4. Login the UI and check out connector run status. All should
      be successful.

   5. Find two AMI image IDs in `us-west-1`, one SaaS and one OVA:

         ```shell
         aws2-wrap --profile lucidum.Administrator \
         aws ec2 describe-images \
           --region us-west-1 \
           --filters "Name=tag:Name,Values=lucidum*-V3.1.0-2022-05-27*" \
             "Name=tag:owner,Values=devops-pipelines" \
             "Name=state,Values=available" \
           --query 'Images[*].[Name, ImageId]' \
           --output table
         ```

   6. Run Jenkins pipeline
      [aws-release-image](http://172.16.200.173:8080/job/image-builders/job/aws-release-image/),
      give the AMI ID, one for OVA image and one for SaaS image.

   7. Verify `us-east-1` now has two AMI images:

         ```shell
         aws2-wrap --profile lucidum.Administrator \
         aws ec2 describe-images \
           --region us-east-1 \
           --filters "Name=tag:product_version,Values=V3.1.0*" \
             "Name=tag:owner,Values=devops-pipelines" \
             "Name=tag:department,Values=eng" \
           --query 'Images[*].[Name, ImageId]' \
           --output table
         ```

   8. Verify S3 has **one** OVA image:

         ```shell
         aws2-wrap --profile lucidum.Administrator \
         aws s3 ls s3://packer-ami-pipelines-ubuntu18-vmdk/release/lucidum-V3.1.0/
         ```

         Default object name is sth like
         `export-i-0a792847a18264155.ova`, goto S3 and rename this
         _object_
         to `lucidum-3.1.0-webapp-amd64.ova`

   9. Verify `us-east-1` parameter stores has **8** passwords:

         ```shell
         aws2-wrap --profile lucidum.Administrator \
         aws ssm describe-parameters \
           --region us-east-1 \
           --parameter-filters "Key=Name,Option=Contains,Values=v3.1.0" \
           --query "Parameters[*].[Name,LastModifiedDate]" \
           --output table
         ````

   10. Compose a release note use the template below:

          ```markdown
          **********************************
          Product Release Announcement
          **********************************

          # Version

          V3.1.0

          # Date

          May 27th, 2022


            # Resource

            - AMI image ID: `ami-0a8c791bb0807afe9` in `us-east-1`
            - OVA image:
            s3://packer-ami-pipelines-ubuntu18-vmdk/release/lucidum-V3.1.0/lucidum-3.1.0-webapp-amd64.ova

            - Default passwords

                - [UI Admin password](https://us-east-1.console.aws.amazon.com/systems-manager/parameters/lucidum-deploy/aws/lucidum-V3.1.0/admin-password/description?region=us-east-1&tab=Table)
                - [DB password](https://us-east-1.console.aws.amazon.com/systems-manager/parameters/lucidum-deploy/aws/lucidum-V3.1.0/db-password/description?region=us-east-1&tab=Table)

                - [Airflow Admin password](https://us-east-1.console.aws.amazon.com/systems-manager/parameters/lucidum-deploy/aws/lucidum-V3.1.0/airflow-password/description?region=us-east-1&tab=Table)

                - [SSH password](https://us-east-1.console.aws.amazon.com/systems-manager/parameters/lucidum-deploy/aws/lucidum-V3.1.0/ssh-password/description?region=us-east-1&tab=Table)

            - Product component versions:
              [V3.1.0.json](https://github.com/LucidumInc/lucidum-deploy/blob/main/lucidum-product-release-versions-V3.1.0.json)

            - Release note:
              [confluence](https://luciduminc.atlassian.net/wiki/spaces/MVPV1/pages/1588199425/Lucidum+Version+3.1.0+JIRA+Filters)

            - Release tag for ECR docker images: release-V3.1.0

            **********************************
            ```

      10. Put the announcement note to `software-dev` and `eng-chat` channel.
      11. Update customer manager presign url.

## Code version, tag

After the release has been announced, we consider the release to be
now **official**. We thus earmark the application code and test code
with this release.

There are four repositories to be considered:

1. [UI library](https://github.com/LucidumInc/ui-library "UI library")
2. [frontend](https://github.com/LucidumInc/mvp1_frontend/)
3. [backend](https://github.com/LucidumInc/mvp1_backend)
4. [integration test](https://github.com/LucidumInc/integration-test)

For the following discussions, assuming:

- previous official release version was `3.2.5`
- this release was `3.3.0`

### UI library, frontend, backend

These three repositories follow the same git branch strategy &mdash;
there is a `V3.3.0` branch as the development main, and the release
`3.3.0` was cut from the **HEAD** of this branch.

1. Check the `version:` value in `package.json`. For example,
   `"version": "3.2.5"` as in the UI library. The value should be a
   valid semantic version syntax. Prerelease/alpha strings are valid
   such as "3.2.5-dev.123". The `major`, `minor`, and `patch` values
   are important.

2. Create a feature branch from `V3.3.0`. This is necessary because
   our branch protection rule requires a PR to modify
   `V3.3.0`. Alternatively, one could turn off this protection
   **temporarily**, operate directly on `V3.3.0` branch, and `git
   push` the changes to upstream.

3. Run `yarn release:<major/minor/patch>` CLI:

      - major: will bump version from `3.2.5` &rarr; `4.0.0`
      - minor: will bump version from `3.2.5` &rarr; `3.3.0`
      - patch: will bump version from `3.2.5` &rarr; `3.2.6`


4. Check the git log. The CLI above created one commit with two files
   changed: `CHANGELOG.md` and `package.json`. In addition, there is
   new git tag `v3.3.0` on this commit.

5. CLI will prompt you to push the change w/ tag. **Don't**. The tag,
   even pushed, will be lost because we enforce PR merge using
   `rebase` and will delete the source branch after, thus the original
   commit associated with this tag will be deleted, leaving the tag
   invalid. A `git push` to feature branch is sufficient.

5. Raise a PR from `feature` &rarr; `V3.3.0`.

6. After the PR is merged, check the `CHANGELOG.md` and `package.json`
   on `V3.3.0`. The `"version":` should now be `3.3.0`.

7. On the `HEAD` of `V3.3.0`, create a git tag `v3.3.0`. At this
   point, the release `3.3.0` code has been earmarked. From this point
   on, we keep the `V3.3.0` branch as a _maintenance
   branch_. Optionally we can remove this branch and create it from
   the tag if needed._

8. Modify `github` `settings/Branches/Pull Requests` to `Allow merge
   commits`. This is necessary so the following PRs will not force
   changes onto the source branch, which will be the `V3.3.0`.

9. Raise a PR from `V3.3.0` to `master`. **Must** select merge type to
   be `merge commits` instead of `rebase`! If we have conflicts at
   this step, it is a signal that there have been changes on `master`
   which were not available in the `3.3.0` release. These changes are
   usually _hotfixes_, thus should have been merged from `master`
   &rarr; `V3.3.0` before cutting the release. Now it is too late to
   revert the entire process, but should be a reminder for the next
   round.

10. After the PR is merged, check the `CHANGELOG.md` and `package.json`
   on `master`. The `"version":` should now be `3.3.0`. In addition,
   check the git tag `v3.3.0`, which should be on `master`, also.

11. If there were another development main, for example, `V4.1.0`,
    that has been existing prior to this release, **rebase** `V4.1.0`
    onto `master`, and notify all developers to:

      - Delete their local `4.1.0` branch
      - `git checkout origin/V4.1.0 -b V4.1.0`
      - Rebase any local `4.1.0` feature branch onto the new `V4.1.0`,
        and update the corresponding upstream feature branches w/ a `git
        push --force`. If there were any V4.1.0 PR in progress, go to
        the PR page and double-check the commit history that it
        includes only the feature changes intended.

12. If there is going to be a new development main, for example, the
    next release is `5.0.0`, create a branch `V5.0.0` from `master`
    `HEAD`.

## Jenkinsfile

Once a staging branch for the next release, eg. `V4.1.0`, has been
created, we now need to update the Jenkinsfiles so that defaults are
pointing to the correct branch. This is necessary because some Jenkins
pipelines are _chained_, which will then use the default value for the
run. So a mismatching default branch values will cause the run to
fail.

### frontend

Set the `defaultValue` of these lines:

```java
string(name: 'WEB_VERSION', defaultValue: 'V4.1.0', ...)
string(name: 'UILIB_VERSION', defaultValue: 'V4.1.0', ...)
string(name: 'INTEGRATION_VERSION', defaultValue: 'V4.1.0', ...)
string(name: 'PRODUCT_VERSION', defaultValue: 'V4.1.0', ...)
````

### backend

Set the `defaultValue` of these lines:

```java
string(name: 'FRONTED_PROJECT_BRANCH', defaultValue: 'V4.1.0', ...)
string(name: 'UI_LIB_PROJECT_BRANCH', defaultValue: 'V4.1.0', ...)
string(name: 'INTEGRATION_TEST_BRANCH', defaultValue: 'V4.1.0', ...)
string(name: 'PRODUCT_VERSION', defaultValue: 'V4.1.0', ...)
```

### cypress

Set the `defaultValue` of these lines:

```java

string(
    name: 'BRANCH',
    defaultValue: 'V4.1.0',...)
```


## Update cypress docker

Cypress test is run inside a docker, which means any change in the
`package.json` requires a rebuild of docker image. This then
propagates to pipeline/Jenkinsfile which uses this docker because the
version is changed &rarr; version is used as the image tag.

To update cypress base image:

1. Copy `package.json` from `integration-test/ui` to
   `image-builder-base/cypress-base`.
2. Copy `cypress.config.js` from `integration-test/ui` to
   `image-builder-base/cypress-base`.
3. Bump version in `image-builder-base/cypress-base/version.json`.
4. Push the change and raise a PR.
5. Goto [Jenkins
   image-builder-base](http://172.16.200.173:8080/job/CI-jobs/job/image-builder-base/),
   click the `Scan Multiple Pipeline Now`. New branch should now be
   built.

To update pipelines that use the cypress image:

1. In `integration-test/ui/uiTest.jenkinsfile`, replace
   `cypress-base-<version>`:

```
docker.withRegistry('https://shirecoretestacr.azurecr.io', 'acr-access-key') {
    sh " \
    export CYPRESS_screenshotOnRunFailure=${params.SCREENSHOT} && \
    docker run --rm \
            -v ${env.WORKSPACE}/ui/cypress:/e2e/cypress \
            -w /e2e -e CYPRESS_screenshotOnRunFailure \
            -e CYPRESS_baseUrl=${params.WEB_ROOT} \
            -e CYPRESS_username=${params.USERNAME} \
            -e CYPRESS_password=${params.PASSWORD} \
            -e CYPRESS_getFieldsUrl='${params.BACKEND_GETFIELDS_URL}' \
            -e CYPRESS_booleanField='${booleanField}' \
            -e CYPRESS_strField='${strField}' \
            -e CYPRESS_listField='${listField}' \
            -e CYPRESS_dateField='${dateField}' \
            -e CYPRESS_numberField='${numberField}' \

            shirecoretestacr.azurecr.io/cypress-base:1.0.3 \ <== HERE!!!

            --config defaultCommandTimeout=20000,requestTimeout=20000 \
            --browser chrome \
            --spec '${params.SPEC}' \
    "
}
```

# Connector API Testing on the Customer Server

1. Create a new connector API dev branch, e.g., V3.2.0-StatusCake
2. Develop the connection codes under the dev branch: connection class, yml file
   under the external/configs folder, and source-mapping.json
3. Deploy the dev Docker image to the customer server: python update_manager.py
   installecr -c connector-api:V3.2.0-StatusCake
4. Run the dev docker container: docker run --network=lucidum_default -it
   connector-api:V3.2.0-StatusCake bash
5. Run the config-to-db command under the dev docker container: ./lucidum_api
   config-to-db
6. Ask customer to enter the connector configs under the web UI
7. Develop the data codes under the dev branch: data class, send some sample API
   responses to data scientists for mappings and logic
8. Update the dev Docker image on the customer server: python update_manager.py
   installecr -c connector-api:V3.2.0-StatusCake
9. Create a PR from the dev branch into the release branch
10. Run build command under the dev docker container: e.g., ./lucidum_api build
    statuscake-ssl
11. Paste the build outputs from Step 8 into the PR
12. Two senior engineers review the PR. If everything is good and approved,
    merge the PR
13. Deploy the Docker image from the release branch to the customer server (make
    sure to use the update manager with -u parameter): python update_manager.py
    installecr -c connector-api:V3.2.0.** -u
14. Delete the dev Docker image: docker rmi connector-api:V3.2.0-StatusCake

# Creating instance from AMI

AMI images generated by pipeline are in `lucidum` `us-west-1`. Below
are key configurations:

1. key pair: `lucidum-test`
2. VPC: `test-vpc`
3. Subnet: `test_private_subnet1`
4. Select existing security group: `App-security-group`
5. Instance type: `t3a.xlarge`
6. Advance details: enable `request spot instance`

# SaaS Networking path


Networking path describes the path from SaaS user's browser to a
Tenant.

![](./images/networking%20path.png)

Overall the networking traffic go through:

1. In route53, resolve DNS, eg. `v310.dev.lucidum.net/...`.
2. Check w/ WAF rules.
3. If passing WAF, load balancer has two rules:
      * all going to port 80 is redirected to port 443, and
      * for port 80, depending on the target host name, eg. `v310.dev...`,
        redirect to a target group.
4. Target group is linked to a Tenant/EC2. Each has **one** registered
   target, which is the EC2's instance. It can later register multiple
   instances, thus achieving load balancing.

There are two sets of resources basically, some that are per-Tenant
basis, and some are fundamental or shareable.

## Per-tenant

Per-tenant resources are fully managed by the
`saas-provisioning-svc`. This includes:

1. Route53 FQDN record
2. Load balancer listerner for port 443 rule
3. A new EC2
4. A new target group pointing to this EC2

To run the server:

```shell
aws2-wrap --profile SaaS-Dev.Administrator \
  go run cmd/server/main.go \
  -conf=./config.dev.yaml
```

Then the service will be listenning on localhost port `1337`.

## Common resources

Common resources including are managed by
`saas-tenant-account-iac`. This includes:

1. HTTPS certificate
2. DNS and general ingress rules
3. WAF rule sets

To change any, run:

```shell
go install github.com/go-task/task/v3/cmd/task@latest
aws2-wrap --profile SaaS-Dev.Administrator task tf:init
aws2-wrap --profile SaaS-Dev.Administration task tf:plan WS=dev
```

# SSO user administration

[confluence](https://luciduminc.atlassian.net/wiki/spaces/DEVOPS/pages/1557594127/Granting+Access+to+AWS+Accounts)

1.  On
    [Azure](https://aad.portal.azure.com/#blade/Microsoft_AAD_IAM/ManagedAppMenuBlade/Users/objectId/5ea06887-183f-4faf-ad83-e920d71cd781/appId/15204951-b319-4202-bcb9-67e83053dd48/preferredSingleSignOnMode/saml)
    side, add the user
2.  Wait till user is synced to AWS single sign on. Check w/ `lucidum`,
    `us-east-1`, look for `AWS Single sign on` service,
3.  Once you see the user, modify
    `global-infra/stacks/catalog/sso.yaml`, add or remove a user.
4.  Raise PR, make KY & Shuning as reviewer.
5.  Once PR is approved, run
    `aws2-wrap --profile lucidum.Administrator atmos
      terraform plan sso -s mgmt/gbl-root`. Nothing is applied yet.
6.  Then change `plan` to `apply` to apply change to AWS.
7.  Test to confirm.


# Online resources

Most of these resources can be accessed using your Office365 oauth which
you would have received on your first day. The ones needs separate
account will be indicated below.

Resource are organized by its origin, eg. Jira & Confluence are all by
Lucidum's `atlassian` access.

## Atlassian: Jira & Confluence

Jira requires admin granting access separately even w/ 365.

1. [connector](https://luciduminc.atlassian.net/jira/software/projects/CON/boards/16)
2. [devops](https://luciduminc.atlassian.net/jira/software/projects/DEVOPS/boards/13)
3. [quarter release
   planning](https://luciduminc.atlassian.net/jira/plans/2/scenarios/2?vid=5#plan/backlog)
4. [[https://luciduminc.atlassian.net/jira/software/c/projects/UX/boards/26/roadmap][frontend]]
5. [[https://luciduminc.atlassian.net/jira/software/c/projects/BE/boards/28/roadmap][backend]]

6. [test cases](https://luciduminc.atlassian.net/projects/TC?selectedItem=com.thed.zephyr.je__cycle-summary)

Confluence/docs:

1. [confluence](https://luciduminc.atlassian.net/wiki/spaces/DEVOPS),
   uses Office365 oauth.
2. [weekly planning, work log](https://luciduminc.atlassian.net/wiki/spaces/VPP/pages/1545699353/2022-04-18)

3. [Devops & QA meeting
   notes](https://luciduminc.atlassian.net/wiki/spaces/SQ/pages/1575780353/2022+May+DevOps+and+QA+Semi-Weekly+Sync+Up)

Coding standards:

1. [code
   review](https://luciduminc.atlassian.net/wiki/spaces/KB/pages/1308262403/Code+Review+Standard)
2. [release version, git branching](https://luciduminc.atlassian.net/wiki/spaces/DEVOPS/pages/1559003169/New+Product+Versions+Workflow)

## Github/code

1. [github repos](https://github.com/LucidumInc), need github admin to
   grant access.

## AWS

1. [EC2
   instances](https://us-west-1.console.aws.amazon.com/ec2/v2/home?region=us-west-1#Instances:v=3)
2. [S3 built images](https://s3.console.aws.amazon.com/s3/buckets?region=us-west-1)
3. [OVA ssh pwd & admin pwd](https://us-east-1.console.aws.amazon.com/systems-manager/parameters/?region=us-east-1&tab=Table)
4. [SSO from Azure](https://myapps.microsoft.com/)

## Lucidum SPECIAL

1. [customer list & ECR token](https://172.16.200.160:5500/customers)
2. [Jenkins](http://172.16.200.173:8080/), needs separate (username, pwd).
3. [Jenkins Saas](http://172.15.50.221:8080/)


# Docker images

There are three types of images used in our application:

1. AMI image: no modification, Ubuntu 18.04.
2. Lucidum base images: there are multiple, each w/ a `Dockerfile`.
3. Lucidum component images: = Lucidum base + component code

## Base images

`image-builder-base` is the repo responsible to
build these base images:

```shell
  drwxrwxr-x  2 fengxia fengxia 4096 Mar 31 12:55 connector-base
  drwxrwxr-x  2 fengxia fengxia 4096 Mar 31 12:55 image-builder-base
  drwxrwxr-x  2 fengxia fengxia 4096 Mar 31 12:55 merger-base
  drwxrwxr-x  2 fengxia fengxia 4096 Mar 31 12:55 mvp1-backend-base
  drwxrwxr-x  2 fengxia fengxia 4096 Mar 31 12:55 packer-ansible-base
```

The `Jenkinsfile` in this repo is essentially enumerating each folder
listed above, if it finds a `Dockerfile`, runs docker build and push
to Azure's docker registry (aka. ACR). Tag is read from a `.json` in
the same folder w/ `Dockerfile`.

## Application component/service images

Use one of the Lucidum base images as starting point, components are
further built into its own docker images.

Jenkinsfile are defined in three possible places:

0. In component's repo
1. `lucidum-deploy` repo
2. as _managed config files_ inside Jenkins itself

| Component          | Base Image           | Jenkinsfile         | Jenkins Pipelines | Push To |
|--------------------|----------------------|---------------------|-------------------|---------|
| `connector-x`      | `connector-base`     | managed config file | connector-xxx     | ECR     |
| backend & frontend | `image-builder-base` | `mvp1_backend`      | mvp1_backend      | S3      |
|                    |                      |                     |                   |         |

# Virtual Appliance

Virtual appliance is a VM image with everything installed and
ready-for-use. This is the host environment for all Lucidum components.

1. Use the `image-builder-base` docker as Jenkins' agent.
2. Create an AMI image from this env (now we are inside
   `image-builder-base` docker!)
3. Export the AMI to a `.ova` w/ disk format `.vmdk`.
4. Push to `s3/packer-ami-pipelines-ubuntu18-vmdk` bucket.

# Run ML

1. Use an EC2 instance.
2. `docker image` to find `python/ml` tag version.
3. `docker run --network=lucidum_default -it python/ml:<tag> bash`
4. `./run_output_data_merger`
5. To profile: `python -m cProfile -s cumtime ./run_output_data_merger > myprofile-cumtime.log`



# MySQL schema

To generate mysql schema:

1. Make a mount to mysql docker, `mysqldump -u root -p lucidum >
   /<mount point>/lucidum.sql`.
2. On the host, launch a new mysql 5.7 docker, then import the sql
   dump.
3. Some tables are using column `Id` as the name, change them `ALTER
   TABLE riverbed_network_flow CHANGE COLUMN ID me_id VARCHAR(100) N
   OT NULL;`.
4. Use schemaspy to craete a schema doc.

There are a few tables considered as [core tables][1] whereas their contents are
essentially a superset of all of the individual API data, and then used as input
for ML. In other words, they represent the _full data view__ of our system.

# ML

## execution info log

Showing the exeuction sequence. On a EC2, took about 15 min end-2-end.

```
root@b4163b0b3519:/home# python3 -m cProfile -s cumtime func_output_data_merger.py > myprofile-cumtime.log
2022-04-14 23:59:58.253 | INFO     | loguru._logger:info:1960 - Load merger settings from model_parameters.yaml file
2022-04-14 23:59:58.397 | INFO     | loguru._logger:info:1960 -  Done! merger_config Data Read: (0, 0)
2022-04-14 23:59:58.398 | INFO     | loguru._logger:info:1960 - Load data lookback and retention settings from DB
2022-04-14 23:59:58.410 | INFO     | loguru._logger:info:1960 -  Done! system_settings Data Read: (1, 26)
2022-04-14 23:59:58.412 | INFO     | loguru._logger:info:1960 - Please review the data merger settings below:
2022-04-14 23:59:58.412 | INFO     | loguru._logger:info:1960 - DHCP TABLE LIST: []
2022-04-14 23:59:58.412 | INFO     | loguru._logger:info:1960 - NETWORK IMPORTANT IP LIST: None
2022-04-14 23:59:58.413 | INFO     | loguru._logger:info:1960 - NETWORK DATA TYPE: None
2022-04-14 23:59:58.413 | INFO     | loguru._logger:info:1960 - HR USER TABLE: None
2022-04-14 23:59:58.414 | INFO     | loguru._logger:info:1960 - ASSET KEY: Asset_Name
2022-04-14 23:59:58.414 | INFO     | loguru._logger:info:1960 - USER KEY: Owner_Name
2022-04-14 23:59:58.415 | INFO     | loguru._logger:info:1960 - RISK THRESHOLDS: LOW < 50, HIGH > 90
2022-04-14 23:59:58.415 | INFO     | loguru._logger:info:1960 - RISK SCALING VALUE: None
2022-04-14 23:59:58.415 | INFO     | loguru._logger:info:1960 - NUMBER OF RISK FACTORS: 3
2022-04-14 23:59:58.416 | INFO     | loguru._logger:info:1960 - CHUNK READ FROM MYSQL: True
2022-04-14 23:59:58.416 | INFO     | loguru._logger:info:1960 - GET SOURCE DETAILS: True
2022-04-14 23:59:58.416 | INFO     | loguru._logger:info:1960 - GET APP SOURCE: True
2022-04-14 23:59:58.417 | INFO     | loguru._logger:info:1960 - LOGIN THRESHOLD: 0.6
2022-04-14 23:59:58.417 | INFO     | loguru._logger:info:1960 - NETWORK THRESHOLD: 0.9
2022-04-14 23:59:58.417 | INFO     | loguru._logger:info:1960 - DATA LOOKBACK DAYS: 2
2022-04-14 23:59:58.418 | INFO     | loguru._logger:info:1960 - DATA RETENTION DAYS IN CACHE: 2
2022-04-14 23:59:58.418 | INFO     | loguru._logger:info:1960 - CUSTOM USER QUERY FROM CACHE: None
2022-04-14 23:59:58.419 | INFO     | loguru._logger:info:1960 - CUSTOM ASSET QUERY FROM CACHE: None
2022-04-14 23:59:58.420 | INFO     | loguru._logger:info:1960 - ASSET SELECTED COLUMNS FROM CACHE: *
2022-04-14 23:59:58.420 | INFO     | loguru._logger:info:1960 - DB OUTPUT TABLES: {'current_asset': 'AWS_CMDB_Output', 'current_user': 'User_Combine', 'user_ip': 'User_IP', 'host_ip': 'Host_IP', 'asset_history': 'Asset_History', 'user_history': 'User_History', 'user_ip_history': 'User_IP_History', 'host_ip_history': 'Host_IP_History'}
2022-04-14 23:59:58.420 | INFO     | loguru._logger:info:1960 - DATA RETENTION DAYS IN DB: 15
2022-04-14 23:59:58.421 | INFO     | loguru._logger:info:1960 - RISK WEIGHT TABLE IN DB: risk_settings
2022-04-14 23:59:58.421 | INFO     | loguru._logger:info:1960 - RISK WEIGHT VALUE IN DB: risk_weight
2022-04-14 23:59:58.422 | INFO     | loguru._logger:info:1960 - RISK WEIGHT LABEL IN DB: risk_label
2022-04-14 23:59:58.422 | INFO     | loguru._logger:info:1960 - TIMESTAMP FILL VALUE: run_time
2022-04-14 23:59:58.423 | INFO     | loguru._logger:info:1960 - ASSET LIST FIELDS: ['High_Risk_App', 'Vuln_Name', 'Services', 'Critical_CVE', 'Open_Port_List', 'CVE', 'app', 'Critical_Risk_App', 'High_CVE', 'Vuln_List', 'Tag', 'Network_ID']
2022-04-14 23:59:58.423 | INFO     | loguru._logger:info:1960 - USER LIST FIELDS: ['Owner_Key', 'Role_Assume_Principal', 'Role_Name', 'Owner_Policies', 'Is_MFA_Configured', 'app', 'Is_Password_Enabled', 'Owner_Groups', 'Tag']
2022-04-14 23:59:58.424 | INFO     | loguru._logger:info:1960 - ASSET REQ FIELDS: ['Cloud_Account_ID', 'Data_Risk', 'Count_High_Severity_Vuln', 'Owner_Name', 'EXT_IP_Address', 'Count_Critical_Severity_Vuln', 'Asset_Type', 'OS', 'Serial_Number', 'Source_User_Name', 'Is_Public']
2022-04-14 23:59:58.425 | INFO     | loguru._logger:info:1960 - USER REQ FIELDS: ['Cloud_Account_ID', 'Data_Risk', 'Data_Type', 'Asset_Name', 'Cloud_Account_Name', 'Owner_ID', 'Asset_OS', 'Data_Classification']
2022-04-14 23:59:58.425 | INFO     | loguru._logger:info:1960 - Run data merging process and output to DB
2022-04-14 23:59:58.464 | INFO     | loguru._logger:info:1960 - Done! 43 records read from SQL table - information_schema.tables
2022-04-14 23:59:58.519 | INFO     | loguru._logger:info:1960 -  Done! jhi_user Data Read: (2, 20)
2022-04-14 23:59:58.583 | INFO     | loguru._logger:info:1960 - -- Create default Lucidum user and asset records
2022-04-14 23:59:58.709 | INFO     | loguru._logger:info:1960 - Find HR data source: ad_user
2022-04-14 23:59:58.716 | INFO     | loguru._logger:info:1960 - Get HR information from ad_user
2022-04-14 23:59:58.718 | INFO     | loguru._logger:info:1960 - Get input data for ML model
2022-04-14 23:59:58.756 | INFO     | loguru._logger:info:1960 - Done! 1000 records read from SQL table - ad_user
2022-04-15 00:00:01.051 | INFO     | loguru._logger:info:1960 - Building ML model
2022-04-15 00:00:06.487 | INFO     | loguru._logger:info:1960 - ML model built with 60 clusters
2022-04-15 00:00:06.488 | INFO     | loguru._logger:info:1960 - Generate ML model outputs
2022-04-15 00:00:07.289 | INFO     | loguru._logger:info:1960 - Get user information from Owner_Department
2022-04-15 00:00:11.739 | INFO     | loguru._logger:info:1960 - Get user information from Data_Topic
2022-04-15 00:00:15.098 | INFO     | loguru._logger:info:1960 - 977 out of 977 users' information generated
2022-04-15 00:00:15.099 | INFO     | loguru._logger:info:1960 - Get past 2 days' records from asset and user tables
2022-04-15 00:00:15.100 | INFO     | loguru._logger:info:1960 - Read user table ...
2022-04-15 00:00:16.612 | INFO     | loguru._logger:info:1960 - -- getting 1 out of 1 chunk from /tmp/tmp31wt92ij/chunk0.hdf5
2022-04-15 00:00:17.254 | INFO     | loguru._logger:info:1960 - 1289 records read from SQL database in 1 chunks
2022-04-15 00:00:17.255 | INFO     | loguru._logger:info:1960 - Done! 1289 records read from SQL table - user_combine
2022-04-15 00:00:17.256 | INFO     | loguru._logger:info:1960 - Read asset table ...
2022-04-15 00:00:22.768 | INFO     | loguru._logger:info:1960 - -- getting 1 out of 1 chunk from /tmp/tmpkdq8l67g/chunk0.hdf5
2022-04-15 00:00:24.915 | INFO     | loguru._logger:info:1960 - 11087 records read from SQL database in 1 chunks
2022-04-15 00:00:24.916 | INFO     | loguru._logger:info:1960 - Done! 11087 records read from SQL table - asset_combine
2022-04-15 00:00:24.918 | INFO     | loguru._logger:info:1960 - Read data table ...
2022-04-15 00:00:25.693 | INFO     | loguru._logger:info:1960 - -- getting 1 out of 1 chunk from /tmp/tmpn0jt99c3/chunk0.hdf5
2022-04-15 00:00:26.008 | INFO     | loguru._logger:info:1960 - 330 records read from SQL database in 1 chunks
2022-04-15 00:00:26.009 | INFO     | loguru._logger:info:1960 - Done! 330 records read from SQL table - file_sharing_graph
2022-04-15 00:00:28.213 | WARNING  | loguru._logger:warning:1968 - Asset_Name patterns are different across data sources: deviation 0.1704
2022-04-15 00:00:28.222 | WARNING  | loguru._logger:warning:1968 - check data sources: ['aws_codecommit', 'aws_dynamodb', 'aws_ecs', 'lucidum_system', 'aws_eks', 'aws_lambda', 'aws_rds', 'aws_route53']
2022-04-15 00:00:28.384 | WARNING  | loguru._logger:warning:1968 - Owner_Name patterns are different across data sources: deviation 0.4684
2022-04-15 00:00:28.483 | WARNING  | loguru._logger:warning:1968 - check data sources: ['aws_iam']
2022-04-15 00:00:28.484 | INFO     | loguru._logger:info:1960 - Get data source details for user and asset
2022-04-15 00:02:26.573 | INFO     | loguru._logger:info:1960 - Get field sources for user and asset
2022-04-15 00:02:27.683 | INFO     | loguru._logger:info:1960 - Get data source summaries for user and asset
2022-04-15 00:02:27.695 | INFO     | loguru._logger:info:1960 - get_source_summary ad_user subset total count: 1000
2022-04-15 00:02:27.773 | INFO     | loguru._logger:info:1960 - get_source_summary aws_iam subset total count: 284
2022-04-15 00:02:27.842 | INFO     | loguru._logger:info:1960 - get_source_summary lucidum_user subset total count: 5
2022-04-15 00:02:27.915 | INFO     | loguru._logger:info:1960 - get_source_summary aws_inventory subset total count: 2000
2022-04-15 00:02:28.167 | INFO     | loguru._logger:info:1960 - get_source_summary ad_computer subset total count: 641
2022-04-15 00:02:28.294 | INFO     | loguru._logger:info:1960 - get_source_summary infoblox_dhcp subset total count: 865
2022-04-15 00:02:28.340 | INFO     | loguru._logger:info:1960 - get_source_summary pan_vpn subset total count: 440
2022-04-15 00:02:28.384 | INFO     | loguru._logger:info:1960 - get_source_summary sentinelone_agent subset total count: 641
2022-04-15 00:02:28.477 | INFO     | loguru._logger:info:1960 - get_source_summary sepm_protection subset total count: 641
2022-04-15 00:02:28.557 | INFO     | loguru._logger:info:1960 - get_source_summary os_secure_login subset total count: 160
2022-04-15 00:02:28.598 | INFO     | loguru._logger:info:1960 - get_source_summary tenable_vuln_scan subset total count: 560
2022-04-15 00:02:28.678 | INFO     | loguru._logger:info:1960 - get_source_summary aws_route53 subset total count: 100
2022-04-15 00:02:28.742 | INFO     | loguru._logger:info:1960 - get_source_summary aws_dynamodb subset total count: 14
2022-04-15 00:02:28.807 | INFO     | loguru._logger:info:1960 - get_source_summary aws_lambda subset total count: 82
2022-04-15 00:02:28.880 | INFO     | loguru._logger:info:1960 - get_source_summary aws_cache subset total count: 4
2022-04-15 00:02:28.969 | INFO     | loguru._logger:info:1960 - get_source_summary aws_rds subset total count: 2
2022-04-15 00:02:29.082 | INFO     | loguru._logger:info:1960 - get_source_summary aws_eks subset total count: 2
2022-04-15 00:02:29.180 | INFO     | loguru._logger:info:1960 - get_source_summary aws_ecr subset total count: 4224
2022-04-15 00:02:29.467 | INFO     | loguru._logger:info:1960 - get_source_summary aws_eip subset total count: 40
2022-04-15 00:02:29.540 | INFO     | loguru._logger:info:1960 - get_source_summary aws_codecommit subset total count: 16
2022-04-15 00:02:29.616 | INFO     | loguru._logger:info:1960 - get_source_summary aws_ami subset total count: 130
2022-04-15 00:02:29.712 | INFO     | loguru._logger:info:1960 - get_source_summary aws_eni subset total count: 142
2022-04-15 00:02:29.820 | INFO     | loguru._logger:info:1960 - get_source_summary aws_workspace subset total count: 4
2022-04-15 00:02:29.915 | INFO     | loguru._logger:info:1960 - get_source_summary aws_ecs subset total count: 2
2022-04-15 00:02:30.028 | INFO     | loguru._logger:info:1960 - get_source_summary aws_sg subset total count: 274
2022-04-15 00:02:30.132 | INFO     | loguru._logger:info:1960 - get_source_summary aws_ec2 subset total count: 98
2022-04-15 00:02:30.364 | INFO     | loguru._logger:info:1960 - get_source_summary lucidum_system subset total count: 5
2022-04-15 00:02:30.465 | INFO     | loguru._logger:info:1960 - Add data source to applications
2022-04-15 00:02:33.267 | INFO     | loguru._logger:info:1960 - Convert ports to string format
2022-04-15 00:02:33.366 | INFO     | loguru._logger:info:1960 - Expand all IP addresses
2022-04-15 00:02:34.095 | INFO     | loguru._logger:info:1960 - Clean records from user and asset tables
2022-04-15 00:02:34.096 | INFO     | loguru._logger:info:1960 -  - trim the string values
2022-04-15 00:02:34.493 | INFO     | loguru._logger:info:1960 -  - clean up FQDN value
2022-04-15 00:02:34.498 | INFO     | loguru._logger:info:1960 -  - remove invalid IP addresses
2022-04-15 00:02:34.691 | INFO     | loguru._logger:info:1960 -  - fix invalid timestamps
2022-04-15 00:02:34.691 | INFO     | loguru._logger:info:1960 - Fill in invalid timestamps with data run time
2022-04-15 00:02:34.707 | INFO     | loguru._logger:info:1960 - Fill in invalid timestamps with data run time
2022-04-15 00:02:34.721 | INFO     | loguru._logger:info:1960 - Clean user data and incorporate user data lookup
2022-04-15 00:02:50.633 | INFO     | loguru._logger:info:1960 - Combine 977 records from user lookup with user main table
2022-04-15 00:02:50.764 | INFO     | loguru._logger:info:1960 - Get user information from app
2022-04-15 00:02:54.796 | INFO     | loguru._logger:info:1960 - 0 more users' information generated
2022-04-15 00:02:54.797 | INFO     | loguru._logger:info:1960 - Used memory (MB): 4329
2022-04-15 00:02:54.798 | INFO     | loguru._logger:info:1960 - Memory usage %: 29.4
2022-04-15 00:02:54.798 | INFO     | loguru._logger:info:1960 - --------- Data Collection/Cleansing: 3 Minutes
2022-04-15 00:02:54.799 | INFO     | custom_rules.custom_pre_rules:process_pre_rules:23 - ----------------------------- Start Processing Custom Pre Rules -----------------------------
2022-04-15 00:02:54.799 | INFO     | custom_rules.custom_pre_rules:process_pre_rules:39 - ----------------------------- End Processing Custom Pre Rules -----------------------------
2022-04-15 00:02:54.799 | INFO     | loguru._logger:info:1960 - --------- Custom Pre Rules: 0 Minutes
2022-04-15 00:02:54.801 | INFO     | loguru._logger:info:1960 - Find DHCP data sources for Owner_Name: ['infoblox_dhcp', 'pan_vpn']
2022-04-15 00:02:54.824 | INFO     | loguru._logger:info:1960 - Done! 1 records read from SQL table - infoblox_dhcp
2022-04-15 00:02:54.848 | INFO     | loguru._logger:info:1960 - Done! 1 records read from SQL table - pan_vpn
2022-04-15 00:02:54.849 | INFO     | loguru._logger:info:1960 - Get Owner_Name IP assignment history in previous 2 days from infoblox_dhcp, pan_vpn
2022-04-15 00:02:54.969 | INFO     | loguru._logger:info:1960 - -- getting 1 out of 1 chunk from /tmp/tmpq5pj5dq6/chunk0.hdf5
2022-04-15 00:02:55.035 | INFO     | loguru._logger:info:1960 - 1305 records read from SQL database in 1 chunks
2022-04-15 00:02:55.357 | INFO     | loguru._logger:info:1960 - Find 940 Owner_Name IP assignment records
2022-04-15 00:02:55.417 | INFO     | loguru._logger:info:1960 - Find DHCP data sources for Asset_Name: ['infoblox_dhcp', 'pan_vpn']
2022-04-15 00:02:55.440 | INFO     | loguru._logger:info:1960 - Done! 1 records read from SQL table - infoblox_dhcp
2022-04-15 00:02:55.465 | INFO     | loguru._logger:info:1960 - Done! 1 records read from SQL table - pan_vpn
2022-04-15 00:02:55.467 | INFO     | loguru._logger:info:1960 - Get Asset_Name IP assignment history in previous 2 days from infoblox_dhcp, pan_vpn
2022-04-15 00:02:55.581 | INFO     | loguru._logger:info:1960 - -- getting 1 out of 1 chunk from /tmp/tmpocjifduc/chunk0.hdf5
2022-04-15 00:02:55.642 | INFO     | loguru._logger:info:1960 - 1305 records read from SQL database in 1 chunks
2022-04-15 00:02:55.978 | INFO     | loguru._logger:info:1960 - Find 940 Asset_Name IP assignment records
2022-04-15 00:02:56.038 | INFO     | loguru._logger:info:1960 - Create asset/user/IP mapping
2022-04-15 00:02:56.090 | INFO     | loguru._logger:info:1960 - Get Owner_Name from IP history
2022-04-15 00:02:56.151 | INFO     | loguru._logger:info:1960 - 36 records with Owner_Name mapped from IP history
2022-04-15 00:02:57.009 | INFO     | loguru._logger:info:1960 - Get Asset_Name from IP history
2022-04-15 00:02:57.064 | INFO     | loguru._logger:info:1960 - 0 records with Asset_Name mapped from IP history
2022-04-15 00:03:02.797 | INFO     | loguru._logger:info:1960 - Get unique Asset_Name from MAC_Address
2022-04-15 00:03:22.400 | INFO     | loguru._logger:info:1960 - Get 0 extra data source details for user and ip
2022-04-15 00:03:22.400 | INFO     | loguru._logger:info:1960 - Get 80 extra data source details for ip
2022-04-15 00:03:22.401 | INFO     | loguru._logger:info:1960 - Get 771 extra data source details for serial number
2022-04-15 00:03:22.401 | INFO     | loguru._logger:info:1960 - Get latest record by User and IP address
2022-04-15 00:03:24.063 | INFO     | loguru._logger:info:1960 - Get latest record by Serial Number
2022-04-15 00:03:35.805 | INFO     | loguru._logger:info:1960 - Get unique Asset_Name from Serial_Number
2022-04-15 00:05:20.304 | INFO     | loguru._logger:info:1960 - Create asset-user-IP linkage
2022-04-15 00:05:34.428 | INFO     | loguru._logger:info:1960 - Difference in data source details for assets: 80
2022-04-15 00:05:34.786 | INFO     | loguru._logger:info:1960 - Used memory (MB): 4429
2022-04-15 00:05:34.787 | INFO     | loguru._logger:info:1960 - Memory usage %: 30.0
2022-04-15 00:05:34.788 | INFO     | loguru._logger:info:1960 - --------- IP Host Mapping: 3 Minutes
2022-04-15 00:05:34.788 | INFO     | custom_rules.custom_mid_rules:process_mid_rules:29 - ----------------------------- Start Processing Custom Mid Rules -----------------------------
2022-04-15 00:05:34.788 | INFO     | custom_rules.rules_user_infer:process_user_infer:34 - Custom Mid Rule: Get network flow data for user inference
2022-04-15 00:05:35.218 | INFO     | loguru._logger:info:1960 - -- getting 1 out of 1 chunk from /tmp/tmpm7lzpp3o/chunk0.hdf5
2022-04-15 00:05:35.400 | INFO     | loguru._logger:info:1960 - 1000 records read from SQL database in 1 chunks
2022-04-15 00:05:35.401 | INFO     | loguru._logger:info:1960 - Done! 1000 records read from SQL table - network_flow
2022-04-15 00:05:35.402 | INFO     | custom_rules.rules_user_infer:process_user_infer:40 - Get source host user information
2022-04-15 00:05:35.448 | INFO     | custom_rules.rules_user_infer:process_user_infer:57 - Infer users for destination host
2022-04-15 00:05:35.540 | INFO     | custom_rules.rules_user_infer:process_user_infer:95 - User information inferred on 730 hosts: example output
2022-04-15 00:05:35.543 | INFO     | custom_rules.rules_user_infer:process_user_infer:96 - [{'IP_Address': '192.168.96.255', 'Owner_Name': 'AGILLEN', 'run_time': 1649922085, 'sourcetype': ['riverbed_network_flow'], 'OS': nan, 'Asset_Name': '192.168.96.255', 'First_Discovered_Datetime': 1649922085, 'Last_Discovered_Datetime': 1649922085}]
2022-04-15 00:05:35.544 | INFO     | custom_rules.rules_user_infer:process_user_infer:97 - input asset data: (6887, 108)
2022-04-15 00:05:35.611 | INFO     | custom_rules.rules_user_infer:process_user_infer:99 - asset data with inferred users: (7617, 108)
2022-04-15 00:05:35.771 | INFO     | loguru._logger:info:1960 -  Done! Asset_List Data Read: (7664, 6)
2022-04-15 00:05:35.772 | INFO     | custom_rules.rules_user_infer:process_user_infer:129 - no user information collected from asset master list
2022-04-15 00:05:35.773 | INFO     | custom_rules.rules_file_names:process_file_names:57 - Custom Mid Rule: Get file name and time information from previous 7 days
2022-04-15 00:05:35.803 | INFO     | loguru._logger:info:1960 - Done! 330 records read from SQL table - file_sharing_graph
2022-04-15 00:05:36.822 | INFO     | custom_rules.rules_file_names:process_file_names:76 - 167 file access records added to asset output
2022-04-15 00:05:37.676 | INFO     | custom_rules.rules_file_names:process_file_names:89 - 321 file access records added to user output
2022-04-15 00:05:37.738 | INFO     | custom_rules.rules_file_buckets:process_file_buckets:30 - Custom Mid Rule: Get file buckets information from previous 7 days
2022-04-15 00:05:37.778 | INFO     | loguru._logger:info:1960 - Done! 155 records read from SQL table - file_sharing_graph
2022-04-15 00:05:38.764 | INFO     | custom_rules.rules_file_buckets:process_file_buckets:101 - 71 file bucket records added to outputs
2022-04-15 00:05:38.884 | INFO     | custom_rules.rules_ip_whois:process_ip_sans:226 - Custom Mid Rule: Getting SANS attack information for EXT_IP_Address
2022-04-15 00:05:40.325 | INFO     | custom_rules.rules_ip_whois:process_ip_sans:276 - -- SANS IP found for 0 assets
2022-04-15 00:05:40.330 | INFO     | custom_rules.rules_ip_whois:process_ip_tor:300 - Custom Mid Rule: Getting TOR exit node information for EXT_IP_Address
2022-04-15 00:05:41.739 | INFO     | custom_rules.rules_ip_whois:process_ip_tor:328 - -- TOR IP found for 0 assets
2022-04-15 00:05:41.743 | INFO     | custom_rules.rules_ip_whois:process_geo_ip:132 - Custom Mid Rule: Getting GeoLite2 information for EXT_IP_Address
2022-04-15 00:05:43.294 | INFO     | custom_rules.rules_ip_whois:_get_file:105 - -- Downloading Maxmind GeoLite2 database GeoLite2-City.mmdb
2022-04-15 00:05:44.877 | INFO     | custom_rules.rules_ip_whois:_get_file:105 - -- Downloading Maxmind GeoLite2 database GeoLite2-ASN.mmdb
2022-04-15 00:05:44.991 | INFO     | custom_rules.rules_ip_whois:process_geo_ip:148 - -- Reading country ISO code data
2022-04-15 00:05:55.390 | INFO     | custom_rules.rules_ip_whois:process_geo_ip:200 - -- Country found for 730 assets
2022-04-15 00:05:55.391 | INFO     | custom_rules.rules_ip_whois:process_geo_ip:201 - -- ASN found for 621 assets
2022-04-15 00:05:55.391 | INFO     | custom_rules.rules_ip_whois:process_geo_ip:202 - -- Geo location found for 4778 assets
2022-04-15 00:05:55.396 | INFO     | custom_rules.rules_asset_type:process_asset_type:16 - Custom Mid Rule: Assigning asset types from different rules
2022-04-15 00:05:55.397 | INFO     | custom_rules.rules_asset_type:process_asset_type:23 - -- Assign asset types from different data sources
2022-04-15 00:06:07.988 | INFO     | custom_rules.rules_asset_type:process_asset_type:88 - -- Assign types for 2064 assets: ['DNS', nan, 'Workstation', 'Server', 'VM_Image', 'Storage', 'Container', 'Code', 'Database', 'Micro_Service', 'Interface', 'VM', 'Firewall']
2022-04-15 00:06:08.441 | INFO     | custom_rules.custom_mid_rules:process_mid_rules:93 - ----------------------------- End Processing Custom Mid Rules -----------------------------
2022-04-15 00:06:08.445 | INFO     | loguru._logger:info:1960 - --------- Custom Mid Rules: 1 Minutes
2022-04-15 00:06:08.912 | INFO     | loguru._logger:info:1960 - Run login analysis with threshold = 0.6
2022-04-15 00:06:09.145 | INFO     | loguru._logger:info:1960 - Combine 1929 analysis outputs with asset table
2022-04-15 00:06:09.650 | INFO     | loguru._logger:info:1960 - Done! 321 records read from SQL table - file_sharing_graph_output
2022-04-15 00:06:09.651 | INFO     | loguru._logger:info:1960 - Get 321 ML file outputs
2022-04-15 00:06:09.793 | INFO     | loguru._logger:info:1960 - 0 users' information generated from analysis
2022-04-15 00:06:10.167 | INFO     | loguru._logger:info:1960 - Done! 240 records read from SQL table - network_flow_graph_output
2022-04-15 00:06:10.176 | INFO     | loguru._logger:info:1960 - Get 24 ML network outputs
2022-04-15 00:06:11.717 | INFO     | loguru._logger:info:1960 - Used memory (MB): 4606
2022-04-15 00:06:11.718 | INFO     | loguru._logger:info:1960 - Memory usage %: 31.1
2022-04-15 00:06:11.719 | INFO     | loguru._logger:info:1960 - --------- ML Inference: 0 Minutes
2022-04-15 00:06:11.719 | INFO     | loguru._logger:info:1960 - Create asset summarized table
2022-04-15 00:08:13.237 | INFO     | loguru._logger:info:1960 -  Done! Asset_List Data Read: (7664, 2)
2022-04-15 00:08:13.238 | INFO     | loguru._logger:info:1960 - Update first discovered time from Asset_List
2022-04-15 00:08:13.684 | INFO     | loguru._logger:info:1960 - -- Updating First_Discovered_Datetime
2022-04-15 00:10:09.516 | INFO     | loguru._logger:info:1960 - Attach asset's user access history
2022-04-15 00:10:16.931 | INFO     | loguru._logger:info:1960 - Combine 7657 asset records with 1121 user records
2022-04-15 00:10:16.931 | INFO     | loguru._logger:info:1960 - Asset columns to be included: ['Last_Asset_Datetime', 'Data_Risk', 'displayName', 'Data_Type', 'IP_Address', 'Owner_Email', 'First_Asset_Datetime', 'Asset_Name', 'Owner_ID', 'Data_Classification']
aﾌ栢ﾂｰaﾌ栢ﾂｰ2022-04-15 00:10:40.346 | INFO     | loguru._logger:info:1960 - Feature engineering in user table
2022-04-15 00:10:40.375 | INFO     | loguru._logger:info:1960 - user output: (1121, 40)
2022-04-15 00:10:40.666 | INFO     | loguru._logger:info:1960 - Combine 1121 user records with 5509 asset records
2022-04-15 00:10:40.670 | INFO     | loguru._logger:info:1960 - User columns to be included: ['Data_Risk', 'displayName', 'Owner_Sources', 'Owner_Department', 'Data_Type', 'Owner_Email', 'Is_Disabled', 'Owner_Job_Title', 'Data_Topic', 'Owner_Manager', 'Owner_Groups', 'Owner_ID', 'Data_Classification']
2022-04-15 00:10:41.231 | INFO     | loguru._logger:info:1960 - Feature engineering in asset table
2022-04-15 00:10:42.021 | INFO     | loguru._logger:info:1960 - Combine 1121 user records with 7657 asset records
2022-04-15 00:10:42.025 | INFO     | loguru._logger:info:1960 - User columns to be included: ['Data_Risk', 'displayName', 'Owner_Sources', 'Owner_Department', 'Data_Type', 'Owner_Email', 'Is_Disabled', 'Owner_Job_Title', 'Data_Topic', 'Owner_Manager', 'Owner_Groups', 'Owner_ID', 'Data_Classification']
2022-04-15 00:10:42.708 | INFO     | loguru._logger:info:1960 - Feature engineering in asset table
2022-04-15 00:10:43.656 | INFO     | loguru._logger:info:1960 - asset output: (5509, 138); ip output: (7657, 137); data output: (2114, 138)
2022-04-15 00:10:43.669 | INFO     | loguru._logger:info:1960 - Get Lucidum license settings
2022-04-15 00:10:43.670 | INFO     | loguru._logger:info:1960 - Get Lucidum license expiration date
2022-04-15 00:10:43.671 | INFO     | loguru._logger:info:1960 - Check Lucidum license features
2022-04-15 00:10:43.672 | INFO     | loguru._logger:info:1960 - Get Lucidum license settings
2022-04-15 00:10:43.673 | INFO     | loguru._logger:info:1960 - Get Lucidum license expiration date
2022-04-15 00:10:43.674 | INFO     | loguru._logger:info:1960 - Check Lucidum license features
2022-04-15 00:10:43.674 | INFO     | loguru._logger:info:1960 - Get Lucidum license settings
2022-04-15 00:10:43.675 | INFO     | loguru._logger:info:1960 - Get Lucidum license expiration date
2022-04-15 00:10:43.676 | INFO     | loguru._logger:info:1960 - Check Lucidum license features
2022-04-15 00:10:43.676 | INFO     | loguru._logger:info:1960 - --------- Asset User Summary: 5 Minutes
2022-04-15 00:10:43.677 | INFO     | custom_rules.custom_post_rules:process_post_rules:29 - ----------------------------- Start Processing Custom Post Rules -----------------------------
2022-04-15 00:10:49.144 | INFO     | custom_rules.rules_port_service:process_port_service:106 - Custom Post Rule: Getting service information for Open_Port_List
2022-04-15 00:10:49.203 | INFO     | custom_rules.rules_port_service:process_port_service:119 - -- services found for 2147 assets
2022-04-15 00:10:49.204 | INFO     | custom_rules.rules_port_service:process_port_service:122 - Custom Post Rule: Getting accessible ports and services on external IP addresses
2022-04-15 00:12:27.051 | INFO     | custom_rules.rules_port_service:process_port_service:128 - -- external open ports found for 13 assets
2022-04-15 00:12:27.053 | INFO     | custom_rules.rules_mac_lookup:process_mac_lookup:78 - Custom Post Rule: Getting asset vendor information for MAC_Address
2022-04-15 00:12:44.068 | INFO     | custom_rules.rules_mac_lookup:process_mac_lookup:92 - -- MAC vendors found for 2879 assets
2022-04-15 00:12:44.436 | INFO     | custom_rules.rules_cloud_compliance:process_cloud_compliance:24 - Custom Post Rule: Get cloud compliance information from previous 7 days
2022-04-15 00:12:44.479 | INFO     | loguru._logger:info:1960 - Done! 654 records read from SQL table - compliance_combine
2022-04-15 00:12:44.680 | INFO     | custom_rules.rules_cloud_compliance:process_cloud_compliance:55 - Save outputs to MongoDB Compliance table
2022-04-15 00:12:44.922 | INFO     | loguru._logger:info:1960 -  Done! Compliance Data Inserted: (327, 47)
2022-04-15 00:12:44.926 | INFO     | loguru._logger:info:1960 - Create FULL TEXT indexes on Compliance table
2022-04-15 00:12:45.013 | INFO     | custom_rules.rules_cloud_compliance:process_cloud_compliance:62 - Create output metadata for compliance table
2022-04-15 00:12:45.014 | INFO     | loguru._logger:info:1960 - Getting field summary and metadata on outputs
2022-04-15 00:12:46.691 | INFO     | loguru._logger:info:1960 - Extract keys and values from nested fields: ['Policy_Statement']
2022-04-15 00:12:46.893 | INFO     | loguru._logger:info:1960 -  Done! Metadata_Compliance Data Inserted: (43, 4)
2022-04-15 00:12:46.894 | INFO     | custom_rules.custom_post_rules:process_post_rules:67 - ----------------------------- End Processing Custom Post Rules -----------------------------
2022-04-15 00:12:46.897 | INFO     | loguru._logger:info:1960 - --------- Custom Post Rules: 2 Minutes
2022-04-15 00:13:00.003 | INFO     | loguru._logger:info:1960 - Set empty list as null: ['High_Risk_App', 'Vuln_Name', 'MAC_Address', 'Services', 'Critical_CVE', 'Open_Port_List', 'CVE', 'app', 'Critical_Risk_App', 'High_CVE', 'Vuln_List', 'sourcetype', 'Network_ID', 'Tag', 'IP_Address', 'EXT_IP_Address', 'Security_Group_ID', 'Security_Group_Rules', 'Security_Group_IP', 'Security_Group_Name', 'Non_Compliance', 'Image_Tag', 'File_Name', 'User_Bucket', 'List_Users', 'Owner_Sources', 'Owner_Groups', 'Owner_ID', 'EXT_Open_Ports', 'EXT_Services', 'Application']
2022-04-15 00:13:01.238 | INFO     | loguru._logger:info:1960 - Set empty list as null: ['Asset_Name', 'IP_Address', 'Asset_OS', 'Role_Assume_Principal', 'Cloud_Account_ID', 'Owner_Key', 'Role_Name', 'Owner_Policies', 'Is_MFA_Configured', 'app', 'Is_Password_Enabled', 'Cloud_Account_Name', 'Owner_Groups', 'sourcetype', 'Tag', 'File_Name', 'Owner_ID', 'Application']
2022-04-15 00:13:18.079 | INFO     | loguru._logger:info:1960 - Set empty list as null: ['High_Risk_App', 'Vuln_Name', 'MAC_Address', 'Services', 'Critical_CVE', 'Open_Port_List', 'CVE', 'app', 'Critical_Risk_App', 'High_CVE', 'Vuln_List', 'sourcetype', 'Network_ID', 'Tag', 'Security_Group_ID', 'Security_Group_Rules', 'Security_Group_IP', 'Security_Group_Name', 'Non_Compliance', 'Image_Tag', 'File_Name', 'User_Bucket', 'Owner_Sources', 'Owner_Groups', 'Owner_ID']
2022-04-15 00:13:18.297 | INFO     | loguru._logger:info:1960 - Get risk weights from /home/custom_rules: model_parameters.yaml
2022-04-15 00:13:18.297 | INFO     | loguru._logger:info:1960 - Load merger settings from model_parameters.yaml file
2022-04-15 00:13:18.353 | INFO     | loguru._logger:info:1960 -  Done! risk_settings Data Read: (0, 0)
2022-04-15 00:13:18.542 | INFO     | loguru._logger:info:1960 - Standardize risk scores with calculated scaling factor 0.1111
2022-04-15 00:13:19.207 | INFO     | loguru._logger:info:1960 - Get risk weights and labels from /home/custom_rules: model_parameters.yaml
2022-04-15 00:13:19.207 | INFO     | loguru._logger:info:1960 - Load merger settings from model_parameters.yaml file
2022-04-15 00:13:19.262 | INFO     | loguru._logger:info:1960 - Load merger settings from model_parameters.yaml file
2022-04-15 00:13:19.318 | INFO     | loguru._logger:info:1960 -  Done! risk_settings Data Read: (0, 0)
2022-04-15 00:13:19.319 | INFO     | loguru._logger:info:1960 - Generate top asset risk factors
242022-04-15 00:13:54.487 | INFO     | loguru._logger:info:1960 - Generate CAASM maturity score and level
2022-04-15 00:13:54.631 | INFO     | loguru._logger:info:1960 - Attach asset risk scores to user table
2022-04-15 00:13:55.002 | INFO     | loguru._logger:info:1960 - asset risk stats: max - 121.31; average - 6.69; median - 4.24
2022-04-15 00:13:55.007 | INFO     | loguru._logger:info:1960 - Used memory (MB): 4758
2022-04-15 00:13:55.007 | INFO     | loguru._logger:info:1960 - Memory usage %: 32.1
2022-04-15 00:13:55.008 | INFO     | loguru._logger:info:1960 - --------- Asset User Outputs: 1 Minutes
2022-04-15 00:13:55.022 | INFO     | loguru._logger:info:1960 - Save User IP mapping tables to database
2022-04-15 00:13:55.186 | INFO     | loguru._logger:info:1960 - Save Host IP mapping tables to database
2022-04-15 00:13:55.357 | INFO     | loguru._logger:info:1960 - Clean up over 2 days' cache data
2022-04-15 00:13:55.463 | INFO     | loguru._logger:info:1960 - -- ad_computer cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:55.505 | INFO     | loguru._logger:info:1960 - -- ad_user cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:55.545 | INFO     | loguru._logger:info:1960 - -- ad_user_department cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:55.590 | INFO     | loguru._logger:info:1960 - -- asset_combine cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:55.631 | INFO     | loguru._logger:info:1960 - -- aws_ami cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:55.692 | INFO     | loguru._logger:info:1960 - -- aws_cache cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:55.745 | INFO     | loguru._logger:info:1960 - -- aws_codecommit cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:55.788 | INFO     | loguru._logger:info:1960 - -- aws_compliance cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:55.831 | INFO     | loguru._logger:info:1960 - -- aws_dynamodb cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:55.872 | INFO     | loguru._logger:info:1960 - -- aws_ec2 cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:55.916 | INFO     | loguru._logger:info:1960 - -- aws_ecr cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:55.959 | INFO     | loguru._logger:info:1960 - -- aws_ecs cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:55.998 | INFO     | loguru._logger:info:1960 - -- aws_eip cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.039 | INFO     | loguru._logger:info:1960 - -- aws_eks cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.105 | INFO     | loguru._logger:info:1960 - -- aws_eni cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.144 | INFO     | loguru._logger:info:1960 - -- aws_iam cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.184 | INFO     | loguru._logger:info:1960 - -- aws_inventory cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.227 | INFO     | loguru._logger:info:1960 - -- aws_lambda cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.266 | INFO     | loguru._logger:info:1960 - -- aws_org cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.306 | INFO     | loguru._logger:info:1960 - -- aws_rds cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.350 | INFO     | loguru._logger:info:1960 - -- aws_route53 cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.400 | INFO     | loguru._logger:info:1960 - -- aws_sg cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.450 | INFO     | loguru._logger:info:1960 - -- aws_workspace cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.490 | INFO     | loguru._logger:info:1960 - -- compliance_combine cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.536 | INFO     | loguru._logger:info:1960 - -- file_sharing_graph cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.575 | INFO     | loguru._logger:info:1960 - -- file_sharing_graph_output cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.618 | INFO     | loguru._logger:info:1960 - -- google_drive cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.666 | INFO     | loguru._logger:info:1960 - -- infoblox_dhcp cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.706 | INFO     | loguru._logger:info:1960 - -- network_flow cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.765 | INFO     | loguru._logger:info:1960 - -- network_flow_graph cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.810 | INFO     | loguru._logger:info:1960 - -- network_flow_graph_output cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.854 | INFO     | loguru._logger:info:1960 - -- os_secure_login cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.897 | INFO     | loguru._logger:info:1960 - -- pan_traffic cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.934 | INFO     | loguru._logger:info:1960 - -- pan_vpn cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:56.972 | INFO     | loguru._logger:info:1960 - -- riverbed_network_flow cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:57.010 | INFO     | loguru._logger:info:1960 - -- sentinelone_agent cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:57.047 | INFO     | loguru._logger:info:1960 - -- sepm_protection cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:57.086 | INFO     | loguru._logger:info:1960 - -- tenable_vuln_scan cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:57.125 | INFO     | loguru._logger:info:1960 - -- user_combine cleaning has been scheduled with 2 days' retention
2022-04-15 00:13:57.158 | INFO     | loguru._logger:info:1960 - Attach 1121 source details to user outputs
2022-04-15 00:13:57.190 | INFO     | loguru._logger:info:1960 - Attach 5360 source details to asset outputs
2022-04-15 00:13:58.106 | INFO     | loguru._logger:info:1960 -  Done! User_List Data Read: (1121, 5)
2022-04-15 00:13:58.106 | INFO     | loguru._logger:info:1960 - Update first discovered time from User_List
2022-04-15 00:13:58.138 | INFO     | loguru._logger:info:1960 - -- Updating First_Discovered_Datetime
2022-04-15 00:13:58.266 | INFO     | loguru._logger:info:1960 - -- Updating AWS IAM First Seen Datetime
2022-04-15 00:13:58.392 | INFO     | loguru._logger:info:1960 - -- Updating AD USER First Seen Datetime
2022-04-15 00:13:58.518 | INFO     | loguru._logger:info:1960 - -- Updating LUCIDUM USER First Seen Datetime
2022-04-15 00:13:58.823 | INFO     | loguru._logger:info:1960 -  Done! Asset_List Data Read: (7664, 2)
2022-04-15 00:13:58.824 | INFO     | loguru._logger:info:1960 - Update first discovered time from Asset_List
2022-04-15 00:13:58.872 | INFO     | loguru._logger:info:1960 - -- Updating First_Discovered_Datetime
2022-04-15 00:13:59.135 | INFO     | loguru._logger:info:1960 -  Done! Host_List Data Read: (5511, 26)
2022-04-15 00:13:59.135 | INFO     | loguru._logger:info:1960 - Update first discovered time from Host_List
2022-04-15 00:13:59.425 | INFO     | loguru._logger:info:1960 - -- Updating First_Discovered_Datetime
2022-04-15 00:14:00.082 | INFO     | loguru._logger:info:1960 - -- Updating AWS ROUTE53 First Seen Datetime
2022-04-15 00:14:00.713 | INFO     | loguru._logger:info:1960 - -- Updating TENABLE VULN SCAN First Seen Datetime
2022-04-15 00:14:01.472 | INFO     | loguru._logger:info:1960 - -- Updating AD COMPUTER First Seen Datetime
2022-04-15 00:14:02.125 | INFO     | loguru._logger:info:1960 - -- Updating SENTINELONE AGENT First Seen Datetime
2022-04-15 00:14:02.725 | INFO     | loguru._logger:info:1960 - -- Updating SEPM PROTECTION First Seen Datetime
2022-04-15 00:14:03.355 | INFO     | loguru._logger:info:1960 - -- Updating INFOBLOX DHCP First Seen Datetime
2022-04-15 00:14:03.975 | INFO     | loguru._logger:info:1960 - -- Updating PAN VPN First Seen Datetime
2022-04-15 00:14:04.613 | INFO     | loguru._logger:info:1960 - -- Updating OS SECURE LOGIN First Seen Datetime
2022-04-15 00:14:05.323 | INFO     | loguru._logger:info:1960 - -- Updating AWS AMI First Seen Datetime
2022-04-15 00:14:05.976 | INFO     | loguru._logger:info:1960 - -- Updating AWS EKS First Seen Datetime
2022-04-15 00:14:06.614 | INFO     | loguru._logger:info:1960 - -- Updating AWS CODECOMMIT First Seen Datetime
2022-04-15 00:14:07.248 | INFO     | loguru._logger:info:1960 - -- Updating AWS RDS First Seen Datetime
2022-04-15 00:14:07.868 | INFO     | loguru._logger:info:1960 - -- Updating AWS DYNAMODB First Seen Datetime
2022-04-15 00:14:08.497 | INFO     | loguru._logger:info:1960 - -- Updating AWS LAMBDA First Seen Datetime
2022-04-15 00:14:09.131 | INFO     | loguru._logger:info:1960 - -- Updating AWS ECS First Seen Datetime
2022-04-15 00:14:09.761 | INFO     | loguru._logger:info:1960 - -- Updating AWS EIP First Seen Datetime
2022-04-15 00:14:10.401 | INFO     | loguru._logger:info:1960 - -- Updating AWS ENI First Seen Datetime
2022-04-15 00:14:11.019 | INFO     | loguru._logger:info:1960 - -- Updating AWS EC2 First Seen Datetime
2022-04-15 00:14:11.760 | INFO     | loguru._logger:info:1960 - -- Updating AWS INVENTORY First Seen Datetime
2022-04-15 00:14:12.428 | INFO     | loguru._logger:info:1960 - -- Updating LUCIDUM SYSTEM First Seen Datetime
2022-04-15 00:14:13.147 | INFO     | loguru._logger:info:1960 - -- Updating AWS SG First Seen Datetime
2022-04-15 00:14:13.848 | INFO     | loguru._logger:info:1960 - -- Updating AWS ECR First Seen Datetime
2022-04-15 00:14:14.479 | INFO     | loguru._logger:info:1960 - -- Updating AWS CACHE First Seen Datetime
2022-04-15 00:14:15.109 | INFO     | loguru._logger:info:1960 - -- Updating AWS WORKSPACE First Seen Datetime
2022-04-15 00:14:15.976 | INFO     | loguru._logger:info:1960 - Create entity life fields
2022-04-15 00:14:16.144 | INFO     | loguru._logger:info:1960 -  Done! Asset_List Data Read: (7664, 6)
2022-04-15 00:14:16.188 | INFO     | loguru._logger:info:1960 -  Done! User_List Data Read: (1121, 21)
2022-04-15 00:14:16.642 | INFO     | loguru._logger:info:1960 -  Done! Host_List Data Read: (5511, 91)
2022-04-15 00:14:16.643 | INFO     | loguru._logger:info:1960 - Find new assets
2022-04-15 00:14:16.775 | INFO     | loguru._logger:info:1960 - Find new users
2022-04-15 00:14:17.003 | INFO     | loguru._logger:info:1960 - Update Asset_List with history data
2022-04-15 00:14:17.424 | INFO     | loguru._logger:info:1960 -  Done! Asset_List Data Inserted: (7664, 6)
2022-04-15 00:14:17.432 | INFO     | loguru._logger:info:1960 - Create FIELD TEXT indexes on Asset_List table
2022-04-15 00:14:17.661 | INFO     | loguru._logger:info:1960 - Update Host_List with history data
2022-04-15 00:14:20.909 | INFO     | loguru._logger:info:1960 -  Done! Host_List Data Inserted: (5511, 91)
2022-04-15 00:14:20.930 | INFO     | loguru._logger:info:1960 - Create FIELD TEXT indexes on Host_List table
2022-04-15 00:14:21.556 | INFO     | loguru._logger:info:1960 - Getting field summary and metadata on outputs
2022-04-15 00:14:26.590 | INFO     | loguru._logger:info:1960 - Extract keys and values from nested fields: ['Application']
2022-04-15 00:14:27.215 | INFO     | loguru._logger:info:1960 -  Done! Metadata_Host_List Data Inserted: (94, 4)
2022-04-15 00:14:27.245 | INFO     | loguru._logger:info:1960 - Update User_List with history data
2022-04-15 00:14:27.605 | INFO     | loguru._logger:info:1960 -  Done! User_List Data Inserted: (1121, 21)
2022-04-15 00:14:27.612 | INFO     | loguru._logger:info:1960 - Create FIELD TEXT indexes on User_List table
2022-04-15 00:14:27.688 | INFO     | loguru._logger:info:1960 - Getting field summary and metadata on outputs
2022-04-15 00:14:28.489 | INFO     | loguru._logger:info:1960 - Extract keys and values from nested fields: ['Application']
2022-04-15 00:14:28.706 | INFO     | loguru._logger:info:1960 -  Done! Metadata_User_List Data Inserted: (23, 4)
2022-04-15 00:14:28.720 | INFO     | loguru._logger:info:1960 - get_source_summary Current User Table subset total count: 1121
2022-04-15 00:14:29.019 | INFO     | loguru._logger:info:1960 - get_source_summary Current Asset Table subset total count: 5509
2022-04-15 00:14:31.932 | INFO     | loguru._logger:info:1960 - Create user and asset metrics
2022-04-15 00:14:32.080 | INFO     | loguru._logger:info:1960 -  Done! User_Metric Data Inserted: (5, 3)
2022-04-15 00:14:32.098 | INFO     | loguru._logger:info:1960 -  Done! Asset_Metric Data Inserted: (27, 3)
2022-04-15 00:14:32.100 | INFO     | loguru._logger:info:1960 - User Metric: [{'sourcetype': 'ad_user', 'count': 977, 'run_time': 1649981671}, {'sourcetype': 'aws_iam', 'count': 142, 'run_time': 1649981671}, {'sourcetype': 'aws_s3', 'count': 1, 'run_time': 1649981671}, {'sourcetype': 'google_drive', 'count': 318, 'run_time': 1649981671}, {'sourcetype': 'lucidum_user', 'count': 2, 'run_time': 1649981671}]
2022-04-15 00:14:32.102 | INFO     | loguru._logger:info:1960 - Asset Metric: [{'sourcetype': 'ad_computer', 'count': 641, 'run_time': 1649981671}, {'sourcetype': 'aws_ami', 'count': 65, 'run_time': 1649981671}, {'sourcetype': 'aws_cache', 'count': 2, 'run_time': 1649981671}, {'sourcetype': 'aws_codecommit', 'count': 4, 'run_time': 1649981671}, {'sourcetype': 'aws_dynamodb', 'count': 7, 'run_time': 1649981671}, {'sourcetype': 'aws_ec2', 'count': 47, 'run_time': 1649981671}, {'sourcetype': 'aws_ecr', 'count': 2117, 'run_time': 1649981671}, {'sourcetype': 'aws_ecs', 'count': 1, 'run_time': 1649981671}, {'sourcetype': 'aws_eip', 'count': 20, 'run_time': 1649981671}, {'sourcetype': 'aws_eks', 'count': 1, 'run_time': 1649981671}, {'sourcetype': 'aws_eni', 'count': 71, 'run_time': 1649981671}, {'sourcetype': 'aws_inventory', 'count': 2000, 'run_time': 1649981671}, {'sourcetype': 'aws_lambda', 'count': 10, 'run_time': 1649981671}, {'sourcetype': 'aws_rds', 'count': 1, 'run_time': 1649981671}, {'sourcetype': 'aws_route53', 'count': 50, 'run_time': 1649981671}, {'sourcetype': 'aws_s3', 'count': 59, 'run_time': 1649981671}, {'sourcetype': 'aws_sg', 'count': 137, 'run_time': 1649981671}, {'sourcetype': 'aws_workspace', 'count': 2, 'run_time': 1649981671}, {'sourcetype': 'google_drive', 'count': 12, 'run_time': 1649981671}, {'sourcetype': 'infoblox_dhcp', 'count': 721, 'run_time': 1649981671}, {'sourcetype': 'lucidum_system', 'count': 1, 'run_time': 1649981671}, {'sourcetype': 'os_secure_login', 'count': 160, 'run_time': 1649981671}, {'sourcetype': 'pan_vpn', 'count': 400, 'run_time': 1649981671}, {'sourcetype': 'riverbed_network_flow', 'count': 228, 'run_time': 1649981671}, {'sourcetype': 'sentinelone_agent', 'count': 641, 'run_time': 1649981671}, {'sourcetype': 'sepm_protection', 'count': 641, 'run_time': 1649981671}, {'sourcetype': 'tenable_vuln_scan', 'count': 560, 'run_time': 1649981671}]
2022-04-15 00:14:32.206 | INFO     | loguru._logger:info:1960 -  Done! User_Combine Data Read: (1121, 53)
2022-04-15 00:14:33.448 | INFO     | loguru._logger:info:1960 -  Done! AWS_CMDB_Output Data Read: (5509, 207)
2022-04-15 00:14:33.450 | INFO     | loguru._logger:info:1960 - Compare data difference by Owner_Name on User Table ......
2022-04-15 00:14:33.451 | INFO     | loguru._logger:info:1960 - -- Compared fields: ['Asset_Name', 'Owner_Name', 'Application', 'Data_Classification', 'Data_Type', 'Is_Disabled', 'Is_Lockout', 'Is_Terminated', 'Location', 'Owner_Department', 'Owner_Email', 'Owner_Job_Title', 'Owner_Manager', 'Owner_Type', 'Status', 'displayName']
2022-04-15 00:14:35.874 | INFO     | loguru._logger:info:1960 - Compare data difference by Asset_Name on Asset Table ......
2022-04-15 00:14:35.874 | INFO     | loguru._logger:info:1960 - -- Compared fields: ['Asset_Name', 'Owner_Name', 'Application', 'Asset_Type', 'CVE', 'Cloud_Account_ID', 'Cloud_Account_Name', 'Data_Classification', 'Data_Type', 'EXT_IP_Address', 'FQDN', 'IP_Address', 'InstanceType', 'Is_Cloud_Device', 'Is_EC2_Idle', 'Is_Encrypted', 'Is_Image_Public', 'Is_Managed_Asset', 'Is_Public', 'Is_Public_Inbound', 'Is_Server', 'Is_Virtual', 'Location', 'MAC_Address', 'Model', 'Monthly_Cost', 'OS', 'Open_Port_List', 'Owner_Department', 'Owner_Email', 'Owner_Job_Title', 'Owner_Manager', 'Region', 'Risk_Level', 'Serial_Number', 'Services', 'Risk_Score', 'Status', 'VA_Scan', 'Vendor']
2022-04-15 00:15:18.127 | INFO     | loguru._logger:info:1960 - Save outputs to asset/user tables
2022-04-15 00:15:21.733 | INFO     | loguru._logger:info:1960 -  Done! AWS_CMDB_Output Data Inserted: (5509, 207)
2022-04-15 00:15:22.102 | INFO     | loguru._logger:info:1960 -  Done! User_Combine Data Inserted: (1121, 53)
2022-04-15 00:15:22.168 | INFO     | loguru._logger:info:1960 -  Done! User_IP Data Inserted: (940, 4)
2022-04-15 00:15:22.225 | INFO     | loguru._logger:info:1960 -  Done! Host_IP Data Inserted: (940, 4)
2022-04-15 00:15:22.284 | INFO     | loguru._logger:info:1960 -  Done! User_IP_History Data Inserted: (940, 4)
2022-04-15 00:15:22.342 | INFO     | loguru._logger:info:1960 -  Done! Host_IP_History Data Inserted: (940, 4)
2022-04-15 00:15:27.021 | INFO     | loguru._logger:info:1960 -  Done! Asset_History Data Inserted: (5509, 207)
2022-04-15 00:15:27.557 | INFO     | loguru._logger:info:1960 -  Done! User_History Data Inserted: (1121, 53)
2022-04-15 00:15:27.566 | WARNING  | loguru._logger:warning:1968 - Input data is empty: User_Change collection NOT created
2022-04-15 00:15:27.570 | INFO     | loguru._logger:info:1960 -  Done! Asset_Change Data Inserted: (2, 6)
2022-04-15 00:15:27.630 | INFO     | loguru._logger:info:1960 -  Done! Data_Summary Data Inserted: (881, 11)
2022-04-15 00:15:27.972 | INFO     | loguru._logger:info:1960 - Create SINGLE index on AWS_CMDB_Output table: ['Asset_Name', 'IP_Address', 'Owner_Name', 'Serial_Number', 'sourcetype', 'First_Discovered_Datetime', 'Last_Discovered_Datetime']
2022-04-15 00:15:27.973 | INFO     | loguru._logger:info:1960 - Create FIELD TEXT indexes on AWS_CMDB_Output table
2022-04-15 00:15:29.021 | INFO     | loguru._logger:info:1960 - Create SINGLE index on User_Combine table: ['Asset_Name', 'IP_Address', 'Owner_Name', 'sourcetype', 'First_Discovered_Datetime', 'Last_Discovered_Datetime']
2022-04-15 00:15:29.021 | INFO     | loguru._logger:info:1960 - Create FIELD TEXT indexes on User_Combine table
2022-04-15 00:15:29.139 | INFO     | loguru._logger:info:1960 - Create FULL TEXT indexes on User_IP table
2022-04-15 00:15:29.175 | INFO     | loguru._logger:info:1960 - Create FULL TEXT indexes on Host_IP table
2022-04-15 00:15:29.215 | INFO     | loguru._logger:info:1960 - Create FULL TEXT indexes on User_IP_History table
2022-04-15 00:15:29.219 | INFO     | loguru._logger:info:1960 - Create FULL TEXT indexes on Host_IP_History table
2022-04-15 00:15:29.227 | INFO     | loguru._logger:info:1960 - Create SINGLE index on Asset_History table: ['Asset_Name', 'IP_Address', 'Owner_Name', 'Serial_Number', 'sourcetype', 'First_Discovered_Datetime', 'Last_Discovered_Datetime']
2022-04-15 00:15:29.228 | INFO     | loguru._logger:info:1960 - Create FIELD TEXT indexes on Asset_History table
2022-04-15 00:15:29.238 | INFO     | loguru._logger:info:1960 - Create SINGLE index on User_History table: ['Asset_Name', 'IP_Address', 'Owner_Name', 'sourcetype', 'First_Discovered_Datetime', 'Last_Discovered_Datetime']
2022-04-15 00:15:29.238 | INFO     | loguru._logger:info:1960 - Create FIELD TEXT indexes on User_History table
2022-04-15 00:15:29.241 | WARNING  | loguru._logger:warning:1968 - User_Change data does not exist: TEXT index not created
2022-04-15 00:15:29.244 | INFO     | loguru._logger:info:1960 - Create FULL TEXT indexes on Asset_Change table
2022-04-15 00:15:29.245 | INFO     | loguru._logger:info:1960 - Create output metadata for asset/user tables
2022-04-15 00:15:29.246 | INFO     | loguru._logger:info:1960 - Getting field summary and metadata on outputs
2022-04-15 00:15:43.733 | INFO     | loguru._logger:info:1960 - Extract keys and values from nested fields: ['Vuln_List', 'Tag', 'Security_Group_Rules', 'Image_Tag', 'File_Name', 'User_Bucket', 'List_Users', 'Application', 'Maturity', 'Details']
2022-04-15 00:15:48.000 | INFO     | loguru._logger:info:1960 -  Done! Metadata_AWS_CMDB_Output Data Inserted: (241, 5)
2022-04-15 00:15:48.077 | INFO     | loguru._logger:info:1960 -  Done! Metadata_Asset_History Data Inserted: (241, 5)
2022-04-15 00:15:48.079 | INFO     | loguru._logger:info:1960 - Getting field summary and metadata on outputs
2022-04-15 00:15:50.476 | INFO     | loguru._logger:info:1960 - Extract keys and values from nested fields: ['Asset_OS', 'Owner_Key', 'Owner_Policies', 'Is_MFA_Configured', 'Is_Password_Enabled', 'Tag', 'File_Name', 'Application', 'Details']
2022-04-15 00:15:51.981 | INFO     | loguru._logger:info:1960 -  Done! Metadata_User_Combine Data Inserted: (84, 5)
2022-04-15 00:15:52.032 | INFO     | loguru._logger:info:1960 -  Done! Metadata_User_History Data Inserted: (84, 5)
2022-04-15 00:15:52.034 | INFO     | loguru._logger:info:1960 - Getting field summary and metadata on outputs
2022-04-15 00:15:52.242 | INFO     | loguru._logger:info:1960 -  Done! Metadata_User_IP Data Inserted: (4, 4)
2022-04-15 00:15:52.267 | INFO     | loguru._logger:info:1960 -  Done! Metadata_User_IP_History Data Inserted: (4, 4)
2022-04-15 00:15:52.268 | INFO     | loguru._logger:info:1960 - Getting field summary and metadata on outputs
2022-04-15 00:15:52.502 | INFO     | loguru._logger:info:1960 -  Done! Metadata_Host_IP Data Inserted: (4, 4)
2022-04-15 00:15:52.526 | INFO     | loguru._logger:info:1960 -  Done! Metadata_Host_IP_History Data Inserted: (4, 4)
2022-04-15 00:15:52.527 | INFO     | loguru._logger:info:1960 - Update license usage
2022-04-15 00:15:52.559 | INFO     | loguru._logger:info:1960 - Get license usage from previous day
2022-04-15 00:15:52.561 | INFO     | loguru._logger:info:1960 - Get license usage from previous 30 days
2022-04-15 00:15:52.564 | INFO     | loguru._logger:info:1960 - Clean up over 15 days' historical data
2022-04-15 00:15:52.863 | INFO     | loguru._logger:info:1960 - Generate dynamic fields ......
2022-04-15 00:15:52.879 | INFO     | loguru._logger:info:1960 - -- {"data":{"task_id":""},"message":"There are 0 dynamic field statements being executed","status":200}
2022-04-15 00:15:52.879 | INFO     | loguru._logger:info:1960 - Data merger process completed!
2022-04-15 00:15:53.003 | INFO     | loguru._logger:info:1960 - --------- Final Results: 2 Minutes
2022-04-15 00:15:53.004 | INFO     | loguru._logger:info:1960 - --------- Merger Running Time: 16 Minutes

```

# Notes TODO

1. UI has version/commit info: needs before release, for debugging
2. Categorize bugs per components or even UI menu: all bugs will appear to be UI
3. Definition of release thresholds. Missing PM? but we have UAT.

   1. There are two type of UAT: branch new end-2-end, and incremental
      on existing customer's version.
   2. regression: end-2-end w/ all test cases available
   3. UAT: happy path all test cases + H bug test cases


## UI observation

To follow up the discussion (and I'm gonna skip the screenshots then)
and ignore if it doesn't make sense. There could be a lot of rookie's
mistakes here.

Menu/navigation:

1. `Settings`: `Query Management` get its own 1-level nagivatioin.
2. Three `Field Management` as submenu items of `Query Management` main.
3. Unify word in this menu, `Manage license` instead of `License`, for
   example.
4. If `integration` is for `Action Center`, then its a submenu under
   `Action...` main.

Connector:

1. Connector `Edit` should be visible w/o hover.
2. Connector error should yield a general error msg at the bottom of
   its card so to bring attention to admin.
       1. Change the "!" icon to a clickable component, eg. link
          button/text, says "details".

Mega guery drawer:

1. Two `Add Condition` are adding two different logic, `OR` vs. `AND`,
   thus should worded differently.


Mega query dropdown menu when selecting a field:

1. Not obvious the left column is **grouping**, and right column is
   details inside selected group. Give the group column a header,
   eg. "Asset Group", and field column eg. "Query Field". If given
   header, remove `bold` style from group values.
2. Subgrouping of _details_ in a group, eg. A-Z, needs
   navigation. Because the submenu has limited space, layout these
   will be challenging.
3. Details' subgrouping header needs stand out, eg. color.
4. Needs padding top, left, and bottom, eg. `2em`.

Overall, I feel this dropdown menu is trying to achieve too
much, but no thought yet.

Overview:

1. The pane on the right, each section needs separation,
   eg. line.
2. Would recommend group `User` pie w/ `New User Found` in one card,
   and so for `Asset` and `Data`.
3. Recommend to put `ingestion flow` in a card also.

Report center charts:

1. Subtitle `Bar Chart` doesn't add additional info to user because
   the chart is a bar chart. If using it to differentiate two charts
   from the same data resource, create a meaningful data attribute
   representing this in the system first. Recommend to replace
   eventually.

Useful links:

1. [material io components](https://material.io/components), try to
   use these lingos more & more in daily discussions, especially w/ UI
   developers.
2. [reactJS material UI](https://v4.mui.com/), if we are using REACT
   for frontend, then this is a lib to achieve material in previous
   bullet. Take a look of its components and capabilities, that will
   give designer an idea what can be done by coder, easy or hard.

# AWS setup


## aws-vault

`aws-vault` is a binary. Download and install.

```shell
# Downlaod the binary
# Here we put it in `/user/local/bin`
curl -L -o /usr/local/bin/aws-vault https://github.com/99designs/aws-vault/releases/download/v4.2.0/aws-vault-linux-amd64

# make it executable
chmod +x /usr/local/bin/aws-vault

# test
aws-vault --help
```

## add aws account as profile

1. In order to use it, you need to have a backend. The easiest is to
   set `export AWS_VAULT_BACKEND=file`.
2. Then make sure you have folder ~/.aws. Run touch ~/.aws/config to
   create a config file if you haven't yet configured aws cli.
3. Now run the aws-vault add <profile name>. It prompts you for your
   access key id and secret access key, and a passphrase.
4. `aws-vault list` to check the profile list.

## configure AWS SSO

Make sure you use aws v2:

1. `curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"`
2. Unzip, and run `./aws/install --update`
3. Test aws --version

Now `aws configure sso`, pass in the values as example below:

```
fengxia@fl5wvhzxat:~/aws$ aws configure sso
SSO start URL [None]: https://d-<.....>.awsapps.com/start
SSO Region [None]: us-east-1
There are 12 AWS accounts available to you.
Using the account ID <......>
The only role available to you is: ReadOnly
Using the role name "ReadOnly"
CLI default client Region [None]: us-east-1
CLI default output format [None]: json
CLI profile name [ReadOnly-<account id>]: give-it-a-name
```

Note:

1. When running for the first time, it prompts you to paste the URL to
   browser, then UI asks for request approval.

     [](mydev/devops/accunt-approval.png)

2. When selecting the account, it shows a screen like this. Use the arrow key
   to select the account you want to use.

     [](mydev/devops/config-sso-select-account.png)

For a good explanation of SSO, read [this][2].

## EC2 state

According to [Boto][boto]:

```shell
0 : pending
16 : running
32 : shutting-down
48 : terminated
64 : stopping
80 : stopped

```


[1]: https://lucidumio.sharepoint.com/:w:/r/sites/ProductDevelopment/_layouts/15/Doc.aspx?sourcedoc=%257B7CEB3642-2AA2-4916-86C6-E08729FA94A8%257D&file=Lucidum%2520Data%2520Cache%2520Schemas%2520WPS.docx&action=default&mobileredirect=true

[2]: https://ben11kehoe.medium.com/you-only-need-to-call-aws-sso-login-once-for-all-your-profiles-41a334e1b37e

[boto]: https://boto3.amazonaws.com/v1/documentation/api/latest/index.html
