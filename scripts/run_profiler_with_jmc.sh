#!/bin/bash

# Define paths
PROJECT_HOME="$HOME/Documents/brown-bag/software-profiling"
ASYNC_PROFILER_DIR="$PROJECT_HOME/profilers/async-profiler"
ASYNC_PROFILER="$ASYNC_PROFILER_DIR/build/bin/asprof"
JMC_APP="/Applications/JDK Mission Control.app"
RESULTS_DIR="$PROJECT_HOME/results/jmc"

# Ensure async-profiler exists
if [[ ! -f "$ASYNC_PROFILER" ]]; then
    echo "Error: async-profiler not found at $ASYNC_PROFILER"
    exit 1
fi

# Ensure JMC exists
if [[ ! -d "$JMC_APP" ]]; then
    echo "Error: JDK Mission Control not found at $JMC_APP"
    exit 1
fi

# Create results directory if it doesn't exist
mkdir -p "$RESULTS_DIR"

# Select a Java process using fzf
echo "Select a Java process to profile:"
TARGET_PID=$(jps -l | fzf | awk '{print $1}')

# Validate PID
if [[ -z "$TARGET_PID" ]]; then
    echo "No process selected."
    exit 1
fi

echo "Profiling PID $TARGET_PID..."
OUTPUT_FILE="$RESULTS_DIR/profile-$TARGET_PID.jfr"

# Run async-profiler in JFR mode
"$ASYNC_PROFILER" start -e cpu -o jfr "$TARGET_PID" > /dev/null 2>&1
echo "Press Enter to stop profiling..."
read
"$ASYNC_PROFILER" stop -o "$OUTPUT_FILE" "$TARGET_PID" > /dev/null 2>&1

echo "Profile saved at $OUTPUT_FILE"

# Open JMC and load the JFR file
echo "Opening JMC..."
open -a "$JMC_APP" "$OUTPUT_FILE"

