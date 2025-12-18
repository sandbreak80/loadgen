#!/bin/bash
# Filename: startload.sh

# This loop will start 10 instances of kk4.py using nohup and suppress their output
for i in {1..10}; do
   nohup python3 /home/ubuntu/load/kk4.py >/dev/null 2>&1 &
   echo "Instance $i of kk4.py load generation started successfully"
done

# Adding a small delay to ensure that the above processes have been initiated
sleep 2

# This loop will start 10 instances of test_checkout.py using nohup and suppress their output
for i in {1..10}; do
   nohup python3 /home/ubuntu/load/test_checkout.py >/dev/null 2>&1 &
   echo "Instance $i of test_checkout.py load generation started successfully"
done