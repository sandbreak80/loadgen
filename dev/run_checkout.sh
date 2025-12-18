#!/bin/bash
# Local script to run the checkout test
# Usage: ./run_checkout.sh [target_url]

# Check if virtual environment is active
if [ -z "$VIRTUAL_ENV" ] && [ -d "venv" ]; then
    echo "Activating virtual environment..."
    source venv/bin/activate
fi

# Set target URL if provided as argument
if [ ! -z "$1" ]; then
    export KONAKART_URL="$1"
    echo "Using target URL: $KONAKART_URL"
fi

# Run the checkout test
python3 test_checkout.py

