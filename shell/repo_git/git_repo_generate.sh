#!/bin/bash
##  global variable ##
VERSION="V02--2016/09/05 by zhangyin_ethan@126.com"
set -e

CUR=`pwd`

echo -e "\n${VERSION}\n"

show_help()
{
	echo "usage: ./git_repo_generate.sh -s xxx/lichee  -d xxx_code.git"
}
##  void no parameter ##

if [ $# -ne  4 ]
then
	show_help
	exit 1
fi

## get the CODE_dir value ##
while getopts "s:d:"  OPTION
do
	#echo "option --$OPTION"
	case $OPTION in
		"s")
			SRC=$OPTARG
			;;
		"d")
			DST=$OPTARG
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


if [ ! -d "$SRC" ] || [ ! -d "$DST" ]
then
	echo "the source_dir or destination_dir is wrong!!"
	exit 1
fi

SRC=$(readlink -f $SRC)
DST=$(readlink -f $DST)


echo -e "dir_src:$SRC"
echo -e "dir_dst:$DST\n"

## get the code repo_list ##
#echo "get the repo_list ..."

dir_src=`basename $SRC`
dir_dst=`basename $DST`

if [ $dir_src == $dir_dst ]; then
	echo "dir_src:$dir_src == dir_dst:$dir_dst" 
	show_help
	exit 1
fi

echo "dir_src:$dir_src"


## create the bare git repository ##
cd  $DST
if [ -d "${dir_src}.git" ]; then
	rm  -rf  ${dir_src}.git
fi
git init --bare  ${dir_src}.git



## get the code repo_list ##
cd ${SRC}
repo list > $CUR/${dir_src}_repo_list
sed -i 's/\(.*\) :\(.*\)/\1/'  $CUR/${dir_src}_repo_list
echo "generated->$CUR/${dir_src}_repo_list"

name=`cat $CUR/${dir_src}_repo_list | head -1`

#echo "name:$name"
cd  ${SRC}/${name}
echo "${SRC}/${name}"  >>  "$CUR/${dir_src}_git_log"
git  log >>  "$CUR/${dir_src}_git_log"


## clear all the sub projects git  ##
for name in $(cat "$CUR/${dir_src}_repo_list")
do
	cd  ${SRC}/${name}
	rm -rf .git
done


## create the source repository ##
cd  $SRC
rm -rf .repo
git init
git remote add origin $DST/${dir_src}.git


echo "all finished!!!"


exit 0
