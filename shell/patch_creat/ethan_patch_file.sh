#!/bin/bash  
#  
# FILE: ethan_store_file.sh  
#  
# DESCRIPTION: This shell is for creating the path code
#  
# NOTES: This requires GNU getopt.  
#  
# COPYRIGHT: (c) 2017-2018 by the zhangyin_ethan
#  
# ORGANIZATION: Allwinnertech
#  
# CREATED: 2017-03-29 12:34:00  
#  
#=======================================================================  

space=" "
dst_dir=
cur_dir=`basename $PWD`
set -e
#-----------------------------------------------------------------------  
# FUNCTION: usage  
# DESCRIPTION:  show the usage
#-----------------------------------------------------------------------  

usage() {  
	cat <<-EOT

	Usage 

	Options:  
	-h, --help        Display this message  
	Example:  
	ethan_patch_file  -d  dest_file  dif-file1 dif-file2 dif-file3

	Report bugs to zhangyin_ethan@126.com
	EOT
}

echoinfo() {
	echo -e "\033[37m$@\033[0m"
}

echowarn() {
	echo -e "\033[33m$@\033[0m"
}
echoerror() {
	echo -e "\033[31m$@\033[0m"
}

if [ $# -eq 0 ]; then 
	usage
	echoerror "no option !!!"
	exit 1
fi  

while [ -n "$1" ]; do  
	case "$1" in  
		-h | --help )
			usage
			exit 1;;  

		-d | --dest_dir)  
			# domain-suffix has an optional argument. as we are in quoted mode,  
			# an empty parameter will be generated if its optional argument is not found.  
			case "$2" in  
				"" )  
					echoerror "no option for -d"
					exit 1
					;;  
				*  )  
					dst_dir=`readlink -f $2`
					echoinfo "dest_dir: $dst_dir"
					shift 2 
					;;  
			esac ;;  

		#* ) 
		#	diff_file="${diff_file}${space}$1"
		#	echoinfo "diff_file:$diff_file" 
		#	shift 
		#	;;

		* )
		echoerror "there are some unkonow paremeter"
		exit 1
		;;  
	esac  
done  

if [ ! -n "$dst_dir" ]; then
	echoerror "no option for -d"
	exit 1
fi
# config file must provided with remaining argument  

if [ ! -d "$dst_dir/$cur_dir/b" ]; then
	echoerror "no  $dst_dir/$cur_dir/b"
	exit 1
fi

#mkdir -p $dst_dir/$cur_dir/a
#mkdir -p $dst_dir/$cur_dir/b

cp  -r  $dst_dir/$cur_dir/b/* $PWD


#for name in $diff_file ; do
#	cp  --parents $name  $dst_dir/$cur_dir/b
#	git checkout $name
#	cp  --parents $name  $dst_dir/$cur_dir/a
#	echoinfo "$name"
#done  

exit 0
