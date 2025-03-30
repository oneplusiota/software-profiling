#!/bin/bash

# Path to async-profiler
ASYNC_PROFILER_DIR="profilers/async-profiler"
ASYNC_PROFILER_BIN="$ASYNC_PROFILER_DIR/build/bin/asprof"

# Check if async-profiler exists
if [[ ! -x "$ASYNC_PROFILER_BIN" ]]; then
    echo "Error: async-profiler not found at $ASYNC_PROFILER_BIN"
    exit 1
fi

# Get a list of Java processes
echo "Available Java processes:"
jps -l | awk '{print NR") PID: "$1" - "$2}'

# Ask user to select a process
echo -n "Select a process number: "
read -r selection

# Get the corresponding PID
PID=$(jps -l | awk "NR==$selection {print \$1}")

# Validate PID
if [[ -z "$PID" ]]; then
    echo "Invalid selection!"
    exit 1
fi

echo "Profiling PID: $PID..."

# Run async-profiler
"$ASYNC_PROFILER_BIN" -d 30 -f results/flamegraph.html "$PID"

echo "Flame graph saved in results/flamegraph.html"