#!/bin/bash


###
### Task 1: Server Monitor Script
### Author: Muhammad Hassan Khan
### email: khassan.3090@gmail.com
###

# Logging script utilization metric to a log file. [Bonus]
Logfile="logfile.txt"    #Logfile name and extension
MAIL_LOG="Server Monitor Script called at: $(date) by user $(whoami)"  #Message to print/append in the log file
Location="./"    ##Define path to store the log files. Default is the same directory as script

cd $Location   
if [ -f $Logfile ]  
then   
echo "$MAIL_LOG " >> $Logfile

else        

touch $Logfile   
echo "$MAIL_LOG" >> $Logfile    

fi 

##
## Beging The Server Monitor
##
echo "Welcome to Server Monitor .:!!.i:i.!!:."

##
## PS3 -  The value of this parameter is used as the prompt for the select command (see SHELL GRAMMAR ).
##
PS3='Please select what task would you like to perform [for e.g. 1]...' 


## Options for select menu:
options=(
"Total RAM available" 
"Total storage space available for a mount point" 
"List top 5 processes for a specific user" 
"List the ports exposed and the process associate with it"
"Option to free up cached memory"
"For a given directory list the files with their size in (MBs), and sort them with descending order"
"For a given directory, list the Folders with their size in (MBs), and sort them with descending order")


select opt in "${options[@]}"
do
    case $opt in
        "Total RAM available") #1
            echo "Total RAM stats"
            free #free command displays the total amount of free space available along with the amount of memory used 
            break
            ;;
        "Total storage space available for a mount point") #2
            df -h #df: Disk Free command. -h: human readable format
            break
            ;;
        "List top 5 processes for a specific user") #3
            echo "Enter username... "
            read username
            ps -Ao user,uid,comm,pid,pcpu,tty --sort=-pcpu | grep $username | head -n 6
            #ps -Ao user,uid,comm,pid,pcpu,tty -r | grep hassankhan | head -n 6 ## FOR macOS
            ##For Linux
            break
            ;;
        "List the ports exposed and the process associate with it") #4
            netstat -tunlp #n: network, l: listening ports, u: UDP, t: TCP, p: process
            #sudo lsof -i ##Doesn't work out of the box for centos/rhel distros
            break
            ;;
        "Option to free up cached memory") #5
            echo "Clearing cache memory...\n"
            sudo sh -c "/usr/bin/echo 3 > /proc/sys/vm/drop_caches" # “...echo 1 >...” will clear the PageCache only.
            echo "Done!"
            free #Lets show the available memory (as in option 1) again to show memory difference after clearing cache.
            break
            ;;
        "For a given directory list the files with their size in (MBs), and sort them with descending order") #6
            echo "Please enter the path to the directory: "
            read files_directory
            echo "You chose " $files_directory
            eval cd $files_directory # eval takes a string as its argument, and evaluates it as if you'd typed that string on a command line. 
            ls -plhS --block-size=M | egrep -v /$ # ls -lhS: sort by size, in human readable format
            break
            ;;
        "For a given directory, list the Folders with their size in (MBs), and sort them with descending order") #7
            echo "Please enter the path to the directory: "
            read folder_directory
            echo "You chose " $folder_directory
            eval cd $folder_directory # eval takes a string as its argument, and evaluates it as if you'd typed that string on a command line. 
            ls -lS --block-size=M | grep '^d'
            #ls -shSd */ # ls -l: long-desc, s: show size, h: human-readable, S: sort by size, -d */: directories only
            break
            ;;
        *) echo "invalid option $REPLY";; #Some validation to cater input that is not mentioned in the options 
    esac
done
