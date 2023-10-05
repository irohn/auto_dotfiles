# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Plugins
plugins=(git git-flow zsh-syntax-highlighting zsh-autosuggestions dirhistory zsh-history-substring-search)

export PATH="$HOME/.local/bin:$PATH"

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Keybindings
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^E" end-of-line
bindkey "^A" beginning-of-line

# User configuration
[[ ! -f ~/.config/aliases.zsh  ]] || source ~/.config/aliases.zsh
[[ ! -f ~/.config/functions.zsh  ]] || source ~/.config/functions.zsh
[[ ! -f ~/.secrets/github.sh ]] || source ~/.secrets/github.sh

# Starship init
eval "$(starship init zsh)"
