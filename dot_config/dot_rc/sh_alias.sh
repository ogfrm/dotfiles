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

# Show a directory listing when using 'cd'
function cd() {
  new_directory="$*";
  if [ $# -eq 0 ]; then
    new_directory=${HOME};
  fi;
  builtin cd "${new_directory}" && /bin/ls -lhF --time-style=long-iso --color=auto --ignore=lost+found
}
function extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjvf $1    ;;
      *.tar.gz)    tar xzvf $1    ;;
      *.tar.xz)    tar xvf $1    ;;
      *.bz2)       bzip2 -d $1    ;;
      *.rar)       unrar2dir $1    ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1    ;;
      *.tgz)       tar xzf $1    ;;
      *.zip)       unzip2dir $1     ;;
      *.Z)         uncompress $1    ;;
      *.7z)        7z x $1    ;;
      *.ace)       unace x $1    ;;
      *)           echo "'$1' cannot be extracted via extract()"   ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
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

########################### GREP  # https://askubuntu.com/questions/1042234/modifying-the-color-of-grep
export GREP_COLORS='mt=3;33'
[ ! -f "/etc/alpine-release" ]; export GREP_OPTIONS='--color=auto' #deprecated
if command -v rg &> /dev/null; then  # Check if ripgrep is installed
    alias grep='rg'
else
    alias grep="/usr/bin/grep $GREP_OPTIONS"
fi

# alias grep="grep $GREP_OPTIONS"  #'always', 'never', or 'auto'
alias egrep="grep -E $GREP_OPTIONS" # --extended-regexp
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '   #recursive search file
    # -H, --with-filename  # -R, --dereference-recursive  likewise, but follow all symlinks
    # -n, --line-number # -C, --context=NUM
unset GREP_OPTIONS


########################### CHEZMOI
alias cz="chezmoi"
alias czar="chezmoi apply && reload"
alias czpush="chezmoi git add . && chezmoi git -- commit -m 'test' && chezmoi git push"