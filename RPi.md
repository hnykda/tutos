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
on google (keywords: how to use ssh). IP address is the one you 
