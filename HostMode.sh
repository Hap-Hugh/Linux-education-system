#!/bin/bash

createTeacher()
{
	echo ">>Entering create function... "
	sleep 1
	clear
	#建立课程的数据库
	#如果已经存在则在原有基础上修改
	touch ./teacherDatabase
	while true
	do
		echo ">>Please input information of a new teacher"
		echo ">>The teacher's id must begin with 0 such as 0xxxxx with total length is 6"
		echo ">>2nd~3rd bit means the year to work in this school"
		read -p ">>Please input the teacher's ID: " teacherID
		#通过正则表达式给ID做规范
		if [[ $teacherID != 0[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		grep -w "$teacherID" ./teacherDatabase 1>/dev/null 2>&1
		if [ $? -eq 0 ]
		then
			echo ">>The ID has already existed!"
			continue
		fi
		read -p ">>Please input the name of teacher: " teacherName
		read -p ">>Please input the password of new teacher: " teacherPasswd
		#将信息定向输入到教师数据库
		echo $teacherID $teacherName $teacherPasswd >> teacherDatabase
		echo ">>Create succeed!"
		sleep 1
		return
	done
}

modifyTeacher()
{	
	while true 
	do
		read -p ">>Please input ID of the teacher: " modifyID
		#首先检测是否违背ID的格式：分别检测首字母和长度
		#statements如果没找到需要重新输入
		if [[ $modifyID != 0[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		#接着在teacher的record中查找教师工号
		#如果没有找到输入的教师工号重新输入
		grep -w "$modifyID" ./teacherDatabase 1>/dev/null 2>&1 
		if [ $? -ne 0 ] 
		then
			echo ">>No such ID in record. "
			continue
		fi
		#将原来的文件全字查找并反转输出到临时文件
		#此时TMP中的内容已经是删除要修改账号的了
		grep -wv "$modifyID" ./teacherDatabase > teacherDBTMP
		rm ./teacherDatabase
		mv teacherDBTMP teacherDatabase
		#上面的操作是将原来的文件删除，将临时文件重新命名
		#如果找到了则从重新输入信息
		echo ">>Please input new ID Name and Password"
		while true
		do
			read -p ">>New ID is：" newTeacherID
			#对于新输入的ID要检查是否满足主码
			#如果不是主码需要重新输入
			#首先检测是否违背ID的格式：分别检测首字母和长度
			#statements如果没找到需要重新输入
			if [[ $newTeacherID != 0[0-9][0-9][0-9][0-9][0-9] ]]; 
			then
				echo ">>Error in syntax for ID"
				continue
			fi
			#接着检测ID是否已经存在了，存在则不可以
			grep -w "$newTeacherID" ./teacherDatabase 1>/dev/null 2>&1
			if [ $? -eq 0 ]
			then
				echo ">>The ID has already existed!"
				continue
			fi
			break
		done
		#读入新输入的教师信息
		read -p ">>New name is: " newTeacherName
		read -p ">>New password is: " newTeacherPassword
		#将新的信息定向输入到教师数据库
		echo $newTeacherID $newTeacherName $newTeacherPassword >> teacherDatabase
		echo ">>Modify succeed!"
		sleep 1
		return
	done
}
#删除教师信息
deleteTeacher()
{
	while true
	do
		read -p ">>Please input ID of the teacher: " delTeacher
		#首先检测是否违背ID的格式：分别检测首字母和长度
		#statements如果没找到需要重新输入
		if [[ $delTeacher != 0[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		#接着在teacher的record中查找教师工号
		#如果没有找到输入的教师工号重新输入
		grep -w "$delTeacher" ./teacherDatabase 1>/dev/null 2>&1 
		if [ $? -ne 0 ] 
		then
			echo ">>No such ID in record. "
			continue
		fi
		break
	done
	#将原来的文件全字查找并反转输出到临时文件
	#此时TMP中的内容已经是删除要修改账号的了
	grep -wv "$delTeacher" ./teacherDatabase > teacherDBTMP
	rm ./teacherDatabase
	mv teacherDBTMP teacherDatabase 
	echo ">>Delete succeed!"
	sleep 1
	return
}
#显示所有老师信息
showTeacher()
{
	clear
	echo ">>Information of teachers: "
	sleep 1
	#在数据库中查找
	cat -n ./teacherDatabase
	sleep 2
}

#新建课程基本信息
createClass()
{
	echo ">>Entering create function... "
	sleep 1
	clear
	#建立课程的数据库
	#如果已经存在则在原有基础上修改
	touch ./classDataBase
	echo ">>Please input the information of class and its teacher"
	echo ">>The classID must begin with 1 such as 1xxxxx with total length is 6"
	echo ">>The name of the class should be English"
	while true
	do	
		read -p ">>Please input class ID: " classID
		#通过正则表达式给ID做规范
		if [[ $classID != 1[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		#在内存中寻找classID是否已经存在
		#若已经存在则不创建，重新输入
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -eq 0 ]
		then
			echo ">>The class ID has already existed!"
			sleep 1
			continue
		fi
		#输入课程的名字要求是英文
		read -p ">>Please input name of the class: " className
		while true
		do
			read -p ">>Please input teacher ID " teacherID
			#首先检测是否违背ID的格式：分别检测首字母和长度
			#statements如果没找到需要重新输入
			if [[ $teacherID != 0[0-9][0-9][0-9][0-9][0-9] ]]; 
			then
				echo ">>Error in syntax for ID"
				continue
			fi
			#接着在teacher的record中查找教师工号
			#如果没有找到输入的教师工号重新输入
			grep -w "$teacherID" ./teacherDatabase 1>/dev/null 2>&1 
			if [ $? -ne 0 ] 
			then
				echo ">>No such ID in record. "
				continue
			fi
			break
		done	
		echo $classID $className $teacherID >> classDataBase
		echo ">>Create succeed!"
		sleep 1
		return
	done
}
#在课程数据库中删除课程
deleteClass()
{
	while true
	do
		read -p ">>Please input class ID: " classID
		#通过正则表达式给ID做规范
		if [[ $classID != 1[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1 #首先查找这个id
		if [ $? -ne 0 ]
		then
			echo ">>No such ID in record!"
		else #如果找到
			grep -wv "$classID" ./classDataBase > classDataBasetmp
			rm ./classDataBase
			mv classDataBasetmp classDataBase
			echo ">>Delete succeed"
			sleep 2
			return
		fi
	done
}
#修改课程基本信息
modifyClass()
{
	while true
	do
		read -p ">>Please input class ID: " classID
		#通过正则表达式给ID做规范
		if [[ $classID != 1[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		#查找课程
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such ID in record!"
		else

			#先将原来的记录删除
			grep -wv "$classID" ./classDataBase > classDataBasetmp
			rm ./classDataBase
			mv classDataBasetmp classDataBase
			#输入新的信息内容
			read -p ">>Please input new ID of the class: " newClassID
			#通过正则表达式给ID做规范
			if [[ $newClassID != 1[0-9][0-9][0-9][0-9][0-9] ]]; 
			then
				echo ">>Error in syntax for ID"
				continue
			fi
			#还要看一下是否新输入的已经存在了
			#如果新输入的和之前的重复，需重新输入
			grep -w "$newClassID" ./classDataBase 1>/dev/null 2>&1
			if [ $? -eq 0 ]
			then
				echo ">>The class ID has already existed!"
				sleep 1
				continue
			fi
			read -p ">>Please input new name of the class: " newClassName
			while true
			do
				read -p ">>Please input new teacher ID of the class：" newTeacherID
				#首先检测是否违背ID的格式：分别检测首字母和长度
				#statements如果没找到需要重新输入
				if [[ $newTeacherID != 0[0-9][0-9][0-9][0-9][0-9] ]]; 
				then
					echo ">>Error in syntax for ID"
					continue
				fi
				#接着在teacher的record中查找教师工号
				#如果没有找到输入的教师工号重新输入
				grep -w "$newTeacherID" ./teacherDatabase 1>/dev/null 2>&1 
				if [ $? -ne 0 ] 
				then
					echo ">>No such ID in record. "
					continue
				fi
				break
			done
			#将新的信息写入文件
			echo $newClassID $newClassName $newTeacherID >> classDataBase
			echo ">>Modify succeed"
			sleep 2
			return
		fi
	done
}
# 显示学生课程
showClass()
{
	clear
	echo ">>Information of classes: "
	cat ./classDataBase
}

changePasswd()
{
	touch ./passwordRecord
	#读取老密码，如果错误则退出
	read -p ">>Please input your initial password: " oldPasswd
	# 在密码数据库中查找
	grep -w "$oldPasswd" ./passwordRecord 1>/dev/null 2>&1 
	if [ $? -ne 0 ] 
		then
		echo ">>Wrong Password. "
		#密码错误直接退出
		sleep 1
		return;
	else
		#打印欢迎信息
		echo ">>Welcome, HapHugh!"
		echo ">>Please input your new password:"
		read -p ">>" newPasswd
		#重复输入新密码，让用户背下来
		echo ">>Please input your new password again:"
		read -p ">>" newPasswdtmp
		if [[ $newPasswdtmp == $newPasswd ]]; then
			echo ">>Change password succeed!"
			#两次输入一样则，定向输入到密码数据库
			echo $newPasswd >> ./passwordRecord
			sleep 2
			clear
			return
		else 
			echo ">>Different input!"
			sleep 1
			clear
			return
		fi
	fi
}
# 返回到上一层
back()
{
	echo "Back to last page..."
	sleep 1
	exit
}
echo ">>Welcome to Host Mode :)"
echo ">>Please input your password for host:"
#首先要把初始化密码定向输入到密码文件
echo 123456 >> ./passwordRecord
while true
do
	read -p ">>" inputPasswd
	# 在密码数据库中查找
	grep -w "$inputPasswd" ./passwordRecord 1>/dev/null 2>&1 
	if [ $? -ne 0 ] 
		then
		# 如果没有找到这个密码说明错误
		echo ">>Wrong Password. "
		echo ">>Please check and input your password: "
		sleep 1
		return;
	else
		#如果找到了打印欢迎信息
		echo ">>Welcome, HapHugh!"
		sleep 1
		clear
		break
	fi
done
clear
while true
do
	#打印初始化界面
	echo "===================================================="
	echo ">>What do you want to do? You can ask me as follows: "
	sleep 1
	echo "CreateTeacher    -to create a teacher number"
	echo "ModifyTeacher    -to modify a teacher's information"
	echo "DeleteTeacher    -to delete a teacher's number"
	echo "ShowTeacher      -to have a look at teacher's information"
	echo "CreateClass      -to create a class number"
	echo "ModifyClass      -to modify a class number"
	echo "DeleteClass      -to delete a class number"
	echo "ShowClass        -to have a look at class information"
	echo "ChangePassword   -to change the initial password"
	echo "Quit             -to quit the host menu"	
	read -p ">>" inputFunction
	#根据用户的输入进行函数定向
	case $inputFunction in
		CreateTeacher)createTeacher
			;;
		ModifyTeacher)modifyTeacher
			;;
		DeleteTeacher)deleteTeacher
			;;
		ShowTeacher)showTeacher
			;;
		CreateClass)createClass
			;;
		ModifyClass)modifyClass
			;;
		DeleteClass)deleteClass
			;;
		ShowClass)showClass
			;;
		ChangePassword)changePasswd
			;;
		Quit)back
			;;
		*) echo "Invalid input, please check your input!"
		#如果输入为非法字符则重新输入
			;;
	esac
done	

