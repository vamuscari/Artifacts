#!/bin/bash

#  fsync: a config sync tool
#  by: Van Muscari
#  Sync config files between a git repo and your file system.
#  Using a list of files with the sync paths, 
#  fsync can push configs into the system or pull them in after making changes.

# TODO: Sync by last modified date 

# Text Colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
clear='\033[0m'

push='false' # push to the system
delete='false' # remove pre-existing files
test='false' # test run
files='files.txt' # file with paths
verbose='false' # print lots of things

usage() {
  echo "Usage: $0 [-p] [-d] [-f files] [-v] [-t]"
  echo "  -p: Push to the system"
  echo "  -d: Delete pre-existing files"
  echo "  -f: File with paths (default: files.txt)"
  echo "  -v: Verbose mode"
  echo "  -t: Test run"
  exit 1
}

while getopts 'pdf:vt' flag; do
  case "${flag}" in
    p) push='true' ;;
    d) delete='true' ;;
    f) files="${OPTARG}" ;;
    v) verbose='true' ;;
    t) test='true' ;;
    *) usage ;;
  esac
done

# File names can get wierd sometimes
# set echo >&2 to avoid pollution of function capture
log() {
  echo -e >&2 "$1"
}

# Verbose is basically just debug
verbose() {
  if [ "$verbose" = true ]; then
    echo -e >&2 "${yellow}$1${clear}"
  fi
}

# Files are identified by a / at the end
# if the file name is left unspecified cp will use its current one hence just pwd
elevate_prompt(){
  bool_prompt "Would you like to run as sudo?(N,y)"
}

copy() {
  verbose " "
  verbose "copy "
  local from="$1" to="$2" name="$3"
  local super=false
  local type="Unknown" 
  local overwrite=false
  local overwrite_type="unknown"

  if [[ ! -e $from ]]; then
    log "${red}Failed${clear}: Item does not exist, $from"
    return
  fi

  if [[ ! -r $from ]]; then
    log "Missing read permission: '$from'"
    super=$( elevate_prompt )
    if [[ "$super" = false ]]; then
      log "${red}Failed${clear}: Missing permissions, $from"
      return
    fi
  fi

  type=$( path_type $from )

  if [[ "$type" = "Unknown" ]]; then
    log "${red}Failed${clear} Invalid type: $from "
    return 
  fi

  verbose "Type: $type, From:'$from', To:'$to'"

  if [[ "$push" = true && ! -d $to ]]; then
    verbose "Destination directory does not exist, creating: $to"
    elevate_run $super "mkdir -p $to"
  fi

  if [[ ! -d $to ]]; then
    log "${red}Failed${clear}: Not a directory, $to"
    return
  fi

  if [[ ! -w $to && "$super" = false ]]; then
    log "Missing write permission: '$to'"
    super=$( bool_prompt "Would you like to run as sudo?(N,y)" )
    if [[ "$super" = false ]]; then
      log "${red}Failed${clear}: Missing permissions, $to"
      return
    fi
  fi

  if [[ -e "$to/$name" ]]; then

    overwrite=true 

    if [[ ! -w "$to/$name" && "$super" = false ]]; then
      log "Missing write permission: '$to/$name'"
      super=$( bool_prompt "Would you like to run as sudo?(N,y)" )
      if [[ "$super" = false ]]; then
        log "${red}Failed${clear}: Missing permissions, $to/$name"
        return
      fi
    fi

    overwrite_type=$( path_type "$to/$name" )

    if [[ "$overwrite_type" = "Unknown" ]]; then
      log "${red}Failed${clear} Invalid type: $to/$name "
      return 
    fi

    if [[ "$overwrite_type" != "$type" ]]; then
      log "${yellow}Warn${clear}: Mismatch overwrite type $type -> $overwrite_type"
      approve_mismatch=$( bool_prompt "Would you like to continue?(N,y)" )
      if [[ "$approve_mismatch" = false ]]; then
        log "${red}Failed${clear}: Mismatch types, $type -> $overwrite_type"
        return
      fi
    fi

    if [[ "$delete" = true ]]; then
      if [[ "$overwrite_type" = "Directory" ]]; then
        elevate_run $super "rm -r $to/$name"
        if [ "$?" -ne "0" ]; then
          log "${red}Failed${clear}: Could not delete pre-existing folder"
          return
        fi
        verbose "Removed pre-existing folder: '$to/$name'"
      fi


      if [[ "$overwrite_type" = "File" ]]; then
        elevate_run $super "rm $to/$name"
        if [ "$?" -ne "0" ]; then
          log "${red}Failed${clear}: Could not delete pre-existing file"
          return
        fi
        verbose "Removed pre-existing file: '$to/$name'"
      fi
    fi
  fi


  if [[ "$type" = "Directory" ]]; then
    elevate_run $super "cp -r $from $to"
    if [ "$?" -ne "0" ]; then
      log "${red}Failed${clear}"
      return
    fi
  fi

  if [[ "$type" = "File" ]]; then
    elevate_run $super "cp $from $to"
    if [ "$?" -ne "0" ]; then
      log "${red}Failed${clear}"
      return
    fi
  fi

  if [[ -e "$to/$name" ]]; then
    log "${green}Success${clear}: $to/$name"
  fi

}

