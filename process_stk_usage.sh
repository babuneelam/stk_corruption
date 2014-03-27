#!/bin/bash

echo "Current soft/hard limits of various processing running in the system now:"
echo "PID	Current_Usage	Proc_name"

pids=`ps ax | awk '{print $1}' | tail -n +2`
#pids=`grep "\[" | grep "\]" | awk '{print $1}' | tail -n +2`
sorted_stack=""
count=1
for line in $pids; do
  if [ -f /proc/$line/exe ]; then
    usage=`cat /proc/$line/status | grep -i vmstk| awk '{print $2}'`
    proc_name=`cat /proc/$line/cmdline`
    sorted_stack=$sorted_stack`echo "$line	${usage}kb			  $proc_name"`"\n"
  fi
done

echo -e $sorted_stack | awk '{ print $1"\t" $2"\t" $3"\t" $4}' | sort -n -k 2 -r

