# ~/.bashrc
fastfetch
[[ $- == *i* ]] &&
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
source -- "$HOME/.local/share/blesh/ble.sh" --attach=none --rcfile "$HOME/.blerc"

alias fucking="sudo"
alias la="ls -la --color=always --group-directories-first"
alias ls="ls -l --color=always --group-directories-first"
alias lt="ls -R --color=always"
alias l.="ls -d .[^.]*"
alias ..="cd .."
alias ....="cd ../.."
alias ......="cd ../../.."


[[ -f ~/.bash_prompt ]] && source ~/.bash_prompt

[[ ! ${BLE_VERSION-} ]] || ble-attach
