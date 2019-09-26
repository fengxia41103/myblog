Title: Sync vs. Async
Date: 2017-05-23 10:36
Tags: dev, design
Slug: sync async
Author: Feng Xia


<figure class="col l4 m4 s12">
  <img src="/images/funny/pointers.png"/>
</figure>

# Irrelevant

Sync vs. Async. I have been thinking this to myself and have involved
quite a few discussions with smart (and mostly young) developers which
from time to time makes me wonder whether there is a definite answer
for this at all.

One thing I can fairly state is that there isn't a **right** or even
an answer. It depends. Yes, it depends on what you mean by sync or
async, and why you care about one way or the other. The discussion
isn't technical, it isn't philosophical, it is to understand use case,
user's expectation, workflow, execution sequence, business assumption,
and maybe last, system performance. If the discussion isn't confined
in these areas, it will go nowhere and quickly downgrade to a heated
argument without a satisfaction from either parties involved but
feelings hurt, self-opinion firmer believed in, and a mine field that
no one is willing to step into again.


Really, a particular framework or programming language does not make
the design async or sync. [Tornado][1], [Twisted][4], or libs like
[Asyncio][2], [Gevent][3], they all have the capability to help an
__async implementation__ if needed, but <span class="myhighlight">
they don't make your design or your architecture
async</span>. Fundamentally one can even argue that computer
architecture is genetically synchronous because CPU can execute one
instruction at a time, unless multicore can be utilized, and I do mean
they are utilized either by at the HW level where CPU, cache and
memory are smart enough to take some instructions for parallel
computing, or the higher level interpretation -- assembly, C, or sth
even more abstract -- have the design and internal implementation all
the way through to generate those instructions that make the CPU
**smart**.

[1]: http://www.tornadoweb.org/en/stable/
[2]: https://docs.python.org/3/library/asyncio.html
[3]: http://www.gevent.org/
[4]: https://github.com/twisted/twisted

<figure class="col l4 m4 s12">
  <img src="/images/funny/1519232-geek_poke02.jpg"/>
</figure>


Too many times ppl take multithreading and multiprocessing as the
statement that my code or my design is now asynchronous, or event
drive, or responsive, which all mean the same thing &mdash; it's
superior to a synchronous one. Really? How do you validate all the
components on your stack are implemented so support your statement? Is
DB itself asyn capable (and what does this even mean!?)? is the DB
interface lib asyn capable? is the 30+ imported libs, third-party
tools, code you have written, asyn capable? Is the server lib based on `Select`,
`epoll`? Is your shell call using `check_call`? Is your disk firmware
async? Even step along the stack can bring your system to a halt
regardless how some part of the stack is actually async. So my point
here is **async design or architecture is irrelevant** because it is
not a technical topic, but a business topic.

# Dependency

Why so? Because what really matters is <span
class="myhighlight">dependency</span>. Your business workflow is the
single voice that will dictate and define dependency. Use PM for
example, if task A is depending on the completion of task B, then
regardless how multitasking the resource assigned to these tasks are,
tasks are executed in sequence, period, because that's what **makes
sense** in business, even though it slows the entire system down. Technology 
can improve UX by making user's wait more tolerant, but it can not,
and <span class="myhighlight">should not</span>, remove the `wait` if
it breaks business sense. Mapping this argument to an e-commerce app,
if user needs to add to shopping cart, submit checkout, pay, get
receipt &mdash; well, clicking that submit checkout button should
BLOCK until it's accepted by server before he is presented with
payment view &mdash; sync. What should really be done is sit down and
watch this [Tech talk][6], yes, technology is not a silver bullet
unless you know what you want to get out of it.


[5]: https://stackoverflow.com/questions/748175/asynchronous-vs-synchronous-execution-what-does-it-really-mean
[6]: https://www.ted.com/talks/renny_gleeson_404_the_story_of_a_page_not_found


Now looking back to my career, funny the only __real asyn__
requirement I have encountered is in china's workflow, the concept of
会签（consensus voting &larr; this is my phrase), but without a
majority rule. Go figure. My implementation is to give everyone a
high-five page and not bother to even post data back to the server
&mdash; everything is handled on client side, no IO blocking concern
of any kind, click-at-will and guaranteed consistent and satisfying
responsive, realtime, event driven, taking advantage of any HW
resource the user happens to have, distributed, HA, zero single point
of failure....this, is an asynchronous design.
