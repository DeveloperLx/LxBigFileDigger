#!/bin/bash

tmpRecordFile='.tmpRecord'

# 返回 1-文件 0-目录 -1-不存在
judgeFilepath() {
	if [[ -f $1 ]]; then
		return 1
	elif [[ -d $1 ]]; then
		return 0
	else
		return -1
	fi
}

isImageFile() {
	filepath=$1
	if [[ ${filepath:0-4:4} = '.png' ]]; then
		return 1
	elif [[ ${filepath:0-4:4} = '.jpg' ]]; then
		return 1
	elif [[ ${filepath:0-5:5} = '.jpeg' ]]; then
		return 1
	elif [[ ${filepath:0-4:4} = '.gif' ]]; then
		return 1
	elif [[ ${filepath:0-4:4} = '.bmp' ]]; then
		return 1
	else
		return 0
	fi
}

recordFileSize() {
	eval 'du -s $1'	>> tmpRecordFile

#	排序
}

traverseDir() {
	dirname=$1
	filenameList=`ls $dirname`
	for file in $filenameList
	do 
		filepath=''
		if [[ ${dirname:-1} = '/' ]]; then
			filepath=$1$file
		else
			filepath=$1/$file
		fi 

		judgeFilepath $filepath
		case $? in
			1) recordFileSize $filepath
			;;
			0) traverseDir $filepath
			;;
			*);;
		esac
	done
}

getFilepath() {
	read -p "👉  输入需要检查的目录：" filepath
	judgeFilepath $filepath
	case $? in
		0) 	touch tmpRecordFile
			traverseDir $filepath
			echo "文件大小|路径"
			sort -nr -k 1 -t ' ' tmpRecordFile
			rm -f tmpRecordFile
			echo 检视完毕，感谢使用 ^_^ DeveloperLx
			echo ''
		;;
		*) echo 【请输入正确的目录路径！】
			getFilepath
		;;
	esac
}

getFilepath

