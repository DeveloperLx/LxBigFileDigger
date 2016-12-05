#!/bin/bash

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

# 返回 1-是 0-否
isOCFile() {
	filepath=$1
	if [[ ${filepath:0-2:2} = '.h' ]]; then
		return 1
	elif [[ ${filepath:0-2:2} = '.m' ]]; then
		return 1
	else
		return 0
	fi
}

# 返回 1-是 0-否
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

getFilterType() {
	read -p "👉  输入需要检查的文件类型（0：全部 1：源码文件 2：图片文件）：" filterType
	if [[ $filterType == 0 || $filterType == 1 || $filterType == 2 ]]; then
		return $filterType
	else
		echo "输入有误，请重新输入！"
		getFilterType
	fi
}

analysisDir() {
	echo "============  正在分析...... ============"

	dir=$1

	cd "$dir"

	traverseResultFile="__traverseResultFile__"
	fileSizeResultFile="__fileSizeResultFile__"

	rm -f $traverseResultFile
	rm -f $fileSizeResultFile

	find `pwd` > $traverseResultFile

	while read line; do
		# 不统计隐藏文件
		if [[ $line =~ '/.' ]]; then
			continue
		fi

		# 跳过目录
		if [[ -d $line ]]; then
			continue
		fi

		ls -l "$line" | awk '{printf "%-12s %s%s%s\n", $5, $9, $10, $11}' >> $fileSizeResultFile

	done < $traverseResultFile

	echo "文件大小（字节）| 绝对路径"

	# 默认只输出最大的60个文件
	sort -nr -k 1 -t ' ' $fileSizeResultFile | awk '{if(NR <= 60){print $0}}'

	rm -f $traverseResultFile
	rm -f $fileSizeResultFile
}

getFilepath() {
	read -p "👉  输入需要检查的目录：" filepath
	judgeFilepath $filepath
	case $? in
		0) 	analysisDir $filepath
		;;
		*) echo 【请输入正确的目录路径！】
			getFilepath
		;;
	esac
}

echo 🍊 🍊 🍊    找出项目中的大文件🍊 🍊 🍊
getFilepath
echo "====== 分析完毕，感谢使用！ (made by DeveloperLx) ======"

