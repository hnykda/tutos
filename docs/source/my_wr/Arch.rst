Instaling Arch linux on laptop and how to make it usable
========================================================

In this tutorial I'd like to cover all steps from installing Archlinux
OS to stable, secure, and working system with working WiFi, windows
manager (i3) etc.

All my current configs are in this repository. Feel free to inspire from
them (as I did from others).

Instalation
-----------

There are tons of step-by-step guides how to install Arch so I will not
go to deep here. Just look here: . Anyway, short summary:

Primary installation
~~~~~~~~~~~~~~~~~~~~

Partitioning
^^^^^^^^^^^^

You have to prepare disc(s) where you'll install Arch Linux. One disc
can be separated to more partitions. I recommend you to use two partions
for Arch Linux. One for system and second for user data (alias "home
directory"). You can of course have one or more - as you wish. In this
tutorial I will use 2 partition. It doesn't matter if there are next
partitions with other systems (next Linux, Windows...). How big
paritions should be? I recommend you 40GB-50GB for system and rest for
home. The easiest way to partition is to use GParted. If you are using
linux, you can download from your distribution and make it from there.
Of course, you'll not be able to resize, create etc. partitions on disc
which is currently used. In that case, or if you don't have linux, there
is GParted life distribution - make a booting USB flash with that. In
GParted you have to create two partitions with previously stated sizes
and format them to filesystem "ext4". Piece of cake. For convenience
it's fine to label them also (when you create partition, you can add
label).

There might be problem with your bios - it don't have to has booting
from USB flash as default. You need to change an order of priority in
your BIOS (the "thing" before operating systems boots up). Google is
your friend :) .

Installing Arch
^^^^^^^^^^^^^^^

Now you have prepared disc for installation. Download last iso of
archlinux and make a booting USB flash with that. When you'll be done
with that, insert USB flash to PC and run it. It should boot up to
Archlinux prompt (terminal, console). Now we need to connect to the
internet. You can use command *``wifi-menu`` or just plug in ethernet
cable. To check if you are connect, try ``ping google.com``. If you get
response, it's working. Now we need to join prepared partitions to
currently running OS. Which are they? You can find it out by typing
``lsblk``. There will be listed all partitions. You care about the two
you partitioned earlier. You should recognize them thanks to the size.
If you are not sure, you'll find it out in a minute. In my case, there
is /dev/sda5 for system (40GB) and /dev/sda6 for home. Of course it
might differ from yours, so subtitute it to your case. Do *
``mount /dev/sda5 /mnt`` \* check if it is empty ``ls /mnt``. If you
don't see anything (or there is only something like *lost+found*), it's
our partition :). \* Create directory for home ``mkdir /mnt/home`` \*
``mount /dev/sda6 /mnt/home``

Now we can physically install Archlinux. Type ``pacstrap /mnt base`` and
waits. It will download and install packages.

Post install
^^^^^^^^^^^^

Now we need to tell system which partition is system disc and which home
partition. This will help us a little: ``gefstab``

Link some zoneinfo

TODO

Change root settings
^^^^^^^^^^^^^^^^^^^^

Now we will change root to new system - from the current one, which is
the USB one, we will magically get to the new. This magic will happen by
command: ``arch-chroot /mnt``.

We need to install packages for conneting to the internet as we did on
the start of installation. For that, we will need these packages (which
are included on this USB version, but not on installation):
``pacman -S dialog wpa_actiond ifplugd wpa_suppicant sudo zsh`` That
should be sufficient for making wifi or wired connection in our new
system, when we finish work from here. There are also two useful
packages *sudo* and *zsh*. I will cover them in next paragraph.

