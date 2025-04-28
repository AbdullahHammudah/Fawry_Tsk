#!/bin/bash

# options' flags and arguments placeholders
num=false
inv=false
sh_string=""
file=""

# parse arguments
index=1
while [ $index -le $# ]; do
  current="${!index}"

  if [ "$current" = "--help" ]; then
    echo "Usage: $0 [-n] [-v] search_string file"
    exit 0

  elif [ "$current" = "-vn" ] || [ "$current" = "-nv" ]; then
    inv=true
    num=true

  elif [ "$current" = "-n" ]; then
    num=true
  elif [ "$current" = "-v" ]; then
    inv=true

  else
    # first non-option is search_string, second is file
    if [ -z "$sh_string" ]; then
      sh_string="$current"
    elif [ -z "$file" ]; then
      file="$current"
    fi
  fi

  index=$((index + 1))
done

# make sure both search_string and file exists
if [ -z "$sh_string" ] || [ -z "$file" ]; then
  echo "Error: Missing search_string or file"
  echo "Usage: $0 [-n] [-v] search_string file"
  exit 1
fi

# verify the file exists
if [ ! -f "$file" ]; then
  echo "File not found: $file"
  exit 1
fi

cmd="grep -i"
[ "$inv" = true ] && cmd="$cmd -v"
[ "$num" = true ] && cmd="$cmd -n"

# run the search
$cmd "$sh_string" "$file"

