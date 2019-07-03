#!/bin/bash
# A script to burn all the files in my ~/music directory to DVDs
# for archiving.
# The directories have all been tar'ed already.

DVD_CAPACITY=4103
CONTENTS=()

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
	genisoimage -o ISODIR.iso ISODIR
	echo "BURNING 🔥"
	wodim -eject -tao dev=/dev/sr0 -v -data ISODIR.iso
	if [ $? -eq 0 ]; then
	    rm ISODIR.iso
	    rm -rf ISODIR/*
	    echo "Success! Wrote these to disk:"
	    for item in ${CONTENTS[@]}; do
		echo -e "\t$item"
		echo "$item" >> delete.txt
	    done
	    echo ""
	    echo "Waiting for input to continue."
	    read p
	else
	    echo "Something went wrong... Waiting for input to continue..."
	    read p
	fi
	echo "Adding $filename to ISO"
	cp "$filename" ISODIR
	CONTENTS=("$filename")
    fi
done	
