
# if [ -n "$BASH_VERSION" ]; then
#   MYSHELL=bash
# elif [ -n "$ZSH_VERSION" ]; then
#   MYSHELL=zsh
# else
#   MYSHELL=unknown
# fi
MYSHELL=`basename $(readlink /proc/$$/exe)`
# MYSHELL=`ps -cp "$$" -o command=""`
# echo "You are using $MYSHELL"


#############   FZF
# CTRL + R: Replaces the standard history search.
# CTRL + T: Quickly find a file or directory in your current tree and paste its path directly into your command line.
# ALT + C: Fuzzy search for a directory and cd into it instantly.
# Git fzf ^G ( ? to show this list ^F Files ^B Branches ^T Tags ^R Remotes ^H commit Hashes ^S Stashes ^L reflogs ^W Worktrees ^E Each ref (git for-each-ref)

fzfdir=/usr/local/share/fzf   # $HOME/.local/share/fzf
[ -d "$fzfdir" ] || (sudo git clone --depth 1 https://github.com/junegunn/fzf.git $fzfdir && sudo $fzfdir/install --bin)

if [[ ! "$PATH" == *$fzfdir/bin* ]]; then
   export PATH="${PATH:+${PATH}:}$fzfdir/bin"
fi

# Set up fzf key bindings and fuzzy completion  # eval "$(fzf --bash)" # source <(fzf --zsh) # fzf --fish | source
[ -f "$fzfdir/shell/completion.${MYSHELL}" ] && source "$fzfdir/shell/completion.${MYSHELL}"
[ -f "$fzfdir/shell/key-bindings.${MYSHELL}" ] && source "$fzfdir/shell/key-bindings.${MYSHELL}"

# set FZF_DEFAULT_OPTS="--color=bg+:24 --border=bold --border=rounded --layout=reverse --margin=3% --color=dark,bg+:24"

# Preview files in a window on the right using 'bat' or 'cat'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "cat {}"'

# Use ripgrep (rg) if installed for faster, cleaner searches
if type rg &>/dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
fi

# https://github.com/Aloxaf/fzf-tab

# https://github.com/junegunn/fzf-git.sh
[ -d "${fzfdir}-git" ] || (sudo git clone --depth 1 https://github.com/junegunn/fzf-git.sh.git ${fzfdir}-git)
[ -f "${fzfdir}-git/fzf-git.sh" ] && source "$fzfdir-git/fzf-git.sh"

################## Show system information at login
if [ -v TMUX ]
then
    echo
#    tmux list-panes -s | awk 'END { if(NR == 1 && $4 ~ "0/") system("neofetch")}'
else
    # -t makes the test test a file descriptor to see if it's a terminal  0=STDIN. if STDIN is a terminal then ...
    # if test -t 1; then
    if [ -t 0 ]; then
        if [ -f /usr/bin/fastfetch ]; then
            fastfetch
        fi
    fi
fi

[ -f /usr/share/autojump/autojump.sh ] && source /usr/share/autojump/autojump.sh || echo
# # terraform auto complete
# [ -f "/usr/bin/terraform" ] && complete -C /usr/bin/terraform terraform
