#!/bin/bash
#     author	:   Alliot     	 
#     date	:  2019-7-8    	 
#     blog 	: www.iots.vip 	  


green='\e[1;32m' 	# green
red='\e[1;31m' 		# red
blue='\e[1;34m' 	# blue  
nc='\e[0m' 		# normal  

# clean the screen
clear 

# Backup the old YUM Repos
backup () {
	echo -e "[${blue}Backuping the old YUM Repos...${nc}]" 
	sleep 0.5 
	# rename the old Repos file name to *.back
	cd /etc/yum.repos.d
	rename .repo .back *.repo 
	if [ $? == 0 ] ; then
		echo -e "[${green}Backup success${nc}]"
	else
		echo -e "[${red}Backup failed,no such files${nc}]"
		exit 1
	fi
}

# Replace the YUM Repos with Aliyun YUM Repos 
replace(){
	echo -e "[${blue}Replaceing the YUM Repos with Aliyun YUM Repos...${nc}]"
	sleep 0.5
	wget -O /etc/yum.repos.d/Centos-Base.repo $1 
		if [ $? == 0 ] ; then
		echo -e "[${green}Replace success${nc}]"
	else
		echo -e "[${red}Replace failed${nc}]"
		exit 1
	fi
}

# Return the systemVersion
systemVersion(){
	v=`cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/'`
	if [ $v -eq 5 ]; then
		return 5
	fi
	if [ $v -eq 6 ]; then
		return 6
	fi
	if [ $v -eq 7 ]; then
		return 7
	fi
}


# judge runing user
if [ $UID -ne 0 ];then 
	echo -e "[${red}please runing this script by root user${nc}"
	exit 1
fi

cat << EOF
================================================================================
This script will automatically replace the yum source to the Aliyun yum source.
				author	:   Alliot    
				date	:  2019-7-8   
				blog 	: www.iots.vip
	USER: $USER 
	HOST: $HOSTNAME
	KERNEL: `uname -r`  
	DISK :`ls  /dev/sd?`
================================================================================
EOF

read -t 30 -p "Do you want to continue? (input 'yes' or 'no')" start 
if [ $start == yes ];then  
	systemVersion
	case $? in 
		5)
			backup
			wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-5.repo
			replace  http://mirrors.aliyun.com/repo/Centos-5.repo
			sed -i 's/$releasever/5/g' /etc/yum.repos.d/Centos-Base.repo
			rpm --import http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-5 
			result=$?
			if [ $result == 0 ] ; then
				echo -e "[${green}Success for CentOS/RedHat-5${nc}]"
			else
				echo -e "[${red}Failed for CentOS/RedHat-5${nc}]"
			exit 1
			fi
		;;
		6)
			backup
			wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
			replace  http://mirrors.aliyun.com/repo/Centos-6.repo
			sed -i 's/$releasever/6/g' /etc/yum.repos.d/Centos-Base.repo
			rpm --import http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-6 
			result=$?
			if [ $result == 0 ] ; then
				echo -e "[${green}Success for CentOS/RedHat-6${nc}]"
			else
				echo -e "[${red}Failed for CentOS/RedHat-6${nc}]"
			exit 1
			fi
		;;
		7)
			backup
			wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
			replace  http://mirrors.aliyun.com/repo/Centos-7.repo
			sed -i 's/$releasever/7/g' /etc/yum.repos.d/Centos-Base.repo
			rpm --import http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7 
			result=$?
			if [ $result == 0 ] ; then
				echo -e "[${green}Success for CentOS/RedHat-7${nc}]"
			else
				echo -e "[${red}Failed for CentOS/RedHat-7${nc}]"
			exit 1
			fi
		;;
		esac
	yum clean all 
	yum makecache
	echo -e "[${green}All done.Bye!${nc}]"
elif [ $start == "no" ];then
	echo "Installation cancelled" 
else
    echo "your input was wrong!"
fi
