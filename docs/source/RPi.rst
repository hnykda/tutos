Making Raspberry Pi usable
==========================

After 3 months of using RPi, I decided to make this tutorial for same
people as I'm - who looks for easy, understandable way to make RPi as
awesome as possible.

In this tutorial I will walk you through whole process of making from
Raspberry Pi secure, reliable, efficient, fast and easy to maintain
server for variable purpouses as is FTP, web hosting, sharing... All
that thanks to Archlinux ARM operating system. The device will be
"headless" - it means, there will be no fancy windows etc., just command
line. Don't be scared, I will walk you through and you'll thank me then
:) . You don't need some special knowledge about computers and linux
systems.

Some notes before you start
---------------------------

-  When I feel that some topic is covered solidly somewhere else, I will
   redirect you there.So thing about this also as summary of materials.
-  On many place it is not only RPi-related
-  You will have to learn some basics about unix systems - naturaly on
   the way
-  Sometimes I'll simplify things. Feel free to find more info about
   that :)

What you get on when you succesfully finish
-------------------------------------------

From "bare" RPi you'll get:

-  Safely to connect to your RPi from anywhere
-  Possibility of hosting web pages, files, etc.
-  Readable and reliable system (it will do what you want and nothing
   more)

What you will need
------------------

-  Raspberry Pi (doesn't matter which model) with power supply
-  SD Card as a main hardisk for RPi
-  SD Card reader on computer with internet access
-  Ethernet LAN cable or USB wifi bundle
-  Other computer (preferably with linux, but nevermind if you use
   Windows or Mac)
-  Possibility to physically get to your router and know credentials to
   login to it (or have contact to your network administrator :) )
-  Few hours of work

What you don't need
-------------------

-  Second monitor or ability to connect RPi to some monitor

Start
-----

So you have just bare RPi, SD card, power supply, ethernet cable
(RJ-45). So let's start! There are houndreds of guides, but I haven't
found them satisfaing.

Installing Archlinux ARM to SD card
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Go `here <http://archlinuxarm.org/platforms/armv6/raspberry-pi>`__ and
make first 3 steps. That's it! You have done it. You have you Archlinux
ARM SD card :)

Little networking
~~~~~~~~~~~~~~~~~

I guess you probably have some of "home router" ("box with internet")
and when you want to connect e.g by wifi with your laptop or mobile
phone, it just connects (after inserting password). You need to test
first what happens, when you try to connect by ethernet cable, for
example with your laptop. Turn off wifi and check it. Did your computer
connects to the network (or even internet) as usuall?

If yes, it is great! You can procced. It is what we need - we need RPi,
when it boots up, to automatically connect to the network. Then we will
able to connect to it. You will need one more think to find out - which
IP address router asign to you when you connected by cable - it is very
probable that RPi will get the same, or similiar. Don't be afraid - it
is easy to get (IP address)[how to get ip address]. On modern systems,
one command :) .

Ok, now you have to insert SD card to RPi and connect it to your router
with ethernet cable and then turn RPi on by inserting power supply. The
diodes starts flashing. Now back to your computer and we will try to
connect it using **SSH**. SSH is just "magic power" which enables to
connect from one to other computer.

RPi is already ready and waits for connection. How to use ssh and some
utilities (Linux, Mac) or programs (Windows) is supereasy - you will
find a tons of tutorials on the internet (keywords: how to use ssh). IP
address is the probably the one you assigned before. It will be
something like this: ``192.168.0.x``, ``10.0.0.14x`` or similar. Next
thing you need is username. It's just "root".

If your RPi haven't got this address (ssh is not working), than there
are two options.

1. You will login to your router settings and find out list of all
   connected devices with IP addresses and try them.
2. Use
   `nmap <http://www.cyberciti.biz/networking/nmap-command-examples-tutorials/>`__
   to find active devices in your network.

**Example** You have this address assigned: ``192.168.0.201``. Then you
have to type (in linux): ``ssh root@192.168.0.201``.

You should end up in RPi console.

Tutorial for used utilities
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Vim
^^^

