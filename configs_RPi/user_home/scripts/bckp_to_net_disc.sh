#!/usr/bin/bash

rdiff-backup --print-statistics --terminal-verbosity 3 \
    --exclude-globbing-filelist /root/scripts/bckp_excl.txt \
    /  dan@192.168.0.22::/media/extq/backup/rpi

rdiff-backup --remove-older-than 20B dan@192.168.0.22::/media/extq/backup/rpi

