#!/bin/bash

# Defaut configuration
host="none"
app="Steam"
resolution="720"
fps="30"
mapping="mapping.map"
release="v1.2.2"

# Directory selection
cd /recalbox/share/roms/limelight/jar/
limelight_dir=$(dirname $PWD)

# Configuration file
if [ -f "${limelight_dir}/limelight.conf" ]; then
    . "${limelight_dir}/limelight.conf";
fi

# Check configuration
if [ $resolution = "720" ]; then resolution="720"; else resolution="1080"; fi
if [ $fps = "30" ]; then fps="30"; else fps="60"; fi

# Check java
java="${limelight_dir}/java/bin/java"
if [ ! -f $java ]; then
    echo "You need to download JDK 8 for ARM and extract content of jdk* folder in $(dirname $(dirname ${java}))"
    exit
fi

# Check limelight jar
limelight="${PWD}/limelight.jar"
if [[ ! -f $limelight && $1 != "update" ]]; then
    echo "You need to download Limelight Embedded with './Limelight.sh update'"
    exit
fi

# commande
cmd="${java} -jar ${limelight}"

case $1 in
    update)
        rm libopus.so
        rm limelight.jar
        cmd="wget https://github.com/irtimmer/limelight-embedded/releases/download/${release}/libopus.so"
        cmd="${cmd} && wget https://github.com/irtimmer/limelight-embedded/releases/download/${release}/limelight.jar" ;;

    pair)
        cmd="${cmd} pair ${host}" ;;

    map)
        cmd="${cmd} map -input $2 ${mapping}" ;;

    *)
        cmd="${cmd} stream -app ${app} -mapping ${mapping} -${resolution} -${fps}fps ${host}" ;;

esac

exec $cmd