# Deployment Test Guide

This guide walks through testing the complete student deployment workflow.

## Test Scenario

Simulate what students will do:
1. SSH into their AWS instance
2. Download LoadGen from GitHub
3. Run the installation script
4. Start load generation
5. Verify it's working

## Prerequisites

- Remote Ubuntu host with KonaKart running
- SSH access to the host
- GitHub repository updated with latest changes

## Test Steps

### Step 1: Push to GitHub

```bash
cd /Users/bmstoner/code_projects/loadgen

# Add all files
git add .

# Commit changes
git commit -m "Updated LoadGen with dual-mode support and improved documentation"

# Push to GitHub
git push origin main
```

### Step 2: SSH into Remote Host

```bash
ssh -i /Users/bmstoner/Downloads/bootcamp.pem ubuntu@54.70.243.207
```

### Step 3: Download and Install

```bash
# Clean any previous installation
sudo rm -rf /home/ubuntu/load

# Download installation script
wget https://raw.githubusercontent.com/sandbreak80/loadgen/main/install_loadgen.sh

# Make executable
chmod +x install_loadgen.sh

# Run installation
sudo ./install_loadgen.sh
```

**Expected output:**
- Chrome installed
- ChromeDriver downloaded
- Python packages installed
- Files cloned to `/home/ubuntu/load/`
- "Setup completed successfully!"

### Step 4: Verify Installation

```bash
# Check Chrome
google-chrome --version

# Check ChromeDriver
/home/ubuntu/load/chromedriver-linux64/chromedriver --version

# Check Python packages
pip3 list | grep -E "(selenium|webdriver-manager|pytest)"

# Check files
ls -lh /home/ubuntu/load/
```

**Expected files:**
- `kk4.py`
- `test_checkout.py`
- `config.py`
- `requirements.txt`
- `startload.sh`
- `stopload.sh`
- All other scripts

### Step 5: Start Load Generation

```bash
# Start load
sudo /home/ubuntu/load/startload.sh
```

**Expected output:**
```
Instance 1 of kk4.py load generation started successfully
Instance 2 of kk4.py load generation started successfully
...
Instance 1 of test_checkout.py load generation started successfully
Instance 2 of test_checkout.py load generation started successfully
...
```

### Step 6: Verify Load is Running

```bash
# Check Python processes
ps aux | grep python3 | grep -E "(kk4|test_checkout)"

# Should see ~20 Python processes (10 crawlers + 10 checkout)

# Check Chrome processes
ps aux | grep chrome | wc -l

# Should see multiple Chrome processes

# Check ChromeDriver processes  
ps aux | grep chromedriver | wc -l

# Should see multiple ChromeDriver processes
```

### Step 7: Monitor for 2-3 Minutes

```bash
# Watch processes
watch -n 5 'ps aux | grep -E "(python3.*(kk4|test_checkout))" | grep -v grep | wc -l'

# Check if KonaKart is receiving requests
# (If you have access to KonaKart logs)
tail -f /path/to/konakart/logs/access.log
```

### Step 8: Stop Load Generation

```bash
sudo /home/ubuntu/load/stopload.sh
```

**Expected output:**
```
All 'chrome' and 'chromedriver' processes have been killed.
```

### Step 9: Verify Cleanup

```bash
# Check no processes remain
ps aux | grep chrome
ps aux | grep chromedriver
ps aux | grep python3 | grep -E "(kk4|test_checkout)"

# Should show no results (or just the grep commands themselves)
```

## Success Criteria

✅ Installation completes without errors  
✅ All dependencies installed correctly  
✅ Files cloned to correct location  
✅ Scripts are executable  
✅ Load generation starts successfully  
✅ 20 processes running (10+10)  
✅ Chrome/ChromeDriver processes visible  
✅ Processes can be stopped cleanly  
✅ No zombie processes remain  

## Troubleshooting Common Issues

### Issue: git clone fails in install_loadgen.sh

**Cause:** Repository might not be public or URL changed

**Fix:** Check GitHub repository is public, verify URL in install_loadgen.sh

### Issue: Chrome version mismatch with ChromeDriver

**Cause:** Chrome auto-updates but ChromeDriver version is hardcoded

**Fix:** Update ChromeDriver version in install_loadgen.sh or use webdriver-manager

### Issue: Python packages fail to install

**Cause:** Network issues or missing dependencies

**Fix:** 
```bash
sudo apt update
sudo apt install -y python3-pip python3-dev
pip3 install --upgrade pip
```

### Issue: Processes don't start

**Cause:** Missing dependencies or permission issues

**Fix:**
```bash
# Check Python can import modules
python3 -c "import selenium; print('OK')"

# Check file permissions
ls -l /home/ubuntu/load/*.sh
chmod +x /home/ubuntu/load/*.sh
```

## Automated Test Script

For faster testing, use the automated deployment test:

```bash
# From your local machine
cd /Users/bmstoner/code_projects/loadgen
./test_remote.sh
```

This will:
1. Deploy files to remote host
2. Run installation
3. Verify installation
4. Show next steps

## Notes

- The remote system should have KonaKart running on port 8780
- LoadGen will auto-detect EC2 environment and test localhost
- Full load generates significant traffic - monitor system resources
- Each checkout test does ~1000 iterations (can take hours to complete)

