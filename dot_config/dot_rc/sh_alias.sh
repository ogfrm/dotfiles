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

########################### FILE Commands
alias cp='cp -i'  #prompt before overwrite
alias mv='mv -i'  #prompt before overwrite
alias ln='ln -i'  # -iv
alias rm="rm -i"
alias rmd="rm -rf"

if [ ! -f "/etc/alpine-release" ]; then
  alias rm="rm -i --preserve-root" # do not delete / or -I prompt if deleting more than 3 files at a time #
  alias rmd="rm -rf --preserve-root" # do not delete / or -I prompt if deleting more than 3 files at a time #
  alias chown="chown --preserve-root"
  alias chmod="chmod --preserve-root"
  alias chgrp="chgrp --preserve-root"
fi
########################### CHMOD commands
function chmodrec() {   # chmodrec . 755 644
    find $1 -type d -exec chmod $2 {} \;
    find $1 -type f -exec chmod $3 {} \;
    # find ./ \( -type d -execdir chmod 755 '{}' \; \) , \( -type f -execdir chmod 644 '{}' \; \)
    # find . -name "*.sh" -exec chmod +x {} \;
    # find /path/to/directory -type f -print0 | xargs -0 chmod 644
}
#chmod -R 'u=rwX,g=rwX,o=rX'    # X sets x for dir or file(already set x at one of the u,g,o)
# chmod -R +X


########################### DIR Manager
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
alias mkdir='mkdir -p'
mkdirg() { # Create and go to the directory
	mkdir -p "$1"
	cd "$1"
}

function diffdir() {    # diffdir /path1 /path2
    # diff <(tree -ap $1) <(tree -ap $2)
    diff -u <(find $1 -printf '%P %m\n' | sort) <(find $2 -printf '%P %m\n' | sort)  # --format='%n %A %U %G' '%#m\t%M\t%T+\t%C+\t%U:%G\t%s\t%P \n'
}
########################### EDITORS
alias e="nano "
# alias e="vim -O "    # side by side
# alias E="vim -o " 	# one windows per file
# alias svim='sudo vim'

########################### FILE FIND

alias f="find . | grep " # Search files in the current folder
alias fd='find . -type d -name'
alias ff='find . -type f -name'
ftext() { # Searches for text in all files in the current folder
	# -i case-insensitive -I ignore binary files -H filename printed -r recursive -n line number
	# optional: -F treat search term as a literal, not a regular expression
	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
	grep -iIHrn --color=always "$1" . | less -r
}

########################### LS
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
  alias lf="ls -la -a | grep -v -e '^d'"  # files only or ls -F | grep -v '/$'
  alias ldir="ls -la -a | grep -e '^d'"   # directories only

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
function path() {
    test -n "$1" && {
        echo $PATH | perl -p -e "s/:/\n/g;" | grep -i "$1"
    } || {
        echo $PATH | perl -p -e "s/:/\n/g;"
    }
}
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

########################### DISK   Alias's to show disk space and space used in a folder
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias dir5='du -cksh * | sort -hr | head -n 5' # List largest directories (aka "ducks")
alias dud='du -d 1 -h'  # folder sizes   -d 1 --max-depth human readible
alias duf='du -sh *'	# summarize
alias df='df -h -x squashfs -x tmpfs -x devtmpfs'  #file systems x exclude
alias ncdu='ncdu --color dark'
# alias lsmount='mount |column -t'

########################### GREP  # https://askubuntu.com/questions/1042234/modifying-the-color-of-grep
export GREP_COLORS='mt=3;33'
[ ! -f "/etc/alpine-release" ]; export GREP_OPTIONS='--color=auto' #deprecated
if command -v rg &> /dev/null; then  # Check if ripgrep is installed
    alias grep='rg'
else
    alias grep="/usr/bin/grep $GREP_OPTIONS"
fi

# alias grep="grep $GREP_OPTIONS"  #'always', 'never', or 'auto'
alias egrep="grep -e $GREP_OPTIONS" # --extended-regexp
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '   #recursive search file
    # -H, --with-filename  # -R, --dereference-recursive  likewise, but follow all symlinks
    # -n, --line-number # -C, --context=NUM
unset GREP_OPTIONS

alias less='less -R'     # Repaint the screen after each page

########################### CAT
# If batcat exists
if command -v batcat >/dev/null 2>&1; then
    alias bat='batcat --color=always'
    alias cat='bat'
    alias catt='bat --paging=never --decorations=never'
# Else if bat exists
elif command -v bat >/dev/null 2>&1; then
    alias bat='bat --color=always'
    alias cat='bat'
    alias catt='bat --paging=never --decorations=never'