In linux, there is always one user, which is equivalent to god. His name
is "root". You are currently login as him. We will change a password for
him. Type ``passwd`` and set new password. We also want to add regular
user (think about it as a god who is creating humans). This can be done
by: ``useradd -m -G wheel -s /usr/bin/zsh username``, where username is
as you wish. I will use "bob" in next chapters as default user. There
are also some other switches in command. ``-m`` is for creating bob's
sandbox for his files and ``-G`` to add him to the wheel group. Why?
Remember installing sudo and mentioning root? It is better working as
bob (being god all the time means a lot of responsibility), but
sometimes has some superpowers as root has. Sudo will do it for as.
``sudo`` can grant you superusers privilegies. More about it here. Now
the wheel group. Every user, who is in wheel group, will have this
ability to use sudo. Type: ``visudo`` and find this line:
``# %wheel ALL=(ALL) ALL`` and delete # character (for future reference,
this means to "uncomment line"). It will look like this
``%wheel ALL=(ALL) ALL``. Save and exit (in vim just press escape and
``:x``). Next switch in creating command was ``-s /usr/bin/zsh``. This
will just save your time in terminal (where you'll be a lot). Enough for
now. We will make this also for root by ``chsh -s /usr/bin/zsh``. Last
thing - we need to set password for bob. Do it by typing ``passwd bob``.

Bootloader
^^^^^^^^^^

We need to tell to your PC what systems are installed and add you the
ability to choose between them (windows, linux(es)...). For that we will
need one or two more packages ``pacman -S grub``. If you have windows
installed on other partitions, also install ``pacman -S os-prober``.
When you boot your PC there is APROXIMATELY this sequence: \* BIOS - it
then looks to the beginning of your disc for first part of GRUB \* GRUB
first stage - if it is found, GRUB takes control and then looks for
other files with more informations and pass control to GRUB second stage
\* GRUB second stage - it gives you option to choose system you want to
boot up and then kick it up \* OS will boot up this is unprecise, but
sufficient for our purpouses and to be honest, for 90% of what you need
on *daily* baisis (personally, I don't know more than this :) ). BIOS is
installed from factory. So our work is to install GRUB stages. Resolve
which disc you wan't to use - I recommend you to use the first one,
which is usally called /dev/sda. If you have only one disc in PC, it is
this one :) .

**CAUTION** - notice that I'm not speaking about partition, in which
case I'd need to add number after sda. First stage of GRUB is somehow
"partition" independent. Ok, now install it:
``grub-install --traget=i386-pc --recheck /dev/sda`` again - now number
after sda. Of course, change **a** to your case. Now we need to install
second stage of GRUB. It will be to the current system partition, so run
``grub-mkconfig -o /boot/grub/grub.cfg``. Now you are ready to restart
your PC. Do it by typing ``shutdown now``, plug off USB flash and turn
PC on again. If everything went well, you should be in white-black
window with names of available systems. Choose Arch, of course. If not,
just boot again from USB flash, mount system partitions with already
installed system, arch-chroot inside it and try installing grub again or
find what went wrong. Don't panic :).

Making system usable
--------------------

Login in
~~~~~~~~

You should be looking to the Arch linux console with asking for username
and password. You have two options now: sign in as bob or as a root. For
now, I recommend you to join as a root because we will maintain the
system for a while. But for future, always use regular user for common
tasks and when you need root privilegies, use ``sudo`` command. So,
username is ``root`` and password is the one you specified in the past.
If you forgot it, you can again boot up from USB flash, arch chroot and
change it.

Setting connection
~~~~~~~~~~~~~~~~~~

We will setup simple connection manager, which will autoconnect to known
wifi networks and autoconnect if you plug in a ethernet cable. If you'll
want to connect to new yet unknown wifi network, you will use
``wifi-menu``.

So now connect to internet using ``wifi-menu``. Now we will enable
networking daemon (things which runs silently on the background) to
start after boot. For that we'll need how is your wifi or ethernet
device inside your laptop called. We can find it by typing ``ip addr``.
Output should be similar to this:

::

    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default 
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host 
           valid_lft forever preferred_lft forever
    2: enp2s0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN group default qlen 1000
        link/ether e8:03:9a:97:b5:a7 brd ff:ff:ff:ff:ff:ff
    3: wlp1s0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN group default qlen 1000
        link/ether 88:53:2e:c1:e4:d1 brd ff:ff:ff:ff:ff:ff

you care about the two of them, which starts with ``wlp...`` and
``enp...``. Let's say it's ``enp2s0`` and ``wlp3s0``.

Now we are ready to start autoconnect to known networks. Let's do that
by ``systemctl enable netctl-auto@wlp3s0`` and
``systemctl enable netctl-ifplugd@enp2s0``. That's it. Now, if you wan't
to connect to unknown wifi, just type (needs root) ``wifi-menu`` and
when you want cable connection, just plug it in :) .

Graphic enviroment
~~~~~~~~~~~~~~~~~~

Installing i3
^^^^^^^^^^^^^

As I sad before, we are going to use `I3 <http://i3wm.org/>`__. Take a
look at there webpage and guide. For make it run we will need to install
these ``pacman -S i3 dmenu xorg xorg-xinit``. It might ask you about
some choices - just install anything. It isn't necessary to have all
crap from Xorg, but to figure out which is and which isn't needed is
just pain (`wayland <http://wayland.freedesktop.org/>`__ should solve
this in near future). If it asks you about installing i3-status, approve
it. Xorg is used for all advance displaing in linux. i3 needs it also.
When you run a graphic enviroment anywhere on linux, it means that Xorg
is runned and than there might be some windows managers etc. So now we
just tell Xorg to run i3 after it's start. To do that, we will edit this
file: ``vim ~/.xinitrc`` to this:

