function echo_error() # red
{
	#echo -e "\033[47;31mERROR: $*\033[0m"
	echo -e "\033[31m$*\033[0m"
}

function echo_warn() #yellow
{
	#echo -e "\033[47;34mWARN: $*\033[0m"
	echo -e "\033[33m$*\033[0m"
}

function echo_info() #white
{
	#echo -e "\033[47;30mINFO: $*\033[0m"
	echo -e "\033[37m$*\033[0m"
}

function echo_good() #green
{
	#echo -e "\033[47;30mINFO: $*\033[0m"
	echo -e "\033[32m$*\033[0m"
}
