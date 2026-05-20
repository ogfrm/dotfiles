# Add /home/$USER/bin to $PATH
case :$PATH: in
	*:/home/$USER/bin:*) ;;
	*) PATH=/home/$USER/bin:$PATH ;;
esac

# Add /home/$USER/.local/bin to $PATH
case :$PATH: in
	*:/home/$USER/.local/bin:*) ;;
	*) PATH=/home/$USER/.local/bin:$PATH ;;
esac

#######################################################
# EXPORTS
#######################################################
# export TERM="xterm-256color"                      # getting proper colors
if command -v fresh &>/dev/null; then
  export EDITOR=fresh
else
  export EDITOR=nano   # nvim  /usr/bin/vim
fi

# To have colors for ls and all grep commands such as grep, egrep and zgrep
# https://gist.github.com/thomd/7667642  https://geoff.greer.fm/lscolors/
# The full list of attributes for LS_COLORS can be found with dircolors -p or dircolors
export LS_COLORS='di=01;36'

##### Color for manpages in less makes manpages a little easier to read
# sudo apt install terminfo   # termcap is obsolete and terminfo is it's newer replacement
export LESS_TERMCAP_md=$'\E[01;32m' # Green  # md,bold Bold text  $(tput bold; tput setaf 2)
export LESS_TERMCAP_me=$'\E[0m'  # $(tput sgr0)  turn off bold, blink and underline   End all mode so, us, mb, md, and mr
export LESS_TERMCAP_us=$'\E[01;36m' # 4-Blue  us,smul start underline   $(tput smul; tput setaf 4)
export LESS_TERMCAP_ue=$'\E[0m'  # ue,rmul stop underline  $(tput rmul; tput sgr0)
export LESS_TERMCAP_so=$'\E[01;44;33m' # so,smso start standout (search result /Like) $(tput bold; tput setab 4; tput setaf 3)
export LESS_TERMCAP_se=$'\E[0m'         # se,rmso End standout  $(printf "\\e[0m")  $(tput rmso; tput sgr0)
# export LESS_TERMCAP_mb=$'\E[01;31m'  # mb      blink     start blink
export MANPAGER='less +Gg'
export GROFF_NO_SGR=1


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
# alias rm="rm -I"  # -i
alias rmd="rm -rf"

if [ ! -f "/etc/alpine-release" ]; then
  alias rm="rm -I --preserve-root" # do not delete / or -I prompt if deleting more than 3 files at a time #
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

if command -v colordiff &>/dev/null; then
    alias diff="colordiff -Nuar"
else
    alias diff="diff -Nuar"
fi

function diffdir() {    # diffdir /path1 /path2
    # diff <(tree -ap $1) <(tree -ap $2)
    diff -u <(find $1 -printf '%P %m\n' | sort) <(find $2 -printf '%P %m\n' | sort)  # --format='%n %A %U %G' '%#m\t%M\t%T+\t%C+\t%U:%G\t%s\t%P \n'
}
########################### EDITORS
alias e="$EDITOR "
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
if command -v eza &>/dev/null; then
# https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
  export EZA_COLORS="da=33:*.zip=38;5;125:*.log=38;5;248:*.md=38;5;121"
  # alias eza="eza --icons --group-directories-first --time-style=long-iso --classify"
  alias eza="eza --icons --group-directories-first --time-style=long-iso --classify"
  alias ls="eza -lg" # --group --long
  alias lw="eza -x"  # wide display
  alias lf="eza -lagf"  # File listing
  alias ldir="eza -lagD"  # Dir listing
  alias lx="eza -lag -s extension"  # sort by extension
  alias lk="eza -lag -s size"  # sort by size
  alias lm="eza -agl -s modified"  # sort by size
        # name, size, extension, modified, changed, accessed, created, inode, type, none
  alias lt="eza -aT"  # --tree listing
  alias tree="eza --tree --long --total-size --no-time --no-permissions --no-user"  # --byte
  alias treed="tree -D"  # dir only
  alias tree2="tree --level=2"

