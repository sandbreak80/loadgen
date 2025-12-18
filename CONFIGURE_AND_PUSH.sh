#!/bin/bash
# Configure git identity and push

echo "=========================================="
echo "Git Configuration & Push"
echo "=========================================="
echo ""

# Prompt for git config (only for this repo)
echo "Enter your name for Git commits:"
read -r GIT_NAME

echo "Enter your email for Git commits:"
read -r GIT_EMAIL

echo ""
echo "Configuring Git (local repository only)..."
cd /Users/bmstoner/code_projects/loadgen
git config user.name "$GIT_NAME"
git config user.email "$GIT_EMAIL"

echo "✓ Git configured"
echo ""

# Commit (files are already staged)
echo "Committing..."
git commit -m "Reorganize project structure per best practices

Structure:
- docs/          Documentation (SETUP, ARCHITECTURE, DEPLOYMENT_TEST)
- dev/           Local development scripts  
- Root level     AWS deployment files (install, start, stop, kk4.py, etc.)

Benefits:
- Clear separation between docs, dev tools, and deployment files
- Students find deployment files easily at root
- Developers find dev tools in dev/
- Documentation centralized in docs/

Changes:
- Moved documentation to docs/
- Moved local dev scripts to dev/
- Updated all path references in README
- Added README.md in docs/ and dev/ directories
- Updated dev scripts to work from any location

AWS deployment files remain at root for easy student access."

echo "✓ Committed"
echo ""

# Push
echo "Pushing to GitHub..."
git push origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "✓ Successfully pushed to GitHub!"
    echo "=========================================="
else
    echo ""
    echo "✗ Push failed"
    echo "Check GitHub authentication"
    exit 1
fi

