# Making Raspberry Pi usable

After 3 months of using RPi, I decided to make this tutorial for same people as I'm - who looks for easy, understandable way to make RPi as awesome as possible.

In this tutorial I will walk you through whole process of making from Raspberry Pi secure, reliable, efficient, fast and easy to maintain server for variable purpouses as is FTP, web hosting, sharing... All that thanks to Archlinux ARM operating system. The device will be "headless" - it means, there will be no fancy windows etc., just command line. Don't be scared, I will walk you through and you'll thank me then :) . You don't need some special knowledge about computers and linux systems. 

## Some notes before you start
* When I feel that some topic is covered solidly somewhere else, I will redirect you there.So thing about this also as summary of materials.
* On many place it is not only RPi-related
* You will have to learn some basics about unix systems - naturaly on the way
* Sometimes I'll simplify things. Feel free to find more info about that :) 

## What you get on when you succesfully finish
From "bare" RPi you'll get: 

* Safely to connect to your RPi from anywhere
* Possibility of hosting web pages, files, etc.
* Readable and reliable system (it will do what you want and nothing more)

## What you will need
* Raspberry Pi (doesn't matter which model) with power supply
* SD Card as a main hardisk for RPi
* SD Card reader on computer with internet access
* Ethernet LAN cable or USB wifi bundle
* Other computer (preferably with linux, but nevermind if you use Windows or Mac)
* Possibility to physically get to your router and know credentials to login to it (or have contact to your network administrator :) )
* Few hours of work 

## What you don't need
* Second monitor or ability to connect RPi to some monitor

## Start
So you have just bare RPi, SD card, power supply, ethernet cable (RJ-45). So let's start! There are houndreds of guides, but I haven't found them satisfaing. 

