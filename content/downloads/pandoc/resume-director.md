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

Seeking _VP of Engineering, Director of Engineering, CTO_
&mdash; I bootstrap engineering organizations, establish technical
governance, and deliver complex programs from zero to production. I
combine deep technical fluency with business acumen to align
engineering execution with organizational strategy.

# Highlights

- **Program Delivery & P&L Ownership**

  - Delivered a $93M state modernization program (go-live June 2025,
    3,000+ users, 100 counties, 50+ repos, 30+ vendor products).
  - Managed $10M multi-year RFP (Yum! China), $3M Fortune 500 RFP,
    $2M ERP acquisition, and $6M venture-funded research program.
  - Won $100M contract with architecture showcased at MWC Barcelona.

- **Organization Building & Team Leadership**

  - Built and led global engineering teams (5-20 direct/indirect)
    across US, China, India, spanning PM, UX, ML, Dev, QA, DevOps.
  - Bootstrapped SDLC, DevOps culture, and engineering practices from
    zero at 5+ organizations (startup to government enterprise).
  - Established architecture governance, release management, incident
    response, and quality frameworks for mission-critical systems.

- **Technical Strategy & Vendor Management**

  - Evaluated, selected, and managed 30+ SaaS/COTS products (Salesforce,
    MuleSoft, AWS, Azure, ROSA, AEM, Adobe Sign, OwnBackup, Splunk).
  - Authored technology roadmaps driving multi-year execution.
  - Led architecture decision processes with formal state/DIT review.
  - Published reference architectures (Lenovo Press).

- **Stakeholder Management & Communication**

  - Direct reporting lines to CTO, State Chief Enterprise Architect,
    and DIT Enterprise Architecture.
  - Managed vendor relationships (Deloitte, Red Hat, MuleSoft, Adobe).
  - Authored and presented architecture knowledge base (87+ topics)
    for cross-functional team enablement.

- **Domain Expertise**

  - Government/Public Sector: child welfare, Medicaid, financial
    systems, FedRAMP/NIST compliance.
  - Enterprise: cloud platforms, AI/ML, data engineering, identity,
    security, integration architecture.

# Experience

## 12/2023 -
Department of Health and Human Service, North Carolina, Principal
System Architect

- Led the technical delivery of the PATH NC ($93M) child welfare
  modernization from architecture through successful statewide go-live
  (June 2025). Managed the complete technology portfolio: 50+
  repositories, 7 AWS accounts, 3 Azure subscriptions, 30+ licensed
  products, and a multi-cluster OpenShift platform serving 3,000+
  users across all 100 NC counties.

- Established the program's entire architecture governance from
  scratch: reference architecture, formal DIT/State architecture
  review decision points, custom code dev/build/deploy standards,
  SBOM and license compliance, backup & restore strategy, production
  incident management, and PROD health dashboards. Created the
  systematic framework that guided the project to on-time delivery.

- Managed vendor technical oversight (Deloitte as prime contractor):
  defined architecture standards, enforced code quality gates,
  reviewed and approved all technical deliverables, drove resolution
  of open topics and tech debts across all workstreams.

- Authored and maintained the architecture knowledge base (87+
  infrastructure topics, 39+ Salesforce topics, 21+ DevOps topics)
  delivered as presentations, driving team-wide technical enablement
  and reducing knowledge silos.

- Orchestrated the phased county rollout strategy (6 groups, 15-22
  counties each): user lifecycle management, NCID/Azure AD SSO
  provisioning, per-county role matrix (400+ roles), validation
  tooling, and go-live readiness checkpoints.

- Directed the technology selection and architecture for the GenAI
  platform: evaluated Kendra, Salesforce AgentForce, Microsoft
  Copilot; selected and delivered RAG solution (Bedrock Claude,
  OpenSearch Serverless) across 6 environments.

- Owned the integration architecture connecting PATH NC to 12 state
  and federal systems via MuleSoft API-led connectivity (13+ APIs):
  NCID, CNDS, DPI, FIS, NEICE, EB, ACTS, NCFS, Vital Records,
  Medicaid, Adobe Sign, DocuEdge.

