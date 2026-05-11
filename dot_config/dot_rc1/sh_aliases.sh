

########################### EDITORS
# alias vi='nvim'
# alias svi='sudo vi'
# alias vis='nvim "+set si"'
# alias pico='edit'
# alias spico='sedit'
# alias nano='edit'
# alias snano='sedit'
# alias vim='nvim'
alias e="nano "
# alias e="vim -O "    # side by side
# alias E="vim -o " 	# one windows per file
# alias svim='sudo vim'

########################### DIR Manager

# pwdtail() { # Returns the last 2 fields of the working directory
# 	pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
# }

# Goes up a specified number of directories  (i.e. up 4)
# up() {
# 	local d=""
# 	limit=$1
# 	for ((i = 1; i <= limit; i++)); do
# 		d=$d/..
# 	done
# 	d=$(echo $d | sed 's/^\///')
# 	if [ -z "$d" ]; then
# 		d=..
# 	fi
# 	cd $d
# }

function diffdir() {    # diffdir /path1 /path2
    # find $1 -exec stat --format='%n %A %U %G' {} \; | sort > /tmp/sil1.diffdir
    # find $2 -exec stat --format='%n %A %U %G' {} \; | sort > /tmp/sil2.diffdir

    # diff <(tree -ap $1) <(tree -ap $2)
    diff -u <(find $1 -printf '%P %m\n' | sort) <(find $2 -printf '%P %m\n' | sort)
}




########################### FILE Commands
if [ -f "/etc/alpine-release" ]; then
	cpadd=
else
	cpadd="--preserve-root" # Preventing changing perms on / #
fi
alias cp='cp -i'  #prompt before overwrite
alias mv='mv -i'  #prompt before overwrite
alias rm="rm -i $cpadd" # do not delete / or -I prompt if deleting more than 3 files at a time #
#alias rm='rm -iv'
alias rmd='/bin/rm -rfv' # Remove a directory and all files
alias mkdir='mkdir -p'
# alias rm='trash -v'
# Create and go to the directory
mkdirg() {
	mkdir -p "$1"
	cd "$1"
}
# Copy file with a progress bar
cpp() {
    set -e
    strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
    awk '{
        count += $NF
        if (count % 10 == 0) {
            percent = count / total_size * 100
            printf "%3d%% [", percent
            for (i=0;i<=percent;i++)
                printf "="
            printf ">"
            for (i=percent;i<100;i++)
                printf " "
            printf "]\r"
        }
    }
    END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

# Copy and go to the directory
cpg() {
	if [ -d "$2" ]; then
		cp "$1" "$2" && cd "$2"
	else
		cp "$1" "$2"
	fi
}

# Move and go to the directory
mvg() {
	if [ -d "$2" ]; then
		mv "$1" "$2" && cd "$2"
	else
		mv "$1" "$2"
	fi
}

########################### CHMOD commands
alias chmod="chmod -c"  #like verbose but report only when a change is made
# alias mx='chmod a+x'
# alias 000='chmod -R 000'
# alias 644='chmod -R 644'
# alias 666='chmod -R 666'
# alias 755='chmod -R 755'
# alias 777='chmod -R 777'
alias chown="chown $cpadd"
alias chmod="chmod $cpadd"
alias chgrp="chgrp $cpadd"
function chmodrec() {   # chmodrec . 755 644
    find $1 -type d -exec chmod $2 {} \;
    find $1 -type f -exec chmod $3 {} \;
    # find ./ \( -type d -execdir chmod 755 '{}' \; \) , \( -type f -execdir chmod 644 '{}' \; \)
    # find . -name "*.sh" -exec chmod +x {} \;
    # find /path/to/directory -type f -print0 | xargs -0 chmod 644
}
#chmod -R 'u=rwX,g=rwX,o=rX'    # X sets x for dir or file(already set x at one of the u,g,o)
# chmod -R +X
########################### FILE FIND

alias f="find . | grep " # Search files in the current folder
alias fd='find . -type d -name'
alias ff='find . -type f -name'
alias ln='ln -i'  # -iv
# Searches for text in all files in the current folder
ftext() {
	# -i case-insensitive -I ignore binary files -H filename printed -r recursive -n line number
	# optional: -F treat search term as a literal, not a regular expression
	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
	grep -iIHrn --color=always "$1" . | less -r
}
# find $1 -printf '%#m\t%M\t%T+\t%C+\t%U:%G\t%s\t%P \n' >_folderreport_1.txt
# Use fzf to file selector with preview

