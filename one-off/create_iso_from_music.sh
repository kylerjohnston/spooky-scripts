#!/bin/bash
# A script to burn all the files in my ~/music directory to DVDs
# for archiving.
# The directories have all been tar'ed already.

DVD_CAPACITY=4103
CONTENTS=()
COUNTER=0

for filename in *.tar.gz; do
    if [[ ! -d ISODIR ]]; then
        mkdir ISODIR
    fi

    dirsize=`du -sm ISODIR | cut -f1 -s`
    filesize=`du -sm "$filename" | cut -f1 -s`
    let totalsize=$filesize+$dirsize

    if [ $totalsize -lt $DVD_CAPACITY ]; then
        echo "Adding $filename to ISO"
        cp "$filename" ISODIR
        CONTENTS+=("$filename")
    else
        ((COUNTER++))
        echo "💿 Writing image..."
        genisoimage -o disc-$COUNTER.iso ISODIR
        echo -e "* disc-$COUNTER" >> iso_log.org
        for ((i = 0; i < ${#CONTENTS[@]}; i++)); do
            echo -e '- "${CONTENTS[$i]}"' >> iso_log.org
        done
        rm -rf ISODIR/*
        echo "Adding $filename to ISO"
        cp "$filename" ISODIR
	    CONTENTS=("$filename")
    fi
done
