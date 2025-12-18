# Files to Commit to GitHub

## Core Production Files (Required on Student Instances)

### Installation & Deployment
- ✅ `install_loadgen.sh` - Ubuntu installation script
- ✅ `startload.sh` - Start load generation
- ✅ `stopload.sh` - Stop load generation

### Load Generation Scripts
- ✅ `kk4.py` - Web crawler
- ✅ `test_checkout.py` - Checkout flow simulator
- ✅ `config.py` - Configuration module
- ✅ `requirements.txt` - Python dependencies

### Documentation
- ✅ `README.md` - Main documentation (student-facing)
- ✅ `SETUP.md` - Setup instructions
- ✅ `ARCHITECTURE.md` - System architecture
- ✅ `DEPLOYMENT_TEST.md` - Deployment testing guide

### Local Development Support
- ✅ `setup_venv.sh` - Local venv setup
- ✅ `activate_venv.sh` - Venv activation helper
- ✅ `run_crawler.sh` - Run single crawler locally
- ✅ `run_checkout.sh` - Run single checkout locally
- ✅ `run_all_local.sh` - Run multiple instances locally
- ✅ `stop_local.sh` - Stop local processes
- ✅ `.gitignore` - Git exclusions

## Files Excluded (Local Development Only)

### Testing Scripts
- ❌ `test_single_page.py` - Single page test
- ❌ `test_single_checkout.py` - Single checkout test
- ❌ `test_crawler_quick.sh` - Quick crawler test
- ❌ `test_remote.sh` - Remote deployment test
- ❌ `deploy_to_remote.sh` - Remote deployment
- ❌ `remote_commands.sh` - Remote management
- ❌ `run_timed_test.sh` - Timed test runner

### Development Artifacts
- ❌ `venv/` - Virtual environment (gitignored)
- ❌ `__pycache__/` - Python cache (gitignored)
- ❌ `logs/` - Log files (gitignored)
- ❌ `*.pem` - SSH keys (gitignored)

## File Count Summary

**Going to GitHub:** 16 files  
**Excluded:** 7+ test scripts, venv, logs, caches

## GitHub Repository Structure

```
loadgen/
├── README.md                 # Main documentation
├── SETUP.md                  # Setup guide
├── ARCHITECTURE.md           # Architecture docs
├── DEPLOYMENT_TEST.md        # Testing guide
│
├── install_loadgen.sh        # AWS installation
├── startload.sh              # Start load
├── stopload.sh               # Stop load
│
├── kk4.py                    # Web crawler
├── test_checkout.py          # Checkout simulator
├── config.py                 # Configuration
├── requirements.txt          # Dependencies
│
├── setup_venv.sh            # Local: venv setup
├── activate_venv.sh         # Local: venv activate
├── run_crawler.sh           # Local: single crawler
├── run_checkout.sh          # Local: single checkout
├── run_all_local.sh         # Local: multi-instance
└── stop_local.sh            # Local: stop all
```

