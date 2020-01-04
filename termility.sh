#!/bin/bash
echo -e "\e[36m############################################### \e[0m"
toilet -f smblock --filter border:metal "Termility"
echo -e "\e[36m############################################### \e[0m"
echo -e "\e[1;31;42m############# ©Technical Dada (KP) ############ \e[0m"
echo -e "\e[36m###############################################\e[0m"
echo -e "\e[40;38;5;82m Please Visit \e[30;48;5;82m https://www.kalilinux.in \e[0m"
echo ""
sleep 1
echo -e "Welcome to \e[5mTerminity \e[25m."
echo ""
echo "Termility is Terminal Utility"
echo ""
sleep 2
echo -e "\e[4mPlease select an option \e[24m:"
echo ""
echo -e "\e[31m1. Check the Weather: \e[0m"
echo ""
echo -e "\e[32m2. Check for External IP: \e[0m"
echo ""
echo -e "\e[33m3. Upload a File: \e[0m"
echo ""
echo -e "\e[35m4. Expand Short URL: \e[0m"
echo ""
echo -e "\e[36m5. Watch Star Wars in Terminal: \e[0m"
echo ""
echo -e "\e[34m6. Download Youtube/Facebook Videos: \e[0m"
echo ""
echo -e "\e[34m7. Other Terminal utility \e[0m"
echo ""
echo -e "\e[92m8. Exit \e[0m"
echo ""
echo -e "\e[4mPlease select a number \e[24m:"
KP='./termility.sh'
read OPT
if [ "$OPT" -eq 1 ]
then
echo -e "\e[31mName of Your City: \e[0m"
echo ""
echo -e "\e[31mPlease use portait or fullscreen mode for better result.\e[0m"
sleep 3
read LOC
curl wttr.in/$LOC
sleep 10
echo ""
$KP
elif [ "$OPT" -eq 2 ]
then
curl ipinfo.io
sleep 5
echo ""
$KP
elif [ "$OPT" -eq 3 ]
then
echo -e "\e[33mBlocked files: application, Executable, Android APKs and system images \e[0m"
echo ""
echo -e "\e[33mEnter name and location of the File ( Ex: /root/common.txt): Max size = 512MiB \e[0m"
read path
curl -F'file=@'$path'' http://0x0.st
echo -e "\e[90mThe above link is for the file.\e[0m"
echo -e "\e[90mFile URLs are valid for at least 30 days to a year. \e[0m"
sleep 10
echo ""
$KP
elif [ "$OPT" -eq 4 ]
then
echo -e "\e[35mPaste your short URL here: \e[0m"
read URL
wget --max-redirect=1 -O - $URL
echo -e "\e[35mSucessfully located source URL location..\e[0m"
sleep 10
echo ""
$KP
elif [ "$OPT" -eq 5 ]
then
echo -e "\e[36mStar Wars starts in 7 seconds..\e[0m"
echo -e "\e[93mTo stop the animation, press ctrl+] ,After that type 'quit' to exit telnet. \e[0m"
sleep 7
telnet towel.blinkenlights.nl
elif [ "$OPT" -eq 6 ]
then
echo -e "\e[32m1.For Linux (Debian-based) \e[0m"
echo ""
echo -e "\e[33m2.For Android (Termux) \e[0m"
echo ""
read SYS
 if [ "$SYS" -eq 1 ]
    then
    echo ""
    echo "Updating Requirements..."
    sleep 2
    echo ""
    apt-get install youtube-dl -y
    echo -e "\e[34mPaste Youtube/Facebook video link here: \e[0m"
    read YT
    youtube-dl $YT
    echo ""
    
 elif [ "$SYS" -eq 2 ]
    then
    echo ""
    echo "Updating Requirements..."
    echo ""
    pkg install python -y
    pip install youtube-dl
    echo ""
    echo -e "\e[34mPaste Youtube/Facebook video link here: \e[0m"
    read YT2
    youtube-dl $YT2
 fi
echo ""
$KP
echo ""
elif [ "$OPT" -eq 7 ]
then
echo -e "\e[34mOther Terminal Utility :\e[0m"
echo ""
echo -e "\e[32m1. Matrix Terminal: \e[0m"
echo ""
echo -e "\e[33m2. System Monitor: \e[0m"
echo ""
echo -e "\e[35m3. Midnight Commander (File Manager) : \e[0m"
read OPT2
 if [ "$OPT2" -eq 1 ]
 then
 echo ""
    echo "Checks for Updates..."
    sleep 2
    sudo apt-get install cmatrix -y
    echo ""
    echo -e "\e[32mStarting Matrix Terminal... \e[0m"
    sleep 2
    cmatrix -r -u 10
 elif [ "$OPT2" -eq 2 ]
 then
 echo ""
    echo "Checks for Updates..."
    sleep 2
    sudo apt-get install htop -y
    echo ""
    echo -e "\e[33mStarting System Monitor... \e[0m"
    sleep 2
    htop
 elif [ "$OPT2" -eq 3 ]
 then
 echo ""
    echo "Checks for Updates..."
    sleep 2
    sudo apt-get install mc -y
    echo ""
    echo -e "\e[35mStarting File Manager... \e[0m"
    sleep 2
    mc 
 fi
echo ""
elif [ "$OPT" -eq 8 ]
then
sleep 2
echo -e "\e[41mThanks for using Tirmility.\e[0m"
sleep 1
echo ""
echo "Trimility is made by Technical Dada (KP)"
echo ""
echo -e "\e[1;31;42m Please visit https://www.kalilinux.in \e[0m"
exit 0
else
echo -e "\e[1;4mOpps.. Please select valid option\e[0m"
echo ""
echo "Exiting..."
sleep 2
echo ""
echo -e "\e[41mThanks for using Tirmility.\e[0m"
echo "Please use valid input Next time"
echo ""
echo "Trimility is made by Technical Dada (KP)"
echo ""
echo -e "\e[1;31;42m Please visit https://www.kalilinux.in \e[0m"
fi
