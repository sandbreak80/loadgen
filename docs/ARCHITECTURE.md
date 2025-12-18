# LoadGen Architecture

## Overview
LoadGen supports two deployment modes with automatic environment detection.

## Deployment Modes

### 1. Local Development Mode
**Environment:** Your local machine (macOS/Linux/Windows)  
**Purpose:** Test student instances remotely for troubleshooting/monitoring

**Characteristics:**
- ✅ Uses Python virtual environment (`venv/`)
- ✅ Targets remote student instances via HTTPS (port 8783)
- ✅ Configured via `config.py` with environment variable overrides
- ✅ Auto-detects ChromeDriver using `webdriver-manager`
- ✅ Reduced load (2+2 instances, 100 iterations)
- ✅ Logs to `logs/` directory

**Detection Logic:**
```python
ec2_public_hostname = get_ec2_public_hostname()  # e.g., "ec2-54-70-243-207.us-west-2.compute.amazonaws.com"
if ec2_public_hostname:
    # Found EC2 metadata - use public hostname to test itself
    base_url = f"https://{ec2_public_hostname}:8783/konakart/Welcome.action"
else:
    # Not on EC2 - use configured target
    base_url = config.TARGET_URL  # e.g., https://34.216.65.98:8783/konakart/...
```

**Scripts:**
- `./setup_venv.sh` - Initial setup
- `./run_crawler.sh [url]` - Single crawler
- `./run_checkout.sh [url]` - Single checkout test
- `./run_all_local.sh [url] [crawlers] [checkouts]` - Full load
- `./stop_local.sh` - Stop all

---

### 2. AWS Student Instance Mode
**Environment:** Ubuntu EC2 instances  
**Purpose:** Generate load on student's own KonaKart instance for observability data

**Characteristics:**
- ✅ No virtual environment (global pip install)
- ✅ Tests local instance via HTTP (port 8780)
- ✅ Uses `ec2metadata` to detect EC2 environment
- ✅ Uses pre-installed ChromeDriver (version-specific)
- ✅ Full load (10+10 instances, 1000 iterations)
- ✅ Output suppressed (`>/dev/null 2>&1`)

**Detection Logic:**
```python
ec2_public_hostname = get_ec2_public_hostname()  # Gets ec2metadata --public-hostname
if ec2_public_hostname:
    # Found EC2 metadata - test itself via public hostname
    base_url = f"https://{ec2_public_hostname}:8783/konakart/Welcome.action"
else:
    # Not on EC2 - use configured target
    base_url = config.TARGET_URL
```

**Scripts:**
- `sudo ./install_loadgen.sh` - One-time setup
- `sudo /home/ubuntu/load/startload.sh` - Start load
- `sudo /home/ubuntu/load/stopload.sh` - Stop load

---

## Port Configuration

| Mode | Protocol | Port | Connection |
|------|----------|------|------------|
| **Local dev → AWS** | HTTPS | 8783 | Remote instance via public IP |
| **AWS → itself** | HTTPS | 8783 | Same instance via public hostname |

**Note:** AWS instances test themselves via their **public hostname** (not localhost) to:
- Avoid SSL certificate issues with localhost
- Match how external clients access the service
- Generate realistic observability telemetry

---

## File Structure

```
loadgen/
├── config.py                 # Configuration (local dev only)
├── requirements.txt          # Python dependencies
│
├── kk4.py                    # Web crawler (dual-mode)
├── test_checkout.py          # Checkout simulator (dual-mode)
│
├── setup_venv.sh            # LOCAL: Setup venv
├── activate_venv.sh         # LOCAL: Activate venv
├── run_crawler.sh           # LOCAL: Single crawler
├── run_checkout.sh          # LOCAL: Single checkout
├── run_all_local.sh         # LOCAL: Multi-instance
├── stop_local.sh            # LOCAL: Stop processes
│
├── install_loadgen.sh       # AWS: Installation script
├── startload.sh             # AWS: Start load (fixed typo)
├── stopload.sh              # AWS: Stop load
│
├── SETUP.md                 # Setup instructions
├── ARCHITECTURE.md          # This file
└── README.md                # Project overview
```

---

## Auto-Detection Flow

```
┌─────────────────────────────────────┐
│  Script starts (kk4.py or           │
│  test_checkout.py)                  │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Try: ec2metadata --public-hostname │
└──────────────┬──────────────────────┘
               │
       ┌───────┴───────┐
       │               │
   Success           Fail
       │               │
       ▼               ▼
┌──────────────┐  ┌──────────────────┐
│  AWS MODE    │  │  LOCAL DEV MODE  │
│              │  │                  │
│  Target:     │  │  Target:         │
│  localhost   │  │  config.TARGET   │
│  :8780       │  │  _URL (remote)   │
│              │  │  :8783           │
└──────────────┘  └──────────────────┘
```

---

## Student Instance URLs (Local Dev)

Configure these in `config.py` or via `KONAKART_URL` environment variable:

```python
STUDENT_INSTANCES = [
    "https://34.216.65.98:8783/konakart/Welcome.action",
    "https://18.146.19.241:8783/konakart/Welcome.action",
    "https://54.229.79.78:8783/konakart/Welcome.action",
    "https://35.92.144.61:8783/konakart/Welcome.action"
]
```

---

## Key Changes from Original

### Fixed Issues:
1. ✅ **Path typo in `startload.sh`** - Fixed line 15
2. ✅ **Hardcoded credentials** - Now uses `config.py` with env var support
3. ✅ **Missing EC2 detection in `test_checkout.py`** - Added same logic as `kk4.py`
4. ✅ **Individual pip installs** - Now uses `requirements.txt`

### New Features:
1. ✅ **Dual-mode operation** - Works locally and on AWS
2. ✅ **Virtual environment support** - Clean local development
3. ✅ **Configuration management** - Centralized config with env var overrides
4. ✅ **Auto-ChromeDriver detection** - No manual path configuration locally
5. ✅ **Reduced local load** - Won't overwhelm development machine

---

## Testing Workflow

### Local Development Testing:
```bash
# One-time setup
./setup_venv.sh

# Test single crawler against first student instance
./run_crawler.sh

# Test against specific instance
./run_crawler.sh "https://18.146.19.241:8783/konakart/Welcome.action"

# Full load test (light)
./run_all_local.sh

# Stop all
./stop_local.sh
```

### AWS Deployment (Student Instances):
```bash
# Students run on their EC2 instance:
sudo ./install_loadgen.sh       # One-time
sudo /home/ubuntu/load/startload.sh   # Start
sudo /home/ubuntu/load/stopload.sh    # Stop
```

---

## Observability Integration

When running on AWS student instances:
- LoadGen generates HTTP requests
- KonaKart application handles requests
- Observability agent captures telemetry:
  - **Traces:** Request flow through application
  - **Metrics:** Response times, throughput, errors
  - **Logs:** Application and access logs
- Students analyze telemetry data in their observability platform

The load patterns provide realistic data for learning:
- Normal browsing behavior (web crawler)
- E-commerce transactions (checkout flow)
- Performance metrics and bottlenecks
- Error tracking and debugging

