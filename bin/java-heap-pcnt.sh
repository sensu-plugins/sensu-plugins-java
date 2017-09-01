#!/usr/bin/env bash
#
# Evaluate percentage of heap usage on specfic Tomcat backed JVM from Linux based systems based on percentage
# This was forked from Sensu Community Plugins

# Date: 2013-9-30
# Modified: Mario Harvey - badmadrad.com

# Date: 2018-08-30
# Modified: Juan Moreno Martinez - Change MAX HEAP instead Current HEAP

# You must have openjdk-7-jdk and openjdk-7-jre packages installed
# http://openjdk.java.net/install/

# Also make sure the user "sensu" can sudo without password

# #RED
while getopts 'w:c:n:l:hp' OPT; do
  case $OPT in
    w)  WARN=$OPTARG;;
    c)  CRIT=$OPTARG;;
    n)  NAME=$OPTARG;;
    l)  HEAP_MAX=$OPTARG;;
    h)  hlp="yes";;
    p)  perform="yes";;
    *)  unknown="yes";;
  esac
done

# usage
HELP="
    usage: $0 [ -n value -w value -c value -p -h ]

        -n --> Name of JVM process < value
        -w --> Warning Percentage < value
        -c --> Critical Percentage < value
        -p --> print out performance data
        -h --> print this help screen
        -l --> limit, valid value max or current (default current)
               current: when -Xms and -Xmx same value
               max: when -Xms and -Xmx have different values

Requirement: User that launch script must be permisions in sudoers for jps,jstat,jmap
sudoers lines suggested:
----------
sensu ALL=(ALL) NOPASSWD: /usr/bin/jps, /usr/bin/jstat, /usr/bin/jmap
Defaults:sensu !requiretty
----------
"

if [ "$hlp" = "yes" ]; then
  echo "$HELP"
  exit 0
fi

WARN=${WARN:=0}
CRIT=${CRIT:=0}
NAME=${NAME:=0}

#Get PID of JVM.
#At this point grep for the name of the java process running your jvm.
PID=$(sudo jps | grep " $NAME$" | awk '{ print $1}')
COUNT=$(echo $PID | wc -w)
if [ $COUNT != 1 ]; then
    echo "$COUNT java process(es) found with name $NAME"
    exit 3
fi

#Get heap capacity of JVM
if [ "$HEAP_MAX" == "" ] || [ "$HEAP_MAX" == "current" ]; then
  TotalHeap=$(sudo ${JAVA_BIN}jstat -gccapacity $PID  | tail -n 1 | awk '{ print ($4 + $5 + $6 + $10) / 1024 }')
elif [[ "$HEAP_MAX" == "max" ]]; then
  TotalHeap=$(sudo ${JAVA_BIN}jmap -heap $PID 2> /dev/null | grep MaxHeapSize | tr -s " " | tail -n1 | awk '{ print $3 /1024 /1024 }')
else
  echo "limit options must be max or current"
  exit 1
fi
#Determine amount of used heap JVM is using
UsedHeap=$(sudo jstat -gc $PID  | tail -n 1 | awk '{ print ($3 + $4 + $6 + $8 + $10) / 1024 }')

#Get heap usage percentage
HeapPer=$(echo "scale=3; $UsedHeap / $TotalHeap * 100" | bc -l| cut -d "." -f1)


if [ "$HeapPer" = "" ]; then
  echo "MEM UNKNOWN -"
  exit 3
fi

if [ "$perform" = "yes" ]; then
  output="jvm heap usage: $HeapPer% | heap usage="$HeapPer"%;$WARN;$CRIT;0"
else
  output="jvm heap usage: $HeapPer% | $UsedHeap MB out of $TotalHeap MB"
fi

if (( $HeapPer >= $CRIT )); then
  echo "MEM CRITICAL - $output"
  exit 2
elif (( $HeapPer >= $WARN )); then
  echo "MEM WARNING - $output"
  exit 1
else
  echo "MEM OK - $output"
  exit 0
fi
