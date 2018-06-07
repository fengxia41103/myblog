Title: Linkage environments
Date: 2016-07-01 23:10
Modified: 2016-07-19 17:11
Category: reference
Tags: dev
Slug: linkage-env-reference
Author: Feng Xia
Summary: Linkage internal environment references
Status: draft

Introduction
=============

Project was initiated in March 2016. Linkage is a Chinese startup
company located in Shanghai. The company aimed to develop customized
modules based on ODOO V8. Fuctions of its clients range from construction
industry to client services. Besides
module development, the primary challenge was to to clean up
legacy code base, establish dev baseline including code styles, naming
conventions, code review process and etc., and
draw up a roadmap that illustrates company's product evolution path
going forward.

Build master
============

* [Build master](http://www.linkage.top:8011)

Etherpad server
==================
* [Etherpad server](http://www.linkage.top:9101)


DOCs
====

* [ODOO8 Data dictionary](http://www.linkage.top:8020/doc/dd/)
* [ODOO API reference, including tutorials](http://www.linkage.top:8020/doc/odoo8/)
* [ODOO API doc details](http://www.linkage.top:8020/doc/odoo9/)

DB admin
========

* [Linkage tests](http://www.linkage.top:8020/phppgadmin)

***

Test environment
================

## [Test-Contract](http://www.linkage.top:8100)

<table class="table table-striped table-hover">
	<caption>Basic configuration</caption>
	<thead>
		<th>DB</th>
		<th>ODOO</th>
		<th>Internal Port</th>
		<th>External Port</th>
		<th>Config</th>
		<th>Sys Service</th>
		<th>ODOO Log</th>
		<th>HTTP Log</th>
		<th>Sys Service Log</th>
	</thead>
	<tbody>
		<tr><td>^odoo*
		</td><td>8.0
		</td><td>8097-8099
		</td><td>8100
		</td><td>TEST-Contract.conf
		</td><td>TEST-Contract
		</td><td>/var/log/odoo/TEST-Contract.log
		</td><td>/var/log/nginx/TEST-Contract.*
		</td><td>/var/log/odoo/TEST-Contract.log
		</td></tr>
	</tbody>
</table>

<table class="table table-striped table-hover">
	<caption>Login</caption>
	<thead>
		<tr>
			<th></th>
			<th colspan="2">System</th>
			<th colspan="2">Superuser</th>
			<th colspan="2">DB</th>
		</tr>
		<tr>
			<th>DB</th>
			<th>Username</th>
			<th>Password</th>
			<th>Username</th>
			<th>Password</th>
			<th>Username</th>
			<th>Password</th>
		</tr>
	</thead>
	<tbody>
		<tr><td>TEST-Contract
		</td><td>Admin
		</td><td>Linabc123
		</td><td>admin
		</td><td>Linabc123
		</td><td>odoo
		</td><td>Linabc123
		</td></tr>
	</tbody>
</table>


## [Test-Cheersumeam](http://www.linkage.top:8105)

<table class="table table-striped table-hover">
	<caption>Basic configuration</caption>
	<thead>
		<th>DB</th>
		<th>ODOO</th>
		<th>Internal Port</th>
		<th>External Port</th>
		<th>Config</th>
		<th>Sys Service</th>
		<th>ODOO Log</th>
		<th>HTTP Log</th>
		<th>Sys Service Log</th>
	</thead>
	<tbody>
		<tr><td>TEST-Cheersumeam
		</td><td>8.0
		</td><td>8101-8104
		</td><td>8105
		</td><td>TEST-Cheersumeam.conf
		</td><td>TEST-Cheersumeam
		</td><td>/var/log/odoo/TEST-Cheersumeam.log
		</td><td>/var/log/nginx/TEST-Cheersumeam.*
		</td><td>/var/log/odoo/TEST-Cheersumeam.log
		</td></tr>
	</tbody>
</table>

<table class="table table-striped table-hover">
	<caption>Login</caption>
	<thead>
		<tr>
			<th></th>
			<th colspan="2">System</th>
			<th colspan="2">Superuser</th>
			<th colspan="2">DB</th>
		</tr>
			<tr>
			<th>DB</th>
			<th>Username</th>
			<th>Password</th>
			<th>Username</th>
			<th>Password</th>
			<th>Username</th>
			<th>Password</th>
		</tr>
	</thead>
	<tbody>
		<tr><td>TEST-Cheersumeam
		</td><td>Admin
		</td><td>Linabc123
		</td><td>admin
		</td><td>Linabc123
		</td><td>odoo
		</td><td>Linabc123
		</td></tr>
	</tbody>
</table>
