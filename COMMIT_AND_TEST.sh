#!/bin/bash
# Script to commit changes and test deployment

echo "=========================================="
echo "LoadGen - Commit & Deploy Test"
echo "=========================================="
echo ""

# Stage all production files
echo "Stage 1: Adding files to git..."
echo ""

# Core files
git add README.md
git add SETUP.md
git add ARCHITECTURE.md
git add DEPLOYMENT_TEST.md
git add .gitignore

# Installation scripts
git add install_loadgen.sh
git add startload.sh
git add stopload.sh

# Load generation scripts
git add kk4.py
git add test_checkout.py
git add config.py
git add requirements.txt

# Local development scripts
git add setup_venv.sh
git add activate_venv.sh
git add run_crawler.sh
git add run_checkout.sh
git add run_all_local.sh
git add stop_local.sh

echo "✓ Files staged"
echo ""

# Show what will be committed
echo "Stage 2: Review changes..."
echo ""
git status
echo ""

# Commit
echo "Stage 3: Committing..."
echo ""
git commit -m "Enhanced LoadGen with dual-mode support and comprehensive documentation

Major improvements:
- Dual-mode operation: Works on AWS instances and local development
- Auto-detects EC2 environment using ec2metadata
- Fixed path typo in startload.sh
- Removed hardcoded credentials (uses config.py)
- Added EC2 detection to test_checkout.py
- Uses requirements.txt for consistent dependency installation

New features:
- Virtual environment support for local development
- Configuration management via config.py
- Local testing scripts (run_*.sh)
- Comprehensive documentation (README, SETUP, ARCHITECTURE)

Files updated:
- install_loadgen.sh: Uses requirements.txt
- startload.sh: Fixed path bug
- kk4.py: Added config support and EC2 detection
- test_checkout.py: Added EC2 detection, removed hardcoded credentials

New files:
- config.py: Configuration management
- requirements.txt: Python dependencies
- Local dev scripts: setup_venv.sh, run_*.sh, stop_local.sh
- Documentation: SETUP.md, ARCHITECTURE.md, DEPLOYMENT_TEST.md

Ready for student deployment and observability lab use."

echo "✓ Changes committed"
echo ""

# Push
echo "Stage 4: Pushing to GitHub..."
echo ""
git push origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "✓ Successfully pushed to GitHub!"
    echo "=========================================="
    echo ""
    echo "Next step: Test deployment on remote host"
    echo ""
    echo "SSH into remote host:"
    echo "  ssh -i /Users/bmstoner/Downloads/bootcamp.pem ubuntu@54.70.243.207"
    echo ""
    echo "Then run on remote host:"
    echo "  # Clean previous installation"
    echo "  sudo rm -rf /home/ubuntu/load"
    echo "  rm -f install_loadgen.sh"
    echo ""
    echo "  # Download and run installation"
    echo "  wget https://raw.githubusercontent.com/sandbreak80/loadgen/main/install_loadgen.sh"
    echo "  chmod +x install_loadgen.sh"
    echo "  sudo ./install_loadgen.sh"
    echo ""
    echo "  # Verify installation"
    echo "  ls -lh /home/ubuntu/load/"
    echo "  google-chrome --version"
    echo ""
    echo "  # Start load generation"
    echo "  sudo /home/ubuntu/load/startload.sh"
    echo ""
    echo "  # Check if running (wait 30 seconds first)"
    echo "  ps aux | grep python3 | grep -E '(kk4|test_checkout)'"
    echo ""
    echo "  # Stop load generation"
    echo "  sudo /home/ubuntu/load/stopload.sh"
    echo ""
    echo "=========================================="
else
    echo ""
    echo "=========================================="
    echo "✗ Push failed"
    echo "=========================================="
    echo ""
    echo "Check:"
    echo "  - GitHub credentials configured?"
    echo "  - Repository access?"
    echo "  - Network connectivity?"
    echo ""
fi