fi
alias fzfp='fzf --preview "batcat --color=always --paging=never --number {}"'
alias fzfch='find ~/.config/cheat/cheatsheets/personal | sort | fzf --preview "cat --language bash {}"'

########################### APPS  # Manage packages easier
if [ -f /usr/bin/apt ]; then
	alias update='sudo apt update'
	alias upgrade='sudo apt update && sudo apt dist-upgrade && sudo apt autoremove && sudo apt clean'
	alias install='sudo apt install'
  alias apt-get='sudo apt-get'
elif [ -f /usr/bin/pacman ]; then
	alias update='sudo pacman -Syyy'
	alias upgrade='sudo pacman -Syu'
	alias install='sudo pacman -S'
  alias pacman-update='sudo pacman-mirrors --geoip'
fi

apps() {
  dpkg-query -Wf '${Installed-Size}\t${Package}\t${Version}\n'
  }
appssize() {
  dpkg-query -Wf '${Installed-Size}\t${Package}\t${Version}\n' | sort -n
  }

appfind() {
    apt-cache --no-all-versions show $1 | awk '$1 == "Package:" { p = $2 } $1 == "Size:" { printf("%10d %s\n", $2, p) }'
}
appsize() {
    sudo apt-get --assume-no autoremove $@ | grep freed | cut -d' ' -f4-5 ; # purge --auto-remove
}
alias appshow="apt show -a"
alias app-depend="apt-cache depends"
alias app-rdepend="apt-cache rdepends"

########################### NETWORK
alias openports='netstat -nape --inet' # Show open ports
alias ports='netstat -tulanp'
alias wget='wget -c'
alias weather='curl wttr.in'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'
alias ping='ping -c 5'   # only ping 5 times
alias ip4="/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1"
function myip () {
    if command -v ip &> /dev/null; then
        echo -n "Internal IP: "
        ip addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
        echo -n "Internal eth0 IP: "
        ip addr show eth0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
    else
        echo -n "Internal IP: "
        ifconfig wlan0 | grep "inet " | awk '{print $2}'
        echo -n "Internal eth0 IP: "
        ifconfig eth0 | grep "inet " | awk '{print $2}'
    fi
    echo -n "External IP: "
    if command -v curl &> /dev/null; then
      curl -s https://ipinfo.io  # ifconfig.me icanhazip.com
    else
      wget -qO- https://ipinfo.io
    fi
}
########################### ARCHIVES
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
extract() { # Extracts any archive(s) (if unp isn't installed)
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: ex <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
	for archive in "$@"; do
		if [ -f "$archive" ]; then
			case $archive in
			*.tar.bz2) tar xvjf $archive ;;
			*.tar.gz) tar xvzf $archive ;;
      *.tar.xz)    tar xvf $1    ;;
			*.bz2) bunzip2 $archive ;; # bzip2 -d $1
			*.rar) rar x $archive ;; # unrar2dir $1  unrar x $1
			*.gz) gunzip $archive ;;
			*.tar) tar xvf $archive ;;   # xf
			*.tbz2) tar xvjf $archive ;; # xjf
			*.tgz) tar xvzf $archive ;;
			*.zip) unzip $archive ;;  # unzip2dir $1
			*.Z) uncompress $archive ;;
			*.7z) 7z x $archive ;;
            # *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) tar xvf "$n"       ;;
            # *.lzma)      unlzma ./"$n"      ;;
            # *.cbr|*.rar)       unrar x -ad ./"$n" ;;
            # *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
            # *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar) 7z x ./"$n"        ;;
            # *.xz)        unxz ./"$n"        ;;
            # *.exe)       cabextract ./"$n"  ;;
            # *.cpio)      cpio -id < ./"$n"  ;;
            # *.cba|*.ace)      unace x ./"$n"      ;;
			*) echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
  fi
}
########################### SYSTEM
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f" # Show all logs in /var/log
alias jctl="journalctl -p 3 -xb" # get error messages from journalctl

alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | (sed -u 1q; sort -nr -k 4) | cat'
alias psmem5='ps auxf | (sed -u 1q; sort -nr -k 4) | head -5 | cat'
alias pscpu='ps auxf | (sed -u 1q; sort -nr -k 3) | cat'
alias pscpu5='ps auxf | (sed -u 1q; sort -nr -k 3) | head -5 | cat'
alias pscpu10="/bin/ps -eo pcpu,pmem,pid,user,args | sort -k 1 -r | head -10 | cat"
alias psmem10="/bin/ps -eo pmem,pcpu,pid,user,args | sort -k 1 -r | head -10 | cat"

########################### CHEZMOI
alias cz="chezmoi"
alias czar="chezmoi apply && reload"
alias czpush="chezmoi git add . && chezmoi git -- commit -m 'test' && chezmoi git push"