# !/bin/bash
touch ./submitDatabase

#1.学生的登入2.查看自己的课程3.提交/查看/编辑：作业4.查看作业是否提交

echo ">>Dear student, welcome to student mode :)"
echo ">>You can inquire your class and operate with your homework here"


ShowMyClass()
{
	clear
	echo ">>Information of your classes: "
	echo "--ID-- -Name- Teacher ClassID--"
	#在学生数据库中查找并输出
	grep "$studentID" ./studentDatabase
}

ShowMyHW()
{
	clear
	echo ">>Please input your class ID first"
	while true
	do
		#检查课程ID的格式是否符合标准
		#如果不符合则重新输入课程ID
	read -p ">>Class ID: " classID
	if [[ $classID != 1[0-9][0-9][0-9][0-9][0-9] ]]; 
	then
		echo ">>Error in syntax for ID"
		continue
	fi
	#检查课程ID的格式是否存在
	#如果不存在则重新输入课程ID
	grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo ">>No such class in record!"
		continue
	fi
	#检查课程ID的格式是否存在作业
	#如果不存在则输出不存在的信息
	grep -w "$classID" ./hwDatabase 1>/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo ">>No homework now"
		return
	fi
	#在作业数据库中查找并输出
	echo ">>Here is your homework in class $classID"
	grep "$classID" ./hwDatabase
	sleep 1
	return
	done
}

