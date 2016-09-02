Title: Internal environments
Date: 2016-07-01 23:10
Category: reference
Tags: internal
Slug: internal-env-reference
Author: Feng Xia
Summary: Internal environment references

# Build master

* [Build master](http://fengxia.co:8011)


***

# Test environment

## [Test-GKP](http://fengxia.co:8001/gaokao)

<table class="table table-striped table-hover">
	<caption>Basic configuration</caption>
	<thead>
		<th>DB</th>
		<th>Port</th>
		<th>uwsgi config</th>
		<th>uwsgi log</th>
		<th>nginx config</th>
	</thead>
	<tbody>
		<tr><td>gkp
		</td><td>8001
		</td><td>/etc/uwsgi/apps-available/gkp.ini
        </td><td>/var/log/uwsgi/app/gkp.log
		</td><td>/etc/nginx/sites-available/gkp.ini
		</td></tr>
	</tbody>
</table>

## [Test-JK](http://fengxia.co:8002/jk)

<table class="table table-striped table-hover">
	<caption>Basic configuration</caption>
	<thead>
		<th>DB</th>
		<th>Port</th>
		<th>uwsgi config</th>
		<th>uwsgi log</th>
		<th>nginx config</th>
	</thead>
	<tbody>
		<tr><td>jk
		</td><td>8002
		</td><td>/etc/uwsgi/apps-available/jk.ini
        </td><td>/var/log/uwsgi/app/jk.log
		</td><td>/etc/nginx/sites-available/jk.ini
		</td></tr>
	</tbody>
</table>

## [Test-Fashion](http://fengxia.co:8003/wei)

<table class="table table-striped table-hover">
	<caption>Basic configuration</caption>
	<thead>
		<th>DB</th>
		<th>Port</th>
		<th>uwsgi config</th>
		<th>uwsgi log</th>
		<th>nginx config</th>
	</thead>
	<tbody>
		<tr><td>gkp
		</td><td>8001
		</td><td>/etc/uwsgi/apps-available/fashion.ini
        </td><td>/var/log/uwsgi/app/fashion.log
		</td><td>/etc/nginx/sites-available/fashion.ini
		</td></tr>
	</tbody>
</table>
