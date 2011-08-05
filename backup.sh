#!/bin/sh

# This script uses files in directory "targets" for host and directory
# information. It stores the backup in directory "storage".  The
# hostname is taken from the filename, and the "target files" must
# contain the directory that will be backed up. Use ** for wildcard.
#
# /home/jaskorpe/public_git/**
#
# The above line in a file called "targets/facies.mindmutation.net
# will back up everything in that directory on that host, recursively.

backup_target ()
{
    target=$1
    /usr/bin/rdiff-backup --include-globbing-filelist=${target} --exclude '**' jaskorpe@${target##*/}::/ ${target%targets*}storage/${target##*/}/
    if [ $? -eq 0 ]; then
	echo "${target##*/} backed up" >> /var/log/backup
    else
	echo "Problem backing up ${target##*/}" >> /var/log/backup
    fi
}

backup ()
{
    echo "Starting backup: $(date)" >> /var/log/backup
    for target in /home/backups/targets/*; do
	backup_target $target
    done
    echo "Nightly backup finished: $(date)" >> /var/log/backup
}

mirror ()
{
    RSYNC=/usr/bin/rsync
    REMOTE_DEST=/var/backups/jaskorpe/
    REMOTE_HOST=facies.mindmutation.net

    echo "Starting remote sync: $(date)" >> /var/log/backup
    for target in /home/backups/targets/*; do
	rsync -av --delete-after --rsh="ssh -l jaskorpe" storage/${target##*/} ${REMOTE_HOST}:${REMOTE_DEST}
	if [ $? -eq 0 ]; then
	    echo "${target##*/} synced" >> /var/log/backup
	else
	    echo "Problem syncing ${target##*/}" >> /var/log/backup
	fi
    done
    echo "Nightly remote sync finished: $(date)" >> /var/log/backup

}

case "$1" in
    "backup" )
	backup
	;;
    "mirror" )
	mirror
	;;
    * )
	backup
	mirror
	;;
esac