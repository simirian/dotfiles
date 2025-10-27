#!/bin/bash

if [[ $HOME == /root* ]]; then
  echo "Do not run this script as root!"
  exit 1
fi

help() {
  echo 'Usage: ./install.sh [OPTIONS]'
  echo 'Install dotfiles to their correct locations in the user configuration.'
  echo ''
  echo 'Options:'
  echo '  -b --backup=[CONTROL] attempt to back up existing files, see `man 1 ln`'
  echo '  -p --pkg              install required packages in `pkglist.txt`'
  echo '  -d --dry-run          simulate installation, but don''t install anything'
  echo '  -h --help             print this help message and exit'
}

script=$(which $0)
cfg=${XDG_CONFIG_HOME-$HOME/.config}
cfg=${cfg%/}

flags=("-fsT")
dry=""
pkg=""
while [[ -n $1 ]]; do
  case $1 in
    -b | --backup*)
      flags+=($1)
      ;;
    -p | --pkg)
      pkg=true
      ;;
    -d | --dry-run)
      dry=true
      ;;
    -h | --help)
      help
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      help
      exit 1
      ;;
  esac
  shift
done

if [[ -n $pkg ]]; then
  echo "Attempting to install packages with pacman; sudo will ask for credentials."
  sudo pacman -Syu --needed - < "${script%/*}/pkglist.txt"
  if [[ $? == 1 ]]; then
    echo "Failed to install packages, exiting."
    exit 1
  fi
fi

declare -A targets
targets[bashrc]="$HOME/.bashrc"
targets[fnott]="$cfg/fnott"
targets[fuzzel]="$cfg/fuzzel"
targets[gitconfig]="$HOME/.gitconfig"
targets[hypr]="$cfg/hypr"
targets[kitty]="$cfg/kitty"
targets[nvim]="$cfg/nvim"
targets[tmux]="$cfg/tmux"
targets[waybar]="$cfg/waybar"

for src in ${!targets[@]}; do
  msg="Installing $src to ${targets[$src]} ..."
  echo $msg
  if [[ -z $dry ]]; then
    mkdir -p $(dirname ${targets[$src]})
    ln ${flags[@]} "${script%/*}/$src" "${targets[$src]}"\
      && echo -e "\e[1F$msg DONE"
  fi
done