alias fzfp='fzf --preview "cat {}"'
alias fzfch='find ~/.config/cheat/cheatsheets/personal | sort | fzf --preview "cat {}"'
if [ -x "$(command -v bat)" ]; then
  alias cat='bat --color=always'
  alias fzfp='fzf --preview "bat --color=always {}"'
  alias fzfch='find ~/.config/cheat/cheatsheets/personal | sort | fzf --preview "bat --color=always --language bash {}"'
elif [ -x "$(command -v batcat)" ]; then
  alias cat='batcat --color=always'
  alias fzfp='fzf --preview "batcat --color=always {}"'
  alias fzfch='find ~/.config/cheat/cheatsheets/personal | sort | fzf --preview "batcat --color=always --language bash {}"'
fi
ch() {
  curl cheat.sh/$1
}
# ch() { curl cheat.sh/$1 | batcat --color=always  }

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

########################### GREP  # https://askubuntu.com/questions/1042234/modifying-the-color-of-grep
export GREP_COLORS='mt=3;33'

[ ! -f "/etc/alpine-release" ]; export GREP_OPTIONS='--color=auto' #deprecated
if command -v rg &> /dev/null; then  # Check if ripgrep is installed
    alias grep='rg' # Alias grep to rg if ripgrep is installed
else
    alias grep="/usr/bin/grep $GREP_OPTIONS"
fi

# alias grep="grep $GREP_OPTIONS"  #'always', 'never', or 'auto'
alias egrep="grep -E $GREP_OPTIONS" # --extended-regexp
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '   #recursive search file
    # -H, --with-filename  # -R, --dereference-recursive  likewise, but follow all symlinks
    # -n, --line-number # -C, --context=NUM
unset GREP_OPTIONS
# alias diff='colordiff'
if command -v colordiff > /dev/null 2>&1; then
    alias diff="colordiff -Nuar"
else
    alias diff="diff -Nuar"
fi
alias t='tail -f'
alias multitail='multitail --no-repeat -c'
alias sortnr='sort -n -r'
alias less='less -R'     # Repaint the screen after each page


########################### ARCHIVES
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'
# Extracts any archive(s) (if unp isn't installed)
extract() {
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
			*.bz2) bunzip2 $archive ;; # bzip2 -d $1
			*.rar) rar x $archive ;; # unrar2dir $1  unrar x $1
			*.gz) gunzip $archive ;;
			*.tar) tar xvf $archive ;;
			*.tbz2) tar xvjf $archive ;;
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

########################### DISK   Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'
alias dir5='du -cksh * | sort -hr | head -n 5' # List largest directories (aka "ducks")
alias dir10='du -cksh * | sort -hr | head -n 10'  # c total k block size
alias dud='du -d 1 -h'  # folder sizes   -d 1 dept1 human readible
alias duf='du -sh *'	# summarize
alias df='df -h -x squashfs -x tmpfs -x devtmpfs'  #file systems x exclude
alias ncdu='ncdu --color dark'
# alias lsmount='mount |column -t'

########################### SYSTEM
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f" # Show all logs in /var/log
alias jctl="journalctl -p 3 -xb" # get error messages from journalctl

alias job='jobs -l'

alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'
alias psf='ps -f'   #full format listing all columns
alias p="ps aux | grep " # Search running processes

alias cpu5='ps auxf | sort -nr -k 3 | head -5' ## get top process eating cpu ##
alias cpu10='ps auxf | sort -nr -k 3 | head -10'
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

alias mem5='ps auxf | sort -nr -k 4 | head -5' ## get top process eating memory
alias mem10='ps auxf | sort -nr -k 4 | head -10'

