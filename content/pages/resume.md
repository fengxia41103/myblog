Title: Resum&eacute;
Date: 2017-01-01 12:00
Slug: resume
Author: Feng Xia
Modified: 2026-05-07 12:00

## Summary

* Principal System Architect, $93M state program delivery
* 25+ years spanning firmware, research, consulting, enterprise, government
* Multi-cloud (AWS, Azure), Kubernetes/OpenShift, Terraform, GitOps
* Published reference architecture author (Lenovo Press)
* Global team leadership, architecture governance, vendor management

* **Also available in**:
<a href="https://www.linkedin.com/in/fengxia41103">
  <i class="fa fa-linkedin-square"></i>
  LinkedIn
</a>
<a href="{static}/downloads/feng%20xia%20resume.pdf">
  <i class="fa fa-file-pdf-o"></i>
  PDF
</a>
<a href="{static}/downloads/feng%20xia%20resume%20architect.pdf">
  <i class="fa fa-file-pdf-o"></i>
  Architect
</a>
<a href="{static}/downloads/feng%20xia%20resume%20devops.pdf">
  <i class="fa fa-file-pdf-o"></i>
  DevOps
</a>
<a href="{static}/downloads/feng%20xia%20resume%20director.pdf">
  <i class="fa fa-file-pdf-o"></i>
  Director
</a>

## Experience

<div class="my-resume-header" id="dhhs">
  <div class="row">
    <div class="text-left col l6 m6 s6">
      Principal System Architect<br />
      <span style="opacity:0.5;">NC Dept. of Health and Human Services</span>
    </div>
    <div class="text-right col l5 m5 s5">
      <i class="fa fa-calendar"></i>
      12/2023 - present<br />
      <span style="opacity:0.5;">Raleigh, NC</span>
    </div>
    <div  class="text-right col l1 m1 s1"
          data-toggle="tooltip"
          title="Click to expand and collapse">
      <br />
      <i class="fa fa-angle-double-down"></i>
    </div>
  </div>
</div>

- Led the technical delivery of PATH NC ($93M) child welfare
  modernization — successful statewide go-live June 2025, serving
  3,000+ users across all 100 NC counties, phased in 6 rollout groups.

- Oversaw 50+ repositories, 7 AWS accounts, 3 Azure subscriptions,
  30+ licensed SaaS/COTS products, and a multi-cluster Red Hat
  OpenShift (ROSA) platform.

- Established architecture governance from scratch: reference
  architecture, formal DIT/State architecture review decision points,
  custom code dev/build/deploy standards, SBOM and license compliance,
  backup & restore strategy, production incident management, and PROD
  health dashboards.

- Architected serverless document management system replacing legacy
  IBM FileNet: event-driven ingestion (S3, EventBridge, Lambda,
  DynamoDB), intelligent document processing (AWS Textract + Bedrock),
  DLQ retry orchestration, automated Glacier archival, 90%+ test coverage.

- Built Enterprise AI platform (GenAIe/RAG) using AWS Bedrock (Claude,
  Titan embeddings), OpenSearch Serverless, Bedrock Guardrails,
  Django/FastAPI/React with Celery workers, deployed on OpenShift via
  ArgoCD across 6 environments.

- Designed MuleSoft API-led integration layer (13+ APIs) connecting to
  12 external systems: NCID, Adobe Sign, AEM, CNDS, DPI, FIS, NEICE,
  EB, ACTS, NCFS, Vital Records, Medicaid/NC Analytics.

- Managed multi-cluster ROSA infrastructure (up to 12 nodes/96 CPU/768
  GB) with Terraform, Kustomize, ArgoCD GitOps, drift detection, and
  Day 0/1/2 automation. Azure: Synapse Workspace, Dedicated SQL Pool,
  ADLS, Entra ID/RBAC, Power Automate.

- Architected end-to-end financial data pipeline (Salesforce → Azure
  Pipeline → Synapse → Power BI → AWS SFTP → NCFS mainframe) for
  monthly county payment processing.

- Built real-time PROD health monitoring (48+ endpoints, 60s interval,
  SNS alerting, React/WebSocket UI).