else
#   alias ls='ls --color=always --time-style=+"%Y-%m-%d %H:%M:%S"' # add colors and file type extensions
  alias ls='ls --color=always --time-style=long-iso -hFl' #  F=adds / to dirs, --ignore=lost+found
  alias lw='ls -x'                 # regular ls wide listing not l
  alias lf="ls -la -a | grep -v -e '^d'"  # files only or ls -F | grep -v '/$'
  alias ldir="ls -la -a | grep -e '^d'"   # directories only

  alias lx='ls -lhBX'               # sort by extension  B=ignore backup files ending with ~
  alias lk='ls -lhrS'               # sort by size reverse
  alias lm='ls -lhrt'               # sort by date reverse
  alias lc='ls -lhrtc'              # sort by change time -r reverse order -c mod time
  alias lu='ls -lturh'              # sort by access time
  alias tree='tree -CAhF --dirsfirst'  # -F Adds '=/*@>|' ls -F  -C Color -A Lines
  alias treed='tree -CAFd' # dirs only
  alias tree2="tree -L 2"


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
if command -v batcat &>/dev/null; then
    alias bat='batcat --color=always'
    alias cat='bat'
    alias catt='bat --paging=never --decorations=never'
# Else if bat exists
elif command -v bat &>/dev/null; then
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
# alias ip6="/sbin/ip -o -6 addr list eth0 | awk '{print $4}' | cut -d/ -f1"

# local_interface=$(ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//")
# local_interface=$(ip -o link show | sed -rn '/^[0-9]+: en/{s/.: ([^:]*):.*/\1/p}')
# local_interface=$(ip route get 8.8.8.8 | awk -- '{printf $5}')
# local_wanip='dig @resolver4.opendns.com myip.opendns.com +short'
# local_wanip4=$(dig @resolver4.opendns.com myip.opendns.com +short -4)
# local_wanip6='dig @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short -6'
# local_wanip4=$(curl ifconfig.io >/dev/null)

