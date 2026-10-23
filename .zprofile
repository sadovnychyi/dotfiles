eval "$(/opt/homebrew/bin/brew shellenv)"

typeset -U path
path=(
  "$HOME/.local/bin"
  "$HOMEBREW_PREFIX/share/google-cloud-sdk/bin"
  "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin"
  "$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin"
  "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
  "$HOME/dotfiles/bin"
  "$HOME/contracts/bin"
  "$HOMEBREW_PREFIX/opt/python@3.13/libexec/bin"
  $path
)