::

    #! /bin/bash
    exec i3

this should be sufficient. Since now, you can start i3 by typing
``startx`` (try it :) ). To quit from i3 back to console press
Windows+Shift+E or Ctrl+Alt+Del. How to actually use i3 we will cover in
next part.

We'd like to start i3 (``startx``) after logging in after boot. Open
file ``/etc/profile`` and add there this:

::

    # autostart systemd default session on tty1
    if [[ "$(tty)" == '/dev/tty1' ]]; then
        exec startx
    fi

What this does? Next time you reboot your computer and you log in with
your username and password, i3 will start :) . If you don't want to
start i3 and you just need console (or i3 is broken), you can just
change `tty <http://www.ehow.com/how_7765949_switch-tty.html>`__. Linux
has by default 7 of them. In majority of distributions with DE (desktop
enviroment) Xorg is running on seventh tty. In our case it will be the
first one.

Configuring i3 status bar
^^^^^^^^^^^^^^^^^^^^^^^^^

i3status bar is just what is is - status bar. After install you need to
edit it a bit. It's located in ``~/.i3status``. Usually it is necessary
to adjust these: **battery** You have to find out **number\* of your
battery. Type ``ls /sys/class/power_supply``. It should show something
like ``ADP1 BAT1``. Number after ``BAT`` is you lucky number. Usually
it's 1 or 0. **wireless and ethernet device name** Here you need to
replace ``wlan0`` and ``eth0`` with ones you have. To find it out again
type ``ip addr``. There should be something like ``wlp1s0`` and
``enp2s0`` (on older distros there is still wlan0 or eth0 - in that case
keep it as is :) ) .

Installing terminal
^^^^^^^^^^^^^^^^^^^

My choice of terminal with i3 is
`urxvt <https://wiki.archlinux.org/index.php/rxvt-unicode>`__. Let's
install it: ``pacman -S rxvt-unicode rxvt-unicode-terminfo``.
``terminfo`` is just for some compatibility issues with sshing and
screen.

Now configure it by opening ``~/.Xdefaults``. Add this:

::

    ! urxvt

    URxvt*geometry:                115x40
    !URxvt*font: xft:Liberation Mono:pixelsize=14:antialias=false:hinting=true
    URxvt*font: xft:Inconsolata:pixelsize=17:antialias=true:hinting=true
    URxvt*boldFont: xft:Inconsolata:bold:pixelsize=17:antialias=false:hinting=true
    !URxvt*boldFont: xft:Liberation Mono:bold:pixelsize=14:antialias=false:hinting=true
    URxvt*depth:                24
    URxvt*borderless: 1
    URxvt*scrollBar:            false
    URxvt*saveLines:  2000
    URxvt.transparent:      true
    URxvt*.shading: 10

    ! Meta modifier for keybindings
    !URxvt.modifier: super

    !! perl extensions
    URxvt.perl-ext:             default,url-select,clipboard

    ! url-select (part of urxvt-perls package)
    URxvt.keysym.M-u:           perl:url-select:select_next
    URxvt.url-select.autocopy:  true
    URxvt.url-select.button:    2
    URxvt.url-select.launcher:  chromium
    URxvt.url-select.underline: true

    ! Nastavuje kopirovani
    URxvt.keysym.Shift-Control-V: perl:clipboard:paste
    URxvt.keysym.Shift-Control-C:   perl:clipboard:copy

    ! disable the stupid ctrl+shift 'feature'
    URxvt.iso14755: false
    URxvt.iso14755_52: false

    !urxvt color scheme:

    URxvt*background: #2B2B2B
    URxvt*foreground: #DEDEDE

    URxvt*colorUL: #86a2b0

    ! black
    URxvt*color0  : #2E3436
    URxvt*color8  : #555753
    ! red
    URxvt*color1  : #CC0000
    URxvt*color9  : #EF2929
    ! green
    URxvt*color2  : #4E9A06
    URxvt*color10 : #8AE234
    ! yellow
    URxvt*color3  : #C4A000
    URxvt*color11 : #FCE94F
    ! blue
    URxvt*color4  : #3465A4
    URxvt*color12 : #729FCF
    ! magenta
    URxvt*color5  : #75507B
    URxvt*color13 : #AD7FA8
    ! cyan
    URxvt*color6  : #06989A
    URxvt*color14 : #34E2E2
    ! white
    URxvt*color7  : #D3D7CF
    URxvt*color15 : #EEEEEC

