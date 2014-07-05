How domains, IP addresses and servers works
===========================================

I'm going to walk you through *how part of the internet works* as simply as possible. 

Domains
--------

How does it happen, that someone type `example.com <example.com>`_ and then see some
web pages? Where this *example.com* come from?

A little background. On internet we have IP addresses to give every
computer it's specific name. Because we don't like these awful numbers
(like 123.28.13.234), we have nicknames for them - **domains**. For example - you
know that when you type ``google.com``, you get to google page. But
that happens even if you type: ``74.125.224.72``. In first example it does
this:

1. It takes name ``google.com``
2. Goes to world data bank of domains and their appropriate IP addresses
3. Find out which IP address belongs to this name ``google.com``
4. Get you to this IP address

You can `buy <http://www.godaddy.com/>`__ your own domain and then
redirect it to your IP address. Redirecting is made by adding  **A record**. This is usually done on their administration website. Then, after few minutes (or hours), it is registered in this world data bank. 

There is also free alternative, for example `freeavailabledomains.com <http://freeavailabledomains.com/>`_. It's not **second-level** domain (the one which is right before ``.com``, ``.eu``...) , but **third-level** (e.g. yourname.flu.cc, ...). You can use it in our example - just register there and choose your domain name (e.g. ``mojepks.flu.cc``). Then you add **name** (that's prefix before ``.flu.cc`` - in my case ``mojepks``) and **destination** - that's your **public** IP address.

Public IP
-----------
What is public IP address? It means that this address is one on the whole internet - it points to one specific place on the world. 

if you are connected to some network, for example to your home router, you have one internal network. Usually it's something like ``192.168.0.xxx``. But this is not an address people can see you from the internet. It's just the internal one. On Linux you can find it by typing::

    ip addr
    
to find your public IP address, you can find it e.g. `here <http://whatismyipaddress.com/>`_. But this address is most probably isn't of your PC, but of the router you have. And not even that - it might be and IP address of some other *node* to which your router is connected to. To find this out is best to ask your administrator or IPS  (a company, which is offering you and internet). 

It means, unfortunately, that not every one has it's own "public" IP address and
even worse, it can change! And that is not what you want - then you
should have had to change it every time your IP get changed. You have to
ask to your IPS if your
address is "static" or "dynamic". My IPS (UPC CZ) told me that my is
"dynamic". But after a little research I found out that it means that my
IP address can *theoretically* change. In real, it is same for few years
now :) . It is relatively common, so maybe you are lucky.

If you don't want to buy "first level domains" (the one which are just
something.com) and second level is enough (like
something.somethingelse.com), then you can take a look on `getfreedomain
<http://www.getfreedomain.name/>`_. It will serve good for our purposes.
