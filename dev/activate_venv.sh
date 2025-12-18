#!/bin/bash
# Helper script to activate the virtual environment
# Usage: source activate_venv.sh

if [ ! -d "venv" ]; then
    echo "Error: Virtual environment not found!"
    echo "Run './setup_venv.sh' first to create it."
    return 1 2>/dev/null || exit 1
fi

source venv/bin/activate
echo "✓ Virtual environment activated"
echo "Python: $(which python3)"
echo "Pip: $(which pip)"

