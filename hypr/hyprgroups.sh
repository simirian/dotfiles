#!/bin/bash

help() {
  echo 'Usage: hyprgroups.sh [OPTIONS] <SUBCOMMAND> [OFFSET]'
  echo 'Access hyprland workspaces in groups.'
  echo ''
  echo 'Options:'
  echo '  -n  --count=  Set the number of groups for this command.'
  echo '                If not supplied, $HYPRGROUP_COUNT or 6 will be used.'
  echo '  -f  --focus   Only move focus, not the current window.'
  echo '  -m  --move    Move the current window to the target workspace.'
  echo '  -h  --help    Print this help and exit.'
  echo ''
  echo 'Subcommands:'
  echo '  workspace   Manipulate the current workspace of the group.'
  echo '  group       Manipulate the current group.'
  echo ''
  echo 'Offsets:'
  echo '  Offsets can be one of `+n`, `-n`, `=n`, or `n`.'
}

workspace() {
  hyprctl activeworkspace -j | jq '.id - 1'
}

offset() {
  case $2 in
    +* | -*)
      echo $(($1 + $2))
      ;;
    *)
      echo ${2#=}
      ;;
  esac
}

clamp() {
  if (( $1 < $2 )); then
    echo $2
  elif (( $1 > $3 )); then
    echo $3
  else
    echo $1
  fi
}

n=${HYPRGROUP_COUNT:-6}
command="workspace"

while [[ -n $1 ]]; do
  case $1 in
    --count=*)
      n=${1#--count=}
      ;;
    -n)
      shift
      n=$1
      ;;
    -m | --move)
      command="movetoworkspace"
      ;;
    -f | --focus)
      command="workspace"
      ;;
    -h | --help)
      help
      exit 0
      ;;
    group)
      group=$(($(workspace) % $n))
      if [[ -z $2 ]]; then
        echo $group
        exit 0
      fi
      group=$(clamp $(offset $group $2) 0 $((n - 1)))
      ws=$(hyprctl workspaces -j | jq ".[] | select(.name[-1:] == \"*\" and (.id - 1) % $n == $group) | .id - 1")
      ws=$((${ws:-$group} + 1))
      perc="20%"
      if [[ $(($(workspace) % $n)) -lt $group ]]; then
        [[ $(hyprctl activeworkspace -j | jq .id) -gt $ws ]] && perc="-20%"
      else
        [[ $(hyprctl activeworkspace -j | jq .id) -lt $ws ]] && perc="-20%"
      fi
      hyprctl --batch "\
        keyword animation workspaces, 1, 2, easeInOutCubic, slidevertfade $perc;\
        dispatch $command $ws" > /dev/null
      exit 0
      ;;
    workspace)
      group=$(($(workspace) % $n))
      ws=$(($(workspace) / $n))
      if [[ -z $2 ]]; then
        echo $ws
        exit 0
      fi
      ws=$(clamp $(offset $ws $2) 0 99999999999)
      ws=$((ws * n + group + 1))
      oldws=$(hyprctl activeworkspace -j | jq .id)
      hyprctl --batch "\
        keyword animation workspaces, 1, 2, easeInOutCubic, slidefade 20%;\
        dispatch renameworkspace $oldws $oldws;\
        dispatch $command $ws;\
        dispatch renameworkspace $ws $ws*;" > /dev/null
      exit 0
      ;;
    *)
      echo "Unknown argument: $1"
      help
      exit 1
      ;;
  esac
  shift
done
