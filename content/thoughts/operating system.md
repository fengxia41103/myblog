Title: Operating systems
Date: 2019-01-13 08:35
Tags: thoughts
Slug: operating systems
Author: Feng Xia

<figure class="col l8 m8 s12">
  <img src="/images/funny/dilbert%20software.jpg"/>
</figure>

Let me talk about OS. This has been an annoying topic recently due to
the ZTE fiasco, which to me is a running joke on its own &mdash; [one
billion dollar fine][3], and we got nothing but a bunch of BS articles
circulating on in wechat that arouses nationalistic sentiments with
conspiracy theory, but nothing else.

The common focus point of these arguments are two things &mdash; OS,
and CPU. When they talk about CPU, as if there is only one maker
called Intel, and if only China could have developed its own CPU, the
threat is over. Well, this is a totally ignorant assumption because,
first of all, Intel is just one of many CPU manufacturers, where is
AMD, where is GPU, do they even know what type of workloads are now
running on what hardware? There are army of these chips, each designed
for its specific purpose. The CPU you can buy at Micro Center is but a
tiny tip of an iceberg, it's a general purpose at best, and even this
I would suspect that it is not &mdash; every design has a tradeoff,
say performance vs. power consumption, or footprint vs. cost,
therefore it is not **general purpose** at all in these senses. It can
be called a general purpose to its workload, but only means that it's
**mediocore** for all workloads, and is not tweaked for any &mdash;
everybody gets 60 out of 100, but forget about a 100/100. Well, then,
I would ask these BS authors, is this really what you are asking for?
is this the state you think that will save this country!? I don't
think you even know what you are talking about.

Not to mention, when we talk about chips, which is a **broad** word,
like **IT**, that covers more than one industry, not more than one
company! There are micro controllers (Motorola), DSP (TI), FPGA
(Xilinx), SOC, and god knows how many other such programmable embedded
thing we are actually using daily even in our life &mdash; just look
around, there is microwave oven, refrig, TV remote control, AC, car
radio, your phone, smart watch, now even smart home devices... all
these, are programmed with some software, so that it has a certain
application logic to react to a human input. None of these, is running
on an Intel CPU. So there you have it, I cease my case on CPU.

Now, let's look at operating system. Again, the same logic fallacy is
seen here &mdash; there are [an army of operating systems out
there][1]. If you look up the word "cloud joke", the number one
popular comic is: **"Cloud is mostly made of Linux servers"**, get it?
China has attempted RedFlag Linux back in 2000, when I was really
impressed by it because it used a Windows-like desktop management UI
so laptop vendors at 中关村 can sell their thing without infringing
Microsoft's IP. At that time it was even bragged that government is to
move to this platform so to become independent from MS &larr; doesn't
this sound familiar now!? 

The difficulty of operating system is not a technical one at all. If
you look the list above, you will be surprised to think how all these
can all work, and many you haven't even heard of &larr; no offense,
let me just ask you this, have you used BSD? or Solaris? ... well,
these are not only in broad use, but is super powerful, and in many
technical ways superior to MS Win. Period. So pls, stop talking about
OS as if you know. You know nothing.

If there is one OS you should care about, then it is not MS at
all. Linux is the king on the Internet, and it's open source! So don't
even bother inventing your own, you will be quite impressive if only
you could understand and keep up w/ Linux core itself! RedFlag tried
it, and failed probably, so go for it, it's a lot harder than writing
those BS articles!

Further, the challenge of OS is not even technical, but purely
business &mdash; operating system is responsible to provide a base for
hardware-to-software interface. The key is how compatible an OS is
with gazillion of hardware varieties and vendors out there. Let's say
you have just invented your own super OS, will my PCI audio card work?
and wifi module? and camera? and even memory, some data bus, USB,
bluetooth, when I plug in my USB microphone for gaming, will it be
recognized and work? and my HP printer?.... the list goes on and on
and on. People dont realize, when his/her computer works so
effortlessly that all these peripherals work magically, is the result
of a tremendous collaboration between OS maker and hardware vendors --
hardware vendor will have **no incentive whatsoever** to write a
driver for your OS unless your OS is popular. Then, alternatively, you
will have to write your own!

So, have you written USB drivers before? are you ready to commit time,
resource, $$ to cover, say 100 hardwares you see in popular laptops?
If even leveraging an existing open source one, such as Linux, has
failed, then I would say it's hard pressed to make me believe you can
pull off without even realizing the task ahead! If we take all these
development as a whole and give it a score of 100, I would say writing
OS is like 10%, or even 5%, while the rest are about making it
compatible with hardware **your OS needs to support**. That, honestly,
is not only technically hard, but simply impossible business wise! If
only China owns every single hardware piece in that computer, and
enforce these vendors to write code to support your OS, I can best
your OS will flop. Period. And I bet you haven't thought of the risk
if this even became true &mdash; if you build a machine like this,
then you have to drag this entire vertical chain over to keep up with
all these other development industry is rolling out constantly &mdash;
new protocol, new bus strategy, new hardware new software, new data
format, so on and on and on.. you will be left in dust sooner than you
think!

People, please, stop talking about things you don't know, and
definitely stop dressing it in such a nationalist tone. This doesn't
help to fix the issue. Instead, do your homework, learn your code,
think hard and **pay as much to** [details][2] as possible. This is
the only way to become good, if you are good, and lucky.

Everything else, is just BS.


[1]: https://en.wikipedia.org/wiki/List_of_operating_systems
[2]: {filename}/thoughts/details.md
[3]: https://money.cnn.com/2018/06/22/news/companies/zte-us-fine-trade-case/index.html
