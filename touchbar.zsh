source ~/dotfiles/zsh-apple-touchbar/functions.zsh

touchBarState=''
npmScripts=()
lastPackageJsonPath=''

function displayDefault() {
  remove_and_unbind_keys

  touchBarState=''

  create_key 1 $(echo $(print -rD $PWD)) 'fzf-file-widget'

  function _prompt_segment() {
    local vcs=""
    # 'feature' or '@72f5c8a' if not on a branch.
    vcs+="${${VCS_STATUS_LOCAL_BRANCH//\%/%%}:-@${VCS_STATUS_COMMIT[1,8]}}"
    # ':master' if the tracking branch name differs from local branch.
    vcs+="${${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH}:+:${VCS_STATUS_REMOTE_BRANCH//\%/%%}}"
    # '#tag' if on a tag.
    vcs+="${VCS_STATUS_TAG:+#${VCS_STATUS_TAG//\%/%%}}"
    # ⇣42 if behind the remote.
    vcs+="${${VCS_STATUS_COMMITS_BEHIND:#0}:+ ⇣${VCS_STATUS_COMMITS_BEHIND}}"
    # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
    # If you want '⇣42 ⇡42' instead, replace '${${(M)VCS_STATUS_COMMITS_BEHIND:#0}:+ }' with ' '.
    vcs+="${${VCS_STATUS_COMMITS_AHEAD:#0}:+${${(M)VCS_STATUS_COMMITS_BEHIND:#0}:+ }⇡${VCS_STATUS_COMMITS_AHEAD}}"
    # *42 if have stashes.
    vcs+="${${VCS_STATUS_STASHES:#0}:+ *${VCS_STATUS_STASHES}}"
    # 'merge' if the repo is in an unusual state.
    vcs+="${VCS_STATUS_ACTION:+ ${VCS_STATUS_ACTION//\%/%%}}"
    # ~42 if have merge conflicts.
    vcs+="${${VCS_STATUS_NUM_CONFLICTED:#0}:+ ~${VCS_STATUS_NUM_CONFLICTED}}"
    # +42 if have staged changes.
    vcs+="${${VCS_STATUS_NUM_STAGED:#0}:+ +${VCS_STATUS_NUM_STAGED}}"
    # !42 if have unstaged changes.
    vcs+="${${VCS_STATUS_NUM_UNSTAGED:#0}:+ !${VCS_STATUS_NUM_UNSTAGED}}"
    # ?42 if have untracked files.
    vcs+="${${VCS_STATUS_NUM_UNTRACKED:#0}:+ ?${VCS_STATUS_NUM_UNTRACKED}}"
    create_key 2 "$(echo "⎇ $vcs")" 'fzf-git-branch'
  }
  prompt_vcs

  # PACKAGE.JSON
  # ------------
  # if [[ -f package.json ]]; then
  #   echo -ne "\033]1337;SetKeyLabel=F5=⚡️ npm-run\a"
  #   bind '"${fnKeys[5]}":"_displayNpmScripts"'
  # fi
}

# function _displayNpmScripts() {
#   # find available npm run scripts only if new directory
#   if [[ $lastPackageJsonPath != $(echo "$(pwd)/package.json") ]]; then
#     lastPackageJsonPath=$(echo "$(pwd)/package.json")
#     npmScripts=($(node -e "console.log(Object.keys($(npm run --json)).filter(name => !name.includes(':')).sort((a, b) => a.localeCompare(b)).filter((name, idx) => idx < 12).join(' '))"))
#   fi
#
#   clearTouchbar
#   unbindTouchbar
#
#   touchBarState='npm'
#
#   fnKeysIndex=1
#   for npmScript in "$npmScripts[@]"; do
#     fnKeysIndex=$((fnKeysIndex + 1))
#     bindkey -s $fnKeys[$fnKeysIndex] "npm run $npmScript \n"
#     echo -ne "\033]1337;SetKeyLabel=F$fnKeysIndex=$npmScript\a"
#   done
#
#   echo -ne "\033]1337;SetKeyLabel=F1=👈 back\a"
#   bindkey "${fnKeys[1]}" displayDefault
# }

precmd_touchbar() {
  if [[ $touchBarState == 'npm' ]]; then
    _displayNpmScripts
  else
    displayDefault
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd precmd_touchbar
