Necessary knowledge
====================

Here I cover two things that I encourage to use during this guide.

Vim
---

We'll need text editor to configure everything and most of our time
we'll spend in command line. How to edit files inside terminal? There
are multiple console-based terminal. I chose one of them, which is
called `vim <http://en.wikipedia.org/wiki/Vim_(text_editor)>`_. We
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

Of course feel free to use other editor.

Systemd
--------

`systemd <http://en.wikipedia.org/wiki/Systemd>`_ is astonishingly
great and also astonishingly hated package, but that’s not necessary to
know now. Briefly - ``systemd`` cares about running processes in the
background. These are called daemons. For example in next chapter we
will use SSH - it will run at background. There is also package, which
takes care of automatically connect to internet (again in next
chapters).

``systemd`` is controlled by ``systemctl``. To start some program, which
is in this context called **service** (and we will stick to that), just
run ``systemctl start <unit>``. There are other useful (and that's 90%
of what you need to know about systemctl) commands (all starts with
``systemctl`` and ends with ``desired_unit`` - watch example):

-  enable - this allow to run service after boot (but it will not start
   immediately)
-  disable - this will make device not to start after boot
-  start - this will immediately start a service (but will not enable it
   - it won't be run after boot)
-  stop - stop service immediately (but not disable)
-  status - this will print out all information in pretty format - you
   can find if it is enabled, started, if **there are any errors** etc.

Example
*********

There is service, which takes care about connection to
network. We will cover it in special chapter for RPi, but we will just play with
that for a minute now. It's called ``systemd-networkd``. Try to start it,
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
