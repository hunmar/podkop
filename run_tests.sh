#!/bin/bash

# Test runner script for BATS unit tests

set -e

echo "=== Podkop BATS Unit Tests ==="
echo

# Check if BATS is installed
if ! command -v bats &> /dev/null; then
    echo "BATS is not installed. Installing..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y bats
    elif command -v brew &> /dev/null; then
        brew install bats-core
    elif command -v yum &> /dev/null; then
        sudo yum install -y bats
    else
        echo "Please install BATS manually: https://github.com/bats-core/bats-core"
        exit 1
    fi
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is not installed. Installing..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get install -y jq
    elif command -v brew &> /dev/null; then
        brew install jq
    elif command -v yum &> /dev/null; then
        sudo yum install -y jq
    else
        echo "Please install jq manually: https://stedolan.github.io/jq/"
        exit 1
    fi
fi

# Make test files executable
echo "Making test files executable..."
find tests/ -name "*.bats" -exec chmod +x {} \;
chmod +x tests/setup.bash

# Run tests
echo "Running BATS tests..."
echo "=========================================="

if [ -d "tests/unit" ]; then
    bats tests/unit/ --show-output-of-passing-tests
    echo "=========================================="
    echo "All tests completed successfully!"
else
    echo "No unit tests found in tests/unit/"
    exit 1
fi