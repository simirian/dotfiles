# ~/.bashrc

export TERMINAL=kitty
export EDITOR=nvim
export PATH="$HOME/.local/bin:$PATH"

export GEM_HOME="$(gem env user_gemhome)"
export PATH="$PATH:$GEM_HOME/bin"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

prompt() {
  if git rev-parse 2>/dev/null; then
    local branch="$(git branch --show-current) "
    [ -z "$DISPLAY$WAYLAND_DISPLAY" ] && branch="on $branch" || branch="󰘬 $branch"
  fi
  PS1="\[\e[93m\]\t \[\e[92m\]$branch\[\e[91m\]\W \[\e[93m\]\$ \[\e[0m\]"
}

export PROMPT_COMMAND=prompt

alias cls="clear"
alias ls="ls --color=auto"
alias vi="nvim --clean"
alias gui="uwsm start hyprland.desktop"

# this computer was made a year before vulkan :(
if [ $(cat /proc/sys/kernel/hostname) = "PArch" ]; then
  alias godot="godot --rendering-driver opengl3"
fi

clear
echo -e "\e[93m"
cat "$HOME/dotfiles/theme/thead/pixel.bashlogo"
echo -e "\e[0m"
