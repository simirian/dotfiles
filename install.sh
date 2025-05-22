#!/bin/bash

path="$PWD/$0"

install() {
  echo "installing $1 to $2"
  rm -r $2 &>/dev/null && echo "removed existing file at $2"
  ln -s --backup=existing "${path%/*}/$1" "$2"
}

unset install
unset path