now you have nice looking terminal for i3. You can start i3 by
``startx`` and press ``Windows+d`` to open something like **run promt**.
There you can type program you'd like to run and press entre. Open urxvt
for now :) .

Install yaourt and AUR
^^^^^^^^^^^^^^^^^^^^^^

Archlinux has several `official
repositories <https://wiki.archlinux.org/index.php/The_Arch_Linux_Repositories>`__
and also unofficial `AUR <https://wiki.archlinux.org/index.php/AUR>`__.
It's not trivial to install packages from there and there are helpers
for that, such as ``yaourt``, which is equivalent to pacman for oficial
repos.

In AUR are usefull packages as Oracle Java implementation, proprietary
software, software which is used rarely etc.

To install yaourt do this: \* ``pacman -S base-devel wget`` \*
``wget https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz``
\* ``wget https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz``
\* ``tar xvf package-query.tar.gz`` \* ``cd package-query`` \*
``makepkg -s`` \* ``pacman -U package-query*`` \*
``tar xvf yaourt.tar.gz`` \* ``cd yaourt`` \* ``makepkg -s`` \*
``pacman -U yaourt*``

That's it. We have installed ``yaourt`` and ``package-query`` from AUR
and you see that it is not hard, but seems a bit...

...ehh - long. Now, to install something from AUR, for example
``copy-agent``, just type: ``yaourt -S copy-agent``. It will do all this
for you :) . Why this is not allowed by default? It might be danger to
install something from AUR, since everyone can add there something. So
be aware of that!

Some other usefull packages to make system usefull
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Office suite** My choice of office suite (alternative to MS Office) is
Libre office.
``pacman -S libreoffice-writer libreoffice-calc libreoffice-impress``.
(I will not type ``pacman -S`` since now when I'll talk about
installing) **PDF viewer** I like lightweigt and fast viewer called
``zathura``. Install ``zathura zathura-pdf-poppler`` **Text editor**
Even I use ``vim`` for 90% of my work, sometimes is usefull to has
simple graphic text editor. I'd recommend ``geany``. **Partitioning**
Just ``gparted``. Great tool. **FTP client** ``filezilla`` **Graphics**
For low level use ``imagemagick``. For something *normal* use
``gpicview``. Instead of photoshop use ``gimp``. **Analyzing processes
etc.** \* ``htop`` - processes \* ``iotop`` - writes to disk **LaTex**
All you in most cases need is ``texlive-core``. The rest is optional and
install it only if you need it.

For editor I'd recommend ``texmaker`` for beginners and ``texworks`` for
the rest.

**tree** Try it in terminal :) . Show structure of current folder. To
limit *level* type ``tree -L <n>``. **torrents** ``transmission-gtk``

**Console-based browser** ``lynx`` - it can be handy when you need
web-browser and can't run graphical enviroment. **Console based file
manager** ``ranger`` - vim like bindings, tabs, written in python and
fast file manager? YES! **media player** ``vlc`` should be sufficient.

Fonts
^^^^^

Install ``ttf-dejavu ttf-inconsolata``.

Nice look of GTK2 apps
^^^^^^^^^^^^^^^^^^^^^^

You maybe noticed that apps looks bit awfull. For configuration like
this exists great tool called ``lxappearance``. Install also simple
greybird theme from AUR - so we'll need to use yaourt:
``yaourt -S xfce-theme-greybird``.

Now just open ``lxappearance`` (by typing ``Win+d`` and
``lxappearance``) and set greybird as default theme.

Multiple monitors
~~~~~~~~~~~~~~~~~

arandr (xrandr)
^^^^^^^^^^^^^^^

For multiple monitor configuration I love app called ``arandr``. Install
it :) . Now just run it and you should be able to configure layouts,
positions, resolutions etc. as you wish. You can even save your layout.

``arandr`` is just a frontend gui for ``xrandr``. It means that
*clicking with mouse* is converted into shell command, which is send to
``xrandr``. Command for setting HDMI1 connected monitor to right next to
notebook monitor is as follows:
``xrandr --output HDMI1 --right-of LVDS1 --preferred --primary --output LVDS1 --preferred``.
This knowledge will be usefull in next chapter.

Automatically detect (dis)connected monitor and change layout
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There is **low level** thing called ``udev`` which cares about
everything what you connect to your PC. We will tell it to run a script,
which has script for ``xrandr``.

Create this file ``/etc/udev/rules.d/95-monitor-hotplug.rules`` and add
this:

