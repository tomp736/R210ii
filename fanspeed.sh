#!bin/sh

#require ipmi tools for manual fanspeed management
command -v ipmitool >/dev/null 2>&1 || { echo >&2 "I require imptool but it's not installed.  Aborting."; exit 1; }

sudo ipmitool raw 0x30 0x30 0x01 0x00
sudo ipmitool raw 0x30 0x30 0x02 0xff 0x14