#!/bin/bash
# Stop all local load generation processes

echo "Stopping all Chrome and ChromeDriver processes..."

# Kill Python processes running our scripts
pkill -f "python3.*kk4.py"
pkill -f "python3.*test_checkout.py"

# Kill Chrome and ChromeDriver processes
pkill -f chromedriver
pkill -f chrome

echo "All load generation processes stopped."

