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

########################### FILE LS


if [ -x "$(command -v eza)" ]; then
# https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
  export EZA_COLORS="da=33:*.zip=38;5;125:*.log=38;5;248:*.md=38;5;121"
  alias eza="eza -g --icons --group-directories-first --time-style=long-iso --classify"
  alias lw="\eza -x --icons --group-directories-first"  # wide display
  alias ls="eza -l"
  alias lt="eza -aT"  # Tree listing
  alias lf="eza -afl"  # Tree listing
  alias ldir="eza -aDl"  # Tree listing
  alias lx="eza -al -s extension"  # sort by extension
  alias lk="eza -al -s size"  # sort by extension
  alias lk="eza -al -s size"  # sort by extension
        # name, size, extension, modified, changed, accessed, created, inode, type, none
else
#   alias ls='ls --color=always --time-style=+"%Y-%m-%d %H:%M:%S"' # add colors and file type extensions
  alias ls='ls --color=always --time-style=long-iso -hFl' #  F=adds / to dirs, --ignore=lost+found
  alias lf="ls -la -a | grep -v -E '^d'"  # files only or ls -F | grep -v '/$'
  alias ldir="ls -la -a | grep -E '^d'"   # directories only

  alias lx='ls -lhBX'               # sort by extension  B=ignore backup files ending with ~
  alias lk='ls -lhrS'               # sort by size reverse
  alias lm='ls -lhrt'               # sort by date reverse
  alias lc='ls -lhrtc'              # sort by change time -r reverse order -c mod time
  alias lu='ls -lturh'              # sort by access time
  alias lw='\ls -x --color=always'                 # regular ls wide listing not l
fi
alias l.="ls -la -a"   # add second -a to show .,.. in eza
alias la="ls -lA"   # hidden but not .,..
alias ll="ls -l"
alias l..="ls -la -a ../"
alias lr='ls -lR'                # recursive ls
alias lmore='ls -al | more'          # pipe through 'more'



# "path" shows current path, one element per line. If an argument is supplied, grep for it.
path() {
    test -n "$1" && {
        echo $PATH | perl -p -e "s/:/\n/g;" | grep -i "$1"
    } || {
        echo $PATH | perl -p -e "s/:/\n/g;"
    }
}

########################### CHEZMOI
alias czar="chezmoi apply && reload"
alias czpush="chezmoi apply && reload"