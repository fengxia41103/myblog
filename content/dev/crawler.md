Title: Crawler, TOR, and be a good web citizen
Date: 2015-03-04 13:00
Tags: dev
Slug: tor crawler
Author: Feng Xia

Many projects I have done involved harvesting data from
public sites. Data crawling is an exciting business. On one hand, it
is easy to develop a crawler these days. In the Python world,
plenty tutorials will show you how to build
a simple crawler using the [Python urllib](https://docs.python.org/2/library/urllib.html),
or building upon some more sophisticate tool like
[Scrapy](http://doc.scrapy.org/en/latest/intro/tutorial.html).

<figure class="s12 center">
  <img src="images/regular_expressions.png"/>
  <figcaption>Fun with regular expression</figcaption>
</figure>

But before carried away by the fun and the power,
let's lay down a ground rule &mdash; to respect
 peer server and try hard being a good web citizen.
We surely learned a few lessons here. So please
take notes and hopefully you won't fall into the same pit.

# Banned

We used to joke about this &mdash; if you haven't been banned by a server,
you haven't hit it hard enough. Well, we were banned.

Our first version was a simple urllib based agent and could be run
in multiprocessing mode. Target was a public site run
by a small startup firm, which by rumor consisted mostly of
developers, too. So we took this on almost like an arm race.

```python
from urllib3 import PoolManager, Retry, Timeout, ProxyManager

class PlainUtility():

    def __init__(self):
        user_agent = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7'
        self.headers = {'User-Agent': user_agent}
        self.ip_url = 'http://icanhazip.com/'
        self.logger = logging.getLogger('gkp')
        retries = Retry(connect=5, read=5, redirect=5)
        self.agent = PoolManager(
            10, retries=retries, timeout=Timeout(total=30.0))

    def current_ip(self):
        return self.request(self.ip_url)

    def request(self, url):
        r = self.agent.request('GET', url)
        if r.status == 200:
            return r.data
        else:
            self.logger.error('status %s' % r.status)
```

We kicked off the crawler in multiprocessing mode (between 200-300
subprocesses) and sat back to watch data pouring in, until
a `403 forbidden`, ban!
Needless to say, the server must have experienced a trigger event which
prompted the action. What could it be?

First, load. We suspected the load we were generating put us on the
radar. This was a public site who claimed a over three million live
daily users. However, I have always viewed such information with a
grain of salt. So in this case, we guessed those million members were
certainly not clicking at the same time as we were, and that site was
likely hosted on a budget server as many startups have done. With this
consideration, one measure to implement &mdash; throttling (and if you
have a website, don't blow up your user number to make it look too good
to be True, unless you are ready to handle the hits.)

Further, from the time
we were hitting the server to the time the ban came in, a few days
have elapsed. So the reaction was likely taken by a manual intervention
instead of a computerized protection. This is a security hazard on their
end.

Last, we moved to a different wifi access and used the same code, it
went through without a glitch. So another thing became clear, the
defense was IP based, which meant all computers in our office were
helpless now because they shared the same outbound IP.

A few possibilities to resolve this. First, moving around *free* wifi.
But that is just not nice. Crossed off the list with a 100% vote.
Second, use a VPN. This is a good and common approach. We could use
either an in-house server or a commercial one. But that's too, "boring",
said one developer. So after a few
tries, we ended up with something quite interesting, simple yet
powerful.


Besides the old school `PlainUtility`, I have introduced
two upgrades &rarr; `TorUtility` and `SeleniumUtility`. Both
added a layer of indirection to the puzzle, but also a layer of protection.

# TOR

First layer added to our stack is to use
[TOR](https://www.torproject.org/) network as our proxy to
serve request. Further, because TOR service is a socket proxy, not a
HTTP proxy, we installed another layer, [privoxy](https://www.privoxy.org/) in between to connect the two.

```python
class TorUtility():

    def __init__(self):
        user_agent = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7'
        self.headers = {'User-Agent': user_agent}
        self.ip_url = 'http://icanhazip.com/'
        self.logger = logging.getLogger('gkp')
        retries = Retry(connect=5, read=5, redirect=5)
        self.agent = ProxyManager(
            'http://localhost:8118/', retries=retries, timeout=Timeout(total=60.0))

    def renewTorIdentity(self, passAuth):
        try:
            s = socket.socket()
            s.connect(('localhost', 9051))
            s.send('AUTHENTICATE "{0}"\r\n'.format(passAuth))
            resp = s.recv(1024)

            if resp.startswith('250'):
                s.send("signal NEWNYM\r\n")
                resp = s.recv(1024)

                if resp.startswith('250'):
                    self.logger.info("Identity renewed")
                else:
                    self.logger.info("response 2:%s" % resp)

            else:
                self.logger.info("response 1:%s" % resp)

        except Exception as e:
            self.logger.error("Can't renew identity: %s" % e)

    def renew_connection(self):
        with Controller.from_port(port=9051) as controller:
            controller.authenticate('natalie')
            controller.signal(Signal.NEWNYM)

        self.logger.info('*' * 50)
        self.logger.info('\t' * 6 + 'Renew TOR IP: %s' %
                         self.request(self.ip_url))
        self.logger.info('*' * 50)

    def request(self, url):
        r = self.agent.request('GET', url)
        if r.status == 200:
            return r.data
        elif r.status == 403:
            self.renew_connection()
        else:
            self.logger.error('status %s' % r.status)
        return ''

    def current_ip(self):
        return self.request(self.ip_url)

```

Now, with the help of the TOR, we are browsing
internet with *anonymity*. TOR maintains a pool
of IP addresses, but a renew request does not guarantee to generate
a new IP. On top of this, some IPs were probably located on the moon because
a request took *forever*, which on our end were a flashing timeout messages across
screen. Internally we maintain a life counter on a connection
and renew it when counter is up so we could return the IP back to the IP.

## TOR config

The key to config the TOR was to enable `ControlPort` and set up `HashedControlPassword`.
The password would be used when sending request to the local TOR service such as renewing a connection. TOR
service would in turn pass that on to TOR network on our behalf.

```shell
In /etc/tor/torrc:

## The port on which Tor will listen for local connections from Tor
## controller applications, as documented in control-spec.txt.
ControlPort 9051

## If you enable the controlport, be sure to enable one of these
## authentication methods, to prevent attackers from accessing it.
HashedControlPassword 16:872860B76453A77D60CA2BB8C1A7042072093276A3D701AD684053EC4C
```

Password is created using [TOR commandline](https://www.torproject.org/docs/tor-manual.html.en).

## Privoxy config

In `/etc/privoxy/config`, we set up a receiving port and a forwarding port.
Forwarding port was set to 9050 as that's the default listening port by
the TOR service.

```shell
listen-address  localhost:8118
forward-socks5   /   127.0.0.1:9050
```

# Phantom

Now with the link between us and the target out of the way, we wanted
to change our agent from a urllib brute force to a nicer consumer.
Our goal was to drive a *real* web browser so our reading of the site
is no different from a real user.
Tapped into our experience with automated web testing, [PhantomJS](http://phantomjs.org/)
and [Selenium](http://www.seleniumhq.org/) were a natural choice for the job.

```python
from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities


class SeleniumUtility():

    def __init__(self, use_tor=True):
        self.ip_url = 'http://icanhazip.com/'
        self.logger = logging.getLogger('gkp')

        dcap = dict(DesiredCapabilities.PHANTOMJS)
        dcap["phantomjs.page.settings.userAgent"] = (
            "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/53 "
            "(KHTML, like Gecko) Chrome/15.0.87"
        )
        # DesiredCapabilities.PHANTOMJS['phantomjs.page.settings.userAgent'] = user_agent
        service_args = [
            '--proxy=127.0.0.1:8118',  # provixy proxy
            '--proxy-type=http',
        ]
        if use_tor:
            self.agent = webdriver.PhantomJS(
                'phantomjs', service_args=service_args, desired_capabilities=dcap)
        else:
            self.agent = webdriver.PhantomJS(
                'phantomjs', desired_capabilities=dcap)
        self.agent.set_page_load_timeout(120)

    def request(self, url):
        for i in xrange(1, 4):
            try:
                self.agent.get(url)
                return self.agent.page_source
            except:
                self.logger.error('#%d request timeout' % i)

    def __del__(self):
        self.agent.quit()
```

At this point, the stack has blown quite a bit from a native Python urllib
to now **Python+Java+Javascript** and a third party web proxy tool.
The downside was apparently the complexity. But the upside was also obvious.
I have achieved a better control over our data harvesting process.
More importantly, we tried our best to be a good web citizen, and let's stick
to that.

# Final design

After all the tweaks, the final design of my crawler comes down to this:

<figure class="s12 center">
  <img src="images/crawler.jpg"/>
  <figcaption>Crawler architecture</figcaption>
</figure>
