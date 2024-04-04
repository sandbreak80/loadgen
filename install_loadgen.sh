#!/bin/bash

# Ensuring the script is run with superuser privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Update package index
sudo apt update

# Download git project
/home/ubuntu/loadgen/git clone https://github.com/sandbreak80/loadgen.git

# Install wget, gnupg2, and unzip
sudo apt install -y wget gnupg2 unzip

# Download Google Chrome .deb package
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# Install Google Chrome
sudo dpkg -i google-chrome-stable_current_amd64.deb

# Install any missing dependencies
sudo apt -f install -y

# Install python3-pip
sudo apt install -y python3-pip

# Install Python packages using pip3
pip3 install requests beautifulsoup4
pip3 install selenium

# Create loadgen directory
mkdir -p /home/ubuntu/loadgen

# Download chromedriver
wget https://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_linux64.zip -P /home/ubuntu/loadgen

# Unzip chromedriver to the specified directory
unzip /home/ubuntu/loadgen/chromedriver_linux64.zip -d /home/ubuntu/loadgen/chromedriver-linux64/

# Make chromedriver executable
sudo chmod +x /home/ubuntu/loadgen/chromedriver-linux64/chromedriver

echo "Setup completed successfully!"