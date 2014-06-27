# Instaling Arch linux on laptop and how to make it usable

In this tutorial I'd like to cover all steps from installing Archlinux OS to stable, secure, and working system with working WiFi, windows manager (i3) etc.

## Instalation
There are tons of step-by-step guides how to install Arch so I will not go to deep here. Just look here: . Anyway, short summary:

### Primary installation
####Partitioning
You have to prepare disc(s) where you'll install Arch Linux. One disc can be separated to more partitions. I recommend you to use two partions for Arch Linux. One for system and second for user data (alias "home directory"). You can of course have one or more - as you wish. In this tutorial I will use 2 partition. It doesn't matter if there are next partitions with other systems (next Linux, Windows...).
How big paritions should be? I recommend you 40GB-50GB for system and rest for home.
The easiest way to partition is to use GParted. If you are using linux, you can download from your distribution and make it from there. Of course, you'll not be able to resize, create etc. partitions on disc which is currently used. In that case, or if you don't have linux, there is GParted life distribution - make a booting USB flash with that.
In GParted you have to create two partitions with previously stated sizes and format them to filesystem "ext4". Piece of cake. For convenience it's fine to label them also (when you create partition, you can add label).

There might be problem with your bios - it don't have to has booting from USB flash as default. You need to change an order of priority in your BIOS (the "thing" before operating systems boots up). Google is your friend :) .

#### Installing Arch
Now you have prepared disc for installation. Download last iso of archlinux and make a booting USB flash with that.
When you'll be done with that, insert USB flash to PC and run it. It should boot up to Archlinux prompt (terminal, console).
Now we need to connect to the internet. You can use command *`wifi-menu` or just plug in ethernet cable. To check if you are connect, try `ping google.com`. If you get response, it's working.
Now we need to join prepared partitions to currently running OS. Which are they? You can find it out by typing `lsblk`. There will be listed all partitions. You care about the two you partitioned earlier. You should recognize them thanks to the size.
If you are not sure, you'll find it out in a minute. In my case, there is /dev/sda5 for system (40GB) and /dev/sda6 for home. Of course it might differ from yours, so subtitute it to your case. Do
* `mount /dev/sda5 /mnt`
* check if it is empty `ls /mnt`. If you don't see anything (or there is only something like *lost+found*), it's our partition :). 
* Create directory for home `mkdir /mnt/home` 
* `mount /dev/sda6 /mnt/home`

Now we can physically install Archlinux. Type `pacstrap /mnt base` and waits. It will download and install packages.

#### Post install
Now we need to tell system which partition is system disc and which home partition. This will help us a little:
`gefstab ` 

Link some zoneinfo

TODO

#### Change root settings
Now we will change root to new system - from the current one, which is the USB one, we will magically get to the new. This magic will happen by command: `arch-chroot /mnt`. 

We need to install packages for conneting to the internet as we did on the start of installation. For that, we will need these packages (which are included on this USB version, but not on installation):
`pacman -S dialog wpa_actiond ifplugd wpa_suppicant sudo zsh` 
That should be sufficient for making wifi or wired connection in our new system, when we finish work from here. There are also two useful packages *sudo* and *zsh*. I will cover them in next paragraph.

In linux, there is always one user, which is equivalent to god. His name is "root". You are currently login as him. We will change a password for him. Type `passwd` and set new password. We also want to add regular user (think about it as a god who is creating humans). This can be done by:
`useradd -m -G wheel -s /usr/bin/zsh username`, where username is as you wish. I will use "bob" in next chapters as default user. There are also some other switches in command. `-m` is for creating bob's sandbox for his files and `-G` to add him to the wheel group.
Why? Remember installing sudo and mentioning root? It is better working as bob (being god all the time means a lot of responsibility), but sometimes has some superpowers as root has. Sudo will do it for as. `sudo` can grant you superusers privilegies. More about it here. Now the wheel group. Every user, who is in wheel group, will have this ability to use sudo. Type: `visudo` and find this line:
`# %wheel ALL=(ALL) ALL`
and delete # character (for future reference, this means to "uncomment line"). It will look like this ` %wheel ALL=(ALL) ALL`. Save and exit (in vim just press escape and `:x`).
Next switch in creating command was `-s /usr/bin/zsh`. This will just save your time in terminal (where you'll be a lot). Enough for now. We will make this also for root by `chsh -s /usr/bin/zsh`. 
Last thing - we need to set password for bob. Do it by typing `passwd bob`.

####Bootloader
We need to tell to your PC what systems are installed and add you the ability to choose between them (windows, linux(es)...). For that we will need one or two more packages `pacman -S grub`. If you have windows installed on other partitions, also install `pacman -S os-prober`.
When you boot your PC there is APROXIMATELY this sequence:
* BIOS - it then looks to the beginning of your disc for first part of GRUB
* GRUB first stage - if it is found, GRUB takes control and then looks for other files with more informations and pass control to GRUB second stage
* GRUB second stage - it gives you option to choose system you want to boot up and then kick it up
* OS will boot up
this is unprecise, but sufficient for our purpouses and to be honest, for 90% of what you need on *daily* baisis (personally, I don't know more than this :) ).
BIOS is installed from factory. So our work is to install GRUB stages. Resolve which disc you wan't to use - I recommend you to use the first one, which is usally called /dev/sda. If you have only one disc in PC, it is this one :) .
**CAUTION** - notice that I'm not speaking about partition, in which case I'd need to add number after sda. First stage of GRUB is somehow "partition" independent. Ok, now install it:
`grub-install --traget=i386-pc --recheck /dev/sda`
again - now number after sda. Of course, change **a** to your case.
Now we need to install second stage of GRUB. It will be to the current system partition, so run `grub-mkconfig -o /boot/grub/grub.cfg`.
Now you are ready to restart your PC. Do it by typing `shutdown now`, plug off USB flash and turn PC on again.
If everything went well, you should be in white-black window with names of available systems. Choose Arch, of course. If not, just boot again from USB flash, mount system partitions with already installed system, arch-chroot inside it  and try installing grub again or find what went wrong. Don't panic :). 

## Making system usable
### Login in
You should be looking to the Arch linux console with asking for username and password. You have two options now: sign in as bob or as a root. For now, I recommend you to join as a root because we will maintain the system for a while. But for future, always use regular user for common tasks and when you need root privilegies, use `sudo` command. So, username is `root` and password is the one you specified in the past. If you forgot it, you can again boot up from USB flash, arch chroot and
change it.

### Setting connection
We will setup simple connection manager, which will autoconnect to known wifi networks and autoconnect if you plug in a ethernet cable. If you'll want to connect to new yet unknown wifi network, you will use `wifi-menu`.
So now connect to internet using `wifi-menu`. Now we will enable networking daemon (things which runs silently on the background) to start after boot. For that we'll need how is your wifi or ethernet device inside your laptop called. We can find it by typing `ip addr`. Output should be similar to this:
```
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
```
you care about the two of them, which starts with `wlp...` and `enp...`. 
