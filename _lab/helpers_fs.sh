# File Checks
## ------------------ ---------  ------   ----    ---     --      -
#   A series of functions which make checks against the filesystem.
#   For use in if/then statements.
#
#   Usage:
#      if is_file "file"; then
#         ...
#      fi
## ------------------ ---------  ------   ----    ---     --      -
# Checks if a command is installed
_hasCMD()
{

    if ! command -v $1 &>/dev/null; then
        #echo "${1} could not be found"
        return 1
    else
        return 0
        #echo "${1} was found"
    fi
}

# Returns whether the given command is executable or aliased.
_has()
{
    return $(which $1 >/dev/null)
}

is_exists()
{
    if [[ -e "$1" ]]; then
        return 0
    fi
    return 1
}

is_not_exists()
{
    if [[ ! -e "$1" ]]; then
        return 0
    fi
    return 1
}

is_file()
{
    if [[ -f "$1" ]]; then
        return 0
    fi
    return 1
}

is_not_file()
{
    if [[ ! -f "$1" ]]; then
        return 0
    fi
    return 1
}

is_dir()
{
    if [[ -d "$1" ]]; then
        return 0
    fi
    return 1
}

is_not_dir()
{
    if [[ ! -d "$1" ]]; then
        return 0
    fi
    return 1
}

is_symlink()
{
    if [[ -L "$1" ]]; then
        return 0
    fi
    return 1
}

is_not_symlink()
{
    if [[ ! -L "$1" ]]; then
        return 0
    fi
    return 1
}

is_empty()
{
    if [[ -z "$1" ]]; then
        return 0
    fi
    return 1
}

is_not_empty()
{
    if [[ -n "$1" ]]; then
        return 0
    fi
    return 1
}
