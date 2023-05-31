---
mainfont: DejaVu Serif
monofont: DejaVu Sans Mono
titlepage: false
papersize: a4
fontsize: 10pt
geometry: margin=1.45in
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
    \usepackage[dvipsnames]{xcolor}
    \usepackage{titlesec}
    \titleformat{\subsection}[leftmargin]{\normalfont\bfseries}{\thesubsection}{8pt}{}
    \titlespacing{\subsection}{5em}{1em}{1pc}

---

# Summary

- Top knowledge in full stack technologies including methodologies
  (MVC, MVVM, micro service, SOA), DB and proxy (ORM, MySQL, PG,
  Mongo), RESTful API (OpenAPI, Swagger, DRF), framework
  (Django/Flask/Spring Boot), cache/messaging (Redis/Rabbit MQ),
  frontend (Storybook, React, Redux, Angular, material), packaging
  (Docker), cloud (AWS, Azure), infrastructure as code (TF, Pulumi),
  DevOps (Ansible), CICD (Jenkins, github action, bitbucket pipeline),
  e2e test (Cypress, Selenium, pytest), secrets (Hashicorp Vault,
  Ansible Vault).

- Top engineering team lead/management experience and continuous
  contribution in any role. Led team of small (<10) and medium scale
  (40+) as Director, PM, team lead, principal system architect, and
  individual developer.

- Top flexibility in participating project at different
  maturity/phase, including new projects from design to production,
  and legacy projects migrating frameworks, libraries, deployment
  (on-premise, cloud, hybrid), CICD, security audit.

- Top expert in managing day-2-day activities of software development
  across SDLC including git (branch, merge/rebase, PR review, tag,
  conflicts), semantic release, bug tracking, Jira, CICD, DevOps, QA.

- Top experience in setting up, integrating, and mentoring global
  teams located in different geos/timezones.

# Experience

## 3/2022 - 3/2023
Lucidum, Principal System Architect, Director

- Laid out next-gen architecture of the system and its development
  roadmap, supporting on-premise, cloud-native (AWS, Azure), and
  hybrid.

- Oversaw global engineering team of 17 &mdash; 5 in US (PM, UX, python, DevOps,
  CICD, AWS), 11 in China (4 Java backend, 3 React frontend, 3 QA, 1
  local team lead), 1 in Ukraine (Python). Report to CTO. Oversaw 2
  major release, 6 minor releases, and 12 patch releases.

- Oversaw SOC2 compliance. Responsible for daily PR reviews across 50+
  github repos including Java, Python, Javascript, React, Groovy,
  Ansible, Terraform, shell scripts.

- Restructured and rewrote 800+ Cypress e2e tests in 6 weeks to
  achieve 100% automation in UAT. Developed new automation tool to
  lower time of creating a new test case from 4-8 hours to < 5
  minutes.

- Implemented semantic release. Fully automated component
  release including release versioning, code tagging, changelog,
  packaging publishing, regression, and continuous component-level upgrade in
  production.

- Optimized DevOps, reducing iteration time from 1.5 hours to 27
  minutes, and AWS VM footprint/cost from $2k/month to < $400/month.

- Contributed a lot of code in React, Cypress, Python, and Ansible.


## 11/2016 - 3/2022
Lenovo US, P8, Senior Solution Architect, Team Lead

- Principal architect of the [Lenovo Open Cloud Automation][25]
  solution, first author of its reference architecture paper. It was
  productized in 13 months, and has won $100M+ contracts after launch.

- First author of the [Red Hat Hyperconverged Infrastructure (RHHI)
  Reference Architecture][26]. Principal architect and primary code
  contributor of RHHI's automated end-2-end deployment.

- Principal architect of the Lenovo Workload Solution Store (WSS). Its
  orchestration technology forms the core of the ThinkAgile VX
  product.

- Principal system architect of the ThinkAgile CP product, a private
  cloud solution. Played a key role in third-party IP evaluation and
  acquisition. Led UI/UX team of five and DevOps team of four in six
  major releases and production deployment to AWS and Cloudfare.

- Principal architect of Lenovo's Datacenter Inventory Management System
  (DCIM), and is its top code contributor.

- Second author of the "Lenovo OpenStack Reference Architecture" and
  "Lenovo Ceph Reference Architecture".

- Contributor of Netbox upstream. Managed 300+
  servers and switches spanning across US, Europe and India. Achieved
  fully automated server onboard discovery, provisioning, and
  reconfiguration. In production.

- Developed a Django application integrating Gitlab and Jira so that a
  feature request can be tracked at git commit level from
  implementation to deployment, giving PM unprecedented insight of a
  SDLC.

- Support pre-sale and customer engagements, RFPs as an SME in the
  area of containerization, microservice design pattern, cloud native
  solution, SDLC, DevOps, CICD, and orchestration.


## 01/2015 - present
PY Consulting, Founder, Freelance

- Contractor, UNC Chapel Hill, School of Medicine. Revived three
  legacy apps used daily by doctors and researchers. All in
  production. Setup the organization's first containerized deployment
  and its first CICD pipeline. Provide training courses on Git
  workflow, Docker, Python, Javascript, Cypress, Jenkins, Ansible,
  Github action, Bitbucket pipeline.

- Volunteer, Mass General Hospital. Created Dockerfile and
  `docker-compose` to install `deeplabcut` and `simba`, two machine
  learning tools used by clinic researchers. Mentored team of 3 of
  Python, version control, Docker. Saved the team hundreds of
  men-hours.

