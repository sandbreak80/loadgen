# LoadGen Documentation

Complete documentation for the LoadGen project.

## Documentation Files

### [SETUP.md](SETUP.md)
Complete setup instructions for both local development and AWS deployment.

**Contents:**
- Local development environment setup
- Virtual environment configuration
- Remote host testing
- AWS deployment instructions
- Configuration options
- Troubleshooting guide

### [ARCHITECTURE.md](ARCHITECTURE.md)
System architecture and design documentation.

**Contents:**
- Deployment modes (local vs AWS)
- Auto-detection flow
- Port configuration
- File structure
- Key changes from original

### [DEPLOYMENT_TEST.md](DEPLOYMENT_TEST.md)
Step-by-step guide for testing the complete deployment workflow.

**Contents:**
- Test scenario walkthrough
- Prerequisites
- Detailed test steps
- Success criteria
- Troubleshooting common issues
- Automated test scripts

## Quick Links

- **For Students:** Start with the [main README](../README.md)
- **For Lab Administrators:** Review [DEPLOYMENT_TEST.md](DEPLOYMENT_TEST.md)
- **For Developers:** Read [SETUP.md](SETUP.md) and [ARCHITECTURE.md](ARCHITECTURE.md)

## Project Structure

```
loadgen/
├── README.md                 # Main documentation (student-facing)
├── requirements.txt          # Python dependencies
├── .gitignore               # Git exclusions
│
├── docs/                    # Documentation (this directory)
│   ├── README.md           # This file
│   ├── SETUP.md            # Setup guide
│   ├── ARCHITECTURE.md     # Architecture docs
│   └── DEPLOYMENT_TEST.md  # Testing guide
│
├── AWS Deployment Files (students use these)
│   ├── install_loadgen.sh   # Installation script
│   ├── startload.sh         # Start load generation
│   ├── stopload.sh          # Stop load generation
│   ├── kk4.py              # Web crawler
│   ├── test_checkout.py    # Checkout simulator
│   └── config.py           # Configuration module
│
└── dev/                     # Local development tools
    ├── setup_venv.sh        # Setup virtual environment
    ├── activate_venv.sh     # Activate venv helper
    ├── run_crawler.sh       # Run single crawler
    ├── run_checkout.sh      # Run single checkout
    ├── run_all_local.sh     # Run multiple instances
    └── stop_local.sh        # Stop local processes
```

