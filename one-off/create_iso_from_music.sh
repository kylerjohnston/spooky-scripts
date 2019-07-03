#!/bin/bash
# A script to burn all the files in my ~/music directory to DVDs
# for archiving.
# The directories have all been tar'ed already.

DVD_CAPACITY=4813

function burn_it {
    genisoimage -o ISODIR.iso ISODIR
    echo "BURNING 🔥"
    wodim -eject -tao dev=/dev/sr0 -v -data ISODIR.iso && \
	rm ISODIR.is && 

for filename in *.tar.gz; do
    if [[ ! -d ISODIR ]]; then
	mkdir ISODIR
    fi
    dirsize=`du -sm ISODIR | cut -f1 -s`
    filesize=`du -sm $filename | cut -f1 -s`
    let totalsize=$filesize+$dirsize
    if [ $totalsize -lt $DVD_CAPACITY ]; then
	cp $filename ISODIR
    else
	genisoimage -o ISODIR.iso ISODIR
	echo "BURNING 🔥"
	wodim -eject -tao dev=/dev/sr0 -v -data ISODIR.iso
	if [ $? -eq 0 ]; then
	    rm ISODIR.iso
	    rm -rf ISODIR/*
	else
	    echo "Something went wrong... Waiting for input to continue..."
	    read p
	fi
	cp $filename ISODIR
	echo "Success! Press enter to continue."
	read p
    fi
done	
