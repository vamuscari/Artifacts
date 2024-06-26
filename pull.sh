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
# TODO: There is probably a better way to do this
copy() {

  in="$1"
  out="$PWD"
  if [[ $1 =~ ^([\!-\~]+)[[:space:]]+\.?([\!-\~]+)$ ]]; then
    debug "has multipath  ${BASH_REMATCH[1]} : ${BASH_REMATCH[2]}"
    in="${BASH_REMATCH[1]}"
    out="$PWD${BASH_REMATCH[2]}"
  fi

  if [[ -d $in && -d $out ]]; then
    debug "Type: Dir, From:'$in', To:'$out'"
    cp -r "$in" "$out"
  elif [[ -f $in && -d $out ]]; then
    debug "Type: File, From:'$in', To:'$out'"
    cp "$in" "$out"
  else
    echo "Invalid Path: $in : $out"
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
