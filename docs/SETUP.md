# LoadGen Setup Guide

## Overview
LoadGen generates synthetic load on KonaKart e-commerce instances for observability lab exercises.

## Quick Start (Local Development)

### 1. Setup Virtual Environment (Recommended for Local Development)

```bash
# Run the setup script - creates venv and installs dependencies
./setup_venv.sh

# The virtual environment is now activated automatically
```

**Alternative: Manual Setup without Virtual Environment**
```bash
# Install dependencies globally
pip3 install -r requirements.txt

# Make scripts executable
chmod +x *.sh
```

### 2. Activate Virtual Environment (for future sessions)

```bash
# Option 1: Use helper script
source activate_venv.sh

# Option 2: Activate directly
source venv/bin/activate

# To deactivate when done
deactivate
```

### 3. Configure Target URL

Edit `config.py` or set environment variables:

```bash
# Option 1: Set environment variable
export KONAKART_URL="https://34.216.65.98:8783/konakart/Welcome.action"

# Option 2: Edit config.py
# Change TARGET_URL in config.py to your student instance
```

### 4. Run Load Generation

**Single crawler (for testing):**
```bash
./run_crawler.sh
```

**Single checkout flow (for testing):**
```bash
./run_checkout.sh
```

**Multiple instances (light load for local):**
```bash
mkdir -p logs
./run_all_local.sh
```

**Target specific student instance:**
```bash
./run_all_local.sh "https://34.216.65.98:8783/konakart/Welcome.action" 2 2
```

### 5. Stop Load Generation

```bash
./stop_local.sh
```

## Student Instances

Available student instances (configured in `config.py`):
- https://34.216.65.98:8783/konakart/Welcome.action
- https://18.146.19.241:8783/konakart/Welcome.action
- https://54.229.79.78:8783/konakart/Welcome.action
- https://35.92.144.61:8783/konakart/Welcome.action

## Configuration Options

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `KONAKART_URL` | First student instance | Target KonaKart URL |
| `KONAKART_USER` | doe@konakart.com | Login username |
| `KONAKART_PASSWORD` | password | Login password |
| `CHROMEDRIVER_PATH` | Auto-detect | Path to ChromeDriver |
| `CRAWLER_INSTANCES` | 10 | Number of crawler processes |
| `CHECKOUT_INSTANCES` | 10 | Number of checkout processes |
| `CHECKOUT_ITERATIONS` | 1000 | Iterations per checkout test |
| `PAGE_LOAD_TIMEOUT` | 10 | Page load timeout (seconds) |

### Example: Custom Configuration

```bash
export KONAKART_URL="https://18.146.19.241:8783/konakart/Welcome.action"
export CHECKOUT_ITERATIONS="500"
export CRAWLER_INSTANCES="5"
export CHECKOUT_INSTANCES="5"

./run_all_local.sh
```

## Remote Host Testing

Before deploying to student instances, test on a staging host.

### Quick Deploy & Test

```bash
# Deploy and install on remote host
./test_remote.sh

# Or step by step:
./deploy_to_remote.sh                    # Copy files
./remote_commands.sh install             # Install dependencies
./remote_commands.sh start               # Start load
./remote_commands.sh status              # Check status
./remote_commands.sh stop                # Stop load
```

### Remote Commands

```bash
# SSH into remote host
./remote_commands.sh ssh

# Deploy latest files
./remote_commands.sh deploy

# Start/stop load generation
./remote_commands.sh start
./remote_commands.sh stop

# Check running processes
./remote_commands.sh status

# View logs
./remote_commands.sh logs

# Clean up temp files
./remote_commands.sh clean
```

### Custom Remote Host

To use a different host:

```bash
./deploy_to_remote.sh ubuntu@your-host.com /path/to/key.pem
```

## AWS Deployment (Student Instances)

**Note:** Virtual environment is NOT used on AWS instances for simplicity.

### Prerequisites
- Ubuntu EC2 instance
- Root access

### Installation

```bash
sudo ./install_loadgen.sh
```

This will:
- Install Chrome and ChromeDriver
- Install Python dependencies globally (no venv)
- Clone the repository to `/home/ubuntu/load/`

### Running on AWS

```bash
# Start load generation (20 instances: 10 crawlers + 10 checkout)
sudo /home/ubuntu/load/startload.sh

# Stop load generation
sudo /home/ubuntu/load/stopload.sh
```

**Important:** AWS scripts install dependencies globally and do NOT use virtual environments for ease of deployment.

## Components

### Scripts

- `kk4.py` - Web crawler that discovers and visits all pages
- `test_checkout.py` - Simulates complete checkout workflow
- `config.py` - Configuration management

### Load Patterns

**Web Crawler (`kk4.py`):**
- Starts at homepage
- Recursively follows all internal links
- Collects performance metrics
- Generates browsing telemetry

**Checkout Flow (`test_checkout.py`):**
- Browse product → Add to cart → Checkout → Login → Complete → Logout
- Repeats configured number of times
- Generates transaction telemetry

## Troubleshooting

### SSL Certificate Errors
Scripts are configured to ignore SSL certificate errors with `--ignore-certificate-errors` flag.

### ChromeDriver Issues
If ChromeDriver fails to auto-detect:
```bash
# Set explicit path
export CHROMEDRIVER_PATH="/path/to/chromedriver"
```

### Too Much Load Locally
Reduce instances for local testing:
```bash
./run_all_local.sh "https://34.216.65.98:8783/konakart/Welcome.action" 1 1
```

### View Logs
```bash
# Watch crawler logs
tail -f logs/crawler_1.log

# Watch checkout logs
tail -f logs/checkout_1.log
```

## Notes

- Local testing uses fewer instances (2 each) vs AWS (10 each)
- Local testing uses fewer iterations (100) vs AWS (1000)
- All scripts run in headless mode (no UI)
- Processes can be monitored with `ps aux | grep python3`