- Drove the end-to-end financial data movement architecture
  (Salesforce → Azure → Synapse → Power BI → SFTP → NCFS mainframe)
  enabling monthly county payment processing for Foster Care, Vendor
  Payments, and Adoption Assistance.

- Led security and compliance: FedRAMP SSP documentation (NIST
  800-53), secrets lifecycle management, network security (Direct
  Connect, Transit Gateway, Cloudflare WAF), and security scanning
  pipeline integration.

## 3/2022 - 3/2023
Lucidum, Principal System Architect

- Led design of the next-gen product architecture, transforming
  on-prem-only model to hybrid cloud-native. Directed the successful
  migration of twelve production systems to AWS & Azure.

- Managed a global engineering team (PM, UX, ML scientist, developers,
  QA, DevOps) with direct reporting line to the CTO. Delivered 2
  major releases, 6 minor releases, and 12 patch releases.

- Established GitOps practices, CI/CD pipeline architecture, security
  hardening (CVE scanning, secret management), and test automation
  (revamped 800+ E2E tests, achieved 100% UAT automation).

- As AWS and Azure administrator: owned cloud infrastructure strategy,
  cost management, and service configuration across the full stack.

## 11/2016 - 3/2022
Lenovo US, P8, Advisory Engineer, Senior Solution Architect, Team Lead

- Led a global team of six, transforming the ["_Lenovo Open Cloud
  Automation Reference Architecture_"][1] from concept to market-ready
  product in 13 months. Showcased at MWC Barcelona 2019, won $100M
  contract.

- Authored the ["_RedHat Hyperconverged Infrastructure (RHHI)
  Reference Architecture_"][2], a published solution design for 3-12
  server deployments with HA, fault tolerance, and zero-touch
  provisioning.

- As team lead of ThinkAgile CP, led a global team (5 UI/UX, 2
  backends, 1 QA, 2 DevOps) delivering six production releases over
  two years for a hybrid cloud platform with AWS management plane.

- Architected the "_Lenovo Workload Solution Store_", serving as the
  core foundation of the ThinkAgile VX product line.

## 01/2015 - 11/2016
PY Consulting, Founder, Freelance

- Bootstrapped engineering practices from zero at 5+ organizations:

- _UNC Chapel Hill_: Initiated first Docker/CI/CD in production,
  authored DevOps technology roadmap, oversaw Phase 2 & 3 execution.

- _Wei Fashion Group_: Designed and delivered first-gen ERP
  consolidating HQ and two global subsidiaries (US, Europe).

- _Linkage_: Created "2016-17 Technology Roadmap", established SDLC
  and development culture for the startup from the ground up.

- _World Bank_: Built data-driven web application for the "Digital
  Development Partnership" program.

## 11/2013 - 01/2015
Beijing Lean Strategy Consulting Group, Associate Director

- Full P&L ownership of a $3M RFP with a Fortune 500 customer:
  business analysis, system design, development, deployment,
  maintenance, and human resource management.

## 07/2010 - 11/2013
CrunchTime! Information Technology, Project Manager

- Managed $10M multi-year RFP with Yum! China: requirement analysis,
  CRM, feature prototyping, deployment rollout across China, user
  training, and technical support.

- Developed the SalesForce Customer Portal winning Bronze at the
  "2011 Steve Awards for Sales & Customer Service".

## 04/2009 - 04/2010
China Everbright Bank, Financial Leasing Division, Business Manager

- Owned $2M RFP for core ERP acquisition. Led team of 4 business
  analysts and 5 engineers through evaluation and selection.

## 04/2004 - 05/2007
Bit 9 Inc. (Carbon Black), Researcher, Tech Lead

- Led kernel security research that won $6M Series A from Kleiner
  Perkins Caufield & Byers.

## 07/1998 - 04/2004
Instron Corp., Senior Engineer

- Developed real-time firmware for industrial testing products.

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
