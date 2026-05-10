# Function to source files if they exist
#zplugindir=$HOME/.local/share/zsh/plugins
# ~/.zsh
# ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/
# zplugindir=/usr/local/share

zplugindir=/usr/share/zsh/plugins

# zplugindir=/usr/local/share/zsh/plugins

function zsh_add_file() {
    [ -f "$1" ] && source "$1"
}

function zsh_add_plugin() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    # sudo rm -rf "$zplugindir/$PLUGIN_NAME"
    [ ! -d "$zplugindir/$PLUGIN_NAME" ] && (
        sudo rm -f $HOME/.zcompdump
        sudo git clone $2 "https://github.com/$1.git" "$zplugindir/$PLUGIN_NAME"
    )
    #        git pull
    zsh_add_file "$zplugindir/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || zsh_add_file "$zplugindir/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
}

# Plugins
# Load ; should be last.
# zsh-autosuggestions - Suggestions based on your history
zsh_add_plugin "zsh-users/zsh-autosuggestions"
# zsh-syntax-highlighting - syntax highlighting for ZSH in standard repos
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
# zsh_add_plugin "zdharma-continuum/fast-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
zsh_add_plugin "zsh-users/zsh-completions"
zsh_add_plugin "romkatv/powerlevel10k" "--depth=1"

# source "$zplugindir/powerlevel10k/powerlevel10k.zsh-theme"
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# #git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${zplugindir:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# For more plugins: https://github.com/unixorn/awesome-zsh-plugins
#https://github.com/MichaelAquilina/zsh-you-should-use

#zmodload zsh/complist
#https://github.com/zsh-users/zsh-history-substring-search

#sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
#install2 ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/
#plugins=( [plugins...] zsh-syntax-highlighting zsh-autosuggestions)
#sudo apt install zsh-syntax-highlighting
#install2 ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
#ZSH_THEME="powerlevel10k/powerlevel10k"

#terraform autocomplte
autoload -U +X bashcompinit && bashcompinit
[ -f "/usr/bin/terraform" ] && complete -o nospace -C /usr/bin/terraform terraform

source <(/usr/local/share/fzf/bin/fzf --zsh) # Set up fzf key bindings and fuzzy completion
# fzf --fish | source # Set up fzf key bindings