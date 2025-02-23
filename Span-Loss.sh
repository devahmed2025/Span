#!/bin/bash

# Wrapper script to execute the hidden script in /nokia/ahmed

# Expiration date (YYYY-MM-DD)
EXPIRATION_DATE="2025-03-28"

# Get current date
CURRENT_DATE=$(date +%Y-%m-%d)

# Compare dates
if [[ "$CURRENT_DATE" > "$EXPIRATION_DATE" ]]; then
    echo "This script has expired. Please contact the administrator."
    exit 1
fi

# Path to the hidden script
HIDDEN_SCRIPT="/nokia/1350OMS/NMS/SDH/14/rm/bin/span.sh"

# Check if the hidden script exists
if [ ! -f "$HIDDEN_SCRIPT" ]; then
    echo "Error: The hidden script does not exist or is not accessible."
    exit 1
fi

# Check if the hidden script is executable
if [ ! -x "$HIDDEN_SCRIPT" ]; then
    echo "Error: The hidden script is not executable."
    exit 1
fi

# Execute the hidden script
"$HIDDEN_SCRIPT"