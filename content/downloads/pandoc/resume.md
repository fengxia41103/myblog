---
mainfont: Noto Sans CJK SC
titlepage: false
papersize: a4
fontsize: 12pt
linkstyle: slanted
urlcolor: blue
linkstyle: slanted
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
---

# Summary

* Python developer since 1998.
* Can deliver any web application from napkin design to Django POC in 72 hours.
* Full-stack capable.
* Welcome challenging problem.
* Have a high standard in work quality.
* SalesForce advocate.
* **Also available in**: [linkedin][101], [PDF][102], [Word][103]

# Skills

Software Development
: Python, C, ODOO/OpenERP, SQL, Salesforce APEX, Cordova, Google App
  Engine (GAE), Git, SVN, Bower, Yeoman, Jira

Web Application
: Django, Ansible, ReactJS, AngularJS, jQuery, Materialize, Bootstrap,
  Jinja2, Pelican

Data Visualization
: Graphviz, Cytoscape.js, netjsongraph.js, D3plus, Highcharts, Google
  chart, MetricsGraphics, chart.js, Plotly.js, dygraphs

QA
: Selenium, HP LoadRunner, SonarQube, Cucumber, Redmine, Bugzilla

System design
: pencil & paper, UML, PlantUML, Dia, Visio

System deployment
: Amazon EC2/RDS/S3, uWSGI, Nginx, Apache2, Builtbot, Fabric

System monitoring
: ELK stack, InfluxDB, Grafana, Cacti, Nagios

System administration
: Salesforce, Red Hat Satellite, Red Hat RHHI, Red Hat Ansible Tower,
  AWS

Documentation
: LaTex, Markdown, reveal.js, Confluence, Org mode, Word, Powerpoint,
  Excel, MS Project, Taskjugger

# Experience

## Advisory Engineer, Lenovo US \hfill 11/2016 - present

* Author of the `Lenovo Open Cloud` reference architecture and `Red
  Hat Hyperverged Infrastructure for Virtalization` reference
  architecture. Published on 5/5/2019.
  
    - **Tools**: Pandoc, Markdown, BibTex, XeLaTex, GNU make, CSS
    - **Sample writing**:
        1. Lenovo Open Cloud Reference Architecture: [pretty
           draft in PDF][23], [official version][25]
        2. Red Hat Hyperconverged Infrastructure for Virtualization
           Reference Architecture: [pretty draft in PDF][24], [official
           version][26]

* `Lenovo Open Cloud` product. Drove overall network
  design. Developed Python scrips and playbooks to automate RH
  Satellite deployment and configuration. Led development of playbooks
  to automate RHHI deployment on baremetal.

    - **Tools**: RedHat RHHI, RedHat Satellite, RedHat Ansible Tower,
                 RHEL 7 server cloud image, KVM/virsh
    - **Sample writings**: 
        1. [Config Lenovo switches ENOS & CNOS][16]
        2. [Config Lenovo server to RAID][17]
        3. [RH Satellite][19]

* `Lenovo Open Cloud` product.  Forked [Netbox][18] by Digital
  Ocean. Retrofit its models and added functions to make it data
  center planning and orchestration tool.  Extended Netbox
  architecture to include Redis for async task. Scripted switch and
  server scanning to draw topology of server-switch & switch-switch
  physical connections. Source code in [github][18].

    - **Tools**: Django, Celery, Redis, Postgresql, Ansible, pexpect
    - **Sample writings**: [Netbox design][15]

* `VX Installer` product. Designed system architecture. Coded Django
  backend and RESTful API.

    - **Tools**: Django, Tastypie, Celery, Redis, Ansible, Canonical charms, Docker
    - **PPT**: Architecture of [VX Installer][14]
    
* `Workload Solution Store` project. Evaluated service orchestration
  technologies and developed Lenovo's core competence in automating
  baremetal provisioning.

    - **Tools**: Openstack, Ironic, Juju, MaaS, Canonical charms,
                 Python, LXD, KVM, Virtualbox
    - **Sample writings**: 
        1. [MAAS lab][5]
        2. Juju charm's [reactive framework][6]
        3. introduction of [Openstack Ironic][8]
        4. comparison analysis of [Ironic vs. MAAS][9]
        5. technologies used in [baremetal provisioining][7]

