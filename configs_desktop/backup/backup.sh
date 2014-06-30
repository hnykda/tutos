#!/usr/bin/bash

rdiff-backup --print-statistics --terminal-verbosity 3 \
    --exclude-globbing-filelist /root/backup/backup.exclude \
    --include-globbing-filelist /root/backup/backup.include \
    / /media/extq/backup/sarch/

rdiff-backup --remove-older-than 10B /media/extq/backup/sarch

