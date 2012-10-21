#!/bin/sh

project_root=`dirname "$0"`
pid_file="$project_root/tmp/pids/sidekiq.pid"
pid=`cat "$pid_file" 2>/dev/null`
sidekiq_is_running=""

if [ -n "$pid" ]
then
	if ps $pid 2>&1 | grep sidekiq > /dev/null
	then
		sidekiq_is_running="yes"
	fi
fi

if [ -z "$sidekiq_is_running" ]
then
	echo "Sidekiq is not running, trying to start it..."
	cd $project_root
	nohup bundle exec sidekiq -e production -C "$project_root/config/sidekiq.yml" -P $pid_file >> "$project_root/log/sidekiq.log" 2>&1 &
	echo "Sidekiq started."
else
	echo "Sidekiq is alive."
fi
