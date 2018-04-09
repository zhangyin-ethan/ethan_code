#!/bin/bash

source  function_define.sh

# global var define
CONFIG_FILE=

while getopts "f:" opt > /dev/null 2>&1; do
	case $opt in

		f)
			if [ -e $OPTARG ]; then
				CONFIG_FILE=$OPTARG
				echo_info "CONFIG_FILE:${CONFIG_FILE}"
			fi
			;;

	esac
done


exit 0
