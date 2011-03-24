#!/bin/sh

for target in /home/backups/targets/*; do
    /usr/bin/rdiff-backup --include-globbing-filelist=${target} --exclude '**' jaskorpe@${target##*/}::/ ${target%targets*}${target##*/}/
done