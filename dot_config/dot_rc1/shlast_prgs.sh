
MYSHELL=`basename $(readlink /proc/$$/exe)`
# MYSHELL=`ps -cp "$$" -o command=""`
# Show system information at login
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

[ -f /usr/share/autojump/autojump.sh ] &&  source /usr/share/autojump/autojump.sh

# fzfdir=$HOME/.local/share/fzf
fzfdir=/usr/local/share/fzf
[ -d "$fzfdir" ] || (sudo git clone --depth 1 https://github.com/junegunn/fzf.git $fzfdir && sudo $fzfdir/install --bin)

if [[ ! "$PATH" == *$fzfdir/bin* ]]; then
   export PATH="${PATH:+${PATH}:}$fzfdir/bin"
fi
set FZF_DEFAULT_OPTS="--color=bg+:24 --border=bold --border=rounded --layout=reverse --margin=3% --color=dark,bg+:24"
[[ $- == *i* ]] && source "$fzfdir/shell/completion.${MYSHELL}" 2> /dev/null
[ -f "$fzfdir/shell/key-bindings.${MYSHELL}" ] && source "$fzfdir/shell/key-bindings.${MYSHELL}"
