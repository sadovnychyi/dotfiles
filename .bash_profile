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

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

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

C_DEFAULT="\[\033[m\]"
C_WHITE="\[\033[1m\]"
C_BLACK="\[\033[30m\]"
C_RED="\[\033[31m\]"
C_GREEN="\[\033[32m\]"
C_YELLOW="\[\033[33m\]"
C_BLUE="\[\033[34m\]"
C_PURPLE="\[\033[35m\]"
C_CYAN="\[\033[36m\]"
C_LIGHTGRAY="\[\033[37m\]"
C_DARKGRAY="\[\033[1;30m\]"
C_LIGHTRED="\[\033[1;31m\]"
C_LIGHTGREEN="\[\033[1;32m\]"
C_LIGHTYELLOW="\[\033[1;33m\]"
C_LIGHTBLUE="\[\033[1;34m\]"
C_LIGHTPURPLE="\[\033[1;35m\]"
C_LIGHTCYAN="\[\033[1;36m\]"
C_BG_BLACK="\[\033[40m\]"
C_BG_RED="\[\033[41m\]"
C_BG_GREEN="\[\033[42m\]"
C_BG_YELLOW="\[\033[43m\]"
C_BG_BLUE="\[\033[44m\]"
C_BG_PURPLE="\[\033[45m\]"
C_BG_CYAN="\[\033[46m\]"
C_BG_LIGHTGRAY="\[\033[47m\]"

PATH_IN_TITLE="\[\033]0;\w\007\]"

source ~/dotfiles/touchbar.bash

__prompt() {
  current_short_path=$(__path_ps1)

  history -a

  PS1="${PATH_IN_TITLE}${C_BLUE}${current_short_path}${C_GREEN}·${C_DEFAULT}"

  # TODO: async
  precmd_iterm_touchbar
}

PROMPT_COMMAND=__prompt

# https://github.com/dvorka/hstr/blob/master/CONFIGURATION.md
# Do not prompt for confirmation when deleting history items, more colors
export HH_CONFIG=noconfirm,hicolor
# if this is interactive shell, then bind hh to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hh -- \C-j"'; fi
# if this is interactive shell, then bind 'kill last command' to Ctrl-x k
if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hh -k \C-j"'; fi
