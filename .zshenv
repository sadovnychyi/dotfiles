# Prefer US English and use UTF-8.
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Always enable colored `grep` output.
export GREP_OPTIONS="--color=auto"

# Ask twice before exisitng shell on Ctrl + D
export IGNOREEOF=1

# Setting for the new UTF-8 terminal support
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export CLICOLOR=1
export GIT_PS1_SHOWDIRTYSTATE=1

export APPENGINE_LIB='/usr/local/google_appengine'

export PYTHONSTARTUP="${HOME}/.pyrc"
export PYTHONIOENCODING='UTF-8'
export PYTHONDONTWRITEBYTECODE=true

export EDITOR=nano

export GOPATH=$HOME/go
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:~/go_appengine
export PATH=$PATH:~/dotfiles/bin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/sbin

export PATH=$PATH:/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

export SSH_AUTH_SOCK=$HOME/.sekey/ssh-agent.ssh
export PATH="$HOME/.cargo/bin:$PATH"

export JAVA_HOME="$(/usr/libexec/java_home)"

export PAGER=less

typeset -gaU cdpath fpath mailpath path
path=($HOME/bin $HOME/.local/bin $HOME/.cargo/bin ${path[@]})

export FZF_DEFAULT_OPTS="--height=50% --min-height=15 --reverse"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

# This affects every invocation of `less`.
#
#   -i   case-insensitive search unless search string contains uppercase letters
#   -R   color
#   -F   exit if there is less than one page of content
#   -X   keep content on screen after exit
#   -M   show more info at the bottom prompt line
#   -x4  tabs are 4 instead of 8
export LESS=-iRFXMx4

if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

setopt NO_GLOBAL_RCS