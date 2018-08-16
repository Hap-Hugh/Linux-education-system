#!/bin/bash

CreateS()
{
	echo ">>Entering create function... "
	sleep 1
	clear
	#创建学生数据库，写入学生信息
	touch ./studentDatabase
	#进入教师ID及课程检验阶段
	while true
	do
		#首先检查课程是否存在
		#如果不存在重新输入
		echo ">>Please input your class ID first"
		read -p ">>" classID
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such class in record!"
			continue
		fi
		#接下来检查课程是否和教师ID匹配
		#如果该教师并没有教这门课，则无法修改对应数据
		grep -w "$classID .* $teacherID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>Sorry, you can't modify information of students in this class..."
			echo ">>This class is not your teaching class..."	
			continue
		else
			break;
		fi
	done
	#进入创建学生阶段
	while true
	do
		echo ">>Please input information of a new student"
		echo ">>Student's ID must begin with 2 such as 2xxxx with total length is 6"
		read -p ">>Please input the student's ID: " studentID
		#首先检查学生ID的格式是否符合标准
		#如果不符合则重新输入学生ID
		if [[ $studentID != 2[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		#接下来检查新建的学生学号是否已经存在
		#如果存在则重新输入学生ID
		grep -w "$studentID .* $classID" ./studentDatabase 1>/dev/null 2>&1
		if [ $? -eq 0 ]
		then
			echo ">>The student ID has already existed in this class!"
			sleep 1
			continue
		fi
		break
	done
	read -p ">>Please input student's name: " nameS
	#最后将学生ID学生name教师ID课程ID一起写入学生数据库
	echo $studentID $nameS $teacherID $classID >> studentDatabase
	echo ">>Create succeed!"
	sleep 1
}

ModifyS()
{
	#进入教师ID及课程检验阶段
	while true
	do
		#首先检查课程是否存在
		#如果不存在重新输入
		echo ">>Please input your class ID first"
		read -p ">>" classID
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such class in record!"
			continue
		fi
		#接下来检查课程是否和教师ID匹配
		#如果该教师并没有教这门课，则无法修改对应数据
		grep -w "$classID .* $teacherID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>Sorry, you can't modify information of students in this class..."
			echo ">>This class is not your teaching class..."	
			continue
		else
			break;
		fi
	done
	#进入教师修改学生信息阶段
	while true
	do
		read -p ">>Please input the student's ID: " studentID
		#首先检查学生ID的格式是否符合标准
		#如果不符合则重新输入学生ID
		if [[ $studentID != 2[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		#接下来检测是否在数据库中能够找到这个学生
		#如果找不到需要重新输入学生ID
		grep -w "$studentID" ./studentDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such class in record!"
			continue
		fi
		#先将原有的记录进行删除
		grep -wv "$studentID" ./studentDatabase > DataBasetmp 
		rm ./studentDatabase 
		mv DataBasetmp studentDatabase
		#嵌套一个循环，作为新信息的输入
		while true
		do
			read -p ">>Please input new ID: " newStudentID
			#首先检查学生ID的格式是否符合标准
			#如果不符合则重新输入学生ID
			if [[ $newStudentID != 2[0-9][0-9][0-9][0-9][0-9] ]]; 
			then
				echo ">>Error in syntax for ID"
				continue
			fi
			#接下来检查新建的学生学号是否已经存在
			#如果存在则重新输入学生ID
			grep -w "$newStudentID" ./studentDatabase 1>/dev/null 2>&1
			if [ $? -eq 0 ]
			then
				echo ">>The student ID has already existed!"
				sleep 1
				continue
			fi
			read -p ">>Please input new name of student: " newStudentName
			#最后将学生ID学生name教师ID课程ID一起写入学生数据库
			echo $newStudentID $newStudentName $teacherID $classID >> studentDatabase
			echo ">>Modify succeed!"
			sleep 1
			break
		done
		break
	done
}

DeleteS()
{
	#进入教师ID及课程检验阶段
	while true
	do
		#首先检查课程是否存在
		#如果不存在重新输入
		echo ">>Please input your class ID first"
		read -p ">>" classID
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such class in record!"
			continue
		fi
		#接下来检查课程是否和教师ID匹配
		#如果该教师并没有教这门课，则无法修改对应数据
		grep -w "$classID .* $teacherID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>Sorry, you can't modify information of students in this class..."
			echo ">>This class is not your teaching class..."	
			continue
		else
			break;
		fi
	done
	#进入删除学生账号阶段
	while true
	do
		read -p ">>Please input ID of the student: " delStudentID
		#首先检测是否违背ID的格式：分别检测首字母和长度
		#statements如果没找到需要重新输入
		if [[ $delStudentID != 2[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		#接着在teacher的record中查找教师工号
		#如果没有找到输入的教师工号重新输入
		grep -w "$delStudentID" ./studentDatabase 1>/dev/null 2>&1 
		if [ $? -ne 0 ] 
		then
			echo ">>No such ID in record. "
			continue
		fi
		#将原来的文件全字查找并反转输出到临时文件
		#此时TMP中的内容已经是删除要修改账号的了
		grep -wv "$delStudentID" ./studentDatabase > studentDBTMP
		rm ./studentDatabase
		mv studentDBTMP studentDatabase 
		echo ">>Delete succeed!"
		sleep 1
		return
	done
}

ShowS()
{
	clear
	echo ">>Information of students: "
	sleep 1
	cat -n ./studentDatabase
	sleep 2
}
FindS()
{
	while true
	do
		read -p ">>Please input the student's ID: " studentID
		#首先检查学生ID的格式是否符合标准
		#如果不符合则重新输入学生ID
		if [[ $studentID != 2[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		#接下来检测是否在数据库中能够找到这个学生
		#如果找不到需要重新输入学生ID
		grep -w "$studentID" ./studentDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such class in record!"
			continue
		fi
		#在记录中将学生信息成行输出
		echo "==ID== ==Name== ==Teacher== ==Class=="
		grep -w "$studentID" ./studentDatabase
		sleep 1
		break
	done
}

CreateClassINF()
{
	echo ">>Entering create function... "
	sleep 1
	clear
	#创建学生数据库，写入学生信息
	touch ./classINFDatabase
	#进入教师ID及课程检验阶段
	echo ">>You can add information of the class in this function"
	while true
	do
		#首先检查课程是否存在
		#如果不存在重新输入
		echo ">>Please input your class ID first"
		read -p ">>" classID
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such class in record!"
			continue
		fi
		#接下来检查课程是否和教师ID匹配
		#如果该教师并没有教这门课，则无法修改对应数据
		grep -w "$classID .* $teacherID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>Sorry, you can't modify information of this class..."
			echo ">>This class is not your teaching class..."	
			continue
		else
			break;
		fi
	done
	read -p ">>Please input discription of the class: " classINF
	echo $classID $classINF >> classINFDatabase
	echo "Create succeed!"
	sleep 1
}

ModifyClassINF()
{
	while true
	do
		#首先检查课程是否存在
		#如果不存在重新输入
		echo ">>Please input your class ID first"
		read -p ">>" classID
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such class in record!"
			continue
		fi
		grep -wv "$classID" ./classINFDatabase > infTMP
		rm ./classINFDatabase
		mv infTMP classINFDatabase
		#接下来检查课程是否和教师ID匹配
		#如果该教师并没有教这门课，则无法修改对应数据
		grep -w "$classID .* $teacherID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>Sorry, you can't modify information of this class..."
			echo ">>This class is not your teaching class..."	
			continue
		else
			break;
		fi
	done
	read -p ">>Please input new discription of the class: " newClassDis
	echo $classID $newClassDis >> classINFDatabase
	echo ">>Modify succeed!"
	sleep 1
	return
}

DeleteClassINF()
{
	while true
	do
		#首先检查课程是否存在
		#如果不存在重新输入
		echo ">>Please input your class ID first"
		read -p ">>" classID
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such class in record!"
			continue
		fi
		#接下来检查课程是否和教师ID匹配
		#如果该教师并没有教这门课，则无法修改对应数据
		grep -w "$classID .* $teacherID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>Sorry, you can't modify information of this class..."
			echo ">>This class is not your teaching class..."	
			continue
		else
			break;
		fi
	done
	grep -wv "$classID" ./classINFDatabase > infTMP
	rm ./classINFDatabase
	mv infTMP classINFDatabase
	echo ">>Delete succeed!"
	sleep 1
	return
}

ShowClassINF()
{
	clear
	echo ">>Information of class information: "
	sleep 1
	cat -n ./classINFDatabase
	sleep 2
}

FindClassINF()
{
	while true
	do
		#首先检查课程是否存在
		#如果不存在重新输入
		echo ">>Please input your class ID first"
		read -p ">>" classID
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such class in record!"
			continue
		fi
		echo "==ID== ====discription===="
		grep -w "$classID" ./classINFDatabase
		sleep 1
		break
	done
}

CreateHW()
{
	echo ">>Entering create function... "
	sleep 1
	clear
	touch ./hwDatabase
	#创建作业数据库，写入学生信
	#进入教师ID及课程检验阶段
	while true
	do
		#首先检查课程是否存在
		#如果不存在重新输入
		read -p ">>Please input your class ID first: " classID
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such class in record!"
			continue
		fi
		#接下来检查课程是否和教师ID匹配
		#如果该教师并没有教这门课，则无法修改对应数据
		grep -w "$classID .* $teacherID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>Sorry, you can't modify information of students in this class..."
			echo ">>This class is not your teaching class..."	
			continue
		else
			break;
		fi
	done
	#此时教师已经获得发布作业的权限
	#接下来开始进行作业的发布
	while true
	do
		echo ">>Welcome teacher, you can assign homework here"
		echo ">>Please input homework ID and discription"
		echo ">>Homework ID must begin with 3 such as 3xxxxx with total length is 6"
		read -p ">>Please input homework ID: " hwID
		#首先检查作业ID的格式是否符合标准
		#如果不符合则重新输入学生ID
		if [[ $hwID != 3[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		#接下来检查作业是否已经存在
		#如果存在则重新输入学生ID
		grep -w "$hwID" ./hwDatabase 1>/dev/null 2>&1
		if [ $? -eq 0 ]
		then
			echo ">>The homework ID has already existed!"
			sleep 1
			continue
		fi
		break
	done
	read -p ">>Please input homework discription: " hwDis
	echo $hwID $hwDis $teacherID $classID >> hwDatabase
	echo ">>Create succeed!"
	sleep 1
	return
}

ModifyHW()
{
	#进入教师ID及课程检验阶段
	while true
	do
		#首先检查课程是否存在
		#如果不存在重新输入
		read -p ">>Please input your class ID first: " classID
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such class in record!"
			continue
		fi
		#接下来检查课程是否和教师ID匹配
		#如果该教师并没有教这门课，则无法修改对应数据
		grep -w "$classID .* $teacherID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>Sorry, you can't modify information of students in this class..."
			echo ">>This class is not your teaching class..."	
			continue
		else
			break;
		fi
	done
	#此时教师已经获得修改作业的权限
	#接下来开始进行作业的修改
	while true
	do
		read -p ">>Please input homework ID: " hwID
		#首先检查作业ID的格式是否符合标准
		#如果不符合则重新输入作业ID
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
		else
			#将这个记录在原来的数据库中删除
			grep -wv "$hwID" ./hwDatabase > infTMP
			rm ./hwDatabase
			mv infTMP hwDatabase
			break;
		fi
	done
	#输入新的作业信息
	while true
	do
		read -p ">>Please input new homework ID: " newHwID
		#首先检查作业ID的格式是否符合标准
		#如果不符合则重新输入作业ID
		if [[ $newHwID != 3[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi

		#接下来检查新建的学生学号是否已经存在
		#如果存在则重新输入学生ID
		grep -w "$newHwID" ./hwDatabase 1>/dev/null 2>&1
		if [ $? -eq 0 ]
		then
			echo ">>The homework ID has already existed!"
			sleep 1
			continue
		fi
		break
	done
	read -p ">>Please input new homework discription: " newHwDis
	echo $newHwID $newHwDis $teacherID $classID >> hwDatabase
	echo ">>Modify succeed"
	sleep 1
	return
}

DeleteHW()
{
	#进入教师ID及课程检验阶段
	while true
	do
		#首先检查课程是否存在
		#如果不存在重新输入
		read -p ">>Please input your class ID first: " classID
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such class in record!"
			continue
		fi
		#接下来检查课程是否和教师ID匹配
		#如果该教师并没有教这门课，则无法修改对应数据
		grep -w "$classID .* $teacherID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>Sorry, you can't modify information of students in this class..."
			echo ">>This class is not your teaching class..."	
			continue
		else
			break;
		fi
	done
	#此时教师已经获得删除作业的权限
	while true
	do
		read -p ">>Please input homework ID: " delHwID
		#首先检查作业ID的格式是否符合标准
		#如果不符合则重新输入作业ID
		if [[ $delHwID != 3[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		#接下来检查作业是否是不存在
		grep -w "$delHwID" ./hwDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such homework in record!"
			continue
		fi
		break
	done
	#将原来的文件全字查找并反转输出到临时文件
	#此时TMP中的内容已经是删除要修改账号的了
	grep -wv "$delStudentID" ./studentDatabase > studentDBTMP
	rm ./studentDatabase
	mv studentDBTMP studentDatabase 
	echo ">>Delete succeed!"
	sleep 1
	return
}

ShowHW()
{
	clear
	echo ">>Information of homework information: "
	sleep 1
	cat -n ./hwDatabase
	sleep 2
}

IsComp()
{

	while true
	do
		read -p ">>Please input homework ID: " hwID
		#首先检查作业ID的格式是否符合标准
		#如果不符合则重新输入作业ID
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
		break
	done
	while true
	do
		read -p ">>Please input the student's ID: " studentID
		#首先检查学生ID的格式是否符合标准
		#如果不符合则重新输入学生ID
		if [[ $studentID != 2[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		#接下来检测是否在数据库中能够找到这个学生
		#如果找不到需要重新输入学生ID
		grep -w "$studentID" ./studentDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such student in record!"
			continue
		fi
		break
	done

	grep -w "$studentID .* $hwID" ./submitDatabase 1>/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo ">>The student has not completed this homework yet"
		return
	else
		echo ">>The student has already completed this homework"
		return 
	fi
}


Quit()
{
	echo "Back to last page..."
	sleep 1
	exit
}

echo ">>Dear teacher, welcome to teacher mode :)"
while true
do	
	
	echo ">>Please input your ID"
	read -p ">>" teacherID
	#首先检测teacherID是否符合格式
	if [[ $teacherID != 0[0-9][0-9][0-9][0-9][0-9] ]]; 
	then
		echo ">>Error in syntax for ID"
		continue
	fi
	#在文件中寻找teacherID是否存在
	grep -w "$teacherID" ./teacherDatabase 1>/dev/null 2>&1 #在teacher_record中查找教师工号
	if [ $? -ne 0 ] 
	then
		echo ">>No such ID in record. "
		continue
	fi
	#如果输入的ID能够在记录找到
	while true
	do
	echo ">>Please input teacher password"
	read -p ">>" teacherPasswd
	if [[ $teacherPasswd == "123456" ]]; then
		echo ">>Welcome, HapHugh's teacher!"
		sleep 1
		clear
		break
	else
		echo ">>Wrong Password..."
		echo ">>Please check your password..."
		continue
	fi
	done
	break
done
while true
do
	echo "=============================================="
	echo ">>Welcome, $teacherID! What do you want to do?"
	sleep 1
	echo ">>You can ask me as follows: "
	echo "CreateStudent   -to create student number"
	echo "ModifyStudent   -to modify student number"
	echo "DeleteStudent   -to delete student number"
	echo "ShowStudent     -to show all student numbers"
	echo "FindStudent     -to search student in record"
	echo "CreateClass     -to create a class and add information"
	echo "ModifyClass     -to modify the information of a class"
	echo "DeleteClass     -to delete the information of a class"
	echo "ShowClass       -to show all information of the class"
	echo "FindClass       -to find class with information"
	echo "CreateHW        -to create homework for class"
	echo "ModifyHW        -to modify homework"
	echo "DeleteHW        -to delete homework"
	echo "ShowHW          -to show all homework"
	echo "IsComp          -to find a student whether complete his homework"
	echo "Quit            -to quit this mode"

	read -p ">>" inputFunc

	case $inputFunc in
		CreateStudent)CreateS
			;;
		ModifyStudent)ModifyS
			;;
		DeleteStudent)DeleteS
			;;
		ShowStudent)ShowS
			;;
		FindStudent)FindS
			;;
		CreateClass)CreateClassINF
			;;
		ModifyClass)ModifyClassINF
			;;
		DeleteClass)DeleteClassINF
			;;
		ShowClass)ShowClassINF
			;;
		FindClass)FindClassINF
			;;
		CreateHW)CreateHW
			;;
		ModifyHW)ModifyHW
			;;
		DeleteHW)DeleteHW
			;;
		ShowHW)ShowHW
			;;
		IsComp)IsComp
			;;
		Quit)Quit
			;;
		*) echo "Invalid input, please check your input!"
			;;
	esac

done