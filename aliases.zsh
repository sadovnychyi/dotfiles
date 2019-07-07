alias diff='diff --color=auto'
alias grep='rg --color=auto'
alias tree='tree -aC -I .git --dirsfirst'

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Folders sorted by disk space usage
alias folders='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias apm="apm-beta"
alias atom="atom-beta ."
alias open="open ."
alias ls="ls -Fah"

# Remove unwanted formatting from text in the clipboard (also available as Shift + Cmd + V)
alias pbclean='pbpaste | pbcopy'

alias timer="echo 'Timer started. Stop with Ctrl-D.' && date && time cat && date"

# Clear which *really* clears the terminal, instead of appending bunch of new lines
alias clear="printf '\33c\e[3J'"

# Set git as alias for hub
eval "$(hub alias -s)"

__fzf_git_branch() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo -n "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
  git checkout $(awk '{print $2}' <<<"$target" )
}

fzf-git-branch() {
  LBUFFER="${LBUFFER}$(__fzf_git_branch)"
  local ret=$?
  zle reset-prompt
  return $ret
}
# Bind Ctrl+B to git branch selection
zle     -N   fzf-git-branch
bindkey '^B' fzf-git-branch

# Get OS X Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
function upgrade() {
  sudo softwareupdate -i -a
  brew update
  brew upgrade
  brew cleanup
  npm install npm -g
  npm update -g
  sudo gem update --system
  sudo gem update
  gcloud components --quiet update
}

# IP addresses
alias ip="echo 'Local:'
          ipconfig getifaddr en0
          echo 'External:'
          dig +short +time=1 +tries=1 +retry=0 myip.opendns.com"

alias lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
alias afk=lock

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# View HTTP traffic
alias sniff="ngrep -d 'en0' -t '^(GET|POST) ' 'tcp and port 80'"

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"

# OS X has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# OS X has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes
                  sudo rm -rfv ~/.Trash
                  sudo rm -rfv /private/var/log/asl/*.asl"

for method in GET HEAD POST PUT DELETE TRACE OPTIONS
  do alias "$method"="lwp-request -m '$method'"
done

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

alias vi=pyvim

# alias drmi="docker rmi -f $(docker images | grep "<none>" | awk "{print \$3}")"

cdf() {
  target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
  if [ "$target" != "" ]; then
    cd "$target"; pwd
  else
    echo 'No Finder window found' >&2
  fi
}

update_macos_notes() {
  brew list -l > ~/dotfiles/.macos && brew cask list -l >> ~/dotfiles/.macos
}


function isnt_connected () {
  scutil --nc status VPN | sed -n 1p | grep -qv Connected
}

function poll_until_connected () {
  let loops=0 || true
  let max_loops=120
  while isnt_connected VPN; do
    sleep 1
    let loops=$loops+1
    [ $loops -gt $max_loops ] && break
  done
  [ $loops -le $max_loops ]
}

vpn_up() {
  gcloud compute instances start vpn --project=sadovnychyi --zone=asia-east1-c
  sleep 10
  scutil --nc start VPN --secret=notasecret
  if poll_until_connected VPN; then
    echo "Connected to $vpn!"
    return
  else
    echo "I'm too impatient!"
    scutil --nc stop VPN
    return
  fi
}

vpn_down() {
  scutil --nc stop VPN
  gcloud compute instances stop vpn --project=sadovnychyi --zone=asia-east1-c
}
