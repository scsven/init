#!/bin/bash

function pushd() {
    command pushd "$@" > /dev/null
}

function popd() {
    command popd "$@" > /dev/null
}

function getfn() {
    filename=$(basename -- "$@")
    extension="${filename##*.}"
    filename="${filename%.*}"
	screen -dmS ${filename} $@
}

modify_time=`stat -c '%y' $HOME/init.ts | awk '{ print $1 " " $2 }'`
modify_time=$(date -d "$modify_time" +%s)

boot_time=`who -b | awk '{ print $3" "$4 }'`
boot_time=$(date -d "$boot_time" +%s)

if [ "${modify_time}" -gt "${boot_time}" ] ;
then
	echo "Inited."
	exit
fi

pushd init.d
for entry in ./*.sh
do
	echo "=========${entry}"
    getfn ${entry}
done
popd

touch $HOME/init.ts
screen -ls

