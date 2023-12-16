# Initialize dotfiles

USER=$(whoami)
KERNEL_NAME=$(uname -s | tr '[:upper:]' '[:lower:]')
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

source "$SCRIPT_DIR/scripts/format.sh"

printf "%s %s Running as user %s\n" "`prefix_info`" "`task_title general`" "$USER"
printf "%s %s Kernel name %s\n" "`prefix_info`" "`task_title general`" "$KERNEL_NAME"
printf "%s %s Script's dir %s\n" "`prefix_info`" "`task_title general`" "$SCRIPT_DIR"

[[ -z $XDG_CONFIG_HOME ]] && export XDG_CONFIG_HOME="$HOME/.config"
[[ -d $XDG_CONFIG_HOME ]] || mkdir $XDG_CONFIG_HOME
printf "%s %s XDG_CONFIG_HOME is set to %s\n" "`prefix_ok`" "`task_title general`" "$XDG_CONFIG_HOME"

# Check fot zsh and/or bash
if grep -q "/zsh" /etc/shells &> /dev/null; then ZSH_INSTALLED=true; else ZSH_INSTALLED=false; fi
if grep -q "/bash" /etc/shells &> /dev/null; then BASH_INSTALLED=true; else BASH_INSTALLED=false; fi
if [ $ZSH_INSTALLED = false ] && [ $BASH_INSTALLED = false ]; then
    printf "%s %s Zsh + Oh-My-Zsh (Recommended) %s\n" "`prefix_err`" "`task_title shell`" "`hyperlink https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH`"
    printf "%s %s Bash %s\n" "`prefix_err`" "`task_title shell`" "`hyperlink https://www.gnu.org/software/bash/manual/html_node/Installing-Bash.html`"
    printf "%s %s Couldn't find zsh nor bash plaease install atleast one of them\n" "`prefix_err`" "`task_title shell`"
    exit 1
else
    if $ZSH_INSTALLED; then printf "%s %s Zsh is installed\n" "`prefix_ok`" "`task_title shell`"; fi
    if $BASH_INSTALLED; then printf "%s %s Bash is installed\n" "`prefix_ok`" "`task_title shell`"; fi
fi

# Aliases
ln -svf "$SCRIPT_DIR"/.config/alias.d "$XDG_CONFIG_HOME" > $SCRIPT_DIR/temp-log.local 2>&1
if [ $? -eq 0 ]; then
    printf "%s %s Aliases linked %s\n" "`prefix_ok`" "`task_title shell`" "`cat $SCRIPT_DIR/temp-log.local | tr '\n' ' '`"
    if $ZSH_INSTALLED; then
        if grep -q "alias\.d" $HOME/.zshrc &> /dev/null; then
            printf "%s %s .zshrc is already configured\n" "`prefix_ok`" "`task_title shell`"
        else
            printf "\nfor file in $XDG_CONFIG_HOME/alias.d/*; do source \$file; done\n\n" >> "$HOME/.zshrc"
        fi
    fi
    if $BASH_INSTALLED; then
        if grep -q "alias\.d" $HOME/.bashrc &> /dev/null; then
            printf "%s %s .bashrc is already configured\n" "`prefix_ok`" "`task_title shell`"
        else
            printf "\nfor file in $XDG_CONFIG_HOME/alias.d/*; do source \$file; done\n\n" >> "$HOME/.bashrc"
        fi
    fi
else
    printf "%s %s Aliases failed to link %s\n" "`prefix_err`" "`task_title shell`" "`cat $SCRIPT_DIR/temp-log.local | tr '\n' ' '`"
fi

# tmux config
if command -v tmux &> /dev/null; then
    ln -svf "$SCRIPT_DIR"/.config/tmux/tmux.conf "$XDG_CONFIG_HOME/tmux" > $SCRIPT_DIR/temp-log.local 2>&1
    if [ $? -eq 0 ]; then
        printf "%s %s Tmux config linked %s\n" "`prefix_ok`" "`task_title tmux`" "`cat $SCRIPT_DIR/temp-log.local | tr '\n' ' '`"
    else
        printf "%s %s Tmux config failed to link %s\n" "`prefix_err`" "`task_title tmux`" "`cat $SCRIPT_DIR/temp-log.local | tr '\n' ' '`"
    fi
else
    printf "%s %s Tmux is not installed, %s\n" "`prefix_skip`" "`task_title tmux`" "`hyperlink https://github.com/tmux/tmux/wiki/Installing`"
fi

# nvim config
if command -v nvim &> /dev/null; then
    [[ -d $XDG_CONFIG_HOME/nvim ]] || mkdir $XDG_CONFIG_HOME/nvim
    ln -svf "$SCRIPT_DIR"/.config/nvim/init.lua "$XDG_CONFIG_HOME/nvim/init.lua" > $SCRIPT_DIR/temp-log.local 2>&1
    ln -svf "$SCRIPT_DIR"/.config/nvim/lua "$XDG_CONFIG_HOME/nvim/lua" > $SCRIPT_DIR/temp-log.local 2>&1
    if [ $? -eq 0 ]; then
        printf "%s %s Neovim config linked %s\n" "`prefix_ok`" "`task_title neovim`" "`cat $SCRIPT_DIR/temp-log.local | tr '\n' ' '`"
    fi
else
    printf "%s %s Neovim is not installed, %s\n" "`prefix_skip`" "`task_title neovim`" "`hyperlink https://github.com/neovim/neovim/blob/master/INSTALL.md`"
fi

# Starship, should run at the end
if command -v starship &> /dev/null; then
    ln -svf "$SCRIPT_DIR"/.config/starship.toml "$XDG_CONFIG_HOME" > $SCRIPT_DIR/temp-log.local 2>&1
    if [ $? -eq 0 ]; then
        printf "%s %s Starship config linked %s\n" "`prefix_ok`" "`task_title starship`" "`cat $SCRIPT_DIR/temp-log.local | tr '\n' ' '`"
        # check if starship is installed
    else
        printf "%s %s Starship failed to link %s\n" "`prefix_skip`" "`task_title starship`" "`cat $SCRIPT_DIR/temp-log.local | tr '\n' ' '`"
    fi
    if $ZSH_INSTALLED; then
        if grep -q "starship init zsh" $HOME/.zshrc &> /dev/null; then
            sed -i "/starship init/d" $HOME/.zshrc
        fi
        printf "eval \"\$(starship init zsh)\"\n" >> "$HOME/.zshrc"
    fi
    if $BASH_INSTALLED; then
        if grep -q "starship init bash" $HOME/.bashrc &> /dev/null; then
            sed -i "/starship init/d" $HOME/.bashrc
        fi
        printf "eval \"\$(starship init bash)\"\n" >> "$HOME/.bashrc"
    fi
else
    printf "%s %s Starship is not installed, %s\n" "`prefix_skip`" "`task_title prompt`" "`hyperlink \"https://starship.rs/guide\"`" 
fi

exit 0
