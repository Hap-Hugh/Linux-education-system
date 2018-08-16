#!/bin/bash

createTeacher()
{
	echo ">>Entering create function... "
	sleep 1
	clear
	touch ./teacherDatabase
	while true
	do
		echo ">>Please input information of a new teacher"
		echo ">>The teacher's id must begin with 0 such as 0xxxxx with total length is 6"
		echo ">>2nd~3rd bit means the year to work in this school"
		read -p ">>Please input the teacher's ID: " teacherID
	
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
	
		if [[ $modifyID != 0[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi

		grep -w "$modifyID" ./teacherDatabase 1>/dev/null 2>&1 
		if [ $? -ne 0 ] 
		then
			echo ">>No such ID in record. "
			continue
		fi

		grep -wv "$modifyID" ./teacherDatabase > teacherDBTMP
		rm ./teacherDatabase
		mv teacherDBTMP teacherDatabase

		echo ">>Please input new ID Name and Password"
		while true
		do
			read -p ">>New ID is：" newTeacherID

			if [[ $newTeacherID != 0[0-9][0-9][0-9][0-9][0-9] ]]; 
			then
				echo ">>Error in syntax for ID"
				continue
			fi

			grep -w "$newTeacherID" ./teacherDatabase 1>/dev/null 2>&1
			if [ $? -eq 0 ]
			then
				echo ">>The ID has already existed!"
				continue
			fi
			break
		done
	
		read -p ">>New name is: " newTeacherName
		read -p ">>New password is: " newTeacherPassword
		echo $newTeacherID $newTeacherName $newTeacherPassword >> teacherDatabase
		echo ">>Modify succeed!"
		sleep 1
		return
	done
}
deleteTeacher()
{
	while true
	do
		read -p ">>Please input ID of the teacher: " delTeacher
		if [[ $delTeacher != 0[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		grep -w "$delTeacher" ./teacherDatabase 1>/dev/null 2>&1 
		if [ $? -ne 0 ] 
		then
			echo ">>No such ID in record. "
			continue
		fi
		break
	done
	grep -wv "$delTeacher" ./teacherDatabase > teacherDBTMP
	rm ./teacherDatabase
	mv teacherDBTMP teacherDatabase 
	echo ">>Delete succeed!"
	sleep 1
	return
}
showTeacher()
{
	clear
	echo ">>Information of teachers: "
	sleep 1
	cat -n ./teacherDatabase
	sleep 2
}

createClass()
{
	echo ">>Entering create function... "
	sleep 1
	clear
	touch ./classDataBase
	echo ">>Please input the information of class and its teacher"
	echo ">>The classID must begin with 1 such as 1xxxxx with total length is 6"
	echo ">>The name of the class should be English"
	while true
	do	
		read -p ">>Please input class ID: " classID
		if [[ $classID != 1[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -eq 0 ]
		then
			echo ">>The class ID has already existed!"
			sleep 1
			continue
		fi
		read -p ">>Please input name of the class: " className
		while true
		do
			read -p ">>Please input teacher ID " teacherID
			if [[ $teacherID != 0[0-9][0-9][0-9][0-9][0-9] ]]; 
			then
				echo ">>Error in syntax for ID"
				continue
			fi
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
deleteClass()
{
	while true
	do
		read -p ">>Please input class ID: " classID
		if [[ $classID != 1[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
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
modifyClass()
{
	while true
	do
		read -p ">>Please input class ID: " classID
		if [[ $classID != 1[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such ID in record!"
		else
			grep -wv "$classID" ./classDataBase > classDataBasetmp
			rm ./classDataBase
			mv classDataBasetmp classDataBase
			read -p ">>Please input new ID of the class: " newClassID
			if [[ $newClassID != 1[0-9][0-9][0-9][0-9][0-9] ]]; 
			then
				echo ">>Error in syntax for ID"
				continue
			fi
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
				if [[ $newTeacherID != 0[0-9][0-9][0-9][0-9][0-9] ]]; 
				then
					echo ">>Error in syntax for ID"
					continue
				fi
				grep -w "$newTeacherID" ./teacherDatabase 1>/dev/null 2>&1 
				if [ $? -ne 0 ] 
				then
					echo ">>No such ID in record. "
					continue
				fi
				break
			done
			echo $newClassID $newClassName $newTeacherID >> classDataBase
			echo ">>Modify succeed"
			sleep 2
			return
		fi
	done
}
showClass()
{
	clear
	echo ">>Information of classes: "
	cat ./classDataBase
}

changePasswd()
{
	touch ./passwordRecord
	read -p ">>Please input your initial password: " oldPasswd
	grep -w "$oldPasswd" ./passwordRecord 1>/dev/null 2>&1 
	if [ $? -ne 0 ] 
		then
		echo ">>Wrong Password. "
		sleep 1
		return;
	else
		echo ">>Welcome, HapHugh!"
		echo ">>Please input your new password:"
		read -p ">>" newPasswd
		echo ">>Please input your new password again:"
		read -p ">>" newPasswdtmp
		if [[ $newPasswdtmp == $newPasswd ]]; then
			echo ">>Change password succeed!"
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
back()
{
	echo "Back to last page..."
	sleep 1
	exit
}
echo ">>Welcome to Host Mode :)"
echo ">>Please input your password for host:"
echo 123456 >> ./passwordRecord
while true
do
	read -p ">>" inputPasswd
	grep -w "$inputPasswd" ./passwordRecord 1>/dev/null 2>&1 
	if [ $? -ne 0 ] 
		then
		echo ">>Wrong Password. "
		echo ">>Please check and input your password: "
		sleep 1
		return;
	else
		echo ">>Welcome, HapHugh!"
		sleep 1
		clear
		break
	fi
done
clear
while true
do
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
			;;
	esac
done	