- Designed user lifecycle and RBAC: Azure AD/NCID SSO, SCIM
  provisioning, JIT activation, 400+ application roles, Salesforce ACL
  model.

- Led security: FedRAMP SSP (NIST 800-53), Terraform-based Secrets
  Manager, network security (Direct Connect, Transit Gateway,
  Cloudflare WAF), scanning (Trivy, Veracode, SonarQube).

- Initiated test automation: Robot Framework, Playwright (TS/Python),
  YAML-driven declarative SF test framework, JMeter, automated code
  review tooling.

<div class="my-resume-header" id="lucidum">
  <div class="row">
    <div class="text-left col l6 m6 s6">
      Principal System Architect<br />
      <span style="opacity:0.5;">Lucidum</span>
    </div>
    <div class="text-right col l5 m5 s5">
      <i class="fa fa-calendar"></i>
      3/2022 - 3/2023<br />
      <span style="opacity:0.5;">RTP, NC</span>
    </div>
    <div  class="text-right col l1 m1 s1"
          data-toggle="tooltip"
          title="Click to expand and collapse">
      <br />
      <i class="fa fa-angle-double-down"></i>
    </div>
  </div>
</div>

- Led design of next-gen product architecture, transforming on-prem-only
  model to hybrid cloud-native. Migrated twelve production systems to
  AWS & Azure.

- Managed global engineering team (PM, UX, ML scientist, developers,
  QA, DevOps) with direct reporting line to CTO.

- Delivered 2 major releases, 6 minor releases, 12 patch releases.
  Initiated GitOps practices using GitHub Actions, GitHub Package
  Registry, and Semantic Release.

- Primary developer of CI/CD pipelines: multi-branch building, matrix
  testing, A/B deployment across GitHub Actions, AWS, and Azure.

- Revamped 800+ Cypress E2E tests in 6 weeks, improved performance by
  50%, achieved 100% automation in UAT.

- Hardened security: CVE scanning (code + docker images), Hashicorp
  Vault, Ansible Vault, AWS & Azure Secret Managers.

- AWS and Azure administrator: SSO, IAM, ECR, ECS, RDS, Aurora,
  Lambda, CloudWatch, VPC, WAF, ELB, Route53, CloudFront.

<div class="my-resume-header" id="lenovo">
  <div class="row">
    <div class="text-left col l6 m6 s6">
      P8, Advisory Engineer, Senior Solution Architect, Team Lead<br />
      <span style="opacity:0.5;">Lenovo US</span>
    </div>
    <div class="text-right col l5 m5 s5">
      <i class="fa fa-calendar"></i>
      11/2016 - 3/2022<br />
      <span style="opacity:0.5;">RTP, NC</span>
    </div>
    <div  class="text-right col l1 m1 s1"
          data-toggle="tooltip"
          title="Click to expand and collapse">
      <br />
      <i class="fa fa-angle-double-down"></i>
    </div>
  </div>
</div>

- First author of the [Lenovo Open Cloud Automation Reference
  Architecture][25]. Led global team of six, delivered in 13 months,
  showcased at MWC Barcelona 2019, won $100M contract.

- First author of the [RedHat Hyperconverged Infrastructure (RHHI)
  Reference Architecture][26]. 3-12 server VM-workload solution with
  Glusterfs, layer-3 networking, HA, fault tolerance, zero-touch
  provisioning.

- Principal architect of the "Lenovo Workload Solution Store", core
  foundation of the ThinkAgile VX product. Technologies: Django, React,
  Ansible, Canonical MAAS, Juju.

- Team lead of ThinkAgile CP, hybrid cloud platform with AWS management
  plane. Led global team (5 UI/UX, 2 backends, 1 QA, 2 DevOps)
  delivering six production releases over two years.

- Lead developer of DCIM system (Netbox-based) administrating 300+
  servers and switches globally. Stack: Django, Celery, Redis, MySQL,
  Docker, Ansible.

