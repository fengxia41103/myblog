**********************************
Product Release Announcement
**********************************

# Version

V3.2.5

# Date

September 28, 2022

# Summary

- Product component versions:
  [V3.2.5.json](https://github.com/LucidumInc/lucidum-deploy/blob/main/lucidum-product-release-versions-V3.2.5.json)

- Release note:
  [confluence](https://luciduminc.atlassian.net/wiki/spaces/MVPV1/pages/1703903249/Lucidum+Version+3.2.5)

- Release tag for ECR docker images: **release-V3.2.5**

# Resource

## SaaS

- AMI image ID: `ami-06718e556d430806c` in `us-east-1`
- Default passwords:

    - [UI Admin password](https://us-east-1.console.aws.amazon.com/systems-manager/parameters/lucidum-deploy/aws/lucidumSAAS-V3.2.5/admin-password/description?region=us-east-1&tab=Table)
    - [DB password](https://us-east-1.console.aws.amazon.com/systems-manager/parameters/lucidum-deploy/aws/lucidumSAAS-V3.2.5/db-password/description?region=us-east-1&tab=Table)
    - [Airflow Admin password](https://us-east-1.console.aws.amazon.com/systems-manager/parameters/lucidum-deploy/aws/lucidumSAAS-V3.2.5/airflow-password/description?region=us-east-1&tab=Table)
    - [SSH password](https://us-east-1.console.aws.amazon.com/systems-manager/parameters/lucidum-deploy/aws/lucidumSAAS-V3.2.5/ssh-password/description?region=us-east-1&tab=Table)


## On-prem

- AMI image ID: `ami-0d79a1bfd9bda8b6a` in `us-east-1`
- OVA image:
`s3://packer-ami-pipelines-ubuntu18-vmdk/release/lucidum-V3.2.5/lucidum-V3.2.5.ova`
- Default passwords:

    - [UI Admin password](https://us-east-1.console.aws.amazon.com/systems-manager/parameters/lucidum-deploy/aws/lucidum-V3.2.5/admin-password/description?region=us-east-1&tab=Table)
    - [DB password](https://us-east-1.console.aws.amazon.com/systems-manager/parameters/lucidum-deploy/aws/lucidum-V3.2.5/db-password/description?region=us-east-1&tab=Table)
    - [Airflow Admin password](https://us-east-1.console.aws.amazon.com/systems-manager/parameters/lucidum-deploy/aws/lucidum-V3.2.5/airflow-password/description?region=us-east-1&tab=Table)
    - [SSH password](https://us-east-1.console.aws.amazon.com/systems-manager/parameters/lucidum-deploy/aws/lucidum-V3.2.5/ssh-password/description?region=us-east-1&tab=Table)