### Installing Archlinux ARM to SD card
Go (here)[http://archlinuxarm.org/platforms/armv6/raspberry-pi] and make first 3 steps.
That's it! You have done it. You have you Archlinux ARM SD card :)

### Little networking
I guess you probably have some of "home router" ("box with internet") and when you want to connect e.g by wifi with your laptop or mobile phone, it just connects (after inserting password). You need to test first what happens, when you try to connect by ethernet cable, for example with your laptop. Turn off wifi and check it. Did your computer connects to the network (or even internet) as usuall? If yes, it is great! You can procced. It is what we need - we need RPi, when it boots up, to automatically
connect to the network. Then we will able to connect to it. You will need one more think to find out - which IP address router asign to you when you connected by cable - it is very probable that RPi will get the same, or similiar. Don't be afraid - it is easy to get (IP address)[how to get ip address]. On modern systems, one command :) .

Ok, now you have to insert SD card to RPi and connect it to your router with ethernet cable and then turn RPi on by inserting power supply. The diodes starts flashing. Now back to your computer and we will try to connect it using **SSH**. SSH is just "magic power" which enables to connect from one to other computer. 

RPi is already ready and waits for connection. How to use ssh and some utilities (Linux, Mac) or programs (Windows) is supereasy - you will find a tons of tutorials
on google (keywords: how to use ssh). IP address is the probably the one you assigned before. It will be something like this: `192.168.0.x`, `10.0.0.14x` or similar. Next thing you need is username. It's just "root".

If your RPi haven't got this address (ssh is not working), than there are two options.
1. You will login to your router settings and find out list of all connected devices with IP addresses and try them.
2. Use `nmap` to find active devices in your network.

**Example**
You have this address assigned: `192.168.0.201`. Then you have to type (in linux): `ssh root@192.168.0.201`. 

You should end up in RPi console.

### First setup
This is covered over the internet, so I will just redirect you.
(elinux)[http://elinux.org/ArchLinux_Install_Guide] - from this guide finish these parts (in RPi console):
* Change root password
* Modify filesystem files
* Mount extra partitions (if you don't know what it is, nevermind)
* Update system
* Install Sudo
* Create regular user account

That's enough for now. Logout from ssh (type "exit") and connect again, but as user who was created. Similiar to previous: `ssh username@ip.address`. From now, you'll need to type "sudo" in front of every command, which is possibly danger. I will warn you in next chapter.

Reboot you rpi using `systemctl reboot`. You must be able to connect to it again after one minute. If not, somthing is wrong... In that case, you need to find out why connection stoped working - if you have keyboard and monitor, you can repair it. If not, you can try to edit mistake on other computer by inserting SD card. Otherwise, reinstall...

### Installing some sugar candy
For our purpouses we will install usefull things, which will help as maintaing the system.
So, run this:
`pacman -S vim zsh wget ranger htop lynx`
do you see: `error: you cannot perform this operation unless you are root.`? Then you need to type `sudo pacman -S ...`. I will not write it in future and it is not in other guides. So sometimes you might be confused.

we will also need these in next chapters:
`pacman -S nginx sshguard vsftpd`

You can notice that is really few packages! And thats true! Isn't it great? No needs of tons of crap in your device.

What are these? Just short summary - you can find more about it in manual pages (`man <name_of_pacakge>`) or find something usefull on the internet. 
* **vim** - powerfull text editor (that's what you will do 99% of time). First few *days* are horrible, but keep using it :) .
* **zsh** - doesn't matter. Just install it and install (this)[https://github.com/robbyrussell/oh-my-zsh]
* **wget** - just for downloading things without browser
* **ranger** - file manager (you can browse files, folders...)
* **htop** - task manager - you can see what tasks are running, how much CPU/MEM is used, kill processes and so on
* **lynx** - browser - no kidding :)

### Some configurations
I assume you installed `zsh` with `oh-my-zsh` (changed your shell) and also vim. You are connected as created user (from now, I will name him **bob**). You are in Bob's home directory - check it with typing `pwd`. It will print `/home/bob`. Edit .vimrc file:
`vim .vimrc` and insert this:

```
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
```
it will customize vim a bit, so it will be easier to edit files in it.

### Network configuration
For reasons I will mention in future, we need to set RPi to connect with **static ip**. This will assure that the IP address of RPi will be still the same and you can connect it. Right now is probably getting automatically assigned IP address from router. 
We will use `systemd-network`. `systemd` is astonishingly great and complex package, but thats not neccessary to know now. 

Type `ip addr`. It should shows something like this:
```
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
```
you are interested just in name **eth0**. If it is there, it is ok. In future versions of system it can change to something other, for example *eth0ps1*. Don't be afraid of it and just use that instead in next chapters.

In this part you'll need to get address of your router. (How to obtain it)[http://compnetworking.about.com/od/workingwithipaddresses/f/getrouteripaddr.htm]?

And what is static address? Whatever you want. Almost. As you know your router is assigning IP address automatically (it is called DHCP). But not randomly. It has some range of IP addresses which it can assign. Standard is this: router has standard IP adress `192.168.0.1` and assign addresses from `192.168.0.2` to `192.168.0.254`. Second standard is `10.0.0.138` for router and it assignes addresses from `10.0.0.139` to `10.0.0.254`. But it *can* be anything else. 
Interesting - and what the hell should you do that? I suggest to set one the address on the end from this range. You can notice, that my "eth0" has IP address `192.168.0.201`.

Open this file `/etc/systemd/network/ethernet_static.network` (how? just use `vim` as in the previous - but don't forgot to use `sudo` in front of `vim`!) and paste this:
```

[Match]
Name=eth0

[Network]
Address=the.static.address.rpi/24
Gateway=your.router.ip.address
```
my example:
```
[Match]
Name=eth0

[Network]
Address=192.168.0.201/24
Gateway=192.168.0.1
```
now we need to try it - we don't to close as out. The connection is right now ensuring by thing called `netctl-ifplugd@eth0`. We want to do this:

* Turn `netctl` off
* Turn `networkd` on
* Try if it is connected to the internet
* If yes, than do nothing - we can connect again
* If not, turn off `networkd` and turn on working `netctl`

why so complicated? Because when you are changing network, it will disconnect - and of course, we will disconnected also from SSH. This script will do what we want:

```
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
```
to run this script you need to login as root. You can do it by typing this: `sudo -i`. This will log you as a root. Now type `vim script.sh` and insert script there. Save and close (in vim using `:x`). Now just type `chmod +x script.sh`. It will make the script executable. Finally this: `./script.sh`.

The connection will close now. Wait 30 seconds. If everything worked properly, you should be able to connect to RPi again by using same ssh command as previous. 

If you can't connect. Don't panic. Just turn off RPi (take out power suppy) and turn it on. 

### Configuring SSH


### Speeding RPi up
Archlinux ARM for RPi is prepared to be tweaked. And now it is possible to speed RPi up by overclocking it's processor without avoiding your waranty. How to do it? 
