#!/bin/bash

for file in ~/.bash_{export,alias}
  do [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

for option in autocd globstar cdspell cmdhist histappend nocaseglob
  # autocd:     a command name that is the name of a directory is executed as
  #             if it were the argument to the cd command
  # globstar:   if set, recursive globbing with ** is enabled
  # cdspell:    autocorrect typos in path names when using `cd`
  # cmdhist:    in history file, combine multi-line comamnds into one line
  # histappend: append to the Bash history file, rather than overwriting it
  # nocaseglob: case-insensitive globbing (used in pathname expansion)
  do shopt -s "$option" 2> /dev/null
done

# Add tab completion for many Bash commands
if which brew > /dev/null && [ -f "$(brew --prefix)/etc/bash_completion" ]
  then source "$(brew --prefix)/etc/bash_completion"
elif [ -f /etc/bash_completion ]
  then source /etc/bash_completion
fi

if which brew > /dev/null
  then
  # Load the git autocomplete script
  if [ -f "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]
    then source "$(brew --prefix)/etc/bash_completion.d/git-completion.bash"
  fi
  # Load the git branch prompt script
  if [ -f "$(brew --prefix)/etc/bash_completion.d/git-promt.sh" ]
    then source "$(brew --prefix)/etc/bash_completion.d/git-promt.sh"
  fi
  # Load the docker autocomplete script
  if [ -f "$(brew --prefix)/etc/bash_completion.d/docker" ]
    then source "$(brew --prefix)/etc/bash_completion.d/docker"
  fi
fi

if [ -d ~/google-cloud-sdk ]; then
  # The next line updates PATH for the Google Cloud SDK
  source ~/google-cloud-sdk/path.bash.inc
  # The next line enables bash completion for gcloud
  source ~/google-cloud-sdk/completion.bash.inc
fi

__path_ps1() {
  local short_path_length=30
  local short_path_keep=3
  local ret=""
  local tilde="~"
  local p="${PWD/#$HOME/$tilde}"
  local mask="…"
  local -i max_len=$(( ${COLUMNS:-80} * short_path_length / 100 ))

  if (( ${#p} <= max_len )); then
    ret="${p}"
  else
    # Len is over max len, show at least short_path_keep leading dirs and
    # current directory
    local tmp=${p//\//}
    local -i delims=$(( ${#p} - ${#tmp} ))

    for (( dir=0; dir < short_path_keep; dir++ )); do
      (( dir == delims )) && break
      local left="${p#*/}"
      local name="${p:0:${#p} - ${#left}}"
      p="${left}"
      ret="${ret}${name%/}/"
    done

    if (( delims <= short_path_keep )); then
      # No dirs between short_path_keep leading dirs and current dir
      ret="${ret}${p##*/}"
    else
      local base="${p##*/}"

      p="${p:0:${#p} - ${#base}}"

      [[ ${ret} != "/" ]] && ret="${ret%/}" # strip trailing slash

      local -i len_left=$(( max_len - ${#ret} - ${#base} - ${#mask} ))

      ret="${ret}${mask}${p:${#p} - ${len_left}}${base}"
    fi
  fi
  # Escape special chars
  echo "${ret//\\/\\\\}"
}

BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

PATH_IN_TITLE="\[\033]0;\w\007\]"

_RESET="\[\017\]"
_RED="\[\033[31;1m\]"
_YELLOW="\[\033[33;1m\]"
_WHITE="\[\033[37;1m\]"
_GREEN="\[\033[1;92m\]"
_MAGENTA="\[\033[1;35m\]"

function timer_start {
  timer=${timer:-$SECONDS}
}

function timer_stop {
  timer_show=$(($SECONDS - $timer))
  unset timer
}

function timer_show_for_humans {
  local T=${timer_show}
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  (( $D > 0 )) && printf '%dd ' $D
  (( $H > 0 )) && printf '%dh ' $H
  (( $M > 0 )) && printf '%dm ' $M
  printf '%ds\n' $S
}

source ~/dotfiles/touchbar.bash

__prompt() {
  timer_stop
  if ((timer_show > 10 )); then
    printf "${NORMAL}${WHITE}%$(tput cols)s$(tput cr)\n" "$(timer_show_for_humans)"
  fi

  current_short_path=$(__path_ps1)

  history -a
  PS1="${PATH_IN_TITLE}${_RESET}${_MAGENTA}\${current_short_path}${_WHITE}·${_GREEN}"

  gitBranch=$(__git_ps1)
  if [[ $gitBranch ]]; then
      rightPrompt=$gitBranch
  elif [ "$current_short_path" != $(pwd) ]; then
      rightPrompt=$(pwd)
  else
      rightPrompt=""
  fi
  printf "${NORMAL}${WHITE}%$(tput cols)s$(tput cr)" "$rightPrompt"
  precmd_iterm_touchbar
}

__prompt_after() {
  printf "${NORMAL}${WHITE}%$(tput cols)s$(tput cr)${NORMAL}"
}

trap 'timer_start' DEBUG

PS0="$(__prompt_after)"
PROMPT_COMMAND=__prompt

# test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
