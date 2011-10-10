#!/bin/bash

HOST=corpus
REMOTEDIR=BitTorrent/

inotifywait --format "%e %w%f" -e MOVED_TO -m download/ | while read event file;
do
    if [[ $event == "MOVED_TO" && "${file}" == *.torrent ]];
    then
	if scp "${file}" ${HOST}:${REMOTEDIR}
	then
	    rm "${file}"
	    echo "Moved ${file} to ${HOST}:${REMOTEDIR}" >> /var/log/torrentmove
	fi
    fi
done