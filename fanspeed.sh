#!/bin/bash

setFanSpeed()
{
    local minSpeed=0
    local maxSpeed=100

    local intSpeed=$1
    local isValid=false
    if [[ "$intSpeed" =~ ^[0-9]+$ ]]; then
        if [[ $intSpeed -ge 20 &&  $intSpeed -le 100 ]]; then
            isValid=true
        fi
    fi

    if ! [[ $isValid ]]; then
        echo "$intSpeed is not a valid fanspeed. Valid range is 20% - 99% because my ears."; exit 1;
    fi

    local hexSpeed=$(printf '%x\n' $hexSpeed)

    #require ipmi tools for manual fanspeed management
    command -v ipmitool >/dev/null 2>&1 || { echo >&2 "I require imptool but it's not installed.  Aborting."; exit 1; }

    #enable manual fan speed control
    sudo ipmitool raw 0x30 0x30 0x01 0x00

    #set fanspeed
    echo "Setting fans to $intSpeed % : $hexSpeed"
    sudo ipmitool raw 0x30 0x30 0x02 0xff $hexSpeed
}

setFanSpeed 85