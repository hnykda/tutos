#!/usr/bin/bash

rdiff-backup --print-statistics --terminal-verbosity 3 \
    --exclude-globbing-filelist /root/scripts/bckp_excl.txt \
    /  hnykdan1@kmlinux.fjfi.cvut.cz::/home/hnykdan1/backups/rdiff/complet


rdiff-backup --remove-older-than 20B hnykdan1@kmlinux.fjfi.cvut.cz::/home/hnykdan1/backups/rdiff/complet
