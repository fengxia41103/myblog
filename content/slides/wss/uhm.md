<h6>Unified Hardware Management (UHM)</h6>

1. Introduction
2. WSS-based POC
3. Demo
---
<h6>UHM: **concept**</h6>
<div class="row">
  <div class="col s12">
    <img data-src="images/uhm%20concept.png"
         style="box-shadow:none;">
  </div>
</div>
---
<h6>UHM POC: **user story**</h6>
<div class="row">
  <div class="col l6 m6 s12">
    <img data-src="images/uhm%20rack.png"
         class="no-shadow">
  </div>

  <div class="col l6 m6 s12">
    <ul>
      <li>
        **AS A**: lenovo customer
      </li>
      <li>
        **I WANT**: a setup that --
        <ol>
	  <li>Has 1 rack</li>
	  <li>1 switch</li>
	  <li>Install 2 servers:</li>
          <ol>
            <li>one to install Windows, and </li>
            <li>one to install ESXi.</li>
          </ol>
	  <li>Server-win has:</li>
          <ol>
            <li>firmware version 4.1</li>
            <li>using config pattern GOLD</li>
	    <li>connected to VLAN 6</li>
          </ol>
          <li>Server-esxi has firmware version 3.8</li>
        </ol>
      </li>
      <li>
        **SO THAT**: I can install my application
      </li>
    </ul>
  </div>
</div>


---
<h6>UHM POC: WSS-based design</h6>
<div class="row">
  <div class="col s3">
    Inputs
  </div>
  <div class="col s6">
    Orchestration service
  </div>
  <div class="col s3">
    Outputs
  </div>
  <div class="col s12">
    <img data-src="images/uhm%20poc%202.png"
         style="box-shadow:none;">
  </div>
</div>

---
<h6>UHM POC: design WSS models</h6>

<div class="row">
  <div align="left"
       class="col s6">
    1. Design charms & playbooks:<br>
    <img data-src="images/uhm%20charms.png">
    <br>
    
    2. Design charm relations:<br>
    <img data-src="images/uhm%20relations.png">
  </div>
  <div align="left"
       class="col s6">
    3. Make them available in (local) store:<br>
    <img data-src="images/uhm%20demo%20juju%20gui%202.png"
         style="box-shadow:none;">
  </div>
</div>
---
<h6>UHM POC: compose WSS orchestration</h6>

<div class="row">
  <div align="left"
       class="col s6">
    4. Compose an orchestration manifest (bundle):<br>
    <img data-src="images/uhm%20solution%20bundle.png">
  </div>
  <div align="left"
       class="col s6">
    Or, create the bundle using Juju GUI:<br>
    <img data-src="images/uhm%20demo%20juju%20gui.png"
  </div>
</div>
---
<h6>UHM poc: overall workflow</h6>
<div class="row">
  <div class="col s7">Design models</div>
  <div class="col s3">Compose orchestration bundle</div>
  <div class="col s2">Orchestrate</div>
</div>

<img data-src="images/uhm%20orchestration%20workflow.png"
     class="no-shadow">
---
<h6>UHM poc: charm inheritance</h6>
<div class="row">
  <div class="col l6 m6 s12">
    <img data-src="images/uhm%20charm%20inheritance.png"
         class="no-shadow">
  </div>
  <div class="col l6 m6 s12">
    <dl>
      <dt>layer-endpoint</dt>
      <dd>
        common attributes and functions of HW charms, eg. all
        HW charm will have an attribute `uuid`
      </dd>

      <dt>layer-uhm</dt>
      <dd>
        common UHM helper functions, eg. log_uhm, run_uhm
      </dd>

      <dt>layer-ansbile</dt>
      <dd>
        Ansible integration
      </dd>

      <dt>layer-pylxca</dt>
      <dd>
        Install `pylxca` Python module
      </dd>

      <dt>layer-basic</dt>
      <dd>
        Handle installation of repo packages
      </dd>
    </dl>
  </div>
</div>
---
<h6>UHM poc: code structure</h6>

<img data-src="images/uhm%20code%20file%20structure.png"
     class="no-shadow">

---
<h6>UHM demo (live)</h6>
<iframe data-src="https://10.240.42.32/gui/"
        height="550px" width="100%"></iframe>