We'll need text editor to configure everything and most of our time
we'll spend in command line. How to edit files inside terminal? There
are multiple console-based terminal. I choosed one of them, which is
called ``[vim](http://en.wikipedia.org/wiki/Vim_(text_editor))``. We
will install it in next chapters, but I will tell you some basics here
(you can try them later).

You can edit a file in vim by typing ``vim <file>``. Vim has three
modes, while I will tell you about two of them. Command and insert mode.
In command mode, you press special keys to make something. It's the
basic mode and you cannot edit file in it. Press ``ESC`` to get into
command mode. To edit a file, press ``i``. Now you are in insert mode
and you can navigate by arrows and type, delete etc. as you know from
other text editors.

After you make a change, you can save the file. To do it, get to command
mode (``ESC``). Now write ``:w``. This will save the file. To exit, type
``:q``. That's all you need for now. More about ``vim`` is under command
``vimtutor``.

Systemd
^^^^^^^

```systemd`` <http://en.wikipedia.org/wiki/Systemd>`__ is astonishingly
great and also astonishingly hated package, but thats not neccessary to
know now. Briefly - ``systemd`` cares about running processes in the
background. These are called daemons. For example in next chapter we
will use SSH - it will run at background. There is also package, which
takes care of automatically connect to internet (again in next
chapters).

``systemd`` is controlled by ``systemctl``. To start some program, which
is in this context called **service** (and we will stick to that), just
run ``systemctl start <unit>``. There are other usefull (and that's 90%
of what you need to know about systemctl) commands (all starts with
``systemctl`` and ends with ``desired_unit`` - watch example):

-  enable - this allow to run service after boot (but it will not start
   imediately)
-  disable - this will make device not to start after boot
-  start - this will imediatelly start a service (but will not enable it
   - it won't be run after boot)
-  stop - stop service imediately (but not disable)
-  status - this will print out all information in pretty format - you
   can find if it is enabled, started, if **there are any errors** etc.

**Example** There is service, which takes care about connection to
network. We will cover it in special chapter, but we will just play with
that for a minute. It's called ``systemd-networkd``. Try to start it,
enable it, disable it and then stop it and get status to see what every
command does by trying these:

-  ``systemctl start systemd-networkd``
-  ``systemctl status systemd-networkd``
-  ``systemctl enable systemd-networkd``
-  ``systemctl status systemd-networkd``
-  ``systemctl disable systemd-networkd``
-  ``systemctl status systemd-networkd``
-  ``systemctl stop systemd-networkd``

Last thing you need to know about systemd for our guide is where these
services has it's own configuration files. They are all stored in
``/usr/lib/systemd/system/``. For example, I've noticed SSH service.
Configuration file for this service is in
``/usr/lib/systemd/system/sshd.service``. You can type
``cat /usr/lib/systemd/system/sshd.service`` to see what is inside and
of course it can be edited.

``systemctl`` just looks inside these folders when you call command for
starting/enabling/... specific unit.

First setup
~~~~~~~~~~~

This is covered over the internet, so I will just redirect you.
`elinux <http://elinux.org/ArchLinux_Install_Guide>`__ - from this guide
finish these parts (in RPi console):

-  Change root password
-  Modify filesystem files
-  Mount extra partitions (if you don't know what it is, nevermind)
-  Update system
-  Install Sudo
-  Create regular user account

That's enough for now. Logout from ssh (type ``exit``) and connect
again, but as user who was created. Similiar to previous:
``ssh username@ip.address``. From now, you'll need to type "sudo" in
front of every command, which is possibly danger. I will warn you in
next chapter.

We must be sure that after reboot RPi will reconnect. Type
``sudo systemctl status netctl-ifplugd@eth0``. In should show something
like this:

::

    ● netctl-ifplugd@eth0.service - Automatic wired network connection using netctl profiles
       Loaded: loaded (/usr/lib/systemd/system/netctl-ifplugd@.service; enabled)
       Active: active (running) since Thu 2014-06-26 17:38:12 CEST; 4h 26min ago
         Docs: man:netctl.special(7)
     Main PID: 302 (ifplugd)
       CGroup: /system.slice/system-netctl\x2difplugd.slice/netctl-ifplugd@eth0.service
               └─302 /usr/bin/ifplugd -i eth0 -r /etc/ifplugd/netctl.action -bfIns

    Jun 26 17:38:12 530uarch ifplugd[302]: ifplugd 0.28 initializing.
    Jun 26 17:38:12 530uarch ifplugd[302]: Using interface eth0/E8:03:9A:97:B5:A7 with driver <r8169> (version: 2.3LK-NAPI)
    Jun 26 17:38:12 530uarch ifplugd[302]: Using detection mode: SIOCETHTOOL
    Jun 26 17:38:12 530uarch ifplugd[302]: Initialization complete, link beat not detected.

Keywords here are **active (running)** in "Active" and **enabled** in
"loaded". If there is **disabled**, just enable it by
``systemctl enable netctl-ifplugd@eth0.service``

Now try if you are connected to the internet. Type ``ping 8.8.8.8``. If
you don't see ``ping: unknown host 8.8.8.8`` it's good! If you do, your
internet connection is not working. Try to find out why - unfortunately
it is not possible to solve it here.

**Warning** Try also ``ping google.com``. It may not work even pinging
8.8.8.8 worked. The reason is bad DNS servers (doesn't matter what it
is). To solve this you have to find "DNS servers of your IPS". Try to
google it. If you find them, add them to ``resolv.conf``.

Reboot you rpi using ``systemctl reboot``. You must be able to connect
to it again after one minute. If not, somthing is wrong... In that case,
you need to find out why connection stoped working - if you have
keyboard and monitor, you can repair it. If not, you can try to edit
mistake on other computer by inserting SD card. Otherwise, reinstall...

Installing some sugar candy
~~~~~~~~~~~~~~~~~~~~~~~~~~~

For our purpouses we will install usefull things, which will help as
maintaing the system. So, run this:
``pacman -S vim zsh wget ranger htop lynx``

Do you see:

::

    error: you cannot perform this operation unless you are root.

Then you need to type ``sudo pacman -S ...``. I will not write it in
future and it is not in other guides. So sometimes you might be confused
whel you'll read some tutorials and autor implicitly use sudo without
mentioning it.

We will also need these in next chapters:
``pacman -S nginx sshguard vsftpd``

You can notice that is really few packages! And thats true! Isn't it
great? No needs of tons of crap in your device.

What are these? Just short summary - you can find more about it in
manual pages (``man <name_of_pacakge>``) or find something usefull on
the internet. \* **vim** - powerfull text editor (that's what you will
do 99% of time). First few *days* are horrible, but keep using it :) .
\* **zsh** - doesn't matter. Just install it and install
`this <https://github.com/robbyrussell/oh-my-zsh>`__ \* **wget** - just
for downloading things without browser \* **ranger** - file manager (you
can browse files, folders...) \* **htop** - task manager - you can see
what tasks are running, how much CPU/MEM is used, kill processes and so
on \* **lynx** - browser - no kidding :)

Some configurations
~~~~~~~~~~~~~~~~~~~

I assume you installed ``zsh`` with ``oh-my-zsh`` (changed your shell)
and also vim. You are connected as created user (from now, I will name
him **bob**). You are in Bob's home directory - check it with typing
``pwd``. It will print ``/home/bob``.

Make vim usable
^^^^^^^^^^^^^^^

Edit .vimrc file: ``vim .vimrc`` and insert this:

::

    syntax on
    set number
    set ruler
    set nocompatible
    set ignorecase
    set backspace=eol,start,indent
    set whichwrap+=<,>,h,l
    set smartcase
    set hlsearch
    set incsearch
    set magic
    set showmatch
    set mat=2
    set expandtab
    set smarttab
    set shiftwidth=4
    set tabstop=4
    set lbr
    set tw=500
    set ai
    set si
    set wrap
    set paste
    set background=dark
    vnoremap <silent> * :call VisualSelection('f')<CR>
    vnoremap <silent> # :call VisualSelection('b')<CR>

it will customize vim a bit, so it will be easier to edit files in it.

Journaling
^^^^^^^^^^

Journaling is one of the most important things you need to have. It just
record everything systemd does. It is part of ``systemd`` quite
customizable. We will save journals in memory, because of limited wear
of SD cards. We will also compress them and then limit size for them on
40 MB.

Open file ``/etc/system/journal.conf`` and set it as this:

::

    [Journal]
    Storage=volatile
    Compress=yes
    #Seal=yes
    #SplitMode=login
    #SyncIntervalSec=5m
    #RateLimitInterval=30s
    #RateLimitBurst=1000
    #SystemMaxUse=50M
    #SystemKeepFree=
    #SystemMaxFileSize=15M
    RuntimeMaxUse=40M
    #RuntimeKeepFree=
    #RuntimeMaxFileSize=
    #MaxRetentionSec=
    #MaxFileSec=1month
    #ForwardToSyslog=yes
    #ForwardToKMsg=no
    #ForwardToConsole=no
    #ForwardToWall=yes
    #TTYPath=/dev/console
    #MaxLevelStore=debug
    #MaxLevelSyslog=debug
    #MaxLevelKMsg=notice
    #MaxLevelConsole=info
    #MaxLevelWall=emerg

Network configuration
~~~~~~~~~~~~~~~~~~~~~

For reasons I will mention in future, we need to set RPi to connect with
**static ip**. This will assure that the IP address of RPi will be still
the same and you can connect it. Right now is probably getting
automatically assigned IP address from router (it's called **dhcp**).

We will use ``systemd-network``.

Type ``ip addr``. It should shows something like this:

::

    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default 
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
    2: ifb0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 32
        link/ether 22:2b:20:5b:8e:b0 brd ff:ff:ff:ff:ff:ff
    3: ifb1: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 32
        link/ether 6a:68:fb:64:2f:c3 brd ff:ff:ff:ff:ff:ff
    4: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether b8:27:eb:2d:25:18 brd ff:ff:ff:ff:ff:ff
        inet 192.168.0.201/24 brd 192.168.0.255 scope global eth0
           valid_lft forever preferred_lft forever

you are interested just in name **eth0**. If it is there, it is ok. In
future versions of system it can change to something other, for example
*eth0ps1*. Don't be afraid of it and just use that instead in next
chapters.

In this part you'll need to get address of your router. `How to obtain
it <http://compnetworking.about.com/od/workingwithipaddresses/f/getrouteripaddr.htm>`__?

And what is static address? Whatever you want. Almost. As you know your
router is assigning IP address automatically (it is called DHCP). But
not randomly in full range. It has some range of IP addresses which it
can assign. Standard is this: router has standard IP adress
``192.168.0.1`` and assign addresses from ``192.168.0.2`` to
``192.168.0.254``. Second standard is ``10.0.0.138`` for router and it
assignes addresses from ``10.0.0.139`` to ``10.0.0.254``. But it *can*
be anything else.

Interesting - and what the hell should you do that? I suggest to set one
the address on the end from this range. You can notice, that my "eth0"
has IP address ``192.168.0.201``.

Open this file ``/etc/systemd/network/ethernet_static.network`` (how?
just use ``vim`` as in the previous - but don't forgot to use ``sudo``
in front of ``vim``, or you'll not be able to save it!) and paste this:

::

    [Match]
    Name=eth0

    [Network]
    Address=the.static.address.rpi/24
    Gateway=your.router.ip.address
    a

my example:

::

    [Match]
    Name=eth0

    [Network]
    Address=192.168.0.201/24
    Gateway=192.168.0.1

now we need to try it - we don't to close us out. The connection is
right now ensuring by thing called ``netctl-ifplugd@eth0``. We want to
do this:

-  Turn ``netctl`` off
-  Turn ``networkd`` on
-  Try if RPi is connected to the internet
-  If yes, than do nothing - we can connect now by ssh
-  If not, turn off ``networkd`` and turn on working ``netctl``

why so complicated? Because when you are changing network, it will
disconnect - and of course, we will disconnected also from SSH. And it
discouraged to use more network managers at once, because they'd
interferate and you don't want that.

This script will do what we want:

::

    #!/usr/bin/bash
    systemctl stop netctl-ifplugd@eth0
    systemctl restart systemd-networkd

    sleep 10
    systemctl status systemd-networkd >> log.txt
    ping -c 1 google.com
    if [[ `echo $?` != 0     ]]
        then 
            systemctl stop systemd-networkd
            systemctl start netctl-ifplugd@eth0
    fi

to run this script you need to login as root. You can do it by typing
this: ``sudo -i``. This will log you as a root. Now type
``vim script.sh`` and insert script there. Save and close (in vim using
``:x``). Now just type ``chmod +x script.sh``. It will make the script
executable. Finally this: ``./script.sh``.

The connection will close now. Wait 30 seconds. If everything worked
properly, you should be able to connect to RPi again by using same ssh
command as previous. In that case find out it works -> does
systemd-networkd care about connection and netctl is stopped?

To find it out, type: ``systemctl status systemd-networkd``. Does it
shows "active (running)" and something like ``gained carrier``?

::

    â systemd-networkd.service - Network Service
       Loaded: loaded (/usr/lib/systemd/system/systemd-networkd.service; enabled)
       Active: active (running) since Wed 2014-06-11 18:42:13 CEST; 2 weeks 1 days ago
         Docs: man:systemd-networkd.service(8)
     Main PID: 213 (systemd-network)
       Status: "Processing requests..."
       CGroup: /system.slice/systemd-networkd.service
               ââ213 /usr/lib/systemd/systemd-networkd

    Jun 17 17:52:01 smecpi systemd-networkd[213]:             eth0: lost carrier
    Jun 17 17:52:02 smecpi systemd-networkd[213]:             eth0: gained carrier

If yes, great! We can get rid off netctl by uninstalling it by
``pacman -Rnsc netctl`` and enable ``networkd`` to start at boot by
``systemctl enable systemd-networkd``.

If not, ``netctl`` should be started again and save the day. Find it out
by ``systemctl status netctl-ifplugd@eth0``. It should be active,
otherwise there is some magic power which care about your connection.
Try to find out why ``networkd`` didn't workd and repair it (probably
bad IP address...). There should be some info in file ``log.txt``.

If you can't connect, don't panic. Just turn off RPi (take out power
suppy) and turn it on. It should reconnect normally with
``netctl-ifplugd``. Try to find out why it is not working and try it
again.

Timesynchronization
~~~~~~~~~~~~~~~~~~~

You've maybe noticed that time is quite weird on your RPi. It is beacuse
it does not have real hardware clock. Every time RPi is waken up, it
thinks that is June 1970. You don't have to care about it, but after
boot it would be fine that time is correctly set. You can do it by using
really great part of ``systemd``. Go ahead and enable service, which
takes care about that: ``systemctl enable systemd-timesyncd``. Thats
all. It will start after next reboot. If you want it to start now, just

Configuring SSH
~~~~~~~~~~~~~~~

We will open RPi to world and in that case we need to secure it a bit.
Service, which takes care about SSH is called ``sshd``. "Where" it is?
It is runned by systemd, so ``systemctl status sshd`` will show you some
info :). We will configure it a bit. This is not necessary, but highly
recommended! Brutal force attacks are really common (hundreds every day
on my little unimportant server).

Open file ``/etc/ssh/sshd_config`` and edit or add these lines as
follows:

::

    Port 1234
    PermitRootLogin no
    PubkeyAuthentication yes

that't enough. Restart sshd ``systemctl restart sshd``.

Since now, you cannot login as a root by ssh and thats good. Also - we
changed the port of ssh. Think about "port" as a tunnel, which is used
for ssh. There are about 60 thousands of them and you can choose
whatever you want. As default there is port **22** used for ssh. We now
changed that to (example) 1234. It is because on port 22 there is to big
chance that someone will try to brutal force your credentials.

Since now, only ``ssh bob@ipadress`` is not enough. You will have to add
port which should be used (in default is assumed port 22).
``ssh -p 1234 bob@ip.address`` will do it for you :) .

