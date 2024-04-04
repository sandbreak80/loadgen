#!/bin/bash
# Filename: launch_loadgens.sh

# This loop will start 10 instances of kk4.py using nohup and suppress their output
for i in {1..10}; do
   nohup python3 kk4.py >/dev/null 2>&1 &
   echo "Instance $i of load generation started successfully"
done