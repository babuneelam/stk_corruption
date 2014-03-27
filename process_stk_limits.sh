#!/bin/bash

echo "Current soft/hard limits of various processing running in the system now:"
echo "PID	Soft Limit	Hard Limit	Units	Proc_name"

pids=`ps ax | grep -v "\[" | grep -v "\]" | awk '{print $1}' | tail -n +2`
#pids=`grep "\[" | grep "\]" | awk '{print $1}' | tail -n +2`
sorted_stack=""
count=1
for line in $pids; do
  if [ -f /proc/$line/exe ]; then
    soft_limit=`cat /proc/$line/limits | grep stack | awk '{print $4}'`
    hard_limit=`cat /proc/$line/limits | grep stack | awk '{print $5}'`
    units=`cat /proc/$line/limits | grep stack | awk '{print $6}'`
    proc_name=`cat /proc/$line/cmdline`
    sorted_stack=$sorted_stack`echo "$line	$soft_limit		$hard_limit	$units	$proc_name"`"\n"
  fi
done

echo -e $sorted_stack | awk '{ print $1"\t" $2"\t" $3"\t" $4"\t" $5}' | sort -n -k 2 -r

