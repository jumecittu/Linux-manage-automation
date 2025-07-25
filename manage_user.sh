#!/usr/bin/env bash
set -e

version="0.1.1"

username="$1"
SERVER="`hostname`"
ssh_path="/home/$username/.ssh"

#------------------------Function---------------------------------------

Help()
{
   # Display Help
   echo
   echo
   echo "Syntax: manage-user [username][-h|-L|-r|-R|-v]"
   echo "options:"
   echo "-h          help"
   echo "-L          Create user with limited environment"
   echo "-r          Remove user"
   echo "-R          Remove user and home folder"
   echo "-v          script version"
   echo
}


user () {

if [ "${username//[A-Za-z0-9\._@]}" ]; then
        echo "username not valid"
        exit 0
    else
            echo "[+] Reset ssh key if they already exist"
            if id -u $username &>/dev/null; then
               if [ -d $ssh_path ]
               then
                  rm -rf $ssh_path
                  key_folder
               else
                  key_folder
               fi
            else
               adduser --shell /bin/bash --gecos "" --disabled-password $username
               key_folder
               
            fi
		
    fi 
}


key_folder () {
	   
		echo "[+] Creating key folder for user"
		mkdir -p $ssh_path
		ssh-keygen -q -t rsa -N "" -C $username@$SERVER -f /home/$username/.ssh/id_rsa
      #puttygen /home/$username/.ssh/id_rsa -o /home/$username/.ssh/$username.ppk
		touch $ssh_path/authorized_keys
		cat /home/$username/.ssh/id_rsa.pub >> /home/$username/.ssh/authorized_keys
		chmod  700 $ssh_path
		chown -R $username $ssh_path
		chgrp -R $username $ssh_path
      #zip -jrm /tmp/key.zip /home/$username/.ssh/$username.ppk /home/$username/.ssh/id_rsa
}

restrict_user () {

	    if [ "${username//[A-Za-z0-9\._@]}" ]; then
        echo "username not valid"
        exit 0
    else
            echo "[+] Reset ssh key if they already exist"
            if id -u $username &>/dev/null; then
               if [ -d $ssh_path ]
               then
                  rm -rf $ssh_path
                  key_folder
               else
                  key_folder
               fi
            else
               adduser --shell /bin/rbash --gecos "" --disabled-password $username
               key_folder
               echo "[+] Creating restrict environment for user"
		       mkdir -p /home/$username/bin
		       echo "PATH=/home/$username/bin" >> /home/$username/.bash_profile
		       chattr +i /home/$username/.bash_profile
		       ln -s /bin/ls /home/$username/bin/ls
            fi
		
    fi 
	
}

output () {


echo " "
echo " User created "
echo " "

}

remove_user () {
        
        echo "[+] Remove user"

        if [ -f "/home/$username/.bash_profile" ]; then
        chattr -i /home/$username/.bash_profile
        deluser $username
        else 
        deluser $username
        fi
	    
}

remove_user_and_folder () {
        
        echo "[+] Remove user and home folder"

        if [ -f "/home/$username/.bash_profile" ]; then
        chattr -i /home/$username/.bash_profile
        deluser --remove-home $username
        else 
        deluser --remove-home $username
        fi
}


Main () {

local a=$1
local b=$2

if [ ! $a ]; then
    Help
    exit 0
 else 
 	case $a in
 		"-h") # display Help
         Help
         exit;;
        "-v") # show version
         echo $version
         exit;;      
      *) # Invalid option create user if not exist
         case $b in
           "-r") # remove user
             remove_user
            exit;;
          "-R") # remove user and folder
             remove_user_and_folder
            exit;;
          "-L") # create restrict user
             restrict_user
             output
            exit;;      
          *) # Invalid option create user if not exist
             user
             output
            exit;;
         esac
         exit;;
     esac
 	
 fi	



}


#------------------------Main---------------------------------------



Main $1 $2
