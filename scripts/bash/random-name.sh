#!/usr/bin/env bash

# 1. Source the ansi library
if [[ -f "./ansi" ]]; then
    source ./ansi
else
    ansi() { shift; echo "$@"; }
fi

FILE="./names.txt"

if [[ ! -f "$FILE" ]]; then
    ansi --red --bold "Error: $FILE not found!"
    exit 1
fi

# Default: match everything
GENDER_REGEX="[[:space:]](m|f|fm)$"

# 2. Parse arguments to update the Regex
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --male)   GENDER_REGEX="[[:space:]](m|fm)$" ;;
        --female) GENDER_REGEX="[[:space:]](f|fm)$" ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# 3. Detect the best shuffle tool (Homebrew gshuf > Linux shuf > Python)
if command -v gshuf >/dev/null 2>&1; then
    SHUFFLE_CMD="gshuf -n 1"
elif command -v shuf >/dev/null 2>&1; then
    SHUFFLE_CMD="shuf -n 1"
else
    SHUFFLE_CMD="python3 -c 'import sys, random; lines=sys.stdin.readlines(); print(random.choice(lines) if lines else \"\", end=\"\")'"
fi

# 4. Pick the name using the regex
RAW_LINE=$(grep -E "$GENDER_REGEX" "$FILE" | eval "$SHUFFLE_CMD")

if [[ -z "$RAW_LINE" ]]; then
    ansi --red "No matching names found."
    exit 1
fi

# 5. Extract components
# This regex strips any trailing whitespace and the m/f/fm code
RAW_NAME=$(echo "$RAW_LINE" | sed -E 's/[[:space:]]+(m|f|fm)$//')
GENDER_CODE=$(echo "$RAW_LINE" | awk '{print $NF}')

# 6. Web-Safe Clean Up (Æ -> AE, etc.)
CLEAN_NAME=$(echo "$RAW_NAME" | iconv -f UTF-8 -t ASCII//TRANSLIT | sed 's/[^a-zA-Z0-9]//g')

# 7. Styled Output Logic
case $GENDER_CODE in
    m)  G_LABEL=$(ansi --blue "Male") ;;
    f)  G_LABEL=$(ansi --magenta "Female") ;;
    fm) G_LABEL=$(ansi --cyan "Unisex") ;;
    *)  G_LABEL=$(ansi --white "Unknown") ;;
esac

echo ""
ansi --bold --yellow "─── Random Identity ───"
echo -e "$(ansi --white "Original: ") $(ansi --bold "$RAW_NAME") ($G_LABEL)"
echo -e "$(ansi --white "Web-Safe: ") $(ansi --green --italic "$CLEAN_NAME")"
echo ""