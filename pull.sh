#!/bin/bash

# File names can get wierd sometimes
# set echo >&2 to avoid pollutions of function capture
debug_enabled=false
debug() {
  if [ "$debug_enabled" = true ]; then
    echo >&2 "$1"
  fi
}

# Files are identified by a / at the end
# if the file name is left unspecified cp will use its current one hence just pwd
copy() {
  from="$1"
  to="$PWD"
  if [[ $1 =~ ^([\!-\~]+)[[:space:]]+\.?([\!-\~]+)$ ]]; then
    debug "has multipath  ${BASH_REMATCH[1]} : ${BASH_REMATCH[2]}"
    from="${BASH_REMATCH[1]%/}"
    to="$PWD${BASH_REMATCH[2]}"
  fi

  from=${from%/}

  if [[ -d $from && -d $to ]]; then
    debug "Type: Dir, From:'$from', To:'$to'"
    cp -r "$from" "$to"
  elif [[ -f $from && -d $to ]]; then
    debug "Type: File, From:'$from', To:'$to'"
    cp "$from" "$to"
  else
    echo "invalid Path: $from : $to"
  fi
}

# Simple match for home identity then replace with actual env
# BASH_REMATCH is the output of =~ and groups.
homeSub() {
  re='(\$HOME|~)(.*)'
  if [[ $line =~ $re ]]; then
    debug "homesub regex match"
    echo "$HOME${BASH_REMATCH[2]}"
  fi
}

# Read input from file one line at a time.
while read -r line || [ -n "$line" ]; do
  newpath=$(homeSub "$line")
  copy "$newpath"
done <files.txt