The next thing we are going to do is set up ``sshguard``. More about it
`here <https://wiki.archlinux.org/index.php/Sshguard>`__. You don't need
more :) . Just remember to use your port (in my case 1234) for settings.

It is anoying still typing same username and password when we want to
connect to RPi. And now, we have to add "-p 1234" also. We will make it
automatic. `Here <http://www.linuxproblem.org/art_9.html>`__ is quite
good guide how to do it. On PC from which you are connecting (no RPi),
edit ``~/.ssh/config`` to this:

::

    Host my_superpc
      HostName ipaddressofRPi
      IdentityFile /home/yourusername/.ssh/name_of_identityfile
      User bob
      port 1234

since now, when you wan't to connect to RPi you can just type
``ssh my_superpc`` and it will take care about rest.

**Screen** You can live without that, but you shouldn't! It makes you
more productive and you don't need to be afraid of some mishmash caused
by accidently closing terminal during update or lossing connection.
Learn more about what the screen is
(`here <http://www.tecmint.com/screen-command-examples-to-manage-linux-terminals/>`__,
`here <https://wiki.archlinux.org/index.php/GNU_Screen>`__ and
`here <http://www.thegeekstuff.com/2010/07/screen-command-examples/>`__),
install it (``pacman -S screen``), use it and love it.

