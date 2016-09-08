#!/bin/bash
##  global variable ##
START_DATE="2016-7-9"
END_DATE="2016-7-20"
VERSION="V01--2016/07/28 by zhangyin_ethan@126.com"
echo -e "\n${VERSION}\n"
show_help()
{
	echo "usage: ./git_file_generate.sh -c code_dir -p platform_dir"
	echo "code_dir: the top dir of lichee, android...etc"
	echo "platform_dir: the templete & handle result dir"
}
##  void no parameter ##
if [ $# -ne  4 ]
then
	show_help
	exit 1
fi

## get the CODE_DIR value ##
while getopts "c:p:"  OPTION
do
	#echo "option --$OPTION"
	case $OPTION in
	"c")
		CODE=$OPTARG
		;;
	"p")
		PLATFORM=$OPTARG
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

if [ ! -d "$CODE" ] || [ ! -d "$PLATFORM" ]
then
	echo "the code_dir or platfrom_dir is wrong!!"
	exit 1
fi
CODE=$(readlink -f $CODE)
PLATFORM=$(readlink -f $PLATFORM)
echo -e "code:$CODE"
echo -e "platform:$PLATFORM\n"

## get the code repo_list ##
#echo "get the repo_list ..."
for dir in $(ls $PLATFORM)
do

	## delete some files ##
	cd ${PLATFORM}/${dir}
	rm $(ls | grep -v file.ignore)
	
	## get the code repo_list ##
	echo "dir:${CODE}/${dir}"
	cd ${CODE}/${dir}
	repo list > ${PLATFORM}/${dir}/repo_list
	sed -i 's/\(.*\) :\(.*\)/\1/'  ${PLATFORM}/${dir}/repo_list

	echo "generated->${PLATFORM}/${dir}/repo_list"

	## get the change or add file ##
	for name in $(cat "${PLATFORM}/${dir}/repo_list")
	do
		TEMP=git_log.tmp
		cd  ${CODE}/${dir}/${name}
		git log --name-status  --since=${START_DATE}  --before={END_DATE} >  ${PLATFORM}/${dir}/${TEMP}
		dir_tmp=$(echo $dir | sed 's/\//\\\//g')
		dir_tmp="$(echo $dir_tmp | sed 's/\./\\\./g')"
		name_tmp=$(echo $name | sed 's/\//\\\//g')
		name_tmp="$(echo $name_tmp | sed 's/\./\\\./g')"

		if [ -s ${PLATFORM}/${dir}/${TEMP} ]; then
			sed -n "s/^[M,A]\t\(.*\)/${dir_tmp}\/${name_tmp}\/\1/p"  "${PLATFORM}/${dir}/${TEMP}"  >> ${PLATFORM}/${dir}/git_log_files
		fi
		rm  ${PLATFORM}/${dir}/${TEMP}
	done
	echo "generated->${PLATFORM}/${dir}/git_log_files"
	## delete the same line ##
	#echo "delete the same log files ..."

	sed -r ':1;N;s/^(\S+)((\n.*)*)\n\1$/\1\2/M;$!b1' ${PLATFORM}/${dir}/git_log_files  >  ${PLATFORM}/${dir}/generated_files

	#echo "handle the file.ignore ..."
	## delete the files in file.ignore ##
	for name in $(cat "${PLATFORM}/${dir}/file.ignore")
	do
		## delete the file: ##
		condition="file:"
		if [ ! -z $(echo $name | grep "$condition") ]; then
			name_temp=$(echo $name | sed "s/$condition//")
			name_temp=$(echo $name_temp | sed 's/\//\\\//g')
			name_temp="$(echo $name_temp | sed 's/\./\\\./g')"
			#echo "----dir$name_temp"
			if [ ! -z ${name_temp} ]; then
				sed -i "/^$name_temp/d"  ${PLATFORM}/${dir}/generated_files
			fi
		fi

		## delete the suffix: ##

		condition="suffix:"
		if [ ! -z $(echo $name | grep "$condition") ]; then
			name_temp=$(echo $name | sed "s/$condition//")
			name_temp="$(echo $name_temp | sed 's/\./\\\./g')"
			#echo "----suffix$name_temp"
			if [ ! -z ${name_temp} ]; then
				sed -i "/$name_temp$/d"  ${PLATFORM}/${dir}/generated_files
			fi
		fi

	done
	echo -e "generated->${PLATFORM}/${dir}/generated_files\n"
done
## get the code repo_list ##


echo "all finished!!!"


exit 0
