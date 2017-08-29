#!/usr/bin/env bash
#
# Evaluate percentage of heap usage on specfic Tomcat backed JVM from Linux based systems based on percentage
# This was forked from Sensu Community Plugins

# Date: 2017-02-10
# Modified: Nikoletta Kyriakidou

# Date: 2018-08-30
# Modified: Juan Moreno Martinez - Change MAX HEAP instead Current HEAP

# You must have openjdk-8-jdk and openjdk-8-jre packages installed
# http://openjdk.java.net/install/
#
# Also make sure the user "sensu" can sudo without password

# #RED
while getopts 'w:c:n:o:j:hp' OPT; do
  case $OPT in
    w)  WARN=$OPTARG;;
    c)  CRIT=$OPTARG;;
    n)  NAME=$OPTARG;;
    o)  OPTIONS=$OPTARG;;
    j)  JAVA_BIN=$OPTARG;;
    h)  hlp="yes";;
    p)  perform="yes";;
    *)  unknown="yes";;
  esac
done

# usage
HELP="
    usage: $0 [ -n value -w value -c value -o value -p -h ]

        -n --> Name of JVM process < value
        -w --> Warning Percentage < value
        -c --> Critical Percentage < value
        -o --> options to pass to jps
        -j --> path to java bin dir (include trailing /)
        -p --> print out performance data
        -h --> print this help screen
"

if [ "$hlp" = "yes" ]; then
  echo "$HELP"
  exit 0
fi

WARN=${WARN:=0}
CRIT=${CRIT:=0}
NAME=${NAME:=0}
JAVA_BIN=${JAVA_BIN:=""}

#Get PIDs of JVM.
#At this point grep for the names of the java processes running your jvm.
PIDS=$(sudo ${JAVA_BIN}jps $OPTIONS | grep " $NAME$" | awk '{ print $1}')

projectSize=$(printf "%s\n" $(printf "$PIDS" | wc -w))

i=0
for PID in $PIDS
do
	#Get heap capacity of JVM
	TotalHeap=$(sudo ${JAVA_BIN}jstat -gccapacity $PID  | tail -n 1 | awk '{ print ($2 + $8) / 1024 }')

	#Determine amount of used heap JVM is using
	UsedHeap=$(sudo ${JAVA_BIN}jstat -gc $PID  | tail -n 1 | awk '{ print ($3 + $4 + $6 + $8) / 1024 }')

	#Get heap usage percentage
	HeapPer=$(echo "scale=3; $UsedHeap / $TotalHeap * 100" | bc -l| cut -d "." -f1)


	if [ "$HeapPer" = "" ]; then
	  echo "MEM UNKNOWN -"
	  codes[i]=3
	fi

	#For multiple projects running we need to print the name
	if [ "$projectSize" -ne 1 ]; then
		projectName=$(sudo jps | grep $PID | awk '{ print $2}' | cut -d. -f1)
		project=$projectName
	fi

	if [ "$perform" = "yes" ]; then
	  output="$project jvm heap usage: $HeapPer% | heap usage="$HeapPer"%;$WARN;$CRIT;0"
	else
	  output="$project jvm heap usage: $HeapPer% | $UsedHeap MB out of $TotalHeap MB"
	fi

	if (( $HeapPer >= $CRIT )); then
	  echo "MEM CRITICAL - $output"
 	  codes[i]=2
	elif (( $HeapPer >= $WARN )); then
	  echo "MEM WARNING - $output"
	  codes[i]=1
	else
	  echo "MEM OK - $output"
	  codes[i]=0
	fi
	i+=1
done

if (($projectSize -ne $1 && ${codes[0]} != "0")); then
	exit ${codes[1]}
else
	exit ${codes[0]}
fi
