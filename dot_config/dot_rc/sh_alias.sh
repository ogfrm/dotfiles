# To temporarily bypass an alias, we precede the command with a \  like \ls
###########################   TERMINAL
# alias hlp='less ~/.bashrc_help'

alias da='date "+%Y-%m-%d %A %T %Z"'
alias cls='clear'

# alias ssha='eval $(ssh-agent) && ssh-add'
alias watch='watch -d'		#repeats the command
alias checkcommand="type -a" # a command is aliased and paths

########################### HISTORY
alias hgrep="fc -l 1 | grep"		#history search -E zfs shows time

########################### DIR Manager
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias .2='cd ../..'   # ..
alias .3='cd ../../..'   # ...
alias .4='cd ../../../..' # ....
alias .5='cd ../../../../..'
alias bd='cd "$OLDPWD"' # cd into the old directory



# "path" shows current path, one element per line. If an argument is supplied, grep for it.
path() {
    test -n "$1" && {
        echo $PATH | perl -p -e "s/:/\n/g;" | grep -i "$1"
    } || {
        echo $PATH | perl -p -e "s/:/\n/g;"
    }
}