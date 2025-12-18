# Git Setup Instructions

Your changes have been committed locally but need to be pushed to GitHub.

## Issue 1: Git Identity Not Configured

Configure your Git identity (one-time setup):

```bash
# Set your name and email
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Issue 2: SSL Certificate (if needed)

If you encounter SSL certificate errors:

```bash
# Option 1: Fix certificate path (recommended)
export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# Option 2: Disable SSL verification (not recommended for production)
git config --global http.sslVerify false
```

## Push to GitHub

Once configured, push your changes:

```bash
cd /Users/bmstoner/code_projects/loadgen
git push origin main
```

## Verify Push

Check GitHub to ensure changes are visible:
```
https://github.com/sandbreak80/loadgen
```

## Alternative: Manual Commit & Push

If the script doesn't work, do it manually:

```bash
cd /Users/bmstoner/code_projects/loadgen

# Check what's staged
git status

# Already committed, so just push
git push origin main

# Or if you need to add more files
git add .
git commit -m "Your commit message"
git push origin main
```

## What Was Committed

The following changes are ready to push:

### New Files:
- `.gitignore`
- `ARCHITECTURE.md`
- `DEPLOYMENT_TEST.md`
- `SETUP.md`
- `activate_venv.sh`
- `config.py`
- `requirements.txt`
- `run_all_local.sh`
- `run_checkout.sh`
- `run_crawler.sh`
- `setup_venv.sh`
- `stop_local.sh`

### Modified Files:
- `README.md`
- `install_loadgen.sh`
- `kk4.py`
- `startload.sh`
- `stopload.sh`
- `test_checkout.py`

## Next Steps After Push

Once pushed to GitHub, test the deployment:

1. **SSH into remote host:**
   ```bash
   ssh -i /Users/bmstoner/Downloads/bootcamp.pem ubuntu@54.70.243.207
   ```

2. **On remote host, run:**
   ```bash
   # Clean previous installation
   sudo rm -rf /home/ubuntu/load
   rm -f install_loadgen.sh
   
   # Download installation script
   wget https://raw.githubusercontent.com/sandbreak80/loadgen/main/install_loadgen.sh
   chmod +x install_loadgen.sh
   
   # Run installation
   sudo ./install_loadgen.sh
   
   # Verify
   ls -lh /home/ubuntu/load/
   google-chrome --version
   
   # Start load
   sudo /home/ubuntu/load/startload.sh
   
   # Wait 30 seconds, then check
   ps aux | grep python3 | grep -E '(kk4|test_checkout)'
   
   # Stop load
   sudo /home/ubuntu/load/stopload.sh
   ```

See `DEPLOYMENT_TEST.md` for detailed testing instructions.