- Contributor of the World Bank's "Digital Development Partnership"
  program.  Built the [`World's Snapshot`][30], a data analysis tool
  in React w/ APIs by the World Bank and the DHS data. It features
  rich charts using D3, Highcharts, Google charts, eCharts, plotly,
  Dygraphs.

- Contractor, "Wei Fashion Group", a Shanghai-based fashion company
  with subsidiaries in US, Europe and China. Built its ERP and
  e-commerce store.

- Contractor, "Shang Xue Tang", a Beijing high education service
  company. Built a [Django application][21] featuring data crawler,
  RESTful API, data streaming, chat room, and forum.

- Contractor, "Linkage", a Shanghai startup specializing
  `ODOO`(`OpenERP`) customization. Managed 1 business analyst and 3
  engineers over two releases. Authored its "2016-17 Technology
  Roadmap".

## 11/2013 - 01/2015
Beijing Lean Strategy Consulting Group, Associate Director

- Responsible for a $3M RFP w/ a Fortune 500 company to design its ERP
  system. Won the contract.

- Oversight project execution. Responsible for P&L. Designed the
  system architecture. Setup the team's SDLC from
  ground up. Doubled the team in a year.

## 07/2010 - 11/2013
CrunchTime! Information Technology, Project Manager

- Responsible for a $10M RFP w/ Yum!China.

- Led development of the company's Customer Portal in SalesForce. Won
  Bronze prize of the "2011 Steve Awards for Sales & Customer Service"
  award.

- Designed and built the company's first mobile application
  prototype using Cordova, HTML5 and jQuery Mobile.

## 04/2009 - 04/2010
China Everbright Bank, Business Manager

- Responsible for a $2M RFP.
- Built the division's IT branch from the ground up.

## 04/2004 - 05/2007
Bit 9 Inc. (Carbon Black), Researcher, Tech Lead

- Reverse-engineering Windows NT kernel. One breakthrough won the
  company a $6M A-round VC.

## 07/1998 - 04/2004
Instron Corp., Senior Engineer

- Single-handed firmware of its new impact testing line. Sales reached
  $1M in the first year.

# Education
- MBA, (04/2007 - 09/2008), Boston University
- M. Sc., (09/1995 - 05/1997), Ohio University
- B. Sc., (09/1990 - 07/1994), Shanghai JiaoTong University, China

# Sample writings & projects

1. [https://lenovopress.com/lp1148-red-hat-hyperconverged-infrastructure-for-virtualization-reference-architecture
][26]
2. [https://lenovopress.com/lp1149-lenovo-open-cloud-reference-architecture][25]
3. [https://github.com/fengxia41103/storybook][32]
5. [https://github.com/fengxia41103/worldsnapshot][30]
4. [https://fengxia41103.github.io/stock/][31]

[101]: https://www.linkedin.com/in/fengxia41103
[102]: https://fengxia41103.github.io/myblog/downloads/resume.pdf

[1]: https://fengxia41103.github.io/myblog/project%20fashion%20demo.html
[2]: https://fengxia41103.github.io/myblog/project%20gkp%20demo.html
[3]: https://fengxia41103.github.io/myblog/project%20stock%20demo.html
[4]: https://fengxia41103.github.io/myblog/downloads/odoo%20roadmap.pdf
[5]: https://fengxia41103.github.io/myblog/maas%20virtualbox.html
[6]: https://fengxia41103.github.io/myblog/juju%20charm%20reactive.html
[7]: https://fengxia41103.github.io/myblog/baremetal%20provisioning.html
[8]: https://fengxia41103.github.io/myblog/ironic%20intro.html
[9]: https://fengxia41103.github.io/myblog/maas%20and%20ironic.html
[11]: https://fengxia41103.github.io/myblog/pages/jinneng_6001.pdf
[12]: https://fengxia41103.github.io/myblog/pages/jinneng_6002.pdf
[13]: https://fengxia41103.github.io/myblog/pages/jinneng_6003.pdf
[14]: https://fengxia41103.github.io/moment/wss/vx.html
[15]: https://fengxia41103.github.io/myblog/netbox.html
[16]: https://fengxia41103.github.io/myblog/switches.html
[17]: https://fengxia41103.github.io/myblog/server%20raid.html
[18]: https://github.com/lenovo/netbox
[19]: https://fengxia41103.github.io/myblog/satellite.html
[20]: https://github.com/fengxia41103/fashion
[21]: https://github.com/fengxia41103/gkp
[22]: https://github.com/fengxia41103/jk
[23]: https://fengxia41103.github.io/myblog/downloads/ibb%20rhhi%20ra.pdf
[24]: https://fengxia41103.github.io/myblog/downloads/loc%20ra.pdf
[25]: https://lenovopress.com/lp1149-lenovo-open-cloud-reference-architecture
[26]: https://lenovopress.com/lp1148-red-hat-hyperconverged-infrastructure-for-virtualization-reference-architecture
[27]: https://cp.lenovo.com/login#/
[28]: https://github.com/fengxia41103/dev/blob/master/code%20analysis/fancy_string_search.py
[29]: https://fengxia41103.github.io/myblog/downloads/webapp.pdf
[30]: https://github.com/fengxia41103/worldsnapshot
[31]: https://fengxia41103.github.io/stock/#/
[32]: https://github.com/fengxia41103/storybook
