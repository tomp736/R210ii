#!/bin/bash

setFanSpeed()
{
    local intSpeed = 85
    local hexSpeed = $(printf '%x\n' $hexSpeed)

    #require ipmi tools for manual fanspeed management
    command -v ipmitool >/dev/null 2>&1 || { echo >&2 "I require imptool but it's not installed.  Aborting."; exit 1; }

    #enable manual fan speed control
    # sudo ipmitool raw 0x30 0x30 0x01 0x00

    #set fanspeed
    echo "Setting fans to $intSpeed %"
    # sudo ipmitool raw 0x30 0x30 0x02 0xff $hexSpeed
}

setFanSpeed()

#  % = HEX
# 10 = A
# 20 = 14
# 30 = 1E
# 40 = 28
# 50 = 32
# 60 = 3C
# 70 = 46