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

Seeking _Principal/Chief System Architect, Enterprise Architect_
&mdash; I design large-scale distributed systems end-to-end, from
reference architecture through production operations, with a track
record of delivering mission-critical platforms at state and
enterprise scale.

# Highlights

- **Enterprise Architecture & Governance**

  - Authored reference architectures for $93M state program and $100M
    enterprise product, both delivered to production.
  - Published architecture papers: ["_Lenovo Open Cloud Automation
    Reference Architecture_"][1], "_RedHat Hyperconverged
    Infrastructure (RHHI) Reference Architecture_".
  - Expert in architecture decision frameworks, SBOM compliance,
    FedRAMP (NIST 800-53), and formal state/DIT review processes.

- **Distributed Systems & Cloud-Native Architecture**

  - Multi-cloud (AWS, Azure): serverless, event-driven, microservices,
    container orchestration (Kubernetes/OpenShift), API-led connectivity.
  - Designed systems spanning 7 AWS accounts, 3 Azure subscriptions,
    multi-cluster ROSA, 13+ MuleSoft APIs, 12 external integrations.
  - HA patterns: auto-scaling, DLQ retry, drift detection, Glacier
    tiering, failover, network bonding, message queues.

- **AI/ML & Data Architecture**

  - RAG pipelines (Bedrock Claude, Titan embeddings, OpenSearch
    Serverless, Guardrails), ETL (Synapse, Athena, Glue), streaming
    ingestion, data lake/warehouse patterns.

- **Integration & API Architecture**

  - API-led connectivity (MuleSoft), RESTful, GraphQL, SOAP, SCIM,
    OAuth2/OIDC/SAML, event-driven (EventBridge, SQS/SNS).
  - System integration across government, financial, healthcare, and
    identity systems.

- **Security Architecture**

  - Identity: SSO, SCIM provisioning, RBAC, Azure AD/Entra, Keycloak.
  - Compliance: FedRAMP SSP, NIST 800-53, SBOM, CVE remediation.
  - Infrastructure: KMS, Secrets Manager, WAF, VPC Endpoints, Direct
    Connect, Transit Gateway.

- **Platform & Infrastructure**

  - IaC: Terraform, Kustomize, Helm, Ansible, Pulumi.
  - GitOps: ArgoCD, GitHub Actions, Semantic Release.
  - Observability: Splunk, CloudWatch, Prometheus, Grafana.

# Experience

## 12/2023 -
Department of Health and Human Service, North Carolina, Principal
System Architect

- As the principal system architect of the PATH NC ($93M) child
  welfare modernization, led the successful go-live (June 2025) of a
  statewide platform serving 3,000+ users across all 100 NC counties.
  Oversaw 50+ repositories, 30+ SaaS/COTS products, 7 AWS accounts,
  3 Azure subscriptions, and a multi-cluster OpenShift platform.

- Established architecture governance from scratch: authored the
  reference architecture, formal DIT/State architecture review
  decision points, custom code dev/build/deploy standards, SBOM and
  license compliance, backup & restore strategy, production incident
  management, and PROD health dashboards. Systematically drove go-live
  readiness and post-go-live tech debt resolution.

- Designed the complete system topology: Salesforce application tier
  (2,745+ Apex classes, 1,195+ LWC, 647+ objects), MuleSoft
  integration layer (13+ APIs to 12 external systems), serverless
  document management (Lambda, EventBridge, DynamoDB, S3), GenAI/RAG
  platform (Bedrock, OpenSearch), data warehouse (Azure Synapse), and
  container platform (ROSA/OpenShift with ArgoCD).

- Architected the user identity and access model: Azure AD/NCID SSO
  with SCIM provisioning, JIT activation, per-county role matrix
  (400+ application roles), Salesforce ACL model, and phased rollout
  validation tooling.

- Designed the end-to-end financial data movement architecture
  (Salesforce → Azure Pipeline → Synapse → Power BI → AWS SFTP → NCFS
  mainframe) with Power Automate orchestration for monthly county
  payment processing.

- Architected the serverless document management system replacing IBM
  FileNet: event-driven ingestion, intelligent document processing
  (Textract, Bedrock), DLQ retry orchestration, Glacier archival,
  KMS encryption, JWT authorization, VPC Endpoints.

- Designed the GenAI platform architecture (GenAIe): evaluated
  alternatives (Kendra, Salesforce AgentForce, Microsoft Copilot),
  selected RAG approach with Bedrock Claude/Titan, OpenSearch
  Serverless, Bedrock Guardrails, deployed on OpenShift across 6
  environments.

- Defined infrastructure architecture: multi-cluster ROSA with
  auto-scaling (up to 12 nodes/96 CPU/768 GB), Terraform IaC,
  Kustomize/ArgoCD GitOps, drift detection, Day 0/1/2 automation,
  network design across Direct Connect, Transit Gateway, Cloudflare.

- Led security architecture: FedRAMP SSP (NIST 800-53), secrets
  lifecycle management, network segmentation, security scanning
  pipeline (Trivy, Veracode, SonarQube), and compliance tracking.

## 3/2022 - 3/2023
Lucidum, Principal System Architect

- Led design of the next-gen product architecture transforming
  on-prem-only model to hybrid and cloud-native. Introduced AWS &
  Azure services achieving successful transition of twelve production
  systems.

- Defined the system's multi-tenant architecture spanning Python,
  Java, and React services deployed via Helm/K8S with Jenkins and
  ArgoCD. Oversaw 50+ repositories across the full stack.

- Architected CI/CD pipeline system: multi-branch building, matrix
  testing, A/B deployment, GitHub Actions/Package integration, CVE
  scanning, and secret management (Hashicorp Vault, AWS/Azure).

- As AWS and Azure administrator: SSO, IAM, ECR, ECS, RDS, Aurora,
  Lambda, CloudWatch, VPC, WAF, ELB, Route53, CloudFront.

## 11/2016 - 3/2022
Lenovo US, P8, Advisory Engineer, Senior Solution Architect, Team Lead

- As the principal system architect and first author of the ["_Lenovo
  Open Cloud Automation Reference Architecture_"][1]. Designed a
  baremetal-to-cloud orchestration platform from concept to
  market-ready product in 13 months. Showcased at MWC Barcelona 2019,
  won $100M contract.

- As the principal system architect and first author of the ["_RedHat
  Hyperconverged Infrastructure (RHHI) Reference Architecture_"][2].
  Designed a 3-12 server VM-workload solution with Glusterfs, layer-3
  networking, HA, fault tolerance, and zero-touch provisioning.

- As the principal architect of the "_Lenovo Workload Solution Store_",
  a baremetal orchestration solution using declarative taxonomy,
  serving as the core foundation of the ThinkAgile VX product.

- As team lead of ThinkAgile CP, a hybrid cloud platform with on-prem
  infrastructure and AWS management plane. Led global team delivering
  six production releases over two years.

- Designed a DCIM system (Netbox-based) administrating 300+ servers
  and switches globally: Django, Celery, Redis, Docker, Ansible.

## 01/2015 - 11/2016
PY Consulting, Founder, Freelance

- Designed and delivered systems across healthcare (UNC, MGH),
  international development (World Bank), e-commerce (Wei Fashion),
  and EdTech (Shang Xue Tang). Consistently bootstrapped architecture,
  SDLC, and DevOps practices from zero for each engagement.

## 04/2004 - 05/2007
Bit 9 Inc. (Carbon Black), Researcher, Tech Lead

- Led research securing the Windows NT kernel, resulting in $6M
  A-round from Kleiner Perkins.

## 07/1998 - 04/2004
Instron Corp., Senior Engineer

- Architected real-time firmware systems: VxWorks RTOS, real-time
  Linux, C, DSP, PLC, DAQ.

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