<div class="my-resume-header" id="py-consulting">
  <div class="row">
    <div class="text-left col l6 m6 s6">
      Founder, Consultant<br />
      <span style="opacity:0.5;">PY Consulting</span>
    </div>
    <div class="text-right col l5 m5 s5">
      <i class="fa fa-calendar"></i>
      01/2015 - 11/2016<br />
      <span style="opacity:0.5;">Raleigh, NC</span>
    </div>
    <div  class="text-right col l1 m1 s1"
          data-toggle="tooltip"
          title="Click to expand and collapse">
      <br />
      <i class="fa fa-angle-double-down"></i>
    </div>
  </div>
</div>

- **UNC Chapel Hill, School of Medicine**: Initiated first Docker-based
  deployment and CI/CD in production. Led DevOps initiative, authored
  technology roadmap.

- **Massachusetts General Hospital**: Containerized ML tools
  (deeplabcut, simba), reducing installation from days to 30 minutes.

- **World Bank "Digital Development Partnership"**: Built data-driven
  web application using React, Redux, D3.js.

- **Wei Fashion Group**: Designed first-gen ERP consolidating HQ and
  two global subsidiaries. [Demo][1], [Source][20].

- **Linkage**: Created "2016-17 Technology Roadmap", established SDLC
  from the ground up.

<div class="my-resume-header" id="lean">
  <div class="row">
    <div class="text-left col l6 m6 s6">
      Associate Director<br />
      <span style="opacity: 0.5;">Beijing Lean Strategy Consulting Group</span>
    </div>
    <div class="text-right col l5 m5 s5">
      <i class="fa fa-calendar"></i>
      11/2013 - 01/2015<br />
      <span style="opacity:0.5;">Beijing, China</span>
    </div>
    <div  class="text-right col l1 m1 s1"
          data-toggle="tooltip"
          title="Click to expand and collapse">
      <br />
      <i class="fa fa-angle-double-down"></i>
    </div>
  </div>
</div>

- Full P&L ownership of $3M RFP with Fortune 500 customer: business
  analysis, system design, development, deployment, maintenance, HR.

- Managed QA automation (2,000+ Selenium tests), Jenkins CI, SonarQube.

<div class="my-resume-header" id="crunchtime">
  <div class="row">
    <div class="text-left col l6 m6 s6">
        Project Manager<br />
        <span style="opacity:0.5;">CrunchTime! Information Systems</span>
    </div>
    <div class="text-right col l5 m5 s5">
        <i class="fa fa-calendar"></i>
        07/2010 - 11/2013<br />
        <span style="opacity:0.5;">Boston, MA</span>
    </div>
    <div  class="text-right col l1 m1 s1"
          data-toggle="tooltip"
          title="Click to expand and collapse">
        <br />
        <i class="fa fa-angle-double-down"></i>
    </div>
  </div>
</div>

- Managed $10M multi-year RFP with Yum! China: requirement analysis,
  CRM, deployment rollout, user training.

- Developed SalesForce Customer Portal winning Bronze at "2011 Steve
  Awards for Sales & Customer Service".

- Built company's first mobile application (Cordova, HTML5, jQuery Mobile).

<div class="my-resume-header" id="everbright">
  <div class="row">
    <div class="text-left col l6 m6 s6">
      Business Manager<br />
      <span style="opacity:0.5;">China Everbright Bank</span>
    </div>
    <div class="text-right col l5 m5 s5">
      <i class="fa fa-calendar"></i>
      04/2009 - 04/2010<br />
      <span style="opacity:0.5;">Beijing, China</span>
    </div>
    <div  class="text-right col l1 m1 s1"
          data-toggle="tooltip"
          title="Click to expand and collapse">
      <br />
      <i class="fa fa-angle-double-down"></i>
    </div>
  </div>
</div>

- Owned $2M RFP for core ERP acquisition. Led team of 4 BAs and 5
  engineers through evaluation and selection.

<div class="my-resume-header" id="bit9">
  <div class="row">
    <div class="text-left col l6 m6 s6">
      Researcher, Tech Lead<br />
      <span style="opacity:0.5;">Bit 9 Inc. (Carbon Black)</span>
    </div>
    <div class="text-right col l5 m5 s5">
      <i class="fa fa-calendar"></i>
      04/2004 - 05/2007<br />
      <span style="opacity:0.5;">Cambridge, MA</span>
    </div>
    <div  class="text-right col l1 m1 s1"
          data-toggle="tooltip"
          title="Click to expand and collapse">
      <br />
      <i class="fa fa-angle-double-down"></i>
    </div>
  </div>