It can be handy to automatically ssh into screen sesion. For that I use
this command (from PC I want to connect to RPi):

``ssh my_superpc -t screen -dRS "mainScreen"``. You can make some alias
to something shorter (for example adding this to
``alias ssh_connect_RPI="ssh my_superpc  -t screen -dRUS mainScreen"``
in .zshrc). Now all you need to do is type ``ssh_connect_RPI`` - it here
is now screen created, it will create new one. If it is, it will attach
it.

Speeding RPi up
~~~~~~~~~~~~~~~

Archlinux ARM for RPi is prepared to be tweaked. And now it is possible
to speed RPi up by overclocking it's processor without avoiding your
waranty. How to do it? Just edit file ``/boot/config.txt`` and find this
part:

::

    ##None
    arm_freq=700
    core_freq=250
    sdram_freq=400
    over_voltage=0

now comment it out. That means to add "**#**\ " in front of every line.
From now, it will be treated as text and not command. It will look like
this:

::

    ##None
    #arm_freq=700
    #core_freq=250
    #sdram_freq=400
    #over_voltage=0

and now uncoment this:

::

    ##Turbo
    arm_freq=1000
    core_freq=500
    sdram_freq=500
    over_voltage=6

After next boot your RPi will be able to get even to the 1000 MHz. That
means it is faster.

