#!/bin/bash



      #################################################################################
     ##								                              ##
    ##  A BASH shell script to get you the days' Islamic Prayer Times in Terminal  ##
   ##                                                                             ##
  ##  Created by Khwaja Mahad Haq (KMAHADH)                                      ##
 ##                                                                             ##
#################################################################################

checkwget=`command -v wget`
checksed=`command -v sed`
checkpr=`command -v pr`

if [ -z "$checkwget" ]
then
      det1='\e[91m"wget" doesnot exist on the system!\e[39m'
      detall1='Please install "wget" on the system'
      echo $det1
      echo $detall1
      exit
else
echo -ne ""
fi

if [ -z "$checksed" ]
then
      det1='\e[91m"sed" doesnot exist on the system!\e[39m'
      detall1='Please install "sed" on the system'
      echo $det1
      echo $detall1
      exit
else
echo -ne ""
fi

if [ -z "$checkpr" ]
then
      det1='\e[91m"pr" doesnot exist on the system!\e[39m'
      detall1='Please install "pr" on the system'
      echo $det1
      echo $detall1
      exit
else
echo -ne ""
fi

function fetch {

uas="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36 OPR/56.0.3051.36"

helloPT="`wget -q -U "$uas" https://www.islamicfinder.org/prayer-times/ -O - | sed -n 's/<span class="prayertime">\([^<]*\).*/\1/p'`"

helloPT2=`echo "$helloPT" | sed 's/$/ |/'`

#echo "$helloPT"

helloN="`wget -q -U "$uas" https://www.islamicfinder.org/prayer-times/ -O - | sed -n 's/class="prayername ">\|class="prayername">\([^<]*\).*/\1/p'`"

helloN2=`echo "$helloN" | awk '{print $2}'| sed 's/^/| /'`
helloN3=`echo "$helloN2" | awk -F/ '{print $1}' | tr -d "\<"`

CurrentP="`wget -q -U "$uas" https://www.islamicfinder.org/prayer-times/ -O - | sed -n 's/class="prayername ">\|class="prayername">Upcoming Prayer<br>\([^</span>]*\).*/\1/p'`"
CurrentP2=`echo "$CurrentP" | awk '{print $2}'| sed 's/^/ /' | sed 's/^[[:space:]]*//'` 
CurrentP3=`echo "$CurrentP2" | rev | cut -c8- | rev`


Current1="`wget -q -U "$uas" https://www.islamicfinder.org/prayer-times/  -O - | sed -n 's/"nextPrayerRemainingTime": "\([^"]*\).*/\1/p' |  cut -c 2207- | sed 's/".*//'`"

Current2="`wget -q -U "$uas" https://www.islamicfinder.org/prayer-times/  -O - | sed -n 's/Prayer Times in &nbsp;\([^"<]*\).*/\1/p'`"

echo ""

Date2="`wget -q -U "$uas" https://www.islamicfinder.org/prayer-times/  -O - | sed -n 's/<p class="font-weight-bold pt-date-right">\([^"<]*\).*/\1/p'`"

Date1="`wget -q -U "$uas" https://www.islamicfinder.org/prayer-times/  -O - | sed -n 's/			<p>\([^"<]*\).*/\1/p'`"

Nexto=`wget -q -U "$uas" https://www.islamicfinder.org/prayer-times/  -O - | sed -n 's/"nextPrayerRemainingTime": "\([^"]*\).*/\1/p' |  cut -c 2209-`

Calcu="`wget -q -U "$uas" https://www.islamicfinder.org/prayer-times/  -O - | sed -n 's/<p class="font-sm font-dark">\([^"<]*\).*/\1/p'`"
Calc2="`echo $Calcu | sed 's/^.\{0\}//g'`"
Calc="`echo "$Calc2" | rev | cut -c7- | rev`"



#Date2=<p id="hijri-date" class="xs medium bold">
#Date1=<p id="greg-date" class="text-lightest xs">

echo ""
echo ""
echo "+---------------------------------+"
echo ""
echo "Source: Islamic Finder"
echo "At: https://www.islamicfinder.org/"
echo ""
echo "+---------------------------------+"
echo ""


echo Prayer Times in: 
echo $Current2
echo ""

Date1F=${Date1//&nbsp;/ }
Date2F=${Date2//&nbsp;/ }

echo Date:
echo $Date1F
echo $Date2F

echo ""

echo -e "\e[7m                                   "
echo "                                   "

tput cuu1
tput cuu1

echo -e "\e[7mUpcoming Prayer:   ${CurrentP3}          "
echo -ne "  "
echo -ne ${Current1^}"   Coming  in:  $Nexto"

echo -e "\e[27m"

# Reset
reset='\033[0m'

#White Background
BG='\033[47m'

#Black Foreground
FG='\033[0;30m'

#Black Background
BG2='\033[40m'

#White Foreground
FG2='\033[0;37m'


echo ""
echo "+---------------------------------+"
echo "| Today's times                   |"
echo "+---------------------------------+"
MainTimes=`pr -t -m -w 50 <(echo "${helloN3^}") <(echo "$helloPT2" | cut -c 5-)`

echo "$MainTimes"

##########################################################################
#Code for colour alternating colours
#    
#echo "$MainTimes" | head -n 2
#
#
#    for i in {1..6}
#    do
#    echo
#echo "$(echo "$MainTimes" | sed -n ''$i'p')"
#    done
#
#
#var1="\033[0;7m"
#var2="\033[0;27m"
#counter=0
#
#for j in {1..6}; do
#  if ((counter % 2 == 0)); then
#    current="$var1"
#echo -e "$(echo -e "\033[0;7m$MainTimes" | sed -n ''$j'p')"
#echo -ne "$(echo -e "\033[0;27m")"
#  else
#    current="$var2"
#echo -e "$(echo -e "\033[0;27m$MainTimes" | sed -n ''$j'p')"    
#echo -ne "$(echo -e "\033[0;7m")"
#  fi
#
#  ((counter++))
#done
#
#echo -ne "$(echo -e "\033[0;27m")"
##########################################################################

echo "+---------------------------------+"

echo ""


echo "Calculation Method:"
echo "$Calc"
#echo "$Calc2"

echo ""

}

fetch & pid=$!

frames="\\ | / -"

while kill -0 $pid 2&>1 > /dev/null;
do
    for frame in $frames;
    do
        printf "\rFetching data... $frame " 
        sleep 0.2
    done  
done

echo -en "\033[K\r\b\b\b" #'print' backtrace 
echo "+---------------------------------+"
echo ""

