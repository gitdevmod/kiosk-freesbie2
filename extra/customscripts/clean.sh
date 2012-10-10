#!/bin/sh

PRUNEDIRS="/usr/local/man /usr/local/share/doc /usr/local/include"
sum=0
for dir in ${PRUNEDIRS} ; do
	if [ -d $dir ] ; then
		size=$(du -sk $dir|awk '{print $1}')
		sum=$(($sum + $size))
		rm -fr $dir
	fi
done

sum_MB=$(($sum/1024))

echo "$sum_MB MB space saved"