distribution () {  # Show the current distribution
    local dtype="unknown"  # Default to unknown
    if [ -r /etc/os-release ]; then # Use /etc/os-release for modern distro identification
        source /etc/os-release
        case $ID in
            fedora|rhel|centos) dtype="redhat" ;;
            sles|opensuse*) dtype="suse" ;;
            ubuntu|debian) dtype="debian" ;;
            gentoo) dtype="gentoo" ;;
            arch|manjaro) dtype="arch" ;;
            slackware) dtype="slackware" ;;
            *)
                # Check ID_LIKE only if dtype is still unknown
                if [ -n "$ID_LIKE" ]; then
                    case $ID_LIKE in
                        *fedora*|*rhel*|*centos*) dtype="redhat" ;;
                        *sles*|*opensuse*) dtype="suse" ;;
                        *ubuntu*|*debian*) dtype="debian" ;;
                        *gentoo*) dtype="gentoo" ;;
                        *arch*) dtype="arch" ;;
                        *slackware*) dtype="slackware" ;;
                    esac
                fi
                ;;
        esac
    fi
    echo $dtype
}
ver() {  # Show the current version of the operating system
    local dtype
    dtype=$(distribution)
    case $dtype in
        "redhat")
            if [ -s /etc/redhat-release ]; then
                cat /etc/redhat-release
            else
                cat /etc/issue
            fi
            uname -a
            ;;
        "suse") cat /etc/SuSE-release ;;
        "debian") lsb_release -a ;;
        "gentoo") cat /etc/gentoo-release ;;
        "arch") cat /etc/os-release ;;
        "slackware") cat /etc/slackware-version ;;
        *)
            if [ -s /etc/issue ]; then
                cat /etc/issue
            else
                echo "Error: Unknown distribution"
                exit 1
            fi
            ;;
    esac
}


########################### APPS  # Manage packages easier
if [ -f /usr/bin/apt ]; then
	alias u='sudo apt update'
	alias upg='sudo apt update && sudo apt dist-upgrade && sudo apt autoremove && sudo apt clean'
	alias i='sudo apt install'
  alias apt-get='sudo apt-get'
fi

if [ -f /usr/bin/pacman ]; then
	alias update='sudo pacman -Syyy'
	alias upgrade='sudo pacman -Syu'
	alias install='sudo pacman -S'
  alias pacman-update='sudo pacman-mirrors --geoip'
fi
app_installed() {
  dpkg-query -Wf '${Installed-Size}\t${Package}\t${Version}\n'
  }
app_bysize() {
  dpkg-query -Wf '${Installed-Size}\t${Package}\t${Version}\n' | sort -n
  }
app_bysize30() {
    dpkg-query --show --showformat='${Installed-Size}\t${Package}\n' | sort -rh | head -30 | awk '{print $1/1024, $2}'
    # dpkg-query -Wf '${Installed-Size}\t${Package}\t${Version}\n' | sort -n | tail -n 30
# awk '{if ($1 ~ /Package/) p = $2; if ($1 ~ /Installed/) printf("%9d %s\n", $2, p)}' /var/lib/dpkg/status | sort -n | tail
}
app_find() {
  dpkg-query -Wf '${Installed-Size}\t${Package}\t${Version}\n' | grep $1
  }
app_findSize() {
    apt-cache --no-all-versions show $1 | awk '$1 == "Package:" { p = $2 } $1 == "Size:" { printf("%10d %s\n", $2, p) }'
}

alias app_show="apt show -a"
alias app_depend="apt-cache depends"
alias app_rdepend="apt-cache rdepends"
apt-space-used-by() {
    sudo apt-get --assume-no autoremove $@ | grep freed | cut -d' ' -f4-5 ;
}
# dpkg --print-avail <package> | grep "Installed-Size"
# echo -n | sudo apt-get purge <package> | grep "disk space will be freed"
# echo -n | sudo apt-get purge --auto-remove <package> | grep "disk space will be freed"
# This will not purge package with dependencies but only gives how much disk space will be freed with help of grep!

########################### NETWORK
alias openports='netstat -nape --inet' # Show open ports
alias ports='netstat -tulanp'
alias extip='curl icanhazip.com'  #external ip adress
alias wget='wget -c'
alias weather='curl wttr.in'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'
alias ping='ping -c 5'   # only ping 5 times
# IP address lookup
alias ip4=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
alias whatismyip="whatsmyip"
function whatsmyip () {
    # Internal IP Lookup.
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

    # External IP Lookup
    echo -n "External IP: "
    # curl -s ifconfig.me
    if command -v curl &> /dev/null; then
      curl -s https://ipinfo.io
    else
      wget -qO- https://ipinfo.io
    fi
}
########################### DOCKER
alias docker-clean=' \
  docker container prune -f ; \
  docker image prune -f ; \
  docker network prune -f ; \
  docker volume prune -f '
########################### GIT
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias stat='git status'  # 'status' is protected name so using 'stat' instead
alias tag='git tag'
alias newtag='git tag -a'

# bare git repo alias for managing my dotfiles
# alias config="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME"

# GitHub Titus Additions
gcom() {
	git add .
	git commit -m "$1"
}
lazyg() {
	git add .
	git commit -m "$1"
	git push
}
