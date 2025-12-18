#!/bin/bash
# Setup script for local development environment
# Creates a virtual environment and installs dependencies

set -e  # Exit on error

echo "=========================================="
echo "LoadGen - Local Development Setup"
echo "=========================================="

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo "Error: python3 is not installed"
    exit 1
fi

echo "Python version: $(python3 --version)"
echo ""

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    echo "✓ Virtual environment created"
else
    echo "✓ Virtual environment already exists"
fi

echo ""
echo "Activating virtual environment..."
source venv/bin/activate

echo "✓ Virtual environment activated"
echo ""

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

echo ""
echo "Installing dependencies from requirements.txt..."
pip install -r requirements.txt

echo ""
echo "=========================================="
echo "Setup complete!"
echo "=========================================="
echo ""
echo "To activate the virtual environment in the future:"
echo "  source venv/bin/activate"
echo ""
echo "To run load tests:"
echo "  ./run_crawler.sh        # Single crawler"
echo "  ./run_checkout.sh       # Single checkout"
echo "  ./run_all_local.sh      # Full load (light)"
echo ""
echo "To deactivate when done:"
echo "  deactivate"
echo "=========================================="

