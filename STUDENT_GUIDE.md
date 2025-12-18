# LoadGen - Student Lab Guide

## Overview

This guide will help you install and run load generation on your KonaKart lab instance. The load generator will create realistic e-commerce traffic so you can observe metrics, traces, and logs in your observability platform.

---

## Step 1: SSH Into Your Lab Instance

Connect to your assigned AWS EC2 instance:

```bash
ssh -i your-key.pem ubuntu@your-instance-hostname
```

**Example:**
```bash
ssh -i bootcamp.pem ubuntu@ec2-54-70-243-207.us-west-2.compute.amazonaws.com
```

---

## Step 2: Download and Install LoadGen

Run these commands on your EC2 instance:

```bash
# Download the installation script
wget https://raw.githubusercontent.com/sandbreak80/loadgen/main/install_loadgen.sh

# Make it executable
chmod +x install_loadgen.sh

# Run the installation (requires sudo)
sudo ./install_loadgen.sh
```

**What this installs:**
- Google Chrome browser
- ChromeDriver (for automated testing)
- Python packages (Selenium, pytest, etc.)
- LoadGen scripts in `/home/ubuntu/load/`

**Installation time:** ~2-3 minutes

**Expected output:** You should see "Setup completed successfully!" at the end.

---

## Step 3: Start Load Generation

Once installation is complete, start the load generators:

```bash
sudo /home/ubuntu/load/startload.sh
```

**Expected output:**
```
Instance 1 of kk4.py load generation started successfully
Instance 2 of kk4.py load generation started successfully
...
Instance 10 of kk4.py load generation started successfully
Instance 1 of test_checkout.py load generation started successfully
...
Instance 10 of test_checkout.py load generation started successfully
```

**What's running:**
- **10 Web Crawlers** - Browsing all pages on your KonaKart site
- **10 Checkout Tests** - Completing full purchase transactions

These processes run **continuously** until you stop them.

---

## Step 4: Verify Load Generation is Running

Wait 30 seconds after starting, then check:

```bash
ps aux | grep python3 | grep -E '(kk4|test_checkout)' | grep -v grep
```

**Expected result:** You should see **20 processes** running (10 crawlers + 10 checkout tests).

**Example output:**
```
root     123456  4.5  0.2  44140 36048 ?  S  09:40  0:01 python3 /home/ubuntu/load/kk4.py
root     123457  4.3  0.2  44140 35916 ?  S  09:40  0:01 python3 /home/ubuntu/load/kk4.py
...
```

---

## Step 5: Observe Your Telemetry

Now that load is running, you can:

1. **Check your observability platform** for incoming data
2. **View metrics** - Request rates, response times, error rates
3. **Explore traces** - See requests flowing through your application
4. **Analyze logs** - Application logs, access logs, errors

**The load will generate:**
- Hundreds of page views per minute
- Dozens of complete transactions per minute
- Realistic traffic patterns for analysis

---

## Step 6: Stop Load Generation (When Lab is Complete)

When you're finished with the lab, stop the load generators:

```bash
sudo /home/ubuntu/load/stopload.sh
```

**Expected output:**
```
All 'chrome' and 'chromedriver' processes have been killed.
```

**Verify they stopped:**
```bash
ps aux | grep python3 | grep -E '(kk4|test_checkout)' | grep -v grep
```

**Expected result:** No output (all processes stopped)

---

## Quick Reference Commands

| Action | Command |
|--------|---------|
| **Install** | `sudo ./install_loadgen.sh` |
| **Start** | `sudo /home/ubuntu/load/startload.sh` |
| **Check Status** | `ps aux \| grep python3 \| grep -E '(kk4\|test_checkout)' \| grep -v grep` |
| **Stop** | `sudo /home/ubuntu/load/stopload.sh` |

---

## Troubleshooting

### Problem: "Command not found" errors during installation

**Solution:** Make sure you're running as `ubuntu` user and using `sudo`:
```bash
sudo ./install_loadgen.sh
```

### Problem: Only 10 processes running (not 20)

**Wait:** It takes 20-30 seconds for all processes to start. Wait and check again.

**Check for errors:** Run one manually to see any errors:
```bash
python3 /home/ubuntu/load/test_checkout.py
```

### Problem: Processes keep stopping

**Check KonaKart:** Make sure KonaKart is running on your instance:
```bash
curl -I https://localhost:8783/konakart/Welcome.action
```

### Problem: Can't stop processes with stopload.sh

**Force stop:** Use these commands:
```bash
sudo pkill -9 -f chrome
sudo pkill -9 -f chromedriver
sudo pkill -9 -f python3
```

---

## What the Load Generation Does

### Web Crawlers (10 instances)
- Start at the homepage
- Discover and visit all product pages
- Click through categories and manufacturers
- Continuously loop through the entire site
- Collect performance metrics

### Checkout Tests (10 instances)
- Browse to a product (Acctim Metal Clock)
- Add product to shopping cart
- Proceed to checkout
- Log in with demo credentials
- Complete the purchase transaction
- Log out
- Repeat continuously

---

## Expected Resource Usage

Running all 20 load generators will use approximately:
- **CPU:** 20-40% on a t2.medium instance
- **Memory:** ~1.5 GB
- **Network:** Moderate (local traffic to KonaKart)

This is normal and expected for load generation.

---

## Lab Exercise Questions

As the load runs, explore these questions in your observability platform:

1. **What is the average response time** for the homepage?
2. **How many requests per minute** is your application handling?
3. **Can you identify the slowest endpoint?**
4. **Are there any errors** in the traces or logs?
5. **What does the transaction flow** look like for a checkout?
6. **Which database queries** are being executed most frequently?
7. **Can you set up an alert** for response times over 1 second?

---

## Need Help?

If you encounter issues:

1. Check the troubleshooting section above
2. Verify KonaKart is running properly
3. Ask your instructor for assistance
4. Check the detailed documentation: https://github.com/sandbreak80/loadgen

---

## Summary

✅ **Download:** `wget` the install script  
✅ **Install:** Run `sudo ./install_loadgen.sh`  
✅ **Start:** Run `sudo /home/ubuntu/load/startload.sh`  
✅ **Verify:** Check 20 processes are running  
✅ **Observe:** View telemetry in your platform  
✅ **Stop:** Run `sudo /home/ubuntu/load/stopload.sh`  

**Good luck with your observability lab!** 🎓