Other tweaks of /boot/config.txt
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Since you don't need any of gpu memory - which cares about shiny things
like windows etc., you can disable it in favor of the rest of memory
which we use.

::

    gpu_mem=16
    #gpu_mem_512=316
    #gpu_mem_256=128
    #cma_lwm=16
    #cma_hwm=32
    #cma_offline_start=16

Making RPi visible from outside
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Now we need to configure access from outside. You will need to configure
you router. You have to make a "port forwarding". Remember port from
ssh? I told you to think about them as a tunnels. These tunnels are also
handy when you need to find out what is on there end.

What we will do here is this: We want to be able from anywhere on the
internet connect to our RPi server.

Example? ``ssh -p 1234 bob@what.the.hell.is.here``. You know? There is
definetely not your local address (the one with 192.168...). There must
be your "public" IP address (more about this in **Domains** - take a
look there). But this public address points to your router (if you are
lucky). Where does it go next?

With every request there is also a port. With command ``ssh smt``, you
are sending username, port (standard 22, if not otherwise stated) and IP
address. Ip address redirect it to router. Now router takes **port** and
looks to it's internal database. In this database are pairs: **port** -
**internal\_ipaddress**. For some port there is IP address, which it
redirects to. In another worlds: if router gets some request from
specific port (say, 1234) and it has in it's database IP address

