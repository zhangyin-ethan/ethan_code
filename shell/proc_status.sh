#! /bin/bash
while true 
do
echo "monitor time：`date '+%Y-%m-%d %H:%M:%S'`"
adb shell "cat /proc/1557/status"
adb shell "cat /proc/1624/status"
adb shell "cat /proc/1660/status"
sleep 5

done

exit 0
