#!/bin/zsh
alias i='printf "hostname: $(hostname)\nuser: $(whoami)\nhome: $HOME\nshell:$SHELL\n"'

alias op='/mnt/c/Program\ Files/1Password\ CLI/op.exe'
alias sz='source ~/.zshrc'

alias sshj='ssh -J localhost:2222'

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

alias fl='flux logs -A'
alias fra='flux reconcile kustomization flux-system --with-source'

if type "$bat" > /dev/null; then
  alias cat='bat -p'
fi