## Founder & Consultant, PY Consulting, 01/2015 - 11/2016

* `Wei Fashion Group` project. Wei Fashion Group is an international
  fashion product trading company. Designed and built an inventory
  management and order tracking system in four weeks. Developed
  Android prototype in two weeks. Played a key role in setting up its
  Shenzhen subsidiary. Invited as feature speaker by "_2016 Jiuzhou
  e-Commerce Convention_" on Dec 8th, 2015, Shenzhen, China.
    - **Tools**: Django, Bootstrap, jQuery, Cordova, AngularJS, AWS,
                 uWSGI, Nginx
    - **Demo**: [view project Fashion for details][1]
    - **Source**: [github][20]


* `GKP` project. Designed a web reference tool assisting Chinese
  high school graduate selecting domestic colleges. Featuring information
  about 3,383 colleges and universities, 1,663 majors, two million
  historical exam records and 50,000 lines per minute live chat stream.

    - **Tools**: Django, Bootstrap, Redis, Google map API, Baidu map
                 API, Baidu Echarts, TOR API, Privoxy, AWS, uWSGI,
                 Nginx
    - **Demo**: [view project GKP for details][2]
    - **Source**: [github][21]

* `Stock analysis` project. Developed an open-source web application that
  runs stock trading simulation with step-by-step transaction
  trace. User can test strategy and view comparisons with actual
  S&P500 daily data and China’s S&P500 equivalent. Asynchronous design
  puts CPU intense computation to background processed by
  multithreading consumer.

    - **Tools**: Django, Bootstrap, Redis, Highcharts, AWS, uWSGI, Nginx
    - **Demo**: [view project Stock for details][3]
    - **Source**: [github][22]

* `Linkage` project. Linkage Ltd. is a Chinese start-up software company
  specializing ODOO module development. Built ODOO’s continuous
  integration (CI) server. Customized ODOO inventory management
  system. Authored the company’s “2016-17 Technology Roadmap”.

    * **Tools**: Python, ODOO, Buildbot
    * **Sample writings**: [Linkage 2016-17 Technology Roadmap][4] (in Chinese)

## Director, Beijing Lean Strategy Consulting Group, 11/2013 - 01/2015

* Responsible for a $3-million fixed-bid software contract. Client is
  a Fortune-500 company. Project included designing and developing
  full-stack web and mobile applications which replaced three legacy
  systems.

    * **Tools**: Python, ODOO, Buildbot
    * **Reports (in Chinese)**: 
        1. [晋能集团数据中心建设分析 – 规模和成本][11]
        2. [晋能集团云平台建设和使用咨询报告][12]


* Design system architecture using SOA technologies. Managed
  evaluation of ESB, BPM and database components.

    * **Tools**: IBM Rational, MySQL, Java Spring Struts Hibernate,
                 JBoss ESB, Mule ESB, Apache ServiceMix, Activiti BPM
    * **Reports (in Chinese)**: [数据库技术和系统测试简介][13]

* Supervised two vendor invitation-for-bids. Responsible for
  $1.2-million RMB ($200,000 USD) purchase.

* Managed QA team to automate regression tests.  Coded two thousand
  test cases in TDD syntax, Python Unittest and Selenium
  webdriver. Built QA continuous integration infrastructure using
  Jenkins and SonarQube.

    * **Tools**: Python, Selenium webdriver, PhantomJS, Jenkins, SonarQube

* Enhanced company's standard operating procedure (SOP), including
  initiation of an online knowledge base, a project management system
  and a configuration management system.

    * **Tools**: Redmine, SVN

* Setup a local service team. Screened hundreds of resume and
  interviewed nearly one hundred candidates.

## Project Manager, CrunchTime! Information Technology, 07/2010 - 11/2013

**Tools**: Salesforce APEX, Visualforce, Jira, MS Project, Taskjuggler

* Provided technical support to client on administrating our ERP
  product. Initiated statement-of-work(SOW) and followed it through
  development, user-acceptance-test(UAT) and deployment.
* Played a key role in pre-sales to Yum!China, Yum!’s most profitable
  branch at the time. Analyzed over 600 pages of requirements covering
  operation of fourteen departments. Worked closely with CEO and
  Yum!’s senior executives to outline deal structure. Participated in
  all key decisions regarding this deal.
