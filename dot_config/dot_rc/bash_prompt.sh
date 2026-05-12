#https://en.wikipedia.org/wiki/ANSI_escape_code
# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
# \e=\033=\x1B
# https://linuxcommand.org/lc3_adv_tput.php
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
# for fg_color in {0..7}; do
#     set_foreground=$(tput setaf $fg_color)
#     fg=`expr $fg_color + 30`
#     # echo "$set_foreground" | \cat -v
#     # for bg_color in {0..7}; do
#     #     set_background=$(tput setab $bg_color)
#     #     echo -n $set_background$set_foreground
#     #     printf ' F: %s B:  %s ' $fg_color $bg_color   # printf "$(tput sgr0)$(tput setaf $i) tput $i"
#     # done
#     # echo $(tput sgr0)
#     for bg_color in {0..7}; do
#         bg=`expr $bg_color + 40`
#         echo -e -n "\e[0m\e[0;${bg};${fg}m"
#         printf ' F:%s B: %s ' $fg $bg   # printf "$(tput sgr0)$(tput setaf $i) tput $i"
#         echo -e -n "\e[0m\e[1;${bg};${fg}m BL"
#         echo -e -n "\e[0m\e[4;${bg};${fg}m UL"
#     done
#     echo -e "\e[0m"
#     fg=`expr $fg_color + 90`
#     # echo "$set_foreground" | \cat -v
#     for bg_color in {0..7}; do
#         bg=`expr $bg_color + 100`
#         echo -e -n "\e[0m\e[0;${bg};${fg}m"
#         printf ' F:%s B:%s ' $fg $bg   # printf "$(tput sgr0)$(tput setaf $i) tput $i"
#         echo -e -n "\e[0m\e[1;${bg};${fg}m BL"
#         echo -e -n "\e[0m\e[4;${bg};${fg}m UL"
#     done
#     echo -e "\e[0m"
# done

# rev	Start reverse video
# smso	Start “standout” mode
# rmso	End “standout” mode
# tput setaf <value>	Set foreground color
# tput setab <value>	Set background color

# 0 sgr0 reset all
# 1 bold  21 reset
# 2 Dim   22 reset
# 4 smu   24 rmul reset  Underlined
# 5 blink 25 reset
# 7 reverse 27 reset  Reverse
# 8 invis  28 reset   Hidden

#          setaf       setab                bold (with 0-7)      bold (with 0-7)
# Color    Normal(FG)  Background  Color    Bright(FG)           Bright Back.
# Black    \e[30m 0    \e[40m      DarkGray \e[1,30m \e[90m 8    \e[1,40m \e[100m
# Red      \e[31m 1    \e[41m      LRed     \e[1,31m \e[91m 9    \e[1,41m \e[101m
# Green    \e[32m 2    \e[42m      LGreen   \e[1,32m \e[92m 10   \e[1,42m \e[102m
# Brown    \e[33m 3    \e[43m      Yellow   \e[1,33m \e[93m 11   \e[1,43m \e[103m
# Blue     \e[34m 4    \e[44m      LBlue    \e[1,34m \e[94m 12   \e[1,44m \e[104m
# Magenta  \e[35m 5    \e[45m      LMagenta \e[1,35m \e[95m 13   \e[1,45m \e[105m
# Cyan     \e[36m 6    \e[46m      LCyan    \e[1,36m \e[96m 14   \e[1,46m \e[106m
# White    \e[37m 7    \e[47m      LGray    \e[1,37m \e[97m 15   \e[1,47m \e[107m
# Default  \e[39m      \e[49m

# \e = \033   $escape char
# \[ = \001 Start of Heading (SOH): (start a non-printing sequence)  so the shell can accurately calculate prompt length
# \] = \002 Start of Text (STX): (end a non-printing sequence)
# none print char has to be between \[ \]  to they dont count as char

black='\[\e[0;30m\]' # '\001\033[0;30m\002'  "\001$(tput setaf 0)\002"
gray='\[\e[1;30m\]'  # "\001$(tput setaf 8)\002" "\001$(tput bold)$(tput setaf 0)\002"
red='\[\e[0;31m\]'
lred='\[\e[1;31m\]'
green='\[\e[0;32m\]'
lgreen='\[\e[1;32m\]'
yellow='\[\e[1;33m\]'
blue='\[\e[0;34m\]'
lblue='\[\e[1;34m\]'
# purple='\[\e[0;35m\]'
# lpurple='\[\e[1;35m\]'
cyan='\[\e[0;36m\]'
lcyan='\[\e[1;36m\]'
lgray='\[\e[0;37m\]'
# white='\[\e[1;37m\]'
reset='\[\e[0m\]' # no color  # "\001$(tput sgr0)\002"
dim='\[\e[2m\]' # "\001$(tput dim)\002"
rev='\[\e[7m\]' # "\001$(tput dim)\002"

# og_setprompt=starship
og_setprompt=posh
# og_setprompt=1
# og_setprompt=$1

BRACKET_COLOR=$lgreen  # "\[\033[38;5;35m\]"
CLOCK_COLOR="$BRACKET_COLOR"
JOB_COLOR=$lblue   # "\[\033[38;5;33m\]"
PATH_COLOR=$lblue  # "\[\033[38;5;33m\]"
LINE_COLOR=$lgray # "\[\033[38;5;248m\]"

LINE_STRAIGHT="$LINE_COLOR\342\[\224\200\]"        # ─
LINE_BOTTOM_CORNER="\n$LINE_COLOR\342\[\224\224\]$LINE_STRAIGHT$LINE_STRAIGHT"   # └──
LINE_UPPER_CORNER="$LINE_COLOR\342\[\224\214\]$LINE_STRAIGHT"      # ┌───
ERROR_CHAR="\342\[\234\227\]"   # ✗

P_ERROR="\$([[ \$? != 0 ]] && echo \"$red[$ERROR_CHAR]\")$(if [[ ${EUID} == 0 ]]; then echo $lred; else echo $lgray; fi)"
P_CLOCK="$BRACKET_COLOR[$CLOCK_COLOR\t$BRACKET_COLOR]$LINE_STRAIGHT"
P_PATH="$BRACKET_COLOR$PATH_COLOR \w"
P_JOB="$BRACKET_COLOR[$JOB_COLOR\j$BRACKET_COLOR]$LINE_STRAIGHT"
case "$og_setprompt" in
   1)
        # jays prompt  256 color format
        P_HOST="$BRACKET_COLOR[\H:]"
        END_CHARACTER="|" #    "🦄" mess is up

        # P_HOST="$red[\u$yellow@$lcyan\h$red]"
        # P_PATH="$LINE_STRAIGHT$green[\w]"
        # END_CHARACTER="$C3$reset$yellow \$"
        # P_CLOCK=""
        # P_JOB=""

        tty -s && export PS1="$LINE_UPPER_CORNER$P_ERROR$LINE_STRAIGHT$P_CLOCK$P_JOB$P_HOST$P_PATH$LINE_BOTTOM_CORNER$END_CHARACTER${reset} "
        # https://www.learnlinux.tv/10-linux-terminal-tips-and-tricks-to-enhance-your-workflow/
     ;;
   2)
        export PS1="$dim[\t] \[\e[0;32m\]\u@\h$\[\e[0;33m\]\w\\[\e[0m\]" # [hh:mm:ss] user@host workingdir$ green brown reset
   ;;

esac