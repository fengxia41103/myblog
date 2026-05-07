---
mainfont: DejaVu Serif
monofont: DejaVu Sans Mono
titlepage: false
papersize: a4
fontsize: 10pt
geometry: margin=1.30in
linkstyle: slanted
urlcolor: RoyalBlue
subparagraph: yes
header-includes: |
    \usepackage{dashrule}
    \usepackage{setspace}
    \singlespacing
    \usepackage{parskip}
    \usepackage{fancyhdr}
    \fancyhead[LO,LE]{
        \textbf{Feng Xia}\\
        \url{github.com/fengxia41103}}
    \fancyhead[RO,RE]{
        (508) 801-1794\\
        fengxia41103@gmail.com}
    \pagestyle{fancy}
    \usepackage{pifont}
    \renewcommand{\labelitemi}{\ding{125}}
    \let\emphasized\emph
    \renewcommand{\emph}[1]{\textcolor{RoyalBlue}{\emphasized{#1}}}
    \usepackage[dvipsnames]{xcolor}
    \usepackage{titlesec}
    \titleformat{\subsection}[leftmargin]{\normalfont\bfseries}{\thesubsection}{8pt}{}
    \titlespacing{\subsection}{5em}{1em}{1pc}

---

Seeking _DevOps Engineer, Platform Engineer, SRE, Cloud Infrastructure Architect_
&mdash; I build and operate production infrastructure at scale, with
deep expertise in CI/CD, containerization, IaC, and cloud platforms.

# Highlights

- **Cloud Platforms & Infrastructure as Code**

  - Proficient in AWS (EC2, S3, Lambda, ECS, RDS, Aurora, VPC, Transit
    Gateway, Route53, CloudFront, API Gateway, SQS, SNS, KMS,
    Secrets Manager, Bedrock, OpenSearch, Athena, Glue).
  - Proficient in Azure (Synapse, ADLS, Entra ID, RBAC, Power Automate).
  - Infrastructure as Code: Terraform, Pulumi, Kustomize, Helm, Ansible.

- **Container Orchestration & GitOps**

  - Proficient in Kubernetes (K8S), Red Hat OpenShift (ROSA), Docker,
    Containerd, Helm, ArgoCD, Harbor.
  - Hands-on multi-cluster management with auto-scaling, drift
    detection, and Day 0/1/2 automation.

- **CI/CD Pipelines & Automation**

  - Expert in designing and maintaining CI/CD: GitHub Actions,
    Jenkins, Bitbucket Pipelines, Copado, Semantic Release.
  - Reusable workflow orchestration, multi-branch builds, matrix
    testing, A/B deployment, GitOps promotion models.

- **Observability, Monitoring & SRE**

  - Proficient in Splunk, CloudWatch, Prometheus, Grafana, ELK.
  - Built real-time health dashboards with alerting (SNS, WebSocket).
  - Production incident management and post-mortem processes.

- **Security & Compliance**

  - Security scanning: Trivy, Veracode, SonarQube, Burp Suite, Qualys.
  - Secrets management: AWS Secrets Manager, Hashicorp Vault, Ansible Vault.
  - FedRAMP SSP (NIST 800-53), SBOM compliance, CVE remediation.
  - SSO/Identity: OAuth2, OIDC, SAML, SCIM, Azure AD, Keycloak.

- **Scripting & Development**

  - Python, Bash, Groovy, YAML, Terraform HCL, Ansible playbooks.
  - Django, FastAPI, Flask for tooling and automation services.
  - Strong in Linux, networking (BGP, Direct Connect, VPN, WAF).

# Experience

## 12/2023 -
Department of Health and Human Service, North Carolina, Principal
System Architect / DevOps Lead

- Managed multi-cluster ROSA (Red Hat OpenShift on AWS) infrastructure
  (Dev, Pre-Prod, Prod) with auto-scaling worker nodes (r6a.2xl, up
  to 12 nodes/96 CPU/768 GB) across 7 AWS accounts and 3 Azure
  subscriptions. Implemented Terraform-based IaC, Kustomize manifests,
  and ArgoCD GitOps with drift detection and Day 0/1/2 automation.

- Designed and maintained centralized CI/CD pipeline orchestration via
  reusable GitHub Actions workflows shared across 50+ repositories,
  integrating MuleSoft deployment, SonarQube quality gates, Postman
  API testing, security scanning (Trivy, Veracode), Semantic Release,
  and commitlint enforcement.

- Built a real-time PROD health monitoring system checking 48+ API
  endpoints and OpenShift pods every 60 seconds with AWS SNS alerting
  on consecutive failures, React UI with WebSocket updates,
  complementing Splunk and CloudWatch dashboards.

- Architected serverless infrastructure for a document management
  system (replacing IBM FileNet): event-driven pipeline (S3,
  EventBridge, Lambda, DynamoDB, SQS DLQ), KMS encryption, VPC
  Endpoints, JWT custom authorizer, automated Glacier archival,
  deployed via Terraform/OpenTofu across dev/test/prod.

- Managed Azure infrastructure: Synapse Workspace, Dedicated SQL Pool,
  ADLS, Entra ID/RBAC, Power Automate. Architected end-to-end data
  pipeline (Salesforce → Azure Pipeline → Synapse → Power BI → AWS
  SFTP → NCFS mainframe) for monthly financial batch processing.

- Deployed GenAI platform on OpenShift via ArgoCD: Django/FastAPI
  backend with Celery/Redis workers, AWS Bedrock integration,
  OpenSearch Serverless, Terraform modules for Lambda/S3/RDS across 6
  environments with Docker Compose for local dev.

- Implemented Terraform-based AWS Secrets Manager automation with
  per-secret IAM resource policies, metadata tagging, rotation
  alerting via GitHub Actions, and certificate lifecycle management.

- Designed the user identity pipeline: Azure AD/NCID SSO with SCIM
  provisioning to Salesforce, JIT activation, automated user
  validation tooling (Lambda + S3 + API Gateway).

- Led security hardening: FedRAMP SSP documentation (NIST 800-53),
  SBOM and license compliance tracking for 30+ SaaS products,
  network security across Direct Connect, Transit Gateway, Cloudflare
  WAF, and security group automation.

- Built high-performance ETL service (Python/FastAPI) as OpenShift
  CronJob: monthly SFTP ingestion of 1.2M+ records, streaming delta
  loads to PostgreSQL, Athena serverless analytics, secured via
  MuleSoft OAuth.

- Initiated comprehensive test automation infrastructure: Robot
  Framework regression suites, Playwright E2E, JMeter load testing,
  YAML-driven declarative test framework, all integrated into CI/CD.

## 3/2022 - 3/2023
Lucidum, Principal System Architect

- As primary developer and maintainer of CI/CD pipelines featuring
  multi-branch building, matrix testing, A/B deployment, integration
  of GitHub Code, GitHub Actions, GitHub Package, AWS, and Azure.

- Managed successful execution of 2 major releases, 6 minor releases,
  and 12 patch releases. Initiated GitOps practices using GitHub
  Actions, GitHub Package Registry, and Semantic Release.

- Hardened security in DevOps workflows by initiating CVE scanner
  (code, docker image), and integration with secret managers including
  Hashicorp Vault, Ansible Vault, AWS & Azure Secret Managers.

- As the company's AWS and Azure administrator responsible for overall
  configuration and application of cloud services including SSO, IAM,
  ACR, ECR, ECS, RDS, Aurora, EC2, S3, Fargate, Lambda, CloudWatch,
  SNS, VPC, WAF, ELB, TargetGroup, Route53, CloudFront.

- Transformed on-prem-only deployment model to hybrid and cloud-native.
  Introduced and integrated various AWS & Azure services to achieve a
  successful transition of twelve production systems.

- Drove substantial improvements in test automation: revamped 800+
  Cypress E2E tests within 6 weeks, improved performance by 50% and
  achieved 100% automation in UAT.

## 11/2016 - 3/2022
Lenovo US, P8, Advisory Engineer, Senior Solution Architect, Team Lead

- As the principal system architect and first author of the ["_Lenovo
  Open Cloud Automation Reference Architecture_"][1], a baremetal-to-cloud
  orchestration platform. Led a global team of six, delivered in 13
  months, showcased at MWC Barcelona 2019, won $100M contract. Key
  DevOps: Jenkins, Ansible, Python, zero-touch provisioning.

- As the principal system architect of the ["_RedHat Hyperconverged
  Infrastructure (RHHI) Reference Architecture_"][2], a 3-12 server
  VM-workload solution with Glusterfs, layer-3 networking, HA, fault
  tolerance, zero-touch node discovery. Key DevOps: Ansible, Jenkins,
  Cloudform, Python.

- As the principal architect of the "_Lenovo Workload Solution Store_",
  a baremetal orchestration solution using declarative taxonomy,
  serving as the core of ThinkAgile VX. Key DevOps: Ansible, Canonical
  MAAS, Juju, Django, React.

- As team lead of ThinkAgile CP, a hybrid cloud platform with on-prem
  infrastructure and AWS management plane. Oversaw DevOps in Jenkins,
  ArgoCD, Helm, Kubernetes (K8S), and production deployment in AWS.

- As lead developer of a DCIM system (Netbox-based) administrating
  300+ servers and switches globally. Stack: Django, Celery, Redis,
  MySQL, Docker, Ansible, ENOS/NOS.

## 01/2015 - 11/2016
PY Consulting, Founder, Freelance

_UNC Chapel Hill, School of Medicine, Contractor_

- Initiated the organization's first Docker-based deployment and CI/CD
  in production. Led the school's DevOps initiative by authoring its
  technology roadmap, and oversaw DevOps Phase 2 & Phase 3. Provided
  trainings in Git, Docker, Jenkins, Python, Ansible, Cypress.

_Massachusetts General Hospital, Volunteer_

- Containerized deployment of two ML tools (`deeplabcut`, `simba`),
  reducing installation time from days to 30 minutes. Mentored team
  on Git, Docker, Python, DevOps.

## 04/2004 - 05/2007
Bit 9 Inc. (Carbon Black), Researcher, Tech Lead

- Led research securing the Windows NT kernel, resulting in $6M
  A-round from Kleiner Perkins.

## 07/1998 - 04/2004
Instron Corp., Senior Engineer

- Developed real-time firmware: VxWorks RTOS, real-time Linux, C,
  National Instrument DAQ, Texas Instruments DSP, Allen-Bradley PLC.

# Education

- _MBA (04/2007 - 09/2008)_, Boston Univ., International Management & Finance
- _Master of Science (09/1995 - 05/1997)_, Ohio Univ., Electrical Engineering
- _Bachelor of Science (09/1990 - 07/1994)_, Shanghai JiaoTong
  Univ., China, Electrical Engineering

# Publications

1. https://lenovopress.com/lp1148-red-hat-hyperconverged-infrastructure-for-virtualization-reference-architecture
2. https://lenovopress.com/lp1149-lenovo-open-cloud-reference-architecture

[1]: https://lenovopress.com/lp1148-red-hat-hyperconverged-infrastructure-for-virtualization-reference-architecture
[2]: https://lenovopress.com/lp1149-lenovo-open-cloud-reference-architecture
