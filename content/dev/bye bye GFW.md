Title: Bye Bye GFW
Date: 2017-04-30 22:53
Tags: dev
Slug: bye bye gfw
Author: Feng Xia

The GFW is nothing but an anti-humanity instance that blocks knowledge
transfer and information sharing in the 21st century when brain is the
competition advantage and this gov decides to sacrifice all the future
with a vain hope that creativity can continue to flourish while its
citizens are excluded from the rest of the world. The most frustrating
point is that technology forums are handicapped in the crossfire to a
ridiculous degree, for example, my experience with Stackoverflow has
been downgraded to having at least 50% **dead links** due to the
blocking. Come on! and you are talking about technology innovation!?
Get a grip.

> When my brain has to slow down to cope with incoming information,
> it is a sign that this place is culturally backwards and hopeless,
> because mind is being wasted due to artificial barrier which has no
> reason to exist especially in the name of political stability.

Now suppose there is a SSH server sitting outside the block, here is
how to punch a hole and stay connected with life:

1. From SSH client machine, `$ ssh -C -D 1080 username@ssh-server-ip`
2. In firefox, configure a SOCK proxy:
    1. `Preferences -> Advances -> Networking`, set up `Manual proxy`.
    2. Set up as shown below:

<figure class="row">
    <img class="img-responsive center-block"
    src="/images/firefox%20manual%20proxy.png" />
    <figcaption>Firefox manual proxy setup</figcaption>
</figure>
    
    3. Restart firefox, then go to `http://www.google.com`.
    
Welcome back to the world.
