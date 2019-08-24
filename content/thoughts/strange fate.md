Title: Strange fate
Date: 2019-02-15 11:08
Tags: thoughts
Slug: strange fate
Author: Feng Xia

<figure class="col s12">
    <img src="images/country%20life.jpg"/>
</figure>

Have you had this feeling before? that something is off, and things
are happening in a strange way?

This is how I felt yesterday and the day before. Went to see a medical
surgeon to take care of that bump on the back of my head. At parking
lot, out of the twenty some years of driving a car, I ended up
stepping forward and ran over a curb, and of the entire way back home,
I felt my mind was just somewhere. I didn't know what was happening,
just that strange feeling that my mind was off, off. 

Then at night at the end of scrum, Eric asked me whether I have seen
his email. So I found this email, that came from some BS email
address:

```
KANDULA.VENKATA NARENDRA REDDY <bugbounty10378@gmail.com>
```

and it has caused an **uproar** inside the company that some 
trade secret has been leaked by rouge developer and such, myself
included (well, technically yes, but then, the internal analysis said
that I'm no longer working here... so much a joke for taking the
matter seriously!). Instead of anyone questioning the legitimacy and
credibility of this strange looking BS email address, every single on
on that email thread acted as if something terribly immoral and wrong
had just happened:

> - Please provide an overview of what the GITHub project was being used
> for?  
> 
> - Please provide an overview of the functionality and type of
> information the source code was used to access?  
> 
> - Please indicate who
> authorized you to store the source code and information in GIT Hub?
> 

So it turned out that it was a code I pushed into my gitlab account to
showoff the REACTjs way of building a dashboard based on YAML config,
and the example config files had these so called _sensitive data_ that
this `bugbounty10378` guy, for whatever purpose (but honestly, doesn't
this count like a blackmail of a kind!? what the heck is this email!?
and why would anyone take it seriously!? Just some random guy scanning
github for a string pattern `<company name>.com`, and then for
something like a URL, or a username? a pwd?) For God sake, let me give
a legitimate URL we are using internally in our development which
controls million dollar worth of equipment:
`http://10.240.44.48`... does it mean anything to you!? to anyone!?
and how about I give you my credential for a kick, `fxiaeo942423,
bbba39430w908`? Go have fun!


This is turning into a witch hunt, and everyone is acting seriously to
show his/her value in the command chain, while, the only message I got
for being an active developer &mdash; don't write any code! The more
you write, the more likely you will miss one line or two in your git
commit in which you had put an _internal_ URL, a user account
credential, and so on. And to make things even worse, these commit
histories are permanent, like a prisoner's tattoo on your face, done.

Yes, it is a security hazzard, no doubt about that; No, no developer
in his/her sane mode is consciously committing a crime here. If you
folks have ever written a code and made a commit, you know the zillion
`if-else` you had to take care of, the grueling hours of debugging to
make it **work**, and the relief when the code is finally **pushed to
git**... well, at the end of all the exhausting hours, remembering to
comb through all the code again so to mosaic all these **sensntive**
data, is the last thing on dev's mind; besides, having them there is
likely the only way to get the code working, even though dev knows
it's just for now, and it's bad practice, s/he is afraid to touch
code, even to change a newline, can break it!

Well, that's the sad reality of software engineering. For all the
uproar people who jumped on this `bounty` thread, maybe you should
take a working code, mask all these data you care about, and QA it to
make sure it's still working, before dev can commit such a
sin. Honestly, I would love someone to distilll my code to make it,
safe. If you know Python, and Ansible, and REACTjs, and jQuery, and
materialized CSS, and Django, and Postgresql, and Celery, and Tower,
and Satellite, and a few other technologies/applications I'm dealing
w/ everyday, email me, pls. I would love to meet you, and maybe you
can work for me.

Chiao.
