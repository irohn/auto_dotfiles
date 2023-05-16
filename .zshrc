# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Plugins
plugins=(git git-flow zsh-syntax-highlighting zsh-autosuggestions dirhistory zsh-history-substring-search)

# User configuration
[[ ! -f ~/.kube/.kubeconfig.sh  ]] || source ~/.kube/.kubeconfig.sh
[[ ! -f ~/.config/aliases.zsh  ]] || source ~/.config/aliases.zsh
[[ ! -f ~/.config/functions.zsh  ]] || source ~/.config/functions.zsh

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Starship init
eval "$(starship init zsh)"
