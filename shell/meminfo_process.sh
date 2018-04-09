#! /bin/bash
while true 
do
echo "monitor time：`date '+%Y-%m-%d %H:%M:%S'`"
adb shell "dumpsys meminfo 1557"
adb shell "dumpsys meminfo 1624"
adb shell "dumpsys meminfo 1660"
sleep 5

done

exit 0
