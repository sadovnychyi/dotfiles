# Macbook Pro touchbar support for powerlevel10k prompt elements
#
# Requirements:
#   * MBP with touchbar
#   * iTerm2 with shell integrations: `source ~/.iterm2_shell_integration.zsh`
#   * zsh-apple-touchbar plugin
#
# Usage:
#   Set prompt elements you would like to appear on touchbar using:
#
#     typeset -g POWERLEVEL9K_TOUCHBAR_ELEMENTS=(
#       dir
#       vcs
#     )
#
#   You can configure an action for each button by using one of:
#
#     typeset -g POWERLEVEL9K_{ELEMENT}_TOUCHBAR_CMD='ls'
#     typeset -g POWERLEVEL9K_{ELEMENT}_TOUCHBAR_WIDGET='widget'
#
#   For example, to open git branch chooser when pressing on VCS button
#   (note that you need to have this widget available):
#
#     typeset -g POWERLEVEL9K_VCS_TOUCHBAR_WIDGET='fzf-git-branch'
#
#   Or to run a `git status` command:
#
#     typeset -g POWERLEVEL9K_VCS_TOUCHBAR_CMD='git status'
#
# Icons are likely to be broken unless they are in plain text with default font.
# zsh-apple-touchbar has a limit of 12 buttons, which most likely can be
# extended.


source ~/dotfiles/zsh-apple-touchbar/functions.zsh

set_default POWERLEVEL9K_TOUCHBAR_ELEMENTS
set_default POWERLEVEL9K_TOUCHBAR_MAX_ELEMENTS 12
set_default POWERLEVEL9K_DIR_TOUCHBAR_CMD 'ls'

precmd_touchbar() {
  remove_and_unbind_keys

  _touchbar_key_n=1
  for element in $POWERLEVEL9K_TOUCHBAR_ELEMENTS; do
    function touchbar_prompt_segment() {
      local icon=""
      if [[ "$4" && "$4" != 0 ]]; then
        icon="$4"
      else
        icon="$5"
      fi

      local powerlevel_icon=$(print_icon $icon)
      if [[ "$powerlevel_icon" != "" ]]; then
        icon=$powerlevel_icon
      fi

      local label=$(print -P "$7" "$8")
      # strip colors
      label=$(echo $label | sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g')
      # remove trailing space
      label=${label##[[:blank:]]##}
      # add icon
      label="$icon $label"

      local widget_var="POWERLEVEL9K_${element:u}_TOUCHBAR_WIDGET"
      local widget_value=${(P)widget_var}

      local cmd_var="POWERLEVEL9K_${element:u}_TOUCHBAR_CMD"
      local cmd_value=${(P)cmd_var}

      if [[ -n "$label" ]]; then
        if [[ "$_touchbar_key_n" -le "$POWERLEVEL9K_TOUCHBAR_MAX_ELEMENTS" ]]; then
          if [[ -n "$widget_value" ]]; then
            create_key "$_touchbar_key_n" "$label" "$widget_value"
          else
            if [[ -n "$cmd_value" ]]; then
              create_key "$_touchbar_key_n" "$label" "$cmd_value" '-s'
            else
              create_key "$_touchbar_key_n" "$label" ':' '-s'
            fi
          fi
        else
          echo -E "${(%):-%F{red\}}[WARNING]: cannot have more than $POWERLEVEL9K_TOUCHBAR_MAX_ELEMENTS touchbar elements." >&2
        fi
        _touchbar_key_n=$((_touchbar_key_n+1))
      fi
    }
    prompt_$element touchbar
  done
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd precmd_touchbar