::

    #Rule for executing commands when an external screen is plugged in.
    KERNEL=="card0", SUBSYSTEM=="drm", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/dan/.Xauthority", RUN+="/usr/local/bin/hotplug_monitor.sh"

Now we need create ``/usr/local/bin/hotplug_monitor.sh`` with this
content:

::

    #! /usr/bin/bash
    # Sets right perspective when monitor is plugged in
    # Needed by udev rule /etc/udev/rules.d/95-hotplug-monitor
    export DISPLAY=:0
    export XAUTHORITY=/home/USERNAME/.Xauthority

    function connect(){
        xrandr --output HDMI1 --right-of LVDS1 --preferred --primary --output LVDS1 --preferred 
    }
      
    function disconnect(){
          xrandr --output HDMI1 --off
    }
       
    xrandr | grep "HDMI1 connected" &> /dev/null && connect || disconnect

**CAUTION** This script is set for my layout, where LVDS1 is my laptop
display and second monitor is connected by HDM1 (and is on the right of
LVDS). You need to adjust it to your case.

If you connect your monitor before boot, there might not be "change"
which would cause this script to run. To solve it add this line in front
of ``exec i3`` to ``~/.xinitrc``.

::

    /usr/local/bin/hotplug_monitor.sh &

Bluetooth
^^^^^^^^^

Use ``bluez`` and ``bluez-utils``. Configuration and usage is on the
Arch wiki. But be aware of the fact that ``bluez`` and generally
bluetooth on linux is TERRIBLY document. ``bluez`` hasn't it's own
documentation and all you can get is old mailing list. UAAAAA!!!

Some other tunnies
^^^^^^^^^^^^^^^^^^

**Nicer look of Java aplications and colors in manual pages and less**
open ``.zshenv`` and add:

::

    export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'
    export EDITOR=/usr/bin/vim

    # Coloring less command
    export LESS=-R
    export LESS_TERMCAP_me=$(printf '\e[0m')
    export LESS_TERMCAP_se=$(printf '\e[0m')
    export LESS_TERMCAP_ue=$(printf '\e[0m')
    export LESS_TERMCAP_mb=$(printf '\e[1;32m')
    export LESS_TERMCAP_md=$(printf '\e[1;34m')
    export LESS_TERMCAP_us=$(printf '\e[1;32m')
    export LESS_TERMCAP_so=$(printf '\e[1;44;1m')

**bash/zsh competition** Maybe you've find out that if you type start of
some command, zsh will help you to finish it if you hit **TAB** key.
It's not supported for all commands, so add it at least for some of
them. Install ``vim-systemd``.

Automounting discs, mounting and umounting as normal user
---------------------------------------------------------

We will use ``devmon``, which is part of ``udevil`` package. Add this
line to ``~/.i3/config``:

::

    exec --no-startup-id "devmon --no-gui"

this will run this daemon which will take care about it for us.

To unmount most recently mounted disc type ``devmon -c``. To umount all
removable devices type ``devmon -r``. To mount connected disc type
``devmon --mount /dev/sdb1`` (change of course ``sdb1``. Use
``devmon -h`` for help.

Writing to NTFS discs
~~~~~~~~~~~~~~~~~~~~~

To have possibility to write to NTFS formated drives is good to install
``ntfs-3g``. Next on Arch wiki :) .

Power control and power consumption
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For laptops there is great tool called
`tlp <https://wiki.archlinux.org/index.php/TLP>`__. ``powertop`` can be
also handy, but don't trust it too much...

Backups
~~~~~~~

TODO - same as RPI

Sound
~~~~~

To allow sound, install
``alsa-firmware alsa-utils alsa-plugins pulseaudio-alsa pulseaudio``. It
usually works out of the box, but is necessary run pulseaudio. Add this
to ``~/.i3/config``: ``exec --no-startup-id "pulseaudio --start``

For graphical control of sound use ``pavucontrol``.

For displaying current volume on i3status, add this to ``~/.i3status``:

::

    order += "volume master"
    ...
    ...
    ...

    volume master {
            format = "V: %volume"
            device = "default"
            mixer = "Master"
            mixer_idx = 0
    }

Using spare memory for browser cache
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you have spare memory (RAM), it's bad :D . Use it for something. It's
a pitty it isn't used for something useful - like adding cache from
browser to it.

What does it mean? Broswer are storing tons of data to *cache* for
faster loading next time. It's waering out the disc (to much writes) and
it's slow. To do this, follow these links:
`chromium <https://wiki.archlinux.org/index.php/Chromium_tweaks#Cache_in_tmpfs>`__
`firefox <https://wiki.archlinux.org/index.php/Firefox_Ramdisk>`__
