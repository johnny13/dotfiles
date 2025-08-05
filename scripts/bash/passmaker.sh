#!/bin/bash

# Set default length to 12
length=12

# Check if length parameter is provided
if [ ! -z "$1" ]; then
    # Validate length is a number
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        length=$1
        # Check if length is within bounds
        if [ $length -lt 8 ] || [ $length -gt 25 ]; then
            echo "Error: Length must be between 8 and 25 characters."
            exit 1
        fi
    else
        echo "Error: Length must be a number."
        exit 1
    fi
fi

# Check if running on macOS or Linux (Debian)
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS: Use openssl for random password
    openssl rand -base64 48 | tr -dc 'A-Za-z0-9!@#$%^&*' | head -c $length
else
    # Linux (Debian): Use /dev/urandom
    tr -dc 'A-Za-z0-9!@#$%^&*' < /dev/urandom | head -c $length
fi

exit 0