to which it has to redirect, it redirects this request there. In our
case, we need to redirect these ports we want (for example 1234 for ssh)
to RPi. So find a port forwarding settings for your router
(`this <http://portforward.com/>`__ might be helpful) and set there port
forward from port you setted for ssh to RPi. You can check if your port
is open (it means it accepts requests
`here <http://www.yougetsignal.com/tools/open-ports/>`__.

Since now, you can ssh from anywhere.

Webserver
~~~~~~~~~

Setting up nginx
~~~~~~~~~~~~~~~~

Similiar to ssh handling "sshish" requests, Nginx is handling almost
everything else and even... **WebServers**! Install nginx with
``pacman -S nginx``. For security reasons create special user for it,
for example using: ``useradd -m -G wheel -s /usr/bin/zsh nginx`` and
also group ``groupadd webdata``. Now create some folder for it. It can
be ``mkdir /var/www/`` and now make them owners
``chown nginx:webdata /var/www``. Of course, enable and start nginx.

``systemctl enable nginx``. It will start after boot.

Now port forward port number 80 to RPi on your router.

Open ``/etc/nginx/nginx.conf``, it can looks like this:

::

    user nginx;
    worker_processes  1;

    error_log  /var/log/nginx/error.log warn;

    events {
        worker_connections  1024;
    }

    http {
        include       mime.types;
        default_type  application/octet-stream;
        server_names_hash_bucket_size 64;

        sendfile        on;

        keepalive_timeout  15;

        server{
            listen  80;
            server_name ~^xxx.xxx.xxx.xxx(.*)$;
        
            location / {
                root   /var/www/$1;
                index  index.html index.htm;
            }
        }

    }

next, create ``/var/www/test/index.html``:

::

    <html>
      <head>
        <title>Sample "Hello, World" Application</title>
      </head>
      <body bgcolor=white>

        <table border="0" cellpadding="10">
          <tr>
            <td>
              <h1>Sample "Hello, World" Application</h1>
            </td>
          </tr>
        </table>

        <p>This is the home page for the HelloWorld Web application. </p>
        <p>To prove that they work, you can execute either of the following links:
        <ul>
          <li>To a <a href="/">JSP page</a>.
          <li>To a <a href="/">servlet</a>.
        </ul>

      </body>
    </html>

where xxx.xxx.xxx.xxx should be your public address. This will do this:
when you type in your browser "youripaddress/test:80", you should see
index Hello world example. Try that without ``:80`` - it will do the
same! Default port for webpages is **80** (similiar to 22 for SSH). So
it can be omited.

FTP
^^^

This will cover the most easy solution for FTP. Don't use this
configuration in real, just for test purpouses. If you didn't download
``vsftp``, do it now by ``pacman -S vsftp``. Now we will create some
directory where all files and users will end up after connecting. Let it
be in ``/var/www/test``. Now edit ``/etc/vsftpd.conf`` and add on the
top this line:

::

    anon_root=/var/www/test

and make sure that this line is uncommented:

::

    anonymous_enable=YES

and just start it: ``systemctl start vsftpd``.

Now we'll tell nginx about that. Add this to servers confs in
``/etc/nginx/nginx.conf``.

::

    server{
        listen  80;
        server_name ~^123.123.32.13(.*)$;
        location / {
            ssi on;
            root   /var/www/$1;
            index  index.html index.htm;
        }
    }

where you need to replace IP address in ``server_name`` directive to
your public IP.

What this little configuration does? It's simple. Every time you type to
your brower your IP address and somthing behind it, it will transfer you
to this "something" in /var/www/.

**Example** I created index.html here ``/var/www/example/index.html``. I
now type ``123.123.32.13/test`` to my browser and voila!

This nginx configuration isn't neccessary in our ftp example (it could
be simpler), but I just like it...

