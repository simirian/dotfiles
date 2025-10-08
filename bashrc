#!/bin/bash

export TERMINAL=kitty
export EDITOR=nvim
export PATH="$HOME/.local/bin:$PATH"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

export GEM_HOME="$(gem env user_gemhome)"
export PATH="$PATH:$GEM_HOME/bin"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

prompt() {
  if git rev-parse 2>/dev/null; then
    local branch="$(git branch --show-current) "
    [[ $(tty) == /dev/tty* ]] && branch="on $branch" || branch="󰘬 $branch"
  fi
  PS1="\[\e[93m\]\t \[\e[92m\]$branch\[\e[91m\]\W \[\e[93m\]\$ \[\e[0m\]"
}

export PROMPT_COMMAND=prompt

alias cls="clear"
alias ls="ls --color=auto"
alias vi="nvim --clean"
alias gui="uwsm check may-start && uwsm start hyprland.desktop"
alias tui="uwsm check is-active && uwsm stop"

clear
echo -e "\e[93m"
cat << EOF
                                          ██
                                         ████
       ▄██████ ███ ███  ████   ███      ▀▀████
      ███▀    ███ ████ █████  ███      █▄▄ ▀███
     ███████ ███ ███████████ ███      ██████████
       ▄███ ███ ███ ████ ███ ██      ████▀  ▀████
   ██████▀ ███ ███  ███  ███ █      █████    ██▀▀▀
                                   ██████▄  ▄████▄▄
                                  ███▀▀        ▀▀███
EOF
echo -e "\e[0m"
