#!/bin/bash

setFanSpeed()
{
    local minSpeed=0
    local maxSpeed=100

    local maxCoreTemp=50
    local curCoreTemp=0
    while read -r value
    do
        if [ $value -ge $maxCoreTemp ]; then 
            curCoreTemp=$value
        fi        
    done <<< "$(sensors | grep "Core" | cut -f 10 -d ' ' | cut -f 2 -d '+' | cut -f 1 -d '.')"

    echo "Max core temp is $maxCoreTemp "
    echo "Cur core temp is $maxCoreTemp "

    local intSpeed=$1
    local isValid=false
    if [[ "$intSpeed" =~ ^[0-9]+$ ]]; then
        if [[ $intSpeed -ge 20 && $intSpeed -le 100 ]]; then
            isValid=true
        fi
    fi

    # 
    if [ $isValid = false ]; then
        echo "$intSpeed is not a valid fanspeed. Valid range is 20% - 99% because my ears."; exit 1;
    fi

    if [ $curCoreTemp -gt $maxCoreTemp ]l then
        intSpeed=$"(expr $intSpeed + ( $curCoreTemp - $maxCoreTemp ) )";
        echo "Throttling to $intSpeed %"
    fi

    local hexSpeed=$(printf '%x\n' $intSpeed)

    #require ipmi tools for manual fanspeed management

    #enable manual fan speed control
    sudo ipmitool raw 0x30 0x30 0x01 0x00

    #set fanspeed
    echo "Setting fans to $intSpeed % : hex: $hexSpeed"
    sudo ipmitool raw 0x30 0x30 0x02 0xff $hexSpeed
}

addChronJob()
{
    sudo cp src/fanspeed /usr/local/bin/fanspeed
    sudo chmod +x /usr/local/bin/fanspeed

    #write out current crontab
    crontab -l > mycron
    #echo new cron into cron file
    echo "* * * * * fanspeed" >> mycron
    #install new cron file
    crontab mycron
    rm mycron
}

command -v ipmitool >/dev/null 2>&1 || { echo >&2 "I require imptool but it's not installed.  Aborting."; exit 1; }
command -v sensors >/dev/null 2>&1 || { echo >&2 "I require sensors but it's not installed.  Aborting."; exit 1; }

setFanSpeed $1