Title: Software engineer
Date: 2019-11-10 15:06
Tags: dev
Slug: software engineer
Author: Feng Xia


<figure class="col l6 m6 s12">
  <img src="images/scissors.jpg"/>
</figure>

Had a chat w/ a young engineer on the team about career, technology,
what to study/learn. Whiling writing my responses, many thoughts came
to me, so I'm pasting the email here since I believe they are very
relevant in these topics, and they are truthfully represent what I
think about them.

# data structure, project Euler

I don't recommend you study data structure or OS on paper at
all. There are three data structures you need to know, and they cover
90% of all cases you will ever encounter in your career &mdash; array,
link list, and hash table. In Python's term, they are list -> array,
no equivalent -> link list, and dictionary -> hash table.

Pick a language you feel comfortable w/, and whatever the term they
use to describe these 3 data structures, read about them. There is no
better way to _study_ them other than finding a _real_ problem to
solve using these. I recommend you to try [Project
Euler](https://projecteuler.net/). They are pure mathematical
problems, and forces you to use these data structure _creatively_ for
your computation because they only have two criterias:

1. get the right answer
2. compute the answer in < 1 minute

You will be surprised (and impressed) how to solve these problems. For
example, finding the 1 million-th prime number... Once you get a few
problems solved (starting from problem 1), I can assure you you will
start to see things in arrays and hash tables.

## a word on `link list`

You don't see link list much in today's SW job, and you will be
wondering why I recommend it. If you ever do embedded system, or OS
for that matter, anything low level, you see link list
EVERYWHERE. It's the concept that matter -- how data can be chained
(nothing fancy, just a pointer to the NEXT, and another to PREV).

This same concept, however, will map into anything needs _scaling_
up/down &mdash; pagination on UI, a task queue, a sequential
workflow. So without reading their code, you can already grasp the
concept how they could have implemented it.

Now, the reason I recommend this is, is because of the data model
relationships (see below section "relationships").

# data modeling, philosophy, life

What you have said in email, actually, is not data structure, but data
modeling. Data structure is too low level; very few people need to
deal w/ that kind of idea. If you want to write your own SQL database,
yes, you need data structure; if you want to use Postgresql, or
Java/Python/Ruby to solve a biz problem, you need data modeling.

There is no golden rule for data modeling, just like there isn't a
_good/bad_ architecture &mdash; they are just subjective opinions. The
quality of such subjective opinion, however, reflects the person's
philosophy, which then came from his/her education, life experience,
whether was in love or dumped, missed breakfast that morning or
not.. and so on. I'm not joking; data modeling is the **arts** side of
software engineering, you can't learn it, you have to practice it.

How to practice it? Implement an idea as web based application.

Any idea, any web framework, doesn't matter, because the first thing
you will be forced to do is data modeling.

## two models

There are only two things in data modeling &mdash; model, and their
relationship. And in models, there are two types in my opinion &mdash;

1. Sth maps to something real (physical product, for example, a model
   called `LenovoSwitch`, or conceptual,for example, `vlan`).

    For these, attributes are already defined &mdash; you need to study
    them, learn, and use them. For example, you can't invent an
    attribute called "color" for model "Vlan", but there **must** be a
    field called "id" because each vlan must have an ID!

2. Sth you invented because you say so, for example, in Netbox there is
   model "site", well, who says my definition of "site" is correct? and
   who says it needs a `name`? 长安街上有很多sites have no name, but a
   number! How about that!?

    You see, this is where your philosophy stuffy comes in &mdash;
    designing data model is completely your world view against
    others. The problem/key is open-mindness &mdash; if you design the
    `site` to be a string, then you need to aware that when you save
    "number" to it, numbers would have to be converted, which makes it
    difficult to validate, say, some naming convention. Alternatively,
    you can design two attributes -- `name`, and `id`.... see, if you
    are a good thinker, you will perceive these possibilities in
    design, and will have to make a lot of choices. But this is what I
    call "conscious decisions" &mdash; this is completly different from
    those 我从来没想到过的scenario.

So for a good data modeler, deep thinking is key. However, you will be
very unhappy, because, after all, no philosopher was a happy
person. You know the phrase that "devils are in the details". Well,
what kind of person will be happy dealing w/ devils!?

## three relationships

Easy, 3 types only:

1. 1->N: foreign key
2. 1-1: strong bind, eg. you can only have one biological father.
3. N->N: matrix

Any model you designed will have one of these three relationships, and
the choice you make **determines** the quality of your design. Period.

In Netbox, if I design Site and Rack to be "1-1", I'm screwed. But
whenever you feel confident, or want to restrict the possibility, you
should 1:1 as much as possible. The more of this you have, the narrow
the scope is, the better quality your code will be, because boundaries
are clear.

"N-N" is a cheap one, catch all. If you don't know what relationship
it should have, give it N-N; but this is lazy work by the
designer. It's a strong signal that you don't understand the problem
well yet.

"1-N" is 90% of all cases, because I believe that is how human brain
works &mdash; we look at things in a tree mode. You must have seen
Chinese biz love to show off their "deep thinking" in mind map, or
terms like 分层，分等，分级，金字塔结构... what they are really saying
is, 1-N, but of course, they don't understand this part.

Tree can grow in size quickly, and what they really are is, yes, link
list! Therefore, link list is the implementation of tree.

In your model, once you formulate these relationships, the limitation
becomes very obvious &mdash; you will never agree to a sale whose
customer wants N sites in 1 rack, because your model doesn't allow
this!  Therefore, it amazes me many SW engr allows the boss to ask for
anything &mdash; it's not that I disagree w/ him being the boss, it's
that I'm defending my world view &mdash; How can I just nodd w/o a
fight?

And because these relationships define the limitations, it becomes an
art (but also the fun). Therefore, the experience, the deep thinking,
the books you read, will dictate your world view, and that will
reflect in your choice in design. There isn't a single book you must
read; you should read any book you want, but think, think, think.

The more _biased_ you are, meaning the stronger an opinion you will
have on the issue, the better, because you won't have your own opinion
unless you have given it a lot of thoughts, will you!? Writing essay
of life, of news, of a movie, or a music, is actually a good way to
learn this, not writing code. I started writing essays in MBA. The
beginning was painful; but it became a habit, and I highly recommend
it.

# what to learn

Don't be fooled by buzz words &mdash; AI, big data, whatever. These
things come and go. Business needs to talk about them so they appear
to be relevant. But don't let them define you.

Javascript is becoming more and more powerful. Learn Angular or React
to write 1 or 2 hobby applications. I think JS has a strong
future/job.

Don't learn Ruby. It has passed its prime. I don't hear it much
anymore.

Python, C#, .net, Java, Scala, R... they are all the same, popular
right now, but they are just tools, and tools don't solve problem,
brain solves problems. They are all fully capable, and overkill for
any biz problem you will ever be hired for. The only time I ran into
limitation of Python was doing a Euler problem, that Python only
allows 27 decimal points(!)... so yes, if you compute size of the
Galaxy, the choice of language matters; otherwise, don't bother.

Pick one you enjoy writing, that fits your way of
thinking/typing/sleeping/whatever, and use it often. I never learned
Java, and didn't catch Go, because I looked at them, and didn't like
their style at all. But I fell in love w/ Python in 1998, because it
uses TAB for code, and makes the code look, nice!

Think this way. If now there is a war going on in Shanghai, will you
feel better w/ a bow and arrow which you can shoot in a blink of an
eye, or a 东风 missile that takes probably you and another 12 ppl to
operate and 6 hours to launch? I get it that the 东风 will kill
thousands in one hit; but if you are walking on the street, that power
doesn't help me at all if you just ran into someone hostile.

# career

Last word on career. SW is an unhappy one. The better you become, the
unhappier you will be.

Biz ppl chase buzz words, thus they will require you to write in
<xyz>.  (Well, does anyone ever care what language Google search
engine was first written in?) Therefore, your "skills" become
_obsolete_ in a matter of 2 years. This is BS; but I don't know how to
change this. Thus, you feel pushed to learn new language, new lib, new
this and that, solving the same old problem, differently perhaps. But
the real issue is not that previous solution didn't work; nobody ever
bothered to investigate the core of the issue at the first place! I
can't tell you how many times in China I was asked to make a SW that
allows them manipulating data/number (of course, 中国特色，业务需要),
while expecting the number on the report to actually match! &larr;
this, again, is a philosophical problem, because they are asking 当了
婊子立牌坊.

However, the world seems populated w/ such requests, such people. The
do-ers will end up being at the bottom of the hierarchy, having the
best knowledge and strongest skills, and lowest rewards. So, what to
do?

Dont rush to 创业， unless u have a rich Dad. But even then, don't,
because that's not your money, you didn't earn it, thus shouldn't
experiment w/ others' money.

But do create. Create as often as the thought comes to you, whatever
it is, using your skills to create &mdash; a website, a blog, a mobile
app, a POC of some library, a script that makes our daily work easier
&mdash; start to work, smart, not harder. When I first learned Python,
I was tired of looking over 10+M of log files searching for an error
message. Script can do it in 1 second; and it took 10 days to write
one, maybe. But writing the script is fun, learning exp, and you
become stronger, and 10+M or 100+M logs make no difference anymore!
That's the way to work. So again, too many ppl working HARD because
they don't work smart. 磨刀不误砍柴功, everybody knows the phrase,
very few practices it.

SW is powerful tool, and powerful concept. By using it, you will have
a sharp observation of the world, a strong opinion of a problem, a
know-how to actually move forward (how many entrepreneurs are just,
talking!?). Remember why we go to school and pursue education? Because
the only thing that belong to you, is your knowledge; everything else
you have, today, are, well, removable. Your know-how, however, is
yours.

It is sad that engineers are viewed as commodities. But don't become
one. If you don't believe anyone who knows alphabets can just write 红
楼梦, then knowing <python/js/...> has nothing to do being a good
programmer/engineer. Engineering is hard work, but solid, because at
the end of all the BS, gears must match exactly, the "if x==y" must be
true or not, no 3rd option!

I like to end w/ the example of the Alpha Go. Go was viewed as Zen,
and no one bothered to really figure out its engineering/mathematical
patterns till Google come along. Once it's codified, human can only
cry &mdash; it has never been Zen, it was viewed as Zen only because
figuring it out is hard. Engineers are those ppl who have a desire to
see how it works; others are just satisfied w/ that it works, but
becomes victims easily because, well, they have reference. Isn't it
better to fail w/ knowing why, rather than fail w/o?
