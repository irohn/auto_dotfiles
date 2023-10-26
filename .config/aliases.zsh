#!/bin/zsh
alias i='printf "hostname: $(hostname)\nuser: $(whoami)\nhome: $HOME\nshell:$SHELL\n"'

alias sshj='ssh -J green@localhost:2222'

alias v='nvim'
alias nv='nvim'

alias tm='tmux'
alias tl='tmux ls'

alias l='ls -lAh'
alias ll='ls -lAh'
alias la='ls -lah'

alias k='kubectl'
alias kn='kubens'

alias fl='flux logs -A'
alias fra='flux reconcile kustomization flux-system --with-source'

bindkey -s '^r' 'history | fzf^M'
