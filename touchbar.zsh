source ~/dotfiles/zsh-apple-touchbar/functions.zsh

touchBarState=''
npmScripts=()
lastPackageJsonPath=''

function displayDefault() {
  remove_and_unbind_keys

  touchBarState=''

  create_key 1 $(echo $(print -rD $PWD)) 'fzf-file-widget'

  function _prompt_segment() {
    colorRe="%?{*}"
    stripRe="{#%}"
    clean9=${9//${~stripRe}/}
    clean10=${10//${~colorRe}/}
    clean11=${11//${~colorRe}/}
    clean12=${12//${~colorRe}/}
    create_key 2 "$(echo "⎇ $8 $VCS_STATUS_TAG $clean10 $clean11 $clean12")" 'fzf-git-branch'
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