SubmitHW()
{
	clear
	echo ">>Please input your class ID first"
	while true
	do
		#首先验证课程是否存在
		#如果不符合则重新输入课程ID
		read -p ">>Class ID: " classID
		if [[ $classID != 1[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		#检查课程ID的格式是否存在
		#如果不存在则重新输入课程ID
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such class in record!"
			continue
		fi
		#接下来验证学生是不是选了这门课程
		grep -w "$studentID .* $classID" ./studentDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>Sorry, you don't have this class"
			echo ">>Please ask teacher for help"	
			continue
		fi
		#接下来输入要提交的作业ID
		read -p ">>Homework ID: " hwID
		#检查作业ID的格式是否符合标准
		#如果不符合则重新输入学生ID
		if [[ $hwID != 3[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		#接下来检查作业是否是不存在
		grep -w "$hwID" ./hwDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such homework in record!"
			continue
		fi
		#现在可以输入作业内容了
		echo "Please input your file name (contain your name and hw ID)"
		read -p ">>Please input your filename: " filename
		touch ./filename
		read -p ">>Please input your homework: " myHomework
		echo $myHomework > ${filename} #提交内容写进文件
		echo $studentID "YES" $filename $hwID>> submitDatabase #学生信息写进保存作业提交信息的文件
		echo ">>Submit succeed!"
		sleep 1
		return
	done
}

IsSubmitHW()
{
	while true
	do
		read -p ">>Homework ID: " hwID
		#检查作业ID的格式是否符合标准
		#如果不符合则重新输入学生ID
		if [[ $hwID != 3[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		#接下来检查作业是否是不存在
		grep -w "$hwID" ./hwDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such homework in record!"
			continue
		fi	
		#在提交的数据库中进行查找
		grep -w "$studentID .* $hwID" ./submitDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			#如果没有提交则
			echo ">>You have not submit yet..."
			echo ">>Mind to pay attantion to DDL!"
		else
			#如果提交了
			echo ">>Well done, you have already submit it!"
			echo ">>You can modify it online"
		fi
		return
	done
}

ModifyHW()
{
	#需要修改作业提交数据库
	while true
	do
		read -p ">>Please input your filename: " filename
		read -p ">>Please input your homework ID: " hwID
		#检查作业ID的格式是否符合标准
		#如果不符合则重新输入学生ID
		if [[ $hwID != 3[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		#接下来检查作业是否是不存在
		grep -w "$hwID" ./hwDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such homework in record!"
			continue
		fi	
		#首先检查这个文件是否存在，也就是说看这个学生是否提交过这个文件
		grep "$filename $hwID" ./submitDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>You have not submit yet..."
			echo ">>Mind to pay attantion to ddl!"	
			continue
		fi
		#删除之前提交的原有记录操作
		grep -wv "$sname .* $jid" ./submitDatabase > submitDatabaseTMP 
		rm ./submitDatabase
		mv submitDatabaseTMP submitDatabase 
		#删除之前提交的文件
		rm ./${filename}
		#将提交的内容写进新的文件
		echo "Please input your new file name (contain your name and hw ID)"
		read -p ">>Please input your new filename: " newFilename
		#新建这个文件
		touch ./filename
		read -p ">>Please input your homework: " myHomework
		echo $myHomework > ${newFilename}
		#将新的提交信息写入
		echo $studentID "YES" $newFilename $hwID>> submitDatabase #学生信息写进保存作业提交信息的文件
		echo ">>Modify succeed!"
		sleep 1
		return
	done
}

ShowMySubmit()
{
	#按照文件cat即可
	while true
	do
		read -p ">>Please input your filename: " filename
		read -p ">>Please input your homework ID: " hwID
		#检查作业ID的格式是否符合标准
		#如果不符合则重新输入学生ID
		if [[ $hwID != 3[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		#接下来检查作业是否是不存在
		grep -w "$hwID" ./hwDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such homework in record!"
			continue
		fi	
		#首先检查这个文件是否存在，也就是说看这个学生是否提交过这个文件
		grep "$filename $hwID" ./submitDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>You have not submit yet..."
			echo ">>Mind to pay attantion to DDL!"	
			continue
		fi
		#输出这个文件中的信息
		echo "Here is your homework: "
		cat ${filename}
		sleep 2
		return
	done

}
CreateComment()
{
	echo ">>Please input your class ID first"
	while true
	do
		#检查作业ID的格式是否符合标准
		#如果不符合则重新输入课程ID
		read -p ">>Class ID: " classID
		if [[ $classID != 1[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		#检验课程是否已经存在
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such class in record!"
			continue
		fi
		#接下来验证学生是不是选了这门课程
		grep -w "$studentID .* $classID" ./studentDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>Sorry, you don't have this class"
			echo ">>Please ask teacher for help"	
			return
		fi
		#新建文件并进行定向输入
		touch ./commemt
		read -p "Please input your comment: " mycomment
		echo $mycomment >> ./comment
		echo "comment succeed!"
		return
	done
}
# 返回上一层
Quit()
{
	echo "Back to last page..."
	sleep 1
	exit
}
#开始的时候先输入学生ID进行验证
while true
do
	read -p ">>Please input your student ID: " studentID
	grep -w "$studentID" ./studentDatabase 1>/dev/null 2>&1
	#如果没有找到
	if [ $? -ne 0 ]
	then
		echo ">>No such ID in student record!"
		echo ">>Please check your number or ask teacher for help"
		continue
	fi
	clear
	break
done
#打印初始界面
while true
do
	sleep 1
	echo ">>Welcome, $studentID! What do you want to do?"
	sleep 1
	echo ">>You can ask me as follows: "
	echo "ShowMyClass  -to list all class you are taking"
	echo "ShowMyHW     -to list all homework your teacher assigned"
	echo "SubmitHW     -to submit your homework online"
	echo "IsSubmitHW   -to find whether your homework is submit"
	echo "ModifyHW     -to change your homework online and resubmit"
	echo "ShowMySubmit -to view your homework online"
	echo "CreateC     -to create comment for class"
	echo "Quit         -to back to last page"
	read -p ">>" input
	case $input in
		ShowMyClass) ShowMyClass
			;;
		ShowMyHW) ShowMyHW
			;;
		SubmitHW) SubmitHW
			;;
		IsSubmitHW) IsSubmitHW
			;;
		ModifyHW) ModifyHW
			;;
		ShowMySubmit) ShowMySubmit
			;;
		CreateC) CreateComment
			;;
		Quit) Quit
			;;
		*) echo "Invalid input, please check your input!"
			;;
	esac
done