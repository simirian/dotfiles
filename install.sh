#!/bin/bash

script=$(which $0)
cfg=${XDG_CONFIG_HOME-$HOME/.config}
cfg=${cfg%/}

echo $HOME

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
	pacman -Syu --needed - < "${script%/*}/pkglist.txt"\
		|| echo "Failed to install packages, exiting."\
		&& exit 1
fi

declare -A targets
targets[hypr]="$cfg/hypr"
targets[kitty]="$cfg/kitty"
targets[tmux]="$cfg/tmux"
targets[bashrc]="$HOME/.bashrc"
targets[gitconfig]="$HOME/.gitconfig"

for src in ${!targets[@]}; do
	msg="Installing $src to ${targets[$src]} ..."
	echo $msg
	if [[ -z $dry ]]; then
		ln ${flags[@]} "${script%/*}/$src" "${targets[$src]}"\
			&& echo -e "\e[1F$msg DONE"
	fi
done
