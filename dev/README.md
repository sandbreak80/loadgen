# Local Development Scripts

Scripts for local development and testing against remote KonaKart instances.

## Quick Start

### First Time Setup

```bash
# Setup virtual environment and install dependencies
./dev/setup_venv.sh
```

### Daily Usage

```bash
# Activate virtual environment
source dev/activate_venv.sh

# Test single crawler
./dev/run_crawler.sh

# Test single checkout
./dev/run_checkout.sh

# Run full local load test (light)
./dev/run_all_local.sh
```

## Scripts

### `setup_venv.sh`
**Purpose:** One-time setup of Python virtual environment

**Usage:**
```bash
./dev/setup_venv.sh
```

**What it does:**
- Creates `venv/` directory
- Installs all dependencies from `requirements.txt`
- Activates the virtual environment

### `activate_venv.sh`
**Purpose:** Helper to activate the virtual environment

**Usage:**
```bash
source dev/activate_venv.sh
```

**Note:** Use `source` (not `./`) to activate in current shell

### `run_crawler.sh`
**Purpose:** Run a single web crawler instance

**Usage:**
```bash
# Use default target from config.py
./dev/run_crawler.sh

# Target specific URL
./dev/run_crawler.sh "https://example.com:8783/konakart/Welcome.action"
```

**What it does:**
- Auto-activates venv if needed
- Runs `kk4.py` with configured target
- Outputs to console

### `run_checkout.sh`
**Purpose:** Run a single checkout test instance

**Usage:**
```bash
# Use default target from config.py
./dev/run_checkout.sh

# Target specific URL
./dev/run_checkout.sh "https://example.com:8783/konakart/Welcome.action"
```

**What it does:**
- Auto-activates venv if needed
- Runs `test_checkout.py` with configured target
- Outputs to console

### `run_all_local.sh`
**Purpose:** Run multiple instances for load testing

**Usage:**
```bash
# Default: 2 crawlers + 2 checkout tests, 100 iterations each
./dev/run_all_local.sh

# Custom target
./dev/run_all_local.sh "https://example.com:8783/konakart/Welcome.action"

# Custom target and instance counts
./dev/run_all_local.sh "https://example.com:8783/konakart/Welcome.action" 3 3
```

**What it does:**
- Auto-activates venv if needed
- Starts multiple crawler instances (background)
- Starts multiple checkout instances (background)
- Logs output to `logs/` directory
- Reduced iterations (100) suitable for local testing

### `stop_local.sh`
**Purpose:** Stop all local load generation processes

**Usage:**
```bash
./dev/stop_local.sh
```

**What it does:**
- Kills all Python processes running kk4.py or test_checkout.py
- Kills Chrome and ChromeDriver processes
- Safe to run multiple times

## Configuration

### Target URLs

Edit `config.py` to set default target:

```python
TARGET_URL = "https://your-instance:8783/konakart/Welcome.action"
```

Or use environment variable:

```bash
export KONAKART_URL="https://your-instance:8783/konakart/Welcome.action"
./dev/run_crawler.sh
```

### Load Settings

Edit `config.py` to adjust:

```python
CRAWLER_INSTANCES = 2        # Number of crawlers
CHECKOUT_INSTANCES = 2       # Number of checkout tests
CHECKOUT_ITERATIONS = 100    # Iterations per checkout test
```

## Logs

All local tests log to `logs/` directory:

```bash
# View crawler output
tail -f logs/crawler_1.log

# View checkout output
tail -f logs/checkout_1.log

# Clean logs
rm -rf logs/*.log
```

## Tips

### Quick Test
```bash
# Fast verification that everything works
./dev/setup_venv.sh
./dev/run_crawler.sh "https://your-host:8783/konakart/Welcome.action"
```

### Load Test
```bash
# Generate realistic load for 5 minutes
./dev/run_all_local.sh "https://your-host:8783/konakart/Welcome.action" 2 2
# Let it run, then:
./dev/stop_local.sh
```

### Multiple Targets
```bash
# Test multiple student instances simultaneously
./dev/run_crawler.sh "https://instance1:8783/konakart/Welcome.action" &
./dev/run_crawler.sh "https://instance2:8783/konakart/Welcome.action" &
./dev/run_crawler.sh "https://instance3:8783/konakart/Welcome.action" &
```

## Differences from AWS Scripts

| Feature | Local (`dev/`) | AWS (root) |
|---------|---------------|-----------|
| Virtual env | Yes (venv/) | No (global) |
| Target | Remote instances | Localhost (auto-detected) |
| Instances | 2+2 (light) | 10+10 (full) |
| Iterations | 100 | 1000 |
| Logs | logs/ directory | /dev/null (suppressed) |

## Troubleshooting

### Virtual Environment Issues

```bash
# Remove and recreate
rm -rf venv/
./dev/setup_venv.sh
```

### ChromeDriver Issues

```bash
# Clear cache and reinstall
rm -rf ~/.wdm/
./dev/setup_venv.sh
```

### Processes Won't Stop

```bash
# Force kill everything
pkill -9 -f chrome
pkill -9 -f chromedriver
pkill -9 -f "python3.*kk4"
pkill -9 -f "python3.*test_checkout"
```

## See Also

- [../docs/SETUP.md](../docs/SETUP.md) - Complete setup guide
- [../docs/ARCHITECTURE.md](../docs/ARCHITECTURE.md) - System architecture
- [../config.py](../config.py) - Configuration file

