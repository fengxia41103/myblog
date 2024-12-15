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

# Highlights

- **Virtualization, Containerization & Cloud Platforms**

  - Proficient in KVM, libvirt, QEMU, VMWare, Virtualbox, Vagrant.
  - Proficient in Helm, Kubernetes (K8S), Docker, Containerd, AWS, Azure;
    Infrastructure as Code: Terraform, Pulumi, Canonical MAAS, Juju.

- **CI/CD Pipelines & Testing**

  - Proficient in initiating/maintaining CI/CD pipelines: Jenkins,
    GitHub Actions, Bitbucket Pipelines.
  - Skilled with DevOps tools: Jenkins, Ansible, ELK, Prometheus,
    Grafana; GitOps: Helm, Kubernetes (K8S), Harbor, ArgoCD.
  - Skilled in testing: Postman, Cypress, Selenium, PyTest, TDD/BDD.

- **API Development & Integration**

  - Proficient in creating RESTful APIs using OpenAPI, Swagger, and
    Django Rest Framework (DRF).
  - Proficient in API integration: RESTful, GraphQL, JSON, XML, SOAP, JWT.

- **Fullstack Frameworks & Architectures**

  - Works in production: micro services, MVC, MVVM, SOA.
  - Hands-on expertise: Django, Flask, Node Express, Java Spring Boot.
  - The first author of published architecture papers: ["_Lenovo Open Cloud Automation Reference
    Architecture_"][1], "_RedHat Hyperconverged Infrastructure (RHHI)
    Reference Architecture_".

- **Frontend**

  - Adept at frontend development using Typescript, React, Redux,
    Angular, Storybook, UmiJS, Material UI, Ant Design, Bootstrap.

- **Scalable Solutions & Databases**

  - Strong DB and ORM skills: SQLAlchemy, Hibernate, MySQL,
    PostgreSQL, Mongo, InfluxDB, Elasticsearch.
  - Proficient in scalable and HA solutions: RAID, switch Port Group,
    network bonding, cache, message queue, failover.

- **Development Leadership**

  - Expert in software SDLC throughout; Proficient in Git, DevOps, GitOps,
    release, project management (Jira, Confluence).
  - Proven track records of success in all maturity levels of an
    organization: startup (5-20), mid-size (100-500), global
    enterprise. Proved capacity in roles: PM, Team Lead, System
    Architect, DevOps, QA, Developer.

- **Global Team Management& Team Enhancement**

  - Rich experience in managing global teams across geo and time zones.
  - Avid knowledge sharing to enhance overall team quality and
    efficiency.

# Experience

## 3/2022 - 3/2023
Lucidum, Principal System Architect

- Led design of the next-gen product architecture to drive expansion
  of target industry and customer base. Transformed on-prem-only model
  to hybrid and cloud-native. Introduced and integrated various AWS &
  Azure services to achieve a successful transition of twelve
  production systems.

- Managed a global engineering team. Provided oversight to roles
  including Project Manager, UX designer, ML scientist, developers
  (Python, Java, React), QA, and DevOps. Held a direct reporting line
  to the CTO.

- Managed successful execution of 2 major releases, 6 minor releases,
  and 12 patch releases. Initiated GitOps practices using GitHub
  Actions, GitHub Package Registry, and Semantic Release.

- Actively participated in coding across every facet of the
  engineering endeavor, spanning the entire product stack (Python,
  Java, Typescript, React, Redux), QA using Cypress, and DevOps
  involving Helm, Kubernetes (K8S), Jenkins, Ansible, Python, Terraform, and
  Pulumi.

- Took the lead in code reviews across a portfolio of 50+ Git
  repositories, covering a wide spectrum of programming languages and
  syntaxes, ranging from Python, Javascript, Java, SQL,
  Groovy, YAML, Json, XML, TOML.

- Drove substantial improvements in test automation efficiency and
  effectiveness. Revamped 800+ Cypress end-to-end (e2e) tests within 6
  weeks, improved performance by 50% and achieved 100% automation in UAT.

- As primary developer and maintainer of CI/CD pipelines featuring
  multi-branch building, matrix testing, A/B deployment, integration
  of GitHub Code, GitHub Actions, GitHub Package, AWS, and Azure.

- Hardened security in DevOps workflows by initiating CVE scanner
  (code, docker image), and integration with secret managers including
  Hashicorp Vault, Ansible Vault, AWS & Azure Secret Managers.

- As the company's AWS and Azure administrator responsible for overall
  configuration and application of cloud services including SSO, IAM,
  ACR, ECR, ECS, RDS, Aurora, EC2, S3, Fargate, Lambda, CloudWatch,
  SNS, VPC, WAF, ELB, TargetGroup, Route53, CloudFront.


## 11/2016 - 3/2022
Lenovo US, P8, Advisory Engineer, Senior Solution Architect, Team Lead

- As the principal system architect and the first author of the
  ["_Lenovo Open Cloud Automation Reference Architecture_"][1] (see
  "Publications"). Led a global team of six developers successfully
  transformed the concept into a market-ready product within a
  13-month timeframe. The solution was showecased in "_MWC Barcelona
  2019_" and won a $100-million contract.

- As the principal system architect and the first author of the
  ["_RedHat Hyperconverged Infrastructure (RHHI) Reference
  Architecture_"][2] (see "Publications"), a VM-workload solution
  based on Lenovo hardware including 3-12 server configuration,
  Glusterfs storage, layer-3 networking, HA, fault tolerance,
  zero-touch node discovery and provisioning. Key
  technologies included RHHI, Glusterfs, Netbox, Cloudform, Python,
  Ansible, Jenkins.

- As the principal architect of the "_Lenovo Workload Solution Store_",
  a baremetal orchestration solution based on declarative
  taxonomy. The technology serves as the core foundation of the
  ThinkAgile VX product. Key technologies included Django,
  React, Ansible, Canonical MAAS and Juju.

- As team lead of the ThinkAgile CP product, a hybrid cloud platform
  with on-prem infrastructure and AWS-based management plane. Led a
  global team of five UI/UX, two backends, one QA, and two DevOps,
  deliverying six productioin releases over two years. Oversaw
  development and quality in Java, Python, AngularJS, Angular, Redux,
  QA in Cypress, Ops in Jenkins, ArgoCD, Helm, Kubernetes (K8S), and
  production deployment in AWS.

- As lead Python developer a Datacenter Infrastructure Management
  (DCIM) system based on Netbox, administrating a portfolio of
  in-house infrastructure comprising over 300 servers and switches
  located globally. Stack include Django, React, Celery, Redis, MySQL,
  Docker, Ansible, ENOS/NOS.

## 01/2015 - present
PY Consulting, Founder, Freelance

_UNC Chapel Hill, School of Medicine, Contractor_

- Initiated the organization's first Docker-based deployment and CI/CD
  in production. Led the school's DevOps initiative by authoring its
  technology roadmap, and oversaw development of its DevOps Phase 2 &
  Phase 3 endeavors. Provided trainings on best practice and tooling
  in Git, Docker, Jenkins, Python, Javascript, Ansible, Cypress.

_Massachusetts General Hospital, Volunteer_

- Containerized the deployment of two popular machine learning tools
  among medical researchers &mdash; `"deeplabcut"` and `"simba"`,
  reducing installation time from days to 30 minutes. Mentored a team
  of three Python developers on Git, Docker, Python, DevOps.

_World Bank's "Digital Development Partnership" program, Contributor_

- Built "_World's Snapshot_", a data-driven web application based on
  the World Bank's and the DHS's data API. Technology used: React,
  Redux, D3.js, Highcharts, Google Charts, eCharts, Plotly, and
  Dygraphs.

_Wei Fashion Group, Contractor_

- Designed and implemented the company's first-gen ERP system catered
  to its unique business model using Django, MySQL, Alibaba Cloud (an
  AWS equivalent), consolidating the sales, inventory, and accounting
  of this Shanghai-based company including its HQ and two global
  subsidiaries in US and Europe.

_Shang Xue Tang, Contractor_

- Designed and POC-ed its B2C web application targeting high-Ed
  market. Efforts included Django, Redis, Celery, MySQL, API
  integration, web page crawling, natural language processing (NLP).

_Linkage, Contractor_

- Initiated its software development SDLC from the ground up. Fostered
  development culture of the startup. Created its "_2016-17 Technology
  Roadmap_", providing a comprehensive and forward-thinking vision for
  the company to grow. Hands-on coding in Python ODOO (OpenERP).

## 11/2013 - 01/2015
Beijing Lean Strategy Consulting Group, Associate Director

- In charge of a high-value Request for Proposal (RFP) worth $3
  million with a Fortune 500 customer, assuming full responsibility of
  its fulfillment including business analysis, system design, software
  development, deployment, maintenance, P&L, human resource. Oversaw
  details in all aspects of the stack including Java Spring,
  Hibernate, MySQL, Selenium, SonarQube, Huawei Cloud Enterprise (an
  AWS equivalent).

## 07/2010 - 11/2013
CrunchTime! Information Technology, Project Manager

- Managed a Request for Proposal (RFP) valued at $10 million with Yum!
  China spanning three years. Were the point-of-contact for
  requirement and gap analysis, CRM, feature prototyping, deployment
  rollout, user training, and technical support. Technology exercised:
  Java Spring, Oracle DB, Django, MySQL, Google App
  Engine, SalesForce.

- Developed the company's SalesForce-based Customer Portal, which won the
  Bronze prize of the "_2011 Steve Awards for Sales & Customer
  Service_". Implemented using SalesForce APEX, CSS, jQuery.

- Designed and built the company's first mobile application using
  Cordova, HTML5 and jQuery Mobile.

## 04/2009 - 04/2010
China Everbright Bank, Financial Leasing Division, Business Manager

- Had an overall responsibility of a $2 million RFP acquiring its core
  ERP system. Led a team of 4 business analysts and 5 software
  engineers executing requirement analysis, system evaluation and
  selection.

## 04/2004 - 05/2007
Bit 9 Inc. (Carbon Black), Researcher, Tech Lead

- Led a groundbreaking research of securing the Windows NT kernel,
  resulting in winning a $6 million A-round
  venture capital investment from Kleiner Perkins.


## 07/1998 - 04/2004
Instron Corp., Senior Engineer

- Developed real-time firmware of its hardness testing and impact
  testing products. Technology: VxWorks RTOS, real-time Linux, C,
  National Instrument DAQ, Texas Instruments DSP, Allen-Bradley PLC.

# Education

- _MBA (04/2007 - 09/2008)_, Boston Univ., International Management & Finance
- _Master of Science (09/1995 - 05/1997)_, Ohio Univ., Electrical Engineering
- _Bachelor of Science (09/1990 - 07/1994)_, Shanghai JiaoTong
  Univ., China, Electrical Engineering

# Publications

1. https://lenovopress.com/lp1148-red-hat-hyperconverged-infrastructure-for-virtualization-reference-architecture
2. https://lenovopress.com/lp1149-lenovo-open-cloud-reference-architecture

# References

| Name                  | Contact                      | Capacity |
|-----------------------|------------------------------|----------|
| Yan, Kai              | kai@lucidumsecurity.com      | Manager  |
| Wu, Shuning           | sw@lucidumsecurity.com       | Peer     |
| McColgan, Meg         | mmccolgan@lenovo.com         | Manager  |
| Herman, Joseph        | jherman1@lenovo.com          | Manager  |
| Stambach, Ricky       | rstambach@lenovo.com         | Peer     |
| Li, Jian              | jianli@lenovo.com            | Peer     |
| Khullar, Lakhesh      | lakhesh\_khullar@med.unc.edu | Manager  |
| Steere, Sylvia Irene  | sylvia\_steere@med.unc.edu   | PM       |
| Harrold, Matthew Kyle | matthew_harrold@med.unc.edu  | Peer     |

[1]: https://lenovopress.com/lp1148-red-hat-hyperconverged-infrastructure-for-virtualization-reference-architecture
[2]: https://lenovopress.com/lp1149-lenovo-open-cloud-reference-architecture
