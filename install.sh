#!/bin/bash

if [[ $HOME == /root* ]]; then
	echo "Do not run this script as root!"
	exit 1
fi

script=$(which $0)
cfg=${XDG_CONFIG_HOME-$HOME/.config}
cfg=${cfg%/}

flags=("-fsT")
dry=""
pkg=""
while [[ -n $1 ]]; do
	case $1 in
		--backup*)
			flags+=($1)
			;;
		--pkg)
			pkg=true
			;;
		--dry-run)
			dry=true
			;;
		*)
			echo "Unknown option: $1"
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
targets[hypr]="$cfg/hypr"
targets[kitty]="$cfg/kitty"
targets[tmux]="$cfg/tmux"
targets[bashrc]="$HOME/.bashrc"
targets[gitconfig]="$HOME/.gitconfig"
targets[nvim]="$cfg/nvim"

for src in ${!targets[@]}; do
	msg="Installing $src to ${targets[$src]} ..."
	echo $msg
	if [[ -z $dry ]]; then
		ln ${flags[@]} "${script%/*}/$src" "${targets[$src]}"\
			&& echo -e "\e[1F$msg DONE"
	fi
done
