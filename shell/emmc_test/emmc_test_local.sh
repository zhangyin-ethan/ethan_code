#!/system/bin/sh
##!/bin/bash
##  global variable ##
set -e


TIMES=1 
VERSION="V01--2016/08/11 by zhangyin_ethan@126.com"
echo -e "\n${VERSION}"

show_help()
{
	echo "usage: ./emmc_test.sh -f file_name -t times"
	echo "file_name: the file to be adb pushed"
	echo "times:  the times of reading & write"
}
##  void no parameter ##
if [ $# -ne  4 ]
then
	show_help
	exit 1
fi



## get the CODE_DIR value ##
while getopts "f:t:"  OPTION
do
	#echo "option --$OPTION"
	case $OPTION in
	"f")
		FILE=$OPTARG
		;;
	"t")
		TIMES=$OPTARG
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


if [ ! -f "$FILE" ]; then
	show_help
	exit 1
fi

TIMES=`expr $TIMES + 0`


#echo "check_sum:${check_sum}"

echo -e "file:$FILE"
echo -e "times:${TIMES}\n"


file_name=$(basename ${FILE})
file_dir=$(dirname ${FILE})

echo -e "$(date +%Y/%m/%d-%H:%M:%S)\n"



num=1;
check_sum=$(md5sum ${file_dir}/${file_name})

#for (mum=1; num<=${TIMES}; num++)
while [ ${num} -le ${TIMES} ]
do
	 cp ${file_dir}/${file_name}  ${file_dir}/${file_name}-temp
	 sync
	 rm ${file_dir}/${file_name}
	 mv ${file_dir}/${file_name}-temp  ${file_dir}/${file_name}
	 check_sum_temp=$(md5sum ${file_dir}/${file_name})
	 echo "times:${num},md5sum:$check_sum_temp"

 	 if [ "$check_sum_temp" != "$check_sum" ]; then
		echo "emmc_test times:${num}"
		echo "$(date +%Y/%m/%d-%H:%M:%S)"
		echo "emmm_test fail !!!!!!!"
		exit 1
	fi
	num=`expr ${num} + 1`
done

num=`expr ${num} - 1`
echo -e "\n$(date +%Y/%m/%d-%H:%M:%S)"
echo -e "\nemmc_test times:${num}"
echo -e "mmc_test success!!\n"


exit 0