</div>

- Led kernel security research securing Windows NT, resulting in $6M
  Series A from Kleiner Perkins.

<div class="my-resume-header" id="instron">
  <div class="row">
    <div class="text-left col l6 m6 s6">
      Senior Engineer<br />
      <span style="opacity:0.5;">Instron Corp.</span>
    </div>
    <div class="text-right col l5 m5 s5">
      <i class="fa fa-calendar"></i>
      07/1998 - 04/2004<br />
      <span style="opacity:0.5;">Canton, MA</span>
    </div>
    <div  class="text-right col l1 m1 s1"
          data-toggle="tooltip"
          title="Click to expand and collapse">
      <br />
      <i class="fa fa-angle-double-down"></i>
    </div>
  </div>
</div>

- Developed real-time firmware for hardness testing and impact testing
  products. VxWorks RTOS, real-time Linux, C, DSP, PLC.

## Education

<div class="my-resume-header">
  <div class="row">
    <div class="text-left col l6 m6 s6">
      MBA<br />
      <span style="opacity:0.5;">Boston University</span>
    </div>
    <div class="text-right col l5 m5 s5">
      <i class="fa fa-calendar"></i>
      04/2007 - 09/2008<br />
      <span style="opacity:0.5;">Boston, MA</span>
    </div>
    <div  class="text-right col l1 m1 s1"
          data-toggle="tooltip"
          title="Click to expand and collapse">
      <br />
      <i class="fa fa-angle-double-down"></i>
    </div>
  </div>
</div>

* International Management & Finance. GPA: 3.75/4.0
* "High Honor and Dean's Achievement Scholarship"

<div class="my-resume-header">
  <div class="row">
    <div class="text-left col l6 m6 s6">
      Master of Science<br />
      <span style="opacity:0.5;">Ohio University</span>
    </div>
    <div class="text-right col l5 m5 s5">
      <i class="fa fa-calendar"></i>
      09/1995 - 05/1997<br />
      <span style="opacity:0.5;">Athens, OH</span>
    </div>
    <div  class="text-right col l1 m1 s1"
          data-toggle="tooltip"
          title="Click to expand and collapse">
      <br />
      <i class="fa fa-angle-double-down"></i>
    </div>
  </div>
</div>

* Electrical Engineering. GPA: 3.5/4.0

<div class="my-resume-header">
  <div class="row">
    <div class="text-left col l6 m6 s6">
      Bachelor of Science<br />
      <span style="opacity:0.5;">Shanghai Jiaotong University</span>
    </div>
    <div class="text-right col l5 m5 s5">
      <i class="fa fa-calendar"></i>
      09/1990 - 07/1994<br />
      <span style="opacity:0.5;">Shanghai, China</span>
    </div>
    <div  class="text-right col l1 m1 s1"
          data-toggle="tooltip"
          title="Click to expand and collapse">
      <br />
      <i class="fa fa-angle-double-down"></i>
    </div>
  </div>
</div>

* Electrical Engineering

## Publications

1. [Red Hat Hyperconverged Infrastructure for Virtualization Reference Architecture][26]
2. [Lenovo Open Cloud Reference Architecture][25]

<script type="text/javascript">
 var j$ = jQuery.noConflict();

 j$(document).ready(function() {
   j$('.my-resume-header').click(function() {
     j$(this).next("ul").slideToggle(700);
     j$(this).find('i').last().toggleClass('fa-angle-double-up');
     j$(this).find('i').last().toggleClass('fa-angle-double-down');
   });

   j$('h2').siblings('.my-resume-header').each(function(index) {
     if (index > 0) {
       j$(this).next('ul').hide();
     }
   });
 });
</script>

[1]: {filename}/workspace/demo/fashion.md
[20]: https://github.com/fengxia41103/fashion
[25]: https://lenovopress.com/lp1149-lenovo-open-cloud-reference-architecture
[26]: https://lenovopress.com/lp1148-red-hat-hyperconverged-infrastructure-for-virtualization-reference-architecture
