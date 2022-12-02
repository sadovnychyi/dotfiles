
alias grep='rg --color=auto'
alias tree='tree -aC -I .git --dirsfirst'
alias nano="micro"
alias cat="bat"
alias top="gotop"

# Folders sorted by disk space usage.
alias folders='find . -maxdepth 1 -type d -print0 | xargs -0 du -skh | sort -rn'

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias code="code ."
alias open="open ."
alias ls="ls -Fah"

# Clear which *really* clears the terminal, instead of appending bunch of new lines.
alias clear="printf '\33c\e[3J'"

chrome-history() {
  local cols sep
  cols=$(( COLUMNS / 3 ))
  sep='{::}'

  cp -f ~/Library/Application\ Support/Google/Chrome/Default/History /tmp/h

  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
     from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs open
}

__fzf_git_branch() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d' | sed 's@origin/@@' | awk '!a[$0]++') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo -n "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
  git checkout $(awk '{print $2}' <<<"$target" )
}

fzf-git-branch() {
  __fzf_git_branch
  local ret=$?
  zle reset-prompt
  return $ret
}

# Bind Ctrl+B to git branch selection
zle     -N   fzf-git-branch
bindkey '^B' fzf-git-branch

# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm,
# and their installed packages.
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

# View HTTP traffic.
alias sniff="sudo ngrep -d 'en0' -t '^(GET|POST) ' 'tcp and port 80'"

# macOS has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# macOS has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# Reload the shell (i.e. invoke as a login shell).
alias reload="exec $SHELL -l"

cdf() {
  target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
  if [ "$target" != "" ]; then
    cd "$target"; pwd
  else
    echo 'No Finder window found' >&2
  fi
}

python() {
  if [[ -d ./.venv ]] ; then
    .venv/bin/python $@
  else
     /opt/homebrew/bin/python $@
  fi
}

pytest() {
  if [[ -d ./.venv ]] ; then
    .venv/bin/pytest $@
  else
     /opt/homebrew/bin/pytest $@
  fi
}

pip() {
  if [[ -d ./.venv ]] ; then
    .venv/bin/pip $@
  else
     /opt/homebrew/bin/pip $@
  fi
}

docflow() {
  .venv/bin/python -m docflow $@
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

# Watch current directory for changes and re-run given commands once something
# changes. Clears terminal after each run. Useful for tests.
# Requires ripgrep and entr.
run() {
  _cmd="echo $@ && $@"
  # Use ripgrep to detect list of files that are not ignored by git.
  rg --files | entr -ccs "$_cmd"
}
