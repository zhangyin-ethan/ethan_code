function ethan_sync_push(){
	branch="origin"
	if [ "$1" ] ; then
		branch="$1"
	fi
	echo "git push $branch master"
	git push $branch master
}

function ethan_sync_pull(){
	branch="origin"
	if [ "$1" ] ; then
		branch="$1"
	fi
	echo "git pull $branch master"
	git pull $branch master
}


function ethan_gitginore_rename(){
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

function ethan_gitginore_restore(){
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
