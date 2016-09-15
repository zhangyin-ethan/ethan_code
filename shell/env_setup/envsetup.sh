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


function gitginore_rename_ethan(){
	echo "find ./ -name .gitignore"
	find ./ -name ".gitignore"
	num_git=`find ./ -name ".gitignore" | wc -l`

	for name in `find ./ -name ".gitignore"`; do
		mv $name  ${name}.bak
	done

	echo "find ./ -name .gitignore.bak"

	find ./ -name ".gitignore.bak"
	num_gitbak=`find ./ -name ".gitignore.bak" | wc -l`

	echo ".gitignore:$num_git .gitignore.bak:$num_gitbak"	
}

function gitginore_restore_ethan(){
	echo "find ./ -name .gitignore.bak"
	find ./ -name ".gitignore.bak"
	num_gitbak=`find ./ -name ".gitignore.bak" | wc -l`
	for name in `find ./ -name ".gitignore.bak"`; do
		dir=`dirname  $name`
		mv $name  $dir/.gitignore
	done

	echo "find ./ -name .gitignore\n"
	find ./ -name ".gitignore"
	num_git=`find ./ -name ".gitignore" | wc -l`
	echo ".gitignore.bak:$num_gitbak .gitignore:$num_git"	
}
