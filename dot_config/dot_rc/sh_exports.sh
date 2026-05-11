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

if [ -x "$(command -v fresh)" ]; then
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
# echo "$(tput bold); $(tput setaf 2)" | cat -v # cat -v: Displays non-printing characters
# tput: Portable, readable, but slower (it runs a binary).Escape : Fast, direct, but hard-coded and less portable.
# "ANSI foreground" (setaf)  (setab background) 0Black 1Red 2Green 3Yellow 4Blue 5Magenta 6Cyan 7White
export LESS_TERMCAP_md=$'\E[01;32m' # Green  # md,bold Bold text  $(tput bold; tput setaf 2)
export LESS_TERMCAP_me=$'\E[0m'  # $(tput sgr0)  turn off bold, blink and underline   End all mode so, us, mb, md, and mr
export LESS_TERMCAP_us=$'\E[01;36m' # 4-Blue  us,smul start underline   $(tput smul; tput setaf 4)
export LESS_TERMCAP_ue=$'\E[0m'  # ue,rmul stop underline  $(tput rmul; tput sgr0)
export LESS_TERMCAP_so=$'\E[01;44;33m' # so,smso start standout (search result /Like) $(tput bold; tput setab 4; tput setaf 3)
export LESS_TERMCAP_se=$'\E[0m'         # se,rmso End standout  $(printf "\\e[0m")  $(tput rmso; tput sgr0)
# export LESS_TERMCAP_mb=$'\E[01;31m'  # mb      blink     start blink
export MANPAGER='less +Gg'
export GROFF_NO_SGR=1