function myip () {
    if command -v ip &>/dev/null; then
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
    if command -v curl &>/dev/null; then
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

############################## OH-MY-POSH
ompex() {  # omp toml,json,yaml <file>
  oh-my-posh config export --config $2 --output $2.$1 --format yaml    # .json .yaml
}
omp() {
  eval "$(oh-my-posh init $(oh-my-posh get shell) --config $1)"
}
##############################   TLDR
alias tldrf='tldr --list | fzf --preview "tldr {1}" --preview-window=right,60% | xargs tldr'

export tldrLocal="$HOME/.local/share/chezmoi/dot_config/tldr_local"
# export tldrLocal="$HOME/._config/tldr_local"
tldrl() {
  if [ -z "$1" ]; then
    find  $tldrLocal -type f | sort | fzf --with-nth -1 --delimiter / --preview  "batcat --color=always --paging=never --number {}" --bind "enter:become(nano {})"
  else
    tldr $1
    [ -f "$tldrLocal/$1.md" ] && cat "$tldrLocal/$1.md" || curl cheat.sh/$1
  fi
}
# alias tldrll='find  $tldrLocal -type f | sort | fzf --with-nth -1 --delimiter / --preview  "batcat --color=always --paging=never --number {}"'
# tldr -r .local/share/tldr/less.md
tldre() {
  [ ! -f "$tldrLocal/$1.md" ] && curl -s cheat.sh/$1 | sed 's/\x1b\[[0-9;]*[mK]//g' > "$tldrLocal/$1.md"
  $EDITOR "$tldrLocal/$1.md"
}
ch() {
  curl cheat.sh/$1
}
# ch() { curl cheat.sh/$1 | batcat --color=always  }

########################### DOCKER
alias docker-clean=' \
  docker container prune -f ; \
  docker image prune -f ; \
  docker network prune -f ; \
  docker volume prune -f '
########################### GIT
alias gcl='git clone'
alias gcm='git commit -m'
alias gs='git status'
alias ga='git add'
alias gall='git add .'

# alias gca='git commit --amend'
# alias gcane='git commit --amend --no-edit'
# alias gd='git diff'
# alias gds='git diff --staged'
# alias gdh='git diff HEAD'

# alias branch='git branch'
# alias checkout='git checkout'
# alias fetch='git fetch'
# alias pull='git pull origin'
# alias push='git push origin'
# alias tag='git tag'
# alias newtag='git tag -a'

# bare git repo alias for managing my dotfiles
# alias config="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME"

# GitHub Titus Additions
gcom() {
	git add .
	git commit -m "$1"
}
glazy() {
	git add .
	git commit -m "$1"
	git push
}

############################## Ansible
# alias anp='ansible-playbook local.yml'
alias anp='ANSIBLE_CONFIG=ansible.cfg ans_play'
alias anpt='ANSIBLE_CALLBACKS_ENABLED=timer,profile_tasks,profile_roles anp'
alias anpug='anp -t update,upgrade,cleanup'
alias anpcheck='anp -C' #  don't make any changes; instead, try to predict
alias anconfig='ANSIBLE_CALLBACKS_ENABLED=timer,profile_tasks,profile_roles ANSIBLE_CONFIG=ansible.cfg ansible-config dump --only-changed'  # show changed configs
ans_play() {
    apps=(); apts=(); pipx=(); pve=(); args=()
    while [[ $# -gt 0 ]]; do
        case $1 in
            -app) shift; while [[ $# -gt 0 && $1 != -* ]]; do apps+=("$1"); shift; done ;;
            -apt) shift; while [[ $# -gt 0 && $1 != -* ]]; do apts+=("$1"); shift; done ;;
            -pipx) shift; while [[ $# -gt 0 && $1 != -* ]]; do pipx+=("$1"); shift; done ;;
            -pve) shift; while [[ $# -gt 0 && $1 != -* ]]; do pve+=("$1"); shift; done ;;
            *) args+=("$1"); shift ;;
        esac
    done
    # apps_json=$(printf '"%s",' "$@") # Convert all arguments into a JSON array

    cmd=(ansible-playbook local.yml)
    if [ ${#apps[@]} -gt 0 ]; then
        apps_json=$(printf '"%s",' "${apps[@]}"); apps_json="[${apps_json%,}]"
        cmd+=(-t apps_yml -e "{\"__e_apps\": $apps_json}")
    fi
    if [ ${#apts[@]} -gt 0 ]; then
        apts_json=$(printf '"%s",' "${apts[@]}"); apts_json="[${apts_json%,}]"
        cmd+=(-t apps_pkgs -e "{\"__e_pkgs\": $apts_json}")
    fi
    if [ ${#pipx[@]} -gt 0 ]; then
        pipx_json=$(printf '"%s",' "${pipx[@]}"); pipx_json="[${pipx_json%,}]"
        cmd+=(-t apps_pipx -e "{\"__e_pipx\": $pipx_json}")
    fi
    if [ ${#pve[@]} -gt 0 ]; then
        pve_json=$(printf '"%s",' "${pve[@]}"); pve_json="[${pve_json%,}]"
        cmd+=(-t apps_pipx -e "{\"__e_pve\": $pve_json}")
    fi

    cmd+=("${args[@]}")
    "${cmd[@]}"
}

############################## Unicod
ucget() {
  python3 -c "print(\"$1\".encode(\"unicode_escape\").decode())"
}

ucconvert() {
  python3 - <<'PY' "$1"
import sys
import re
from pathlib import Path

input = Path(sys.argv[1])
text = input.read_text(encoding="utf-8")

def repl(match):
    return match.group(0).encode(
        "unicode-escape"
    ).decode("utf-8")

result = re.sub(
    r'[\u2000-\uF8FF\U000F0000-\U0010FFFF]',
    repl,
    text
)

output = input.with_suffix(input.suffix + ".converted")
output.write_text(result, encoding="utf-8")

print(f"Saved: {output}")
PY
}
