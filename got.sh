#!/bin/bash

# Check for a list of programs in path. Checks for and removes a question mark at the end 'cause I'm cute.
# got emacs?

deps="$*"
if [[ "${deps:$((${#deps}-1)):1}" == "?" ]]; then
  deps=$(printf '%s\n' "${list[@]%?}")
fi

for dep in $deps
do
  command -v $dep >/dev/null 2>&1 || { echo "$dep is not installed." >&2; }
done
