#!/bin/zsh
alias i='printf "hostname: $(hostname)\nuser: $(whoami)\nhome: $HOME\nshell:$SHELL\n"'

alias sz='source ~/.zshrc'

alias v='nvim'
alias nv='nvim'

alias tm='tmux'
alias tl='tmux ls'

alias l='ls -lAh'
alias ll='ls -lAh'
alias la='ls -lah'

alias k='kubectl'
alias kx='kubectx'
alias kn='kubens'
alias pods='kubectl get pods --all-namespaces'
alias wp='watch -n 0.1 kubectl get pods --all-namespaces'
alias kd='kubectl describe'
