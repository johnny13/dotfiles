#!/usr/bin/env bash
#
# Generate random strings with different character sets
# Usage: random-string [options]
#
# Options:
#   -l, --length N     Length of string (default: 13)
#   -n, --no-special   Alphanumeric only (A-Za-z0-9)
#   -w, --web          Web-safe (A-Za-z0-9_-)
#   -h, --help         Show this help
#

set -u

# Default values
LENGTH=13
CHARSET='A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~'

print_help() {
    echo "Usage: $(basename "$0") [options]"
    echo
    echo "Options:"
    echo "  -l, --length N     Length of the random string (default: $LENGTH)"
    echo "  -n, --no-special   Use only alphanumeric characters (A-Za-z0-9)"
    echo "  -w, --web          Use web-safe characters (A-Za-z0-9_-)"
    echo "  -h, --help         Show this help message"
    echo
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -l|--length)
            LENGTH="$2"
            shift 2
            ;;
        -n|--no-special)
            CHARSET='A-Za-z0-9'
            shift
            ;;
        -w|--web)
            CHARSET='A-Za-z0-9_-'
            shift
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        -*)
            echo "Unknown option: $1" >&2
            print_help
            exit 1
            ;;
        *)
            # Positional length (old behavior)
            if [[ "$1" =~ ^[0-9]+$ ]]; then
                LENGTH="$1"
            else
                echo "Invalid argument: $1" >&2
                exit 1
            fi
            shift
            ;;
    esac
done

# Validate length
if ! [[ "$LENGTH" =~ ^[0-9]+$ ]] || (( LENGTH < 1 )); then
    echo "Error: length must be a positive integer" >&2
    exit 1
fi

# Generate and output
LC_ALL=C tr -dc "$CHARSET" </dev/urandom | head -c "$LENGTH"
echo