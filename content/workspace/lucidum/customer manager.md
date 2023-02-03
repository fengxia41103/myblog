# Use Case

**AS A**: Lucidum admin

**I WANT**: have a single-pane-of-glass of Tenant

**SO THAT**: I can manage their life cycle systematically

# Analysis


## Challenges Today

1. Lack of a source-of-truth of Tenant component versioning and
   configs. The `docker-compose` files are the record keeper of
   component versions right now. However, version can be inaccurate,
   and they don't cover other important configs critical to the
   application.

2. Lack of an anchor point to manage Tenant lifecycle including
   provisioning, updating/patching, suspension, decommissioning,
   backup, restore/rollback, thus also lacking audit log of these
   Tenant events.

3. Tenant metrics is not centralized. Info such as infra, logs, runtime
   metrics are managed by different tools, but are not yet have a
   Tenant-centric view of these data.

4. Tenant health lacks a baseline definition, thus making
   validation of tenant unreliable especially after a change.

Ref: [customer manager instance](https://172.16.200.160:5500/customers)


## Strategy

1. Extend customer manager function to become **Lucidum Admin Portal**.

2. Track component versions in a Tenant, and apply changes such as
   patch/upgrade only through the portal.

3. Tenant configs managed by this portal must be sufficient to
   replicate a running state w/ support of data restored from a recent
   backup.

4. Portal integrates with an orchestrator, SaaS Jenkins, to carry out
   change request targeting a Tenant or a group of Tenant.

5. Change of state of a Tenant should be implemented in Ansible as
   much as possible so the same set of recipe can scale to large
   number of Tenants remotely. This includes integration w/ Update
   Manager API in each EC2.

6. Pick a set of existing UI tests, API tests as baseline health
   definition, and exercise them throughout full life of a
   Tenant. Gradually expand this set to include more interest points
   we want to ensure, thus incrementally build up the robustness of
   Tenant.

# Design

## Overview

<img data-src="images/admin%20portal%20high%20level.png"
     class="responsive-img materialboxed"
     style="box-shadow:none;">

## Change models

Categorize op tasks that will result in a change of state of the
system into **three** change models:

| Change Model                      | Description                                                      | Example           |
|-----------------------------------|------------------------------------------------------------------|-------------------|
| Live Patching                     | In place patch the live system w/o interrupting the service      | Password rotation |
| Lock-down (aka. maintenance mode) | Service/system access is denied or limited to facilitate the ops | DB snapshot       |
| Bait & switch/swap                | Setup parallel instance w/ new changes, then redirect traffic    | New release       |


## Functions/Ops

To manage a tenant:

| Function                                        | Live | Maintenance | Swap |
|-------------------------------------------------|------|-------------|------|
| Provision new tenant                            |      |             |      |
| Terminate tenant                                | x    |             |      |
| Suspend & resume a tenant                       | x    |             |      |
| Enter maintenace mode                           | x    |             |      |
| Exit maintenance mode                           |      | x           |      |
| Upgrade to a release                            |      | x           | x    |
| Full backup (binary+config+data+runtime states) |      | x           |      |
| Full restore                                    |      | x           | x    |
| Validate health baseline (testing)              | x    |             |      |
| Report tenant configs                           | x    |             |      |
| Report tenant AWS metrics                       | x    |             |      |
| Report tenant metering                          | x    |             |      |
| Webapp password rotation                        | x    |             |      |
| DB password rotation                            |      | x           | x    |
| Airflow password rotation                       |      | x           | x    |


## Tenant state life cycle

<img data-src="images/tenant%20states.png"
     class="responsive-img materialboxed"
     style="box-shadow:none;">


## Tenant states


| State            | Description                           |
|------------------|---------------------------------------|
| Provisioning     | New Tenant instance being created     |
| Healthy          | Meet our definition of conditions     |
| Maintenance Mode | System in READONLY mode to customer   |
| Backing up       | Taking snapshot of Tenant             |
| Restoring        | Recovering from a snapshot            |
| In Testing       | Validating system w/ baseline tests   |
| Suspended        | Revoke customer access due to license |
| Broken           | System failed health definition       |
| End of Life      | Resources can be deleted              |


## Storage

## Backend

### Data Models

Areas to cover: license, product/component version, change log, AWS
resource inventory, and tenant configs.

| Model                 | Description                                                 | Field Change Log |
|-----------------------|-------------------------------------------------------------|------------------|
| `Customer`            | Customer basic info                                         | Y                |
| `License`             | Type of license, template                                   | Y                |
| `LicenseAssignment`   | Per customer license detail, eg. public/private key         | Y                |
| `ProductRelease`      | Official release versions, eg. 3.1.0                        | Y                |
| `ComponentVersion`    | Component version in a Tenant                               | Y                |
| `Tenant`              | Tenant basic info, eg. on which release                     | Y                |
| `TenantConfig`        | KV values                                                   | Y                |
| `TenantChangeRequest` | Change request to a Tenant, eg. patch, upgrade, maintenance | N                |
| `TenantAwsResource`   | AWS ARNs used by a Tenant                                   | N                |

### Data Model Relations

<img data-src="images/customer.png"
     class="responsive-img materialboxed"
     style="box-shadow:none;">

### Example recipe

1. Upgrade license: update `LicenseAssignment`, then`TenantChangeRequest` to
   activate new license on Tenant.

2. Revoke license: `LicenseAssignment` change `status`, then
   `TenantChangeRequest` to suspend Tenant.

3. Upgrade/patch: update `ProductRelease`, `ComponentVersion`, then
   compose a set of `TenantConfig`, then `TenantChangeRequest` to
   upgrade.

4. Backup: `Tenant` state to `maintenance`, `TenantChangeRequest` to
   block public access, `TenantChangeRequest` to backup.

5. Shared AWS resource: `TenantAwsResource`, same ARN linked to
   multiple `Tenant`.

6. Arbitrary tenant config values: poll Tenant and update `TenantConfig`

### API

## Frontend

## QA

# Implementation Ticket
