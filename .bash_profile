#!/bin/bash

for file in ~/.bash_{export,alias}
  do [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Whenever displaying the prompt, write the previous line to disk
PROMPT_COMMAND="history -a"

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

RESET="\[\017\]"
RED="\[\033[31;1m\]"
YELLOW="\[\033[33;1m\]"
WHITE="\[\033[37;1m\]"
GREEN="\[\033[1;92m\]"
PURPLE="\[\033[1;35m\]"

SELECT="if [ \$? = 0 ]; then echo \"${WHITE}✈\"; else echo \"${RED}✈\"; fi"

export PS1="${RESET}${PURPLE}\w${YELLOW}\$(__git_ps1) \`${SELECT}\` ${GREEN}"
