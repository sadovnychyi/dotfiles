eval "$(/opt/homebrew/bin/brew shellenv)"

typeset -U path
path=("$HOME/dotfiles/bin" "$HOME/contracts/bin" "$HOMEBREW_PREFIX/opt/python@3.13/libexec/bin" $path)
