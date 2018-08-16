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
	grep "$studentID" ./studentDatabase
}

ShowMyHW()
{
	clear
	echo ">>Please input your class ID first"
	while true
	do
	read -p ">>Class ID: " classID
	if [[ $classID != 1[0-9][0-9][0-9][0-9][0-9] ]]; 
	then
		echo ">>Error in syntax for ID"
		continue
	fi
	grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo ">>No such class in record!"
		continue
	fi
	grep -w "$classID" ./hwDatabase 1>/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo ">>No homework now"
		return
	fi
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
		read -p ">>Class ID: " classID
		if [[ $classID != 1[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such class in record!"
			continue
		fi
		grep -w "$studentID .* $classID" ./studentDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>Sorry, you don't have this class"
			echo ">>Please ask teacher for help"	
			continue
		fi
		read -p ">>Homework ID: " hwID
		if [[ $hwID != 3[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		grep -w "$hwID" ./hwDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such homework in record!"
			continue
		fi
		echo "Please input your file name (contain your name and hw ID)"
		read -p ">>Please input your filename: " filename
		touch ./filename
		read -p ">>Please input your homework: " myHomework
		echo $myHomework > ${filename} 
		echo $studentID "YES" $filename $hwID>> submitDatabase 
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
		if [[ $hwID != 3[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		grep -w "$hwID" ./hwDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such homework in record!"
			continue
		fi	
		grep -w "$studentID .* $hwID" ./submitDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>You have not submit yet..."
			echo ">>Mind to pay attantion to DDL!"
		else
			echo ">>Well done, you have already submit it!"
			echo ">>You can modify it online"
		fi
		return
	done
}

ModifyHW()
{
	while true
	do
		read -p ">>Please input your filename: " filename
		read -p ">>Please input your homework ID: " hwID
		if [[ $hwID != 3[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		grep -w "$hwID" ./hwDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such homework in record!"
			continue
		fi	
		grep "$filename $hwID" ./submitDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>You have not submit yet..."
			echo ">>Mind to pay attantion to ddl!"	
			continue
		fi
		grep -wv "$sname .* $jid" ./submitDatabase > submitDatabaseTMP 
		rm ./submitDatabase
		mv submitDatabaseTMP submitDatabase 
		rm ./${filename}
		echo "Please input your new file name (contain your name and hw ID)"
		read -p ">>Please input your new filename: " newFilename
		touch ./filename
		read -p ">>Please input your homework: " myHomework
		echo $myHomework > ${newFilename}
		echo $studentID "YES" $newFilename $hwID>> submitDatabase 
		echo ">>Modify succeed!"
		sleep 1
		return
	done
}

ShowMySubmit()
{
	while true
	do
		read -p ">>Please input your filename: " filename
		read -p ">>Please input your homework ID: " hwID
		if [[ $hwID != 3[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		grep -w "$hwID" ./hwDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such homework in record!"
			continue
		fi	
		grep "$filename $hwID" ./submitDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>You have not submit yet..."
			echo ">>Mind to pay attantion to DDL!"	
			continue
		fi
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
		read -p ">>Class ID: " classID
		if [[ $classID != 1[0-9][0-9][0-9][0-9][0-9] ]]; 
		then
			echo ">>Error in syntax for ID"
			continue
		fi
		grep -w "$classID" ./classDataBase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>No such class in record!"
			continue
		fi
		grep -w "$studentID .* $classID" ./studentDatabase 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo ">>Sorry, you don't have this class"
			echo ">>Please ask teacher for help"	
			return
		fi
		touch ./commemt
		read -p "Please input your comment: " mycomment
		echo $mycomment >> ./comment
		echo "comment succeed!"
		return
	done
}
Quit()
{
	echo "Back to last page..."
	sleep 1
	exit
}
while true
do
	read -p ">>Please input your student ID: " studentID
	grep -w "$studentID" ./studentDatabase 1>/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo ">>No such ID in student record!"
		echo ">>Please check your number or ask teacher for help"
		continue
	fi
	clear
	break
done
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
