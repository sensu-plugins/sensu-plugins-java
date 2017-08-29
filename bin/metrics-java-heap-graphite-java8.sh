#!/usr/bin/env bash
#
# Collect metrics on your JVM and allow you to trace usage in graphite

# Modified: Nikoletta Kyriakidou

# Date: 2018-08-30
# Modified: Juan Moreno Martinez - Add MAX HEAP metric

# You must have openjdk-8-jdk and openjdk-8-jre packages installed
# http://openjdk.java.net/install/

# Also make sure the user "sensu" can sudo without password

# #RED
while getopts 's:n:h' OPT; do
case $OPT in
s) SCHEME=$OPTARG;;
n) NAME=$OPTARG;;
h) hlp="yes";;
esac
done
#usage
HELP="
        usage $0 [ -n value -s value -h ]
                -n --> NAME or name of jvm process < value
		-s --> SCHEME or server name ex. :::name::: < value
                -h --> print this help screen
"
if [ "$hlp" = "yes" ]; then
        echo "$HELP"
        exit 0
        fi

SCHEME=${SCHEME:=0}
NAME=${NAME:=0}

#Get PIDs of JVM.
#At this point grep for the names of the java processes running your jvm.
PID=$(sudo jps | grep " $NAME$" | awk '{ print $1}')
for PID in $PIDS
do
  #Get max heap capacity of JVM
  MaxHeap=$(sudo jstat -gccapacity $PID  | tail -n 1 | awk '{ print ($2 + $8) / 1024 }')

  #Get heap capacity of JVM
  TotalHeap=$(sudo jstat -gccapacity $PID  | tail -n 1 | awk '{ print ($4 + $5 + $6 + $10) / 1024 }')

  #Determine amount of used heap JVM is using
  UsedHeap=$(sudo jstat -gc $PID  | tail -n 1 | awk '{ print ($3 + $4 + $6 + $8) / 1024 }')

  #Determine Old Space Utilization
  OldGen=$(sudo jstat -gc $PID  | tail -n 1 | awk '{ print ($8) / 1024 }')

  #Determine Eden Space Utilization
  ParEden=$(sudo jstat -gc $PID  | tail -n 1 | awk '{ print ($6) / 1024 }')

  #Determine Survivor Space utilization
  ParSurv=$(sudo jstat -gc $PID  | tail -n 1 | awk '{ print ($3 + $4) / 1024 }')

  #For multiple projects running we need to print the name
	projectSize=$(printf "%s\n" $(printf "$PIDS" | wc -w))

	if [ "$projectSize" -ne 1 ]; then
		projectName=$(sudo jps | grep $PID | awk '{ print $2}' | cut -d. -f1)
		project=$projectName
	fi

  echo "JVMs.$SCHEME.$project.Max_Heap $MaxHeap `date '+%s'`"
  echo "JVMs.$SCHEME.$project.Committed_Heap $TotalHeap `date '+%s'`"
  echo "JVMs.$SCHEME.$project.Used_Heap $UsedHeap `date '+%s'`"
  echo "JVMs.$SCHEME.$project.Eden_Util $ParEden `date '+%s'`"
  echo "JVMs.$SCHEME.$project.Survivor_Util $ParSurv `date '+%s'`"
  echo "JVMs.$SCHEME.$project.Old_Util $OldGen `date '+%s'`"
done
