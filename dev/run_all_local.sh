#!/bin/bash
# Local script to run load generation with multiple instances
# Usage: ./run_all_local.sh [target_url] [crawler_count] [checkout_count]

# Check if virtual environment is active
if [ -z "$VIRTUAL_ENV" ] && [ -d "venv" ]; then
    echo "Activating virtual environment..."
    source venv/bin/activate
    echo ""
fi

TARGET_URL=${1:-$(python3 -c "import config; print(config.TARGET_URL)")}
CRAWLER_COUNT=${2:-2}  # Default to 2 for local testing (less intensive)
CHECKOUT_COUNT=${3:-2}  # Default to 2 for local testing

echo "=========================================="
echo "LoadGen - Local Execution"
echo "=========================================="
echo "Target URL: $TARGET_URL"
echo "Crawler Instances: $CRAWLER_COUNT"
echo "Checkout Instances: $CHECKOUT_COUNT"
echo "Python: $(which python3)"
echo "=========================================="
echo ""

# Ensure logs directory exists
mkdir -p logs

# Export configuration
export KONAKART_URL="$TARGET_URL"
export CRAWLER_INSTANCES="$CRAWLER_COUNT"
export CHECKOUT_INSTANCES="$CHECKOUT_COUNT"
export CHECKOUT_ITERATIONS="100"  # Fewer iterations for local testing

# Start crawler instances
echo "Starting $CRAWLER_COUNT crawler instance(s)..."
for i in $(seq 1 $CRAWLER_COUNT); do
    python3 kk4.py > "logs/crawler_$i.log" 2>&1 &
    echo "  Crawler $i started (PID: $!)"
done

sleep 2

# Start checkout test instances
echo ""
echo "Starting $CHECKOUT_COUNT checkout test instance(s)..."
for i in $(seq 1 $CHECKOUT_COUNT); do
    python3 test_checkout.py > "logs/checkout_$i.log" 2>&1 &
    echo "  Checkout test $i started (PID: $!)"
done

echo ""
echo "=========================================="
echo "All load generators started!"
echo "Check logs/ directory for output"
echo "Run './stop_local.sh' to stop all processes"
echo "=========================================="

