# LoadGen - KonaKart Load Generation Tool

Generate realistic e-commerce traffic for KonaKart observability lab exercises.

## Overview

LoadGen creates synthetic user activity on KonaKart e-commerce applications to generate telemetry data for observability training. It simulates two types of user behavior:

1. **Web Crawler** - Browses and discovers all pages on the site
2. **Checkout Flow** - Completes full e-commerce purchase transactions

---

## Installation

### Step 1: SSH Into Your Lab Instance

```bash
ssh -i your-key.pem ubuntu@your-instance-hostname
```

### Step 2: Download and Install

```bash
# Download the installation script
wget https://raw.githubusercontent.com/sandbreak80/loadgen/main/install_loadgen.sh

# Make it executable
chmod +x install_loadgen.sh

# Run installation (requires sudo)
sudo ./install_loadgen.sh
```

**What gets installed:**
- Google Chrome browser
- ChromeDriver (for automated testing)
- Python packages (Selenium, pytest, etc.)
- LoadGen scripts in `/home/ubuntu/load/`

**Installation time:** 2-3 minutes

**Expected output:** "Setup completed successfully!"

---

## Usage

### Start Load Generation

```bash
sudo /home/ubuntu/load/startload.sh
```

**Expected output:**
```
Instance 1 of kk4.py load generation started successfully
Instance 2 of kk4.py load generation started successfully
...
Instance 10 of test_checkout.py load generation started successfully
```

**What runs:**
- **10 Web Crawlers** - Browsing all pages continuously
- **10 Checkout Tests** - Completing purchase transactions continuously

### Verify Load is Running

Wait 30 seconds after starting, then check:

```bash
ps aux | grep python3 | grep -E '(kk4|test_checkout)' | grep -v grep
```

**Expected:** 20 processes running (10 crawlers + 10 checkout)

### Stop Load Generation

```bash
sudo /home/ubuntu/load/stopload.sh
```

**Expected output:** "All 'chrome' and 'chromedriver' processes have been killed."

---

## Quick Reference

| Action | Command |
|--------|---------|
| **Install** | `sudo ./install_loadgen.sh` |
| **Start** | `sudo /home/ubuntu/load/startload.sh` |
| **Check Status** | `ps aux \| grep python3 \| grep -E '(kk4\|test_checkout)' \| grep -v grep` |
| **Count Processes** | `ps aux \| grep python3 \| grep -E '(kk4\|test_checkout)' \| grep -v grep \| wc -l` |
| **Stop** | `sudo /home/ubuntu/load/stopload.sh` |

---

## What It Does

When running on an AWS instance:
- **Auto-detects** EC2 environment using `ec2metadata`
- **Tests itself** via its public hostname (avoids localhost SSL issues)
- **Generates 20 concurrent sessions:**
  - 10 web crawlers discovering and visiting pages
  - 10 checkout flows completing purchases
- **Creates observability telemetry:**
  - HTTP requests and responses
  - Application traces and spans
  - Performance metrics
  - Transaction data

### Web Crawler (`kk4.py`)
- Starts at homepage
- Recursively crawls all internal links
- Collects performance metrics:
  - DNS lookup time
  - TCP connection time
  - Time to First Byte (TTFB)
  - DOM load times
  - Page size
- Runs continuously (infinite loop) until stopped

### Checkout Flow (`test_checkout.py`)
- Complete e-commerce transaction:
  1. Browse product (Acctim Metal Clock)
  2. Add to cart
  3. Proceed to checkout
  4. Login (demo credentials)
  5. Confirm billing
  6. Complete order
  7. Logout
- Runs continuously (infinite loop) until stopped

---

## Architecture

LoadGen automatically adapts to its environment:

- **On AWS EC2:** Tests itself via public hostname (https://ec2-hostname:8783)
- **Local Dev:** Targets remote instances via configuration (https://target:8783)

### Auto-Detection
```python
ec2_public_hostname = get_ec2_public_hostname()
if ec2_public_hostname:
    # Running on AWS - test itself via public hostname
    base_url = f"https://{ec2_public_hostname}:8783/konakart/Welcome.action"
else:
    # Not on EC2 - use configured target
    base_url = config.TARGET_URL
```

### Why Public Hostname?
- Avoids SSL certificate issues with localhost
- Tests the full network stack
- Generates realistic observability telemetry
- Matches how external clients access the service

---

## SSL Certificate Handling

LoadGen is designed for lab environments and handles SSL certificate errors automatically:

- **The Issue:** KonaKart's SSL certificate may not match the EC2 public hostname
- **The Solution:** Chrome runs with `--ignore-certificate-errors` flag
- **Result:** Load generation works despite certificate mismatches

This is **expected behavior** for lab/demo environments.

---

## Expected Resource Usage

Running all 20 load generators uses approximately:
- **CPU:** 20-40% on a t2.medium instance
- **Memory:** ~1.5 GB
- **Network:** Moderate (local traffic to KonaKart)

This is normal and expected for load generation.

---

## Troubleshooting

### Only 10 Processes Running (Not 20)

**Wait:** It takes 20-30 seconds for all processes to start.

**Check for errors:** Run one manually:
```bash
python3 /home/ubuntu/load/test_checkout.py
```

### Processes Keep Stopping

**Check KonaKart:** Verify KonaKart is running:
```bash
curl -I https://localhost:8783/konakart/Welcome.action
```

### Can't Stop Processes

**Force stop:**
```bash
sudo pkill -9 -f chrome
sudo pkill -9 -f chromedriver
sudo pkill -9 -f python3
```

### Chrome/ChromeDriver Version Mismatch

**Check versions:**
```bash
google-chrome --version
/home/ubuntu/load/chromedriver-linux64/chromedriver --version
```

If mismatched, update ChromeDriver in `install_loadgen.sh` to match Chrome version.

### Installation Fails

**Prerequisites:**
```bash
sudo apt update
sudo apt install -y wget python3-pip
```

---

## Lab Exercise Questions

As the load runs, explore these in your observability platform:

1. What is the average response time for the homepage?
2. How many requests per minute is your application handling?
3. Can you identify the slowest endpoint?
4. Are there any errors in the traces or logs?
5. What does the transaction flow look like for a checkout?
6. Which database queries are being executed most frequently?
7. Can you set up an alert for response times over 1 second?
8. What is the 95th percentile latency?
9. How many successful vs failed transactions?
10. Can you identify any performance bottlenecks?

---

## Local Development

For local development and testing against remote instances, see:
- [docs/SETUP.md](docs/SETUP.md) - Local development setup
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) - System architecture
- [dev/README.md](dev/README.md) - Local development scripts

---

## Files

| File | Purpose |
|------|---------|
| `install_loadgen.sh` | One-time installation script for Ubuntu |
| `startload.sh` | Start load generation (20 instances) |
| `stopload.sh` | Stop all load generation processes |
| `kk4.py` | Web crawler with performance metrics |
| `test_checkout.py` | E-commerce checkout flow simulator |
| `config.py` | Configuration module |
| `requirements.txt` | Python dependencies |

---

## Requirements

- Ubuntu 18.04+ (tested on Ubuntu 22.04)
- Python 3.8+
- 2GB+ RAM recommended
- Internet connectivity

---

## Support

For detailed documentation:
- [SETUP.md](docs/SETUP.md) - Complete setup instructions
- [ARCHITECTURE.md](docs/ARCHITECTURE.md) - System design
- [DEPLOYMENT_TEST.md](docs/DEPLOYMENT_TEST.md) - Testing guide

---

## License

Educational use for observability lab training.
