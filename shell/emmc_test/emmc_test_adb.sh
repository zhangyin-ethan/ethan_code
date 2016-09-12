#!/bin/bash
##  global variable ##
set -e

DIR=""
FILE=""
NUM=10 
VERSION="V01--2016/08/11 by zhangyin_ethan@126.com"
echo -e "\n${VERSION}\n"

show_help()
{
	echo "usage: ./emmc_test.sh -f file_name -d dest_dir"
	echo "file_name: the file to be adb pushed"
	echo "dest_dir:  the file where to be pushed"
}
##  void no parameter ##
if [ $# -ne  4 ]
then
	show_help
	exit 1
fi

## get the CODE_DIR value ##
while getopts "f:d:"  OPTION
do
	#echo "option --$OPTION"
	case $OPTION in
	"f")
		FILE=$OPTARG
		;;
	"d")
		DIR=$OPTARG
		;;
	"?")
		show_help
		exit 1
		;;
	":")
		show_help
		exit 1
		;;
	*)
		echo "some error !!"
		exit 1
		;;
		
	esac	
done

#if [ ! -d "$CODE" ] || [ ! -d "$PLATFORM" ]
#then
#	echo "the code_dir or platfrom_dir is wrong!!"
#	exit 1
#fi

check_sum=$(md5sum ${FILE})
check_sum="$(echo ${check_sum} | sed 's/\(.*\) \(.*\)/\1/')"
#echo "check_sum:${check_sum}"

echo -e "file:$FILE"
echo -e "dir:${DIR}\n"


#FILE=$(readlink -f $FILE)

adb push ${FILE} ${DIR} 2>/dev/null
adb shell sync

echo -e "$(date +%Y/%m/%d-%H:%M:%S)\n"

file_name=$(basename ${FILE})
num=0;
for ((mum=0; num<${NUM}; num++))
do
	adb shell cp ${DIR}/${file_name}  ${DIR}/${file_name}_temp

	adb shell sync
	sleep 1	
	#adb shell "echo \"xxx\" >>  ${DIR}/${file_name}_temp"
	adb shell sync
	check_sum_temp=$(adb shell md5sum ${DIR}/${file_name}_temp)
	check_sum_temp="$(echo ${check_sum_temp} | sed 's/\(.*\) \(.*\)/\1/')"
	if [ ${check_sum_temp} != ${check_sum} ] ; then
		echo "emmc_test num:${num}"
		echo "$(date +%Y/%m/%d-%H:%M:%S)"
		echo "emmm_test fail !!!!!!!"
		exit 1
	fi
	adb shell rm ${DIR}/${file_name}_temp
	adb shell sync
done

echo -e "emmc_test num:${num}\n"
echo "$(date +%Y/%m/%d-%H:%M:%S)"
echo "emmc_test success!!"


exit 0