bool_prompt(){
  read  -p "$1" -n 1 -r </dev/tty
  log " "
  if [[ $REPLY =~ ^[Yy]$ ]];
  then
    echo true
  else 
    echo false
  fi
}

elevate_run(){
  if [[ "$test"  = true ]]; then
    log "${magenta}Execute${clear}: $2"
    return 0
  elif [[ "$1" = true ]]; then
    sudo bash -c "$2"
    return $?
  else 
    bash -c "$2"
    return $?
  fi
}

path_type() {
  if [[ -d $1 ]]; then
    echo "Directory" 
  elif [[ -L $1 ]]; then
    echo "Link" 
  elif [[ -f $1 ]]; then
    echo "File" 
  else
    echo "Unknown"
  fi
  return 
}

parse_re='^([[:alnum:]+=_/\\.\\-]+)[[:space:]]+([[:alnum:]+=_/\\.\\-]+)'

parse_path_pull() {
  from=$(homeSub "$1")

  if [[ $from =~ $parse_re ]]; then
    verbose "has multipath  ${BASH_REMATCH[1]} : ${BASH_REMATCH[2]} "
    from="${BASH_REMATCH[1]% /}"
    to="$PWD/${BASH_REMATCH[2]% /}"
  else
    to="$PWD"
  fi

  name=$(basename $from)
}


parse_path_pull() {
  from=$(homeSub "$1")

  if [[ $from =~ $parse_re ]]; then
    verbose "has multipath  ${BASH_REMATCH[1]} : ${BASH_REMATCH[2]} "
    from="${BASH_REMATCH[1]%/}"
    local dest_path="${BASH_REMATCH[2]%/}"
    dest_path="${dest_path#./}"
    to="$PWD/$dest_path"
  else
    to="$PWD"
  fi

  name=$(basename "$from")
}


parse_path_push() {
  to=$(homeSub "$1")

  if [[ $to =~ $parse_re ]]; then
    verbose "has multipath  ${BASH_REMATCH[1]} : ${BASH_REMATCH[2]} "
    local source_path="${BASH_REMATCH[2]%/}"
    source_path="${source_path#./}"
    from="$PWD/$source_path/$(basename "${BASH_REMATCH[1]}")"
    to="${BASH_REMATCH[1]%/}"
  else
    from="$PWD/$(basename "$to")"
  fi

  name=$(basename "$to")
  to=$(dirname "$to")
}



# Simple match for home identity then replace with actual env
# BASH_REMATCH is the output of =~ and groups.
homeSub() {
  re='(\$HOME|~)(.*)'
  if [[ $1 =~ $re ]]; then
    # verbose "homesub regex match"
    echo "$HOME${BASH_REMATCH[2]}"
  else
    # verbose "homesub no match"
    echo "$1"
  fi
}

main(){
  if [[ "$push" = true ]]; then
    while read -r line || [ -n "$line" ]; do
      verbose " " 
      verbose "-------------------------------------------" 
      verbose "Pushing: $line" 
      from="" to="" name=""
      parse_path_push "$line"

      verbose " " 
      verbose "parse_path " 
      verbose "From: $from" 
      verbose "To: $to" 
      verbose "Name: $name" 
      copy "$from" "$to" "$name"
    done <"$files"
  else
    while read -r line || [ -n "$line" ]; do
      verbose " " 
      verbose "-------------------------------------------" 
      verbose "Pulling: $line" 
      from="" to="" name=""
      parse_path_pull "$line"

      verbose " " 
      verbose "parse_path " 
      verbose "From: $from" 
      verbose "To: $to" 
      verbose "Name: $name" 
      copy "$from" "$to" "$name"
    done <"$files"
  fi
}

main
