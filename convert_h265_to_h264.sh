#!/bin/bash

convert_here()
{
	local n
	local a
	local b
	local c
	local tmp
	local filename
	
	tmp="convert.mp4"
	
	n=0
	
	find -type f -iname '*-video.mp4' | sort | while read filename; do
		a=`getfattr -n "user.converted" --only-values "$filename" 2>/dev/null`
		
		if [ "$a" == "1" ]; then
			continue
		fi
		
		b=`stat --format '%Y' "$filename"`
		c=`date +%s`
		
		if [ $((c - b)) -lt 30 ]; then
			echo "$filename: too recent, skipping."
		fi
		
		echo "$filename: converting..."
		
		nice -n 10 ffmpeg -nostdin -i $filename -vcodec h264 -b:v 3M -preset faster -y $tmp >convert.tmp 2>&1
		
		if [ $? != 0 ]; then
			echo "$filename: failed" >&2
			cat convert.tmp
			continue
		fi
		
		setfattr -n "user.converted" -v 1 $tmp
		
		mv $tmp $filename
		
		echo "$filename: successfully converted"
		
		n=$((n + 1))
		
		if [ $n -gt 10 ]; then
			break
		fi
	done
}

cd /var/cache/zoneminder/events/9 && convert_here

cd /var/cache/zoneminder/events/10 && convert_here