You can now connect to ftp by typing this in your browser:
``ftp://your_ip_address`` or use your favorite FTP client (e.g.
``filezilla``).

**CAUTION** - again, don't use this settings as default. There are great
guides on the internet how to grant access only some users, password
protected etc.

Domains
^^^^^^^

How does it happen, that someone type something.com and see some
webpages? Where this *something.com* come from?

A little background. On internet we have IP addresses to give every
computer it's specific name. Because we don't like these awfull numbers
(like 123.28.13.234), we have nicknames for them. For example - you
know, that when you type ``google.com``, you get to google page. But
that happens even you type: ``74.125.224.72``. In first example it do
this:

1. It takes name ``google.com``
2. Goes to world databank of IP addresses
3. Find out which IP address belongs to this name
4. Get you to this address

You can `buy <http://www.godaddy.com/>`__ your own domain and then
redirect it to your IP address. You have to buy it from them and then
add **AAA record**. Usually it is on there administration website. Then,
after few minutes, it is registered in this world databank.

It's not so easy. Not every one has it's own IP "public" address and
even worse, it can change! And that is not what you want - then you
should have had to change it every time your IP get changed. You have to
ask to you IPS (a company, which is offering you and internet) if you
address is "static" or "dynamic". My IPS (UPC CZ) told me that my is
"dynamic". But after a little research I found out that it means that my
IP address can "theoreticaly" change. In real, it is same for few years
now :) . It is relatively common, so maybe you are lucky.

