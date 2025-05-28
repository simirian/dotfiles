#!/bin/sh

path="$PWD/$0"

install() {
  echo "installing $1 to $2"
  test -d "${2%/*}" || mkdir -p "${2%/*}"
  ln -ns --backup=existing "${path%/*}/$1" "$2"
}

install bashrc ~/.bashrc
install kitty ~/.config/kitty
install gitconfig ~/.gitconfig

unset install
unset path
