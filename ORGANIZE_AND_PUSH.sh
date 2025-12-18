#!/bin/bash
# Organize project per best practices, commit, and push

set -e

cd /Users/bmstoner/code_projects/loadgen

echo "=========================================="
echo "LoadGen - Project Organization & Push"
echo "=========================================="
echo ""

# Reset any partial changes
echo "Resetting previous commit..."
git reset --soft HEAD~1 2>/dev/null || true
git reset

echo "Creating organized directory structure..."
mkdir -p docs dev

# Move files to organized structure
echo "Moving documentation files..."
git mv ARCHITECTURE.md docs/ 2>/dev/null || mv ARCHITECTURE.md docs/
git mv DEPLOYMENT_TEST.md docs/ 2>/dev/null || mv DEPLOYMENT_TEST.md docs/
git mv SETUP.md docs/ 2>/dev/null || mv SETUP.md docs/

echo "Moving local development scripts..."
git mv setup_venv.sh dev/ 2>/dev/null || mv setup_venv.sh dev/
git mv activate_venv.sh dev/ 2>/dev/null || mv activate_venv.sh dev/
git mv run_crawler.sh dev/ 2>/dev/null || mv run_crawler.sh dev/
git mv run_checkout.sh dev/ 2>/dev/null || mv run_checkout.sh dev/
git mv run_all_local.sh dev/ 2>/dev/null || mv run_all_local.sh dev/
git mv stop_local.sh dev/ 2>/dev/null || mv stop_local.sh dev/

echo "✓ Files organized"
echo ""

# Stage all files
echo "Staging all files..."
git add -A

echo "✓ Files staged"
echo ""

# Show structure
echo "New project structure:"
echo ""
git status --short

echo ""
echo "=========================================="
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
- Updated scripts to work from any location

AWS deployment files remain at root for easy student access."

echo "✓ Committed"
echo ""

# Push
echo "=========================================="
echo "Pushing to GitHub..."
git push origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "✓ Successfully pushed to GitHub!"
    echo "=========================================="
    echo ""
    echo "Project Structure:"
    echo ""
    echo "loadgen/"
    echo "├── README.md                 # Main docs"
    echo "├── requirements.txt"
    echo "├── .gitignore"
    echo "│"
    echo "├── docs/                    # Documentation"
    echo "│   ├── README.md"
    echo "│   ├── SETUP.md"
    echo "│   ├── ARCHITECTURE.md"
    echo "│   └── DEPLOYMENT_TEST.md"
    echo "│"
    echo "├── AWS Files (root level - easy student access)"
    echo "│   ├── install_loadgen.sh"
    echo "│   ├── startload.sh"
    echo "│   ├── stopload.sh"
    echo "│   ├── kk4.py"
    echo "│   ├── test_checkout.py"
    echo "│   └── config.py"
    echo "│"
    echo "└── dev/                     # Local development"
    echo "    ├── README.md"
    echo "    ├── setup_venv.sh"
    echo "    ├── activate_venv.sh"
    echo "    ├── run_crawler.sh"
    echo "    ├── run_checkout.sh"
    echo "    ├── run_all_local.sh"
    echo "    └── stop_local.sh"
    echo ""
    echo "=========================================="
    echo "Next: Test deployment on remote host"
    echo "=========================================="
    echo ""
    echo "ssh -i /Users/bmstoner/Downloads/bootcamp.pem ubuntu@54.70.243.207"
    echo ""
    echo "Then on remote host:"
    echo "  sudo rm -rf /home/ubuntu/load && rm -f install_loadgen.sh"
    echo "  wget https://raw.githubusercontent.com/sandbreak80/loadgen/main/install_loadgen.sh"
    echo "  chmod +x install_loadgen.sh"
    echo "  sudo ./install_loadgen.sh"
    echo "  sudo /home/ubuntu/load/startload.sh"
    echo "  sleep 30 && ps aux | grep python3 | grep -E '(kk4|test_checkout)'"
    echo "  sudo /home/ubuntu/load/stopload.sh"
    echo ""
else
    echo "✗ Push failed"
    exit 1
fi

