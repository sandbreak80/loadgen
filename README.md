# LoadGen - KonaKart Load Generation Tool

Generate realistic e-commerce traffic for KonaKart observability lab exercises.

## Overview

LoadGen creates synthetic user activity on KonaKart e-commerce applications to generate telemetry data for observability training. It simulates two types of user behavior:

1. **Web Crawler** - Browses and discovers all pages on the site
2. **Checkout Flow** - Completes full e-commerce purchase transactions

## Quick Start (AWS Student Instances)

**👉 For detailed student lab instructions, see [STUDENT_GUIDE.md](STUDENT_GUIDE.md)**

### Installation

```bash
# Download and run the installation script
wget https://raw.githubusercontent.com/sandbreak80/loadgen/main/install_loadgen.sh
chmod +x install_loadgen.sh
sudo ./install_loadgen.sh
```

This installs:
- Google Chrome and ChromeDriver
- Python dependencies (Selenium, pytest, etc.)
- LoadGen scripts to `/home/ubuntu/load/`

### Running Load Generation

```bash
# Start load generation (10 crawlers + 10 checkout flows)
sudo /home/ubuntu/load/startload.sh

# Check if running (should see 20 processes)
ps aux | grep python3 | grep -E "(kk4|test_checkout)" | grep -v grep

# Stop load generation
sudo /home/ubuntu/load/stopload.sh
```

### What It Does

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

## For Local Development

See [docs/SETUP.md](docs/SETUP.md) for local development instructions.

## Architecture

LoadGen automatically adapts to its environment:

- **On AWS EC2:** Tests itself via public hostname (https://ec2-hostname:8783)
- **Local Dev:** Targets remote instances via configuration (https://target:8783)

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for detailed architecture documentation.

## Files

| File | Purpose |
|------|---------|
| `install_loadgen.sh` | One-time installation script for Ubuntu |
| `startload.sh` | Start load generation (20 instances) |
| `stopload.sh` | Stop all load generation processes |
| `kk4.py` | Web crawler with performance metrics |
| `test_checkout.py` | E-commerce checkout flow simulator |
| `config.py` | Configuration (for local dev) |
| `requirements.txt` | Python dependencies |

## Load Patterns

### Web Crawler (`kk4.py`)
- Starts at homepage
- Recursively crawls all internal links
- Collects performance metrics:
  - DNS lookup time
  - TCP connection time
  - Time to First Byte (TTFB)
  - DOM load times
  - Page size

### Checkout Flow (`test_checkout.py`)
- Complete e-commerce transaction:
  1. Browse product
  2. Add to cart
  3. Proceed to checkout
  4. Login
  5. Confirm billing
  6. Complete order
  7. Logout
- Runs continuously (infinite loop) until stopped

## Requirements

- Ubuntu 18.04+ (tested on Ubuntu 22.04)
- Python 3.8+
- 2GB+ RAM recommended
- Internet connectivity

## SSL Certificate Handling

LoadGen is designed for lab environments and handles SSL certificate errors automatically:

- **The Issue:** KonaKart's SSL certificate may not match the EC2 public hostname
- **The Solution:** Chrome runs with `--ignore-certificate-errors` flag
- **Result:** Load generation works despite certificate mismatches

This is **expected behavior** for lab/demo environments. In production, proper SSL certificates should be used.

## Troubleshooting

### Chrome/ChromeDriver Issues

```bash
# Check Chrome version
google-chrome --version

# Check ChromeDriver version
/home/ubuntu/load/chromedriver-linux64/chromedriver --version
```

### No Processes Running

```bash
# Check logs
journalctl -n 50 | grep -E "(kk4|test_checkout|chrome)"

# Check Python packages
pip3 list | grep -E "(selenium|webdriver-manager)"
```

### Stop Hung Processes

```bash
sudo /home/ubuntu/load/stopload.sh
# If that doesn't work:
sudo pkill -9 chrome
sudo pkill -9 chromedriver
sudo pkill -9 -f "python3.*kk4"
sudo pkill -9 -f "python3.*test_checkout"
```

## Support

For issues or questions:
- Check [SETUP.md](SETUP.md) for detailed setup instructions
- Review [ARCHITECTURE.md](ARCHITECTURE.md) for system design
- Verify KonaKart is running: `curl http://localhost:8780/konakart/Welcome.action`

## License

Educational use for observability lab training.