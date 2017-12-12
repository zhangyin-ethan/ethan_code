#!/bin/sh
PIDS=`ps | awk '{print $1}' | grep -v "PID"`

for name in $PIDS; do
	THREADS=`ls /proc/${name}/task`

	num=0
	for thread in $THREADS; do
		num=`expr $num + 1`
	done
	echo "task pid--$name thread_num= $num"

	for thread in $THREADS; do
		echo "thread pid--------$thread"
		cat /proc/${name}/task/${thread}/status
	done
done




exit 0
