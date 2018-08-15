#!/bin/bash
#给不同的模式赋予权限
chmod +x HostMode
chmod +x StudentMode
chmod +x TeacherMode
#循环输出模式选择的不同功能进入界面
while true
do
	echo "==========================================="
	echo ">>Welcome to ZJU teaching management system"
	sleep 1
	echo ">>What do you want to do? You can ask me as follows: "
	echo "Host     -for host mode"
	echo "Student  -for student mode"
	echo "Teacher  -for teacher mode"
	echo "Quit     -for quit the system"
	echo -n ">>"
read inputMode
#根据用户的输入选择不同的模式进行操作
#通过case语句进入不同的文件

case $inputMode in
	Host)./HostMode;;
	Student)./StudentMode;;
	Teacher)./TeacherMode;;
	Quit) 
		#如果输入Quit需向用户确认是否退出
		echo ">>You type to quit the system."
		echo ">>Are you sure?(Yes/No)"
		echo -n ">>"
		read inputQuitSure
		case $inputQuitSure in
			Yes) #如果用户确认，则退出程序
				echo ">>Thank you for using my system. Bye!"
				sleep 2
				exit 0
				;;
			No) #如果用户输入No，则重新打印界面
				sleep 2
				echo ">>What do you want to do? You can ask me as follows: "
				echo "Host     -for host mode"
				echo "Student  -for student mode"
				echo "Teacher  -for teacher mode"
				echo "Quit     -for quit the system"
				echo -n ">>"
				;;
		esac
		;;
	*) #如果输入为非法字符，提醒用户重新输入
		echo ">>Please check your input!"
		sleep 2
		clear
esac
done
