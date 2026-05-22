#!/bin/bash
#reports the laptop lid state
grep -q closed /proc/acpi/button/lid/LID/state
if [ $? = 0 ]
then
   grep -q 0 /sys/class/power_supply/AC/online
   if [ $? = 0 ]
   then
      pm-suspend
   fi
fi

