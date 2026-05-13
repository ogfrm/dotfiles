
# if [ -n "$BASH_VERSION" ]; then   [ -n "$ZSH_VERSION" ]
MYSHELL=`basename $(readlink /proc/$$/exe)` # MYSHELL=`ps -cp "$$" -o command=""`

#############   FZF   CTRL+R:  history search.  CTRL+T: find a file or directory ALT + C search for a directory and cd

fzfdir=/usr/local/share/fzf   # $HOME/.local/share/fzf
[ -d "$fzfdir" ] || (sudo git clone --depth 1 https://github.com/junegunn/fzf.git $fzfdir && sudo $fzfdir/install --bin)

if [[ ! "$PATH" == *$fzfdir/bin* ]]; then
   export PATH="${PATH:+${PATH}:}$fzfdir/bin"
fi

# Set up fzf key bindings and fuzzy completion  # eval "$(fzf --bash)" # source <(fzf --zsh) # fzf --fish | source
[ -f "$fzfdir/shell/completion.${MYSHELL}" ] && source "$fzfdir/shell/completion.${MYSHELL}"
[ -f "$fzfdir/shell/key-bindings.${MYSHELL}" ] && source "$fzfdir/shell/key-bindings.${MYSHELL}"

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "cat {}"' # Preview files on right 'bat' or 'cat'
# export FZF_DEFAULT_OPTS="--color=bg+:24 --border=bold --border=rounded --layout=reverse --margin=3% --color=dark,bg+:24"

# Use ripgrep (rg) if installed for faster, cleaner searches
if type rg &>/dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
fi

# Git fzf ^G ( ? this list ^F Files ^B Branches ^T Tags ^R Remotes ^H commit Hashes ^S Stashes ^L reflogs ^W Worktrees ^E Each ref (git for-each-ref)
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

#######################################################
# Shell integrations
#######################################################
# eval "$(zoxide init --cmd cd zsh)"
