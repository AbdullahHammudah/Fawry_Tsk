#!/usr/bin/env bash

# --------------IMPORTANT NOTE-------------#
# This Version Of mygrep (v2) is written with heavy dependacne on AI tools, unlike mygrep.sh
# you will realize hence this version is more capable, adhere to best practices & cover more test cases.
# I belive balance between AI capabilites and peronsal knowladge depth will produce best outcomes.
#------------------------------------------#

print_usage() {
  cat <<EOF
Usage: $0 [OPTIONS] PATTERN FILE
Search for PATTERN in FILE (case‐insensitive).

OPTIONS:
  -n        Show line numbers
  -v        Invert match (show non‐matching lines)
  --help    Display this help and exit
EOF
}

# --- Default flags ---
show_nums=false
invert=false

# --- Handle --help before getopts ---
if [[ $1 == "--help" ]]; then
  print_usage
  exit 0
fi

# --- Parse -n and -v with getopts ---
while getopts ":nv" opt; do
  case $opt in
    n) show_nums=true ;;
    v) invert=true  ;;
    \?) echo "mygrep: invalid option -$OPTARG" >&2
        print_usage >&2
        exit 1 ;;
  esac
done
shift $((OPTIND -1))

# --- Check for missing args ---
if [[ $# -eq 0 ]]; then
  echo "mygrep: missing search string and file" >&2
  print_usage >&2
  exit 1
elif [[ $# -eq 1 ]]; then
  echo "mygrep: missing search string" >&2
  print_usage >&2
  exit 1
fi

pattern=$1
file=$2

# --- File existence/permission checks ---
if [[ ! -f $file ]]; then
  echo "mygrep: $file: No such file" >&2
  exit 1
elif [[ ! -r $file ]]; then
  echo "mygrep: $file: Permission denied" >&2
  exit 1
fi

# --- Case-insensitive matching enabled ---
shopt -s nocasematch

line_no=0
while IFS= read -r line; do
  ((line_no++))
  match=false
  if [[ $line =~ $pattern ]]; then
    match=true
  fi

  # Decide whether to print
  if $invert; then
    $match && continue
  else
    ! $match && continue
  fi

  # Output
  if $show_nums; then
    printf "%d:%s\n" "$line_no" "$line"
  else
    printf "%s\n" "$line"
  fi
done < "$file"