If you don't want to buy "first level domains" (the one which are just
something.com) and second level is enough (like
something.somethingelse.com), then you can take a look [here]
(http://www.getfreedomain.name/).

System analyzing and cleaning
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use your friend ``systemd-analyze``. It will show you which units are
loading long time. Also ``systemctl status`` is great for finding failed
units.

Disable things that you dont need
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I guess you don't use ipv6 (if you don't know what it is, you don't need
it :D). ``systemctl disable ip6tables``. In case you use sshguard, you
need also edit file ``/cat /usr/lib/systemd/system/sshguard.service``
and from **Wants** delete ip6tables. Like this:

::

    Wants=iptables.service

Usefull utilites
----------------

Simple to use, just install them and run:

-  iftop - for internet usage
-  iotop - for disk usage

Torrents
~~~~~~~~

Your RPi is maybe running 24/7, so why not to use it for torrents? But
how, when there is no GUI? It's pretty simple. We will use transmission
- popular torrent client. Install it by ``pacman -S transmission-cli``
Installation should create a new user and group, called transmission. To
check that, you can take a look to ``/etc/passwd`` and ``/etc/group``.
``transmission`` will be runned by ``systemd``. Let's see it it's
service file is configured properly. Check
``/usr/lib/systemd/system/transmission.service``:

::

    [Unit]
    Description=Transmission BitTorrent Daemon
    After=network.target

    [Service]
    User=transmission
    Type=notify
    ExecStart=/usr/bin/transmission-daemon -f --log-error
    ExecReload=/bin/kill -s HUP $MAINPID

    [Install]
    WantedBy=multi-user.target

``User=transmission`` is important here (for security reasons). Next
thing we need to do is check, if transmission has place where it will
live. By default it is in ``/var/lib/transmission(-daemon)``. In this
dir should be also config file ``settings.json``. There lays
configuration for it.Edit it ass you wish. It is covered
`here <https://trac.transmissionbt.com/wiki/ConfigFiles>`__ and
`here <https://trac.transmissionbt.com/wiki/EditConfigFiles>`__. Maybe
you'll need to forward ports as we did in previous chapters, you should
make that again without problems :) . No we can run ``transmission``
daemon by ``systemctl start transmission``. Now you can give it commands
using transmission-remote . The most usefull (and that's all I need to
know and use :) ) are these:

-  ``transmission-remote <port> -a "magnetlink/url"`` - adds torrent and
   starts download it
-  ``transmission-remote <port> -l`` - list all torrents that are
   currently running

files should be stored in ``/var/lib/transmission/Downloads``. It can be
configured in config file :) .

Backups
-------

For backups I choosed ``rdiff-backup``. It's so stupid but works
(almost) as expected. More about it's usage you can find in it's manual
pages. For my example I'll redirect you to dir with configs in this
repo. These are inserted to ``cron`` (you have it by default installed)
to do SSH backup every day in 4AM. If I'm on local network I also do
backup to my disc on other PC.

Final
-----

That's all for now! I will see if this is used by someone and than I
will see if I will continue.

Troubleshooting
~~~~~~~~~~~~~~~

-  RPi don't boot - unplug everything from USB ports (there may be not
   enough of power to boot up and supply USB)

