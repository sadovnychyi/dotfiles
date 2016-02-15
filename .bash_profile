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

# Grunt autocomplete
if which grunt > /dev/null
  then eval "$(grunt --completion=bash)"
fi

# Set git as alias for hub
eval "$(hub alias -s)"

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

__prompt() {
  history -a
  PS1="${PATH_IN_TITLE}${NORMAL}${BRIGHT}${MAGENTA}\$(__path_ps1)${WHITE}${NORMAL}·${NORMAL}${BRIGHT}${GREEN}"
  rightPrompt="$(__git_ps1)"
  printf "${NORMAL}${BLACK}%`tput cols`s`tput cr`" "$rightPrompt"
}

PROMPT_COMMAND=__prompt
