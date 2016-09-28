function env_version(){
	echo "yes, env_xxx_ethan has been set"
	echo "V01--20160915 by zhangyin_ethan@126.com"
}
VERSION="V02--2016/09/05 by zhangyin_ethan@126.com"

function push_sync_ethan(){
	branch="origin"
	if [ "$1" ] ; then
		branch="$1"
	fi
	echo "git push $branch master"
	git push $branch master
}

function pull_sync_ethan(){
	branch="origin"
	if [ "$1" ] ; then
		branch="$1"
	fi
	echo "git pull $branch master"
	git pull $branch master
}


function gitignore_rename_ethan(){
	#echo "find ./ -name .gitignore"
	#find ./ -name ".gitignore"
	num_git=`find ./ -name ".gitignore" | wc -l`
	IFS_BAK=$IFS
	IFS=$'\n'
	for name in `find ./ -name ".gitignore"`; do
		mv "$name"  "${name}.bak" #" " yekeyibuyao 
	done

	IFS=$IFS_BAK
	#echo "find ./ -name .gitignore.bak"

	#find ./ -name ".gitignore.bak"
	num_gitbak=`find ./ -name ".gitignore.bak" | wc -l`

	echo ".gitignore:$num_git .gitignore.bak:$num_gitbak"	
}

function gitignore_restore_ethan(){
	#echo "find ./ -name .gitignore.bak"
	#find ./ -name ".gitignore.bak"
	num_gitbak=`find ./ -name ".gitignore.bak" | wc -l`
	IFS_BAK=$IFS
	IFS=$'\n'
	for name in `find ./ -name ".gitignore.bak"`; do
		dir=`dirname  $name`
		git mv -f "$name"  "$dir/.gitignore"
	done
	IFS=$IFS_BAK
	#echo "find ./ -name .gitignore\n"
	#find ./ -name ".gitignore"
	num_git=`find ./ -name ".gitignore" | wc -l`
	echo ".gitignore.bak:$num_gitbak .gitignore:$num_git"	
}

function patch_creat_ethan(){
	dir_name=`basename $PWD`
	dir_old=${dir_name}_old
	dir_new=${dir_name}_new
	mkdir $dir_old $dir_new
	for name in $@	
	do
		if [ -f $name ]; then
			cp --parents $name  $dir_new
			git checkout $name > /dev/null  2>&1
			if [ $? -eq 0 ]; then
				cp --parents $name  $dir_old
				cp  $dir_new/$name  $name
			fi	
			echo "$name --is handled"
		else
			echo "$name is not a file, please manual handle!!"
		fi
	done
	
	unset dir_name dir_old dir_new
}
