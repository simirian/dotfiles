My dotfiles. Not super complicated, but I have plans to make them more
interesting. That depends on other projects getting done beforehand though, so
who knows when that'll happen.

This set of configurations requires:

- Arch Linux (if you want to run `./install.sh --pkg`)
- all of the packages listed in `pkglist.txt`
- user features: Hyprland, Kitty, Neovim, Tmux, Firefox, Libreoffice, Krita, and
  Inkscape

Everything can be installed with the install script, which requires bash. It
will delete or backup existing destination files (depending on `--backup`) and
symlink the files in this repo to their configuration locations. If you want to
see what gets installed where you can run `./install.sh --dry-run`.
