# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# https://github.com/romkatv/powerlevel10k#how-do-i-configure-instant-prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Prefer US English and use UTF-8.
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# Ask twice before exisitng shell on Ctrl + D
export IGNOREEOF=1

# Always enable colored `grep` output.
export GREP_OPTIONS="--color=auto"

export CLICOLOR=1
export GIT_PS1_SHOWDIRTYSTATE=1

eval "$(/opt/homebrew/bin/brew shellenv)"

# http://eradman.com/entrproject/limits.html
ulimit -n 200000
ulimit -u 2048

source ~/dotfiles/prompt.zsh
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
run-tracked +a source ~/.iterm2_shell_integration.zsh

export ENHANCD_DISABLE_DOT=1
export ENHANCD_COMPLETION_BEHAVIOR=list

export FZF_DEFAULT_OPTS="--height=50% --min-height=15 --reverse"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
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

run-tracked source ~/dotfiles/history.zsh
run-tracked +b source ~/dotfiles/bindings.zsh
run-tracked +bw source ~/dotfiles/completions.zsh
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

ZLE_RPROMPT_INDENT=0           # don't leave an empty space after right prompt
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
setopt +o NOMATCH              # don't complain about glob expansions within commands

local _startupTime=$((EPOCHREALTIME*1000-_start))

if (( _startupTime > 2048 )); then
  echo -E "${(%):-%F{red\}}[WARNING]: .zshrc took $((_startupTime))ms to load." >&2
fi

export CPPFLAGS="-I$HOMEBREW_PREFIX/include -L$HOMEBREW_PREFIX/lib"

export PATH=~/dotfiles/bin:$PATH
# Use GNU core utilities (those that come with macOS are outdated).
export PATH=$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH
export PATH=$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin:$PATH
export PATH=$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH
export PATH=$PATH:$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin

export PATH=$HOMEBREW_PREFIX/opt/python@3.10/bin:$PATH
export PATH=$HOMEBREW_PREFIX/opt/python@3.9/bin:$PATH
# To replace `python` with default python3 from homebrew:
# ln -f $HOMEBREW_PREFIX/bin/python3 $HOMEBREW_PREFIX/bin/python
# ln -f $HOMEBREW_PREFIX/bin/pip3 $HOMEBREW_PREFIX/bin/pip

export OPENBLAS=$HOMEBREW_PREFIX/opt/openblas

# Do not limit outputs from jest.
export DEBUG_PRINT_LIMIT=100000

export PYTHONSTARTUP=$HOME/.pyrc

export EDITOR=micro
export CPATH=$CPATH:$HOMEBREW_PREFIX/include
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOMEBREW_PREFIX/opt/lib
export SSH_AUTH_SOCK=$HOME/.sekey/ssh-agent.ssh
export JAVA_HOME=$HOMEBREW_PREFIX/opt/openjdk/libexec/openjdk.jdk/Contents/Home
export PAGER=less

export LOLCOMMITS_DELAY=1
export LOLCOMMITS_FORK=1
export LOLCOMMITS_STEALTH=1

# This affects every invocation of `less`.
#
#   -i   case-insensitive search unless search string contains uppercase letters
#   -R   color
#   -F   exit if there is less than one page of content
#   -X   keep content on screen after exit
#   -M   show more info at the bottom prompt line
#   -x2  tabs are 2 instead of 8
export LESS="-iRFXMx2"
export BAT_PAGER=0
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then . '$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'; fi
