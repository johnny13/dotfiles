#!/bin/bash

# Import the ansi library for colors and UI
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/ansi" 

# Function to generate a random string
random_string() {
  local length=$1
  local chars=$2
  local result=""
  for _ in $(seq 1 $length); do
    result="$result${chars:RANDOM%${#chars}:1}"
  done
  echo "$result"
}

# Display a nice ASCII art header with a border
print_header() {
  ansi --bg-black --white "
  ┌───────────────────────────────────────────┐
  │                                           │
  │        RANDOM STRING GENERATOR            │
  │                                           │
  └───────────────────────────────────────────┘
  "
}

# Main script logic
main() {
  local length=$1
  shift
  local chars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  local only_numbers=false
  local only_letters=false
  local minimal_output=false

  # Parse options
  while [[ "$#" -gt 0 ]]; do
    case $1 in
      --numbers-only)
        chars="0123456789"
        ;;
      --letters-only)
        chars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        ;;
      --min)
        minimal_output=true
        ;;
      *)
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
    shift
  done

  # Generate the string
  local random_str=$(random_string $length "$chars")

  # Print result
  if [ "$minimal_output" = true ]; then
    echo "$random_str"
  else
    print_header
    echo
    echo "   Generated String: $random_str"
    echo
  fi
}

# Call the main function
main "$@"
