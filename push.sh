#!/bin/bash

# File names can get wierd sometimes
# set echo >&2 to avoid pollutions of function capture
debug_enabled=true
debug() {
  if [ "$debug_enabled" = true ]; then
    echo >&2 "$1"
  fi
}

# Files are identified by a / at the end
# if the file name is left unspecified cp will use its current one hence just pwd
# FIX: I dont care that much about this right now. its close enough
# get basename then check path in pwd. copy out
copy() {
  base=$(basename "$1")
  localpath="$PWD/$base"
  if [[ -d $localpath ]]; then
    debug "Type: Dir, From:'$localpath', To:'$1'"
    cp -r "$PWD" "$1"
  elif [[ -f $localpath ]]; then
    debug "Type: File, From:'$localpath', To:'$1'"
    cp "$PWD" "$1"
  else
    echo "Invalid Path: $1"
  fi
}

# Simple match for home identity then replace with actual env
# BASH_REMATCH is the output of =~ and groups.
homeSub() {
  debug "homesub begin"
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
