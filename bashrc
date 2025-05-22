# ~/.bashrc

# ENVIRONMENT ==================================================================
export TERMINAL=kitty
export EDITOR=/bin/nvim
export PATH="$HOME/.local/bin:$PATH"

export GEM_HOME="$(gem env user_gemhome)"
export PATH="$PATH:$GEM_HOME/bin"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# set prompt
prompt() {
  local red="\[\e[91m\]"
  local yellow="\[\e[93m\]"
  local green="\[\e[92m\]"
  local fmtclr="\[\e[0m\]"

  if [ -d .git ]; then
    local branch="$(git branch --show-current 2> /dev/null)$fmtclr"

    [ -z "$DISPLAY$WAYLAND_DISPLAY" ] && branch=" on $branch" || branch=" 󰘬 $branch"
    branch="$branch"
  fi

  PS1="\n$yellow\t$green$branch $red\w\n$yellow\$ $fmtclr"
}

export PROMPT_COMMAND=prompt

# ALIASES ======================================================================
alias cls="clear"
alias vi="nvim --clean"

# this computer was made a year before vulkan :(
if [ $(cat /proc/sys/kernel/hostname) = "PArch" ]; then
  alias godot="godot --rendering-driver opengl3"
fi

# HEADER =======================================================================
clear
echo -e "\e[93m"
cat "$HOME/dotfiles/theme/thead/pixel.bashlogo"
echo -e "\e[0m"
