#!/bin/bash
chmod +x HostMode
chmod +x StudentMode
chmod +x TeacherMode
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

case $inputMode in
	Host)./HostMode;;
	Student)./StudentMode;;
	Teacher)./TeacherMode;;
	Quit) 
		echo ">>You type to quit the system."
		echo ">>Are you sure?(Yes/No)"
		echo -n ">>"
		read inputQuitSure
		case $inputQuitSure in
			Yes) 
				echo ">>Thank you for using my system. Bye!"
				sleep 2
				exit 0
				;;
			No) 
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
	*)
		echo ">>Please check your input!"
		sleep 2
		clear
esac
done
