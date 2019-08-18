() {
  zmodload zsh/terminfo
  autoload -Uz add-zle-hook-widget

  function expand-or-complete-with-dots() {
    emulate -L zsh
    local c=$(( ${+terminfo[rmam]} && ${+terminfo[smam]} ))
    (( c )) && echoti rmam
    print -Pn "%{%F{red}…%f%}"
    (( c )) && echoti smam
    zle expand-or-complete
    zle redisplay
  }

  local which
  for which in up back forward; do
    eval "function dirhistory-$which() {
      emulate -L zsh
      dirhistory_$which
      powerlevel9k_refresh_prompt_inplace
      zle .reset-prompt && zle -R
    }"
  done

  autoload -U up-line-or-beginning-search down-line-or-beginning-search

  zle -N up-line-or-beginning-search
  zle -N down-line-or-beginning-search
  zle -N expand-or-complete-with-dots

  zmodload zsh/terminfo

  if (( $+terminfo[smkx] && $+terminfo[rmkx] )); then
    function enable-term-application-mode() { echoti smkx }
    function disable-term-application-mode() { echoti rmkx }
    zle -N enable-term-application-mode
    zle -N disable-term-application-mode
    add-zle-hook-widget line-init enable-term-application-mode
    add-zle-hook-widget line-finish disable-term-application-mode
  fi

  # Note: You can specify several codes separated by space. All of them will be bound.
  #
  # For example:
  #
  #   CtrlUp '\e[1;5A \e[A'
  #
  # Now, any widget in `bindings` that binds to CtrlUp will be bound to '\e[1;5A' and '\e[A'.
  local -A key_code=(
    Ctrl          '^'
    Tab           '\t'
    Backspace     '^?'
    Delete        '\e[3~'
    Up            "$terminfo[kcuu1]"
    Left          "$terminfo[kcub1]"
    Down          "$terminfo[kcud1]"
    Right         "$terminfo[kcuf1]"
    ShiftTab      "$terminfo[kcbt]"
    CMDLeft       '^X\x7f'
    CMDShiftZ     '^X^_'
  )

  local -a bindings=(
    Up        up-line-or-beginning-search    # prev command in history
    Down      down-line-or-beginning-search  # next command in history
    ShiftTab  reverse-menu-complete          # previous in completion menu
    Tab       expand-or-complete-with-dots   # show '...' while completing
    CMDLeft   backward-kill-line             # delete all to the left
    CMDShiftZ redo
  )

  local key widget
  for key widget in $bindings[@]; do
    local -a code=('')
    local part=''
    for part in ${(@ps:-:)key}; do
      if [[ $#part == 1 ]]; then
        code=${^code}${(L)part}
      elif [[ -n $key_code[$part] ]]; then
        local -a p=(${(@ps: :)key_code[$part]})
        code=(${^code}${^p})
      else
        (( $+key_code[$part] )) || echo -E "[ERROR] undefined key: $part" >&2
        code=()
        break
      fi
    done
    local c=''
    for c in $code[@]; do bindkey $c $widget; done
  done
}
