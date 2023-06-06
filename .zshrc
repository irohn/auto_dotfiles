# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Plugins
plugins=(git git-flow zsh-syntax-highlighting zsh-autosuggestions dirhistory zsh-history-substring-search)

export PATH="$HOME/.local/bin:$PATH"

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# User configuration
[[ ! -f ~/.kube/.kubeconfig.sh  ]] || source ~/.kube/.kubeconfig.sh
[[ ! -f ~/.kube/local ]] || export KUBECONFIG="$KUBECONFIG:~/.kube/local"
[[ ! -f ~/.config/aliases.zsh  ]] || source ~/.config/aliases.zsh
[[ ! -f ~/.config/functions.zsh  ]] || source ~/.config/functions.zsh
[[ ! -f ~/.secrets/github.sh ]] || source ~/.secrets/github.sh

# Starship init
eval "$(starship init zsh)"
