#!/usr/bin/env bash
#
# Collect metrics on your JVMs and allow you to trace usage in graphite

# Modified: Mario Harvey - badmadrad.com

# Date: 2017-06-06
# Modified: Nic Scott - re-work to be java version agnostic

# depends on jps and jstat in openjdk-devel in openjdk-<VERSION>-jdk and
# openjdk-<VERSION>-jre packages being installed
# http://openjdk.java.net/install/

# Also make sure the user "sensu" can sudo jps and jstat without password

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
JAVA_BIN=${JAVA_BIN:=""}

#Get PID of JVM.
#At this point grep for the name of the java process running your jvm.
PIDS=$(sudo ${JAVA_BIN}jps $OPTIONS | grep " $NAME$" | awk '{ print $1 }')
COUNT=$(echo $PID | wc -w)
for PID in $PIDS
do

  project=$(sudo jps | grep $PID | awk '{ print $2 }' | cut -d. -f1)

  JSTAT=$(sudo ${JAVA_BIN}jstat -gc $PID  | tail -n 1)

  # Java version indifferent memory stats
  #Determine Old Space Utilization
  OldGen=$(echo $JSTAT | awk '{ print ($8) / 1024 }')

  #Determine Eden Space Utilization
  ParEden=$(echo $JSTAT | awk '{ print ($6) / 1024 }')

  #Determine Survivor Space utilization
  ParSurv=$(echo $JSTAT | awk '{ print ($3 + $4) / 1024 }')

  # Java version-specific memory stats
  # Java 8 jstat -gc returns 17 columns Java 7 returns 15
  if [[ ${#JSTAT[@]} -gt 15 ]]; then
    # Metaspace is NOT a part of heap in Java 8
    #Get heap capacity of JVM
    TotalHeap=$(echo $JSTAT | awk '{ print ($1 + $2 + $5 + $7) / 1024 }')
    #Determine amount of used heap JVM is using
    UsedHeap=$(echo $JSTAT | awk '{ print ($3 + $4 + $6 + $8) / 1024 }')
    #Get MetaSpace capacity of JVM
    TotalMeta=$(echo $JSTAT | awk '{ print ($9) / 1024 }')
    #Determine Meta Space Utilization
    UsedMeta=$(echo $JSTAT | awk '{ print ($10) / 1024 }')

    echo "JVMs.$SCHEME.$project.Meta_Capacity $TotalMeta `date '+%s'`"
    echo "JVMs.$SCHEME.$project.Meta_Util $UsedMeta `date '+%s'`"

  else
    # PermGen IS part of heap in Java <8
    #Get heap capacity of JVM
    TotalHeap=$(echo $JSTAT | awk '{ print ($1 + $2 + $5 + $7 + $9) / 1024 }')
    #Determine amount of used heap JVM is using
    UsedHeap=$(echo $JSTAT | awk '{ print ($3 + $4 + $6 + $8 + $10) / 1024 }')
    #Get PermGen capacity of JVM
    TotalPerm=$(echo $JSTAT | awk '{ print ($9) / 1024 }')
    #Determine PermGen Space Utilization
    UsedPerm=$(echo $JSTAT | awk '{ print ($10) / 1024 }')

    echo "JVMs.$SCHEME.$project.Perm_Capacity $TotalPerm `date '+%s'`"
    echo "JVMs.$SCHEME.$project.Perm_Util $UsedPerm `date '+%s'`"
  fi
  echo "JVMs.$SCHEME.$project.Committed_Heap $TotalHeap `date '+%s'`"
  echo "JVMs.$SCHEME.$project.Heap_Util $UsedHeap `date '+%s'`"
  echo "JVMs.$SCHEME.$project.Eden_Util $ParEden `date '+%s'`"
  echo "JVMs.$SCHEME.$project.Survivor_Util $ParSurv `date '+%s'`"
  echo "JVMs.$SCHEME.$project.Old_Util $OldGen `date '+%s'`"

done