* In charge of administrating Salesforce production instance,
  including setting up workflows, triggers, approval processes, a
  customer portal and a vendor portal.
* Customized Salesforce Customer Portal using APEX, Visualforce and
  jQuery. The portal won Bronze in the “2011 Steve Awards for Sales &
  Customer Service”.
* Built the company's first mobile application prototype using
  Cordova, HTML5 and jQuery Mobile.

    * **Tools**: Cordova, HTML5, jQuery mobile, Google map API, AT&T
                 yellow page API

* Built user-acceptance-test(UAT) library using Python-Selenium,
  reducing one UAT cycle from 40-man-hour to less than 2 hours.

    * **Tools**: Python, Selenium webdriver, Django

## Business Manager, China Everbright Bank, 04/2009 - 04/2010
**Tools**: Word, Powerpoint, Project

* Supervised two vendor invitation-for-bids. In charge of a $2-million
  purchase of a software system. Managed system implementation,
  customization, training and administration.
* Setup Business Analysis team from ground up. Created report
  templates and analysis framework. Analysis results were the basis of
  two loans of substantial amount.
* Led team to create drafts of contracts, business policies, workflows
  and training materials.

## Team Lead, Bit 9 Inc. (Carbon Black), 04/2004 - 05/2007

**Tools**: NT kernel, Python, Graphviz, VC++, rootkits, VMWare
    
* Led a breakthrough in endpoint application control product, which
  played a key role in winning Bit9 a $6-million B-round led by
  Kleiner Perkins.
* Member of Bit9's SaaS team. Built the world's largest Windows binary
  repository at the time featuring four billion data records. Wrote
  C++ parser for Windows binary PE formats.

## Senior Engineer, Instron Corp., 07/1998 - 04/2004

**Tools**: RTOS, C, VB, PLC, Python

* Developed embedded controller of Instron’s impact tester line (9250HV).
* Developed embedded controller of two million-dollar projects. Led
  system training. 　　
* Initiated a new product line -- closed-loop Brinell hardness tester.
* Assisted in training the company’s first Chinese R&D team.

# Education

## MBA, Boston University, 04/2007 - 09/2008

* **Major**: International Management Program
* GPA: 3.75/4.0
* Recipient of "High Honor and Dean’s Achievement Scholarship"
* "Certificate of International Management Program"
* 2nd place in the "13th Annual Net Impact Case Competition"

## Master of Science, Ohio University, 09/1995 - 05/1997

* **Major**: Power System Automation
* GPA: 3.15/4.0


[101]: https://www.linkedin.com/in/fengxia41103
[102]: http://fengxia.co/downloads/resume.pdf
[103]: http://fengxia.co/downloads/resume.doc

[1]: http://fengxia.co/project%20fashion%20demo.html
[2]: http://fengxia.co/project%20gkp%20demo.html
[3]: http://fengxia.co/project%20stock%20demo.html
[4]: http://fengxia.co/downloads/odoo%20roadmap.pdf
[5]: http://fengxia.co/maas%20virtualbox.html
[6]: http://fengxia.co/juju%20charm%20reactive.html
[7]: http://fengxia.co/baremetal%20provisioning.html
[8]: http://fengxia.co/ironic%20intro.html
[9]: http://fengxia.co/maas%20and%20ironic.html
[11]: http://fengxia.co/pages/jinneng_6001.pdf
[12]: http://fengxia.co/pages/jinneng_6002.pdf
[13]: http://fengxia.co/pages/jinneng_6003.pdf
[14]: https://fengxia41103.github.io/moment/wss/vx.html
[15]: http://fengxia.co/netbox.html
[16]: http://fengxia.co/switches.html
[17]: http://fengxia.co/server%20raid.html
[18]: https://github.com/lenovo/netbox
[19]: http://fengxia.co/satellite.html
[20]: https://github.com/fengxia41103/fashion
[21]: https://github.com/fengxia41103/gkp
[22]: https://github.com/fengxia41103/jk
[23]: http://fengxia.co/downloads/ibb%20rhhi%20ra.pdf
[24]: http://fengxia.co/downloads/loc%20ra.pdf
[25]: https://lenovopress.com/lp1149-lenovo-open-cloud-reference-architecture
[26]: https://lenovopress.com/lp1148-red-hat-hyperconverged-infrastructure-for-virtualization-reference-architecture
