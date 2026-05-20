if ! command -v tmux>/dev/null; then return ; fi
alias tn=' tmux new -s'

# Enable tab completion for tmux
source /home/$USER/.tmux/plugins/completion/tmux

# Add /home/$USER/.tmux/tmuxifier to $PATH
case :$PATH: in
	*:/home/$USER/.tmux/tmuxifier/bin:*) ;;
	*) PATH=/home/$USER/.tmux/tmuxifier/bin:$PATH ;;
esac
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi
# Make sure always using tmux
if command -v tmux>/dev/null; then
    if [ ! -z "$PS1" ]; then # unless shell not loaded interactively, run tmux
        [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && tmux new -As0
#        [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && tmux attach || tmux
#        [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && tmux
    fi
fi

run_under_tmux() {
    # Run $1 under session or attach if such session already exist.
    # $2 is optional path, if no specified, will use $1 from $PATH.
    # If you need to pass extra variables, use $2 for it as in example below..
    # Example usage:
    #   torrent() { run_under_tmux 'rtorrent' '/usr/local/rtorrent-git/bin/rtorrent'; }
    #   mutt() { run_under_tmux 'mutt'; }
    #   irc() { run_under_tmux 'irssi' "TERM='screen' command irssi"; }


    # There is a bug in linux's libevent...
    # export EVENT_NOEPOLL=1

    command -v tmux >/dev/null 2>&1 || return 1

    if [ -z "$1" ]; then return 1; fi
        local name="$1"
    if [ -n "$2" ]; then
        local execute="$2"
    else
        local execute="command ${name}"
    fi

    if tmux has-session -t "${name}" 2>/dev/null; then
        tmux attach -d -t "${name}"
    else
        tmux new-session -s "${name}" "${execute}" \; set-option status \; set set-titles-string "${name} (tmux@${HOST})"
    fi
}
