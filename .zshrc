if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/dotfiles/powerlevel10k/powerlevel10k.zsh-theme

emulate zsh

zmodload zsh/datetime
local _start=$((EPOCHREALTIME*1000))

autoload -Uz add-zsh-hook run-help zargs zmv zcp zln

ZSH=~/dotfiles/oh-my-zsh
ZSH_CUSTOM=$ZSH/custom

ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=32
ZSH_AUTOSUGGEST_USE_ASYNC=true

if zmodload zsh/terminfo && (( terminfo[colors] >= 256 )); then
  # the default is hard to see
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
else
  # the default is outside of 8 color range
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=005'
fi

source ~/dotfiles/functions.zsh

# Kill bindings and widgets as we define our own in bindings.zsh. Deny random exports.
run-tracked -bwe source $ZSH/plugins/dirhistory/dirhistory.plugin.zsh
# Disallow `x` alias.
run-tracked -a source $ZSH/plugins/extract/extract.plugin.zsh
# Allow `z` alias.
run-tracked +a source $ZSH/plugins/z/z.plugin.zsh
run-tracked source ~/dotfiles/zsh-prompt-benchmark/zsh-prompt-benchmark.plugin.zsh
run-tracked source ~/.iterm2_shell_integration.zsh

export DISABLE_FZF_AUTO_COMPLETION="true"
run-tracked +b source $ZSH/plugins/fzf/fzf.plugin.zsh

function late-init() {
  emulate -L zsh
  # Must be sourced after all widgets have been defined but before zsh-autosuggestions.
  run-tracked +aw source ~/dotfiles/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

  run-tracked +aeb source ~/dotfiles/enhancd/init.sh

  run-tracked source ~/dotfiles/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
  run-tracked +w _zsh_autosuggest_start
  add-zsh-hook -d precmd late-init
}

add-zsh-hook precmd late-init

run-tracked source ~/dotfiles/prompt.zsh
run-tracked source ~/dotfiles/history.zsh
run-tracked +b source ~/dotfiles/bindings.zsh
run-tracked +bw source ~/dotfiles/completions.zsh
run-tracked source ~/dotfiles/touchbar.zsh
run-tracked source ~/dotfiles/wakatime-zsh-plugin/wakatime.plugin.zsh

# On every prompt, set terminal title to "cwd".
function set-term-title() {
  print -Pn '\e]0;%~\a'
}
add-zsh-hook precmd set-term-title

# Disable highlighting of text pasted into the command line.
zle_highlight=('paste:none')

(( $+aliases[run-help] )) && unalias run-help
run-tracked +ab source ~/dotfiles/aliases.zsh

# TODO: fix with next version of zsh
# https://github.com/romkatv/powerlevel10k/commit/f95a0fc3eef9a33c1a783359ea17b9486b27e30e
# ZLE_RPROMPT_INDENT=0           # don't leave an empty space after right prompt
READNULLCMD=$PAGER             # use the default pager instead of `more`
WORDCHARS=''                   # only alphanums make up words in word-based zle widgets
ZLE_REMOVE_SUFFIX_CHARS=''     # don't eat space when typing '|' after a tab completion

setopt ALWAYS_TO_END           # full completions move cursor to the end
setopt AUTO_CD                 # `dirname` is equivalent to `cd dirname`
setopt AUTO_PUSHD              # `cd` pushes directories to the directory stack
setopt EXTENDED_GLOB           # (#qx) glob qualifier and more
setopt GLOB_DOTS               # glob matches files starting with dot; `*` becomes `*(D)`
setopt HIST_EXPIRE_DUPS_FIRST  # if history needs to be trimmed, evict dups first
setopt HIST_IGNORE_DUPS        # don't add dups to history
setopt HIST_IGNORE_SPACE       # don't add commands starting with space to history
setopt HIST_REDUCE_BLANKS      # remove junk whitespace from commands before adding to history
setopt HIST_VERIFY             # if a cmd triggers history expansion, show it instead of running
setopt INTERACTIVE_COMMENTS    # allow comments in command line
setopt MULTIOS                 # allow multiple redirections for the same fd
setopt NO_BANG_HIST            # disable old history syntax
setopt PUSHD_IGNORE_DUPS       # don’t push copies of the same directory onto the directory stack
setopt PUSHD_MINUS             # `cd -3` now means "3 directory deeper in the stack"
setopt SHARE_HISTORY           # write and import history on every command
setopt EXTENDED_HISTORY        # write timestamps to history
# setopt CORRECT_ALL           # try to correct the spelling of commands

# https://github.com/robbyrussell/oh-my-zsh/issues/31
unsetopt nomatch

local _startupTime=$((EPOCHREALTIME*1000-_start))

if (( _startupTime > 2048 )); then
  echo -E "${(%):-%F{red\}}[WARNING]: .zshrc took $((_startupTime))ms to load." >&2
fi
