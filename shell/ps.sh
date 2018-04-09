#! /bin/bash
while true 
do
echo "ps monitor time：`date '+%Y-%m-%d %H:%M:%S'`"
adb shell "ps"
sleep 5

done

exit 0
