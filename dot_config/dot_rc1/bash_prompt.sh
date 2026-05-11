#https://en.wikipedia.org/wiki/ANSI_escape_code
# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
# \e=\033=\x1B
# https://linuxcommand.org/lc3_adv_tput.php
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
for fg_color in {0..7}; do
    set_foreground=$(tput setaf $fg_color)
    fg=`expr $fg_color + 30`
    # echo "$set_foreground" | \cat -v
    # for bg_color in {0..7}; do
    #     set_background=$(tput setab $bg_color)
    #     echo -n $set_background$set_foreground
    #     printf ' F: %s B:  %s ' $fg_color $bg_color   # printf "$(tput sgr0)$(tput setaf $i) tput $i"
    # done
    # echo $(tput sgr0)
    for bg_color in {0..7}; do
        bg=`expr $bg_color + 40`
        echo -e -n "\e[0m\e[0;${bg};${fg}m"
        printf ' F:%s B: %s ' $fg $bg   # printf "$(tput sgr0)$(tput setaf $i) tput $i"
        echo -e -n "\e[0m\e[1;${bg};${fg}m BL"
        echo -e -n "\e[0m\e[4;${bg};${fg}m UL"
    done
    echo -e "\e[0m"
    fg=`expr $fg_color + 90`
    # echo "$set_foreground" | \cat -v
    for bg_color in {0..7}; do
        bg=`expr $bg_color + 100`
        echo -e -n "\e[0m\e[0;${bg};${fg}m"
        printf ' F:%s B:%s ' $fg $bg   # printf "$(tput sgr0)$(tput setaf $i) tput $i"
        echo -e -n "\e[0m\e[1;${bg};${fg}m BL"
        echo -e -n "\e[0m\e[4;${bg};${fg}m UL"
    done
    echo -e "\e[0m"
done

rev	Start reverse video
blink	Start blinking text
invis	Start invisible text
smso	Start “standout” mode
rmso	End “standout” mode
0	Black
1	Red
2	Green
3	Yellow
4	Blue
5	Magenta
6	Cyan
7	White
8	Not used
9	Reset to default color
# tput setaf <value>	Set foreground color
# tput setab <value>	Set background color
# The first number in the color code specifies the typeface:
# 0 sgr0 reset all
# 1 bold  21 reset
# 2 Dim  22 reset
# 4 Underlined smul  24 rmul reset
# 5 blink 25 reset
# 7 reverse back and front 27 reset
# 8 hidden invis  28 reset

# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

#  \e  = \033

black='\[\e[0;30m\]'
gray='\[\e[1;30m\]'  #tput setaf 1
red='\[\e[0;31m\]'
RED='\[\e[1;31m\]'  #tput setaf 1
green='\[\e[0;32m\]'
GREEN='\[\e[1;32m\]' #tput setaf 2
yellow='\[\e[0;33m\]'
YELLOW='\[\e[1;33m\]' #tput setaf 3
blue='\[\e[0;34m\]'
BLUE='\[\e[1;34m\]' #tput setaf 4
purple='\[\e[0;35m\]'
PURPLE='\[\e[1;35m\]' #tput setaf 5
cyan='\[\e[0;36m\]'
CYAN='\[\e[1;36m\]'     #tput setaf 6
GRAY='\[\e[0;37m\]'
WHITE='\[\e[1;37m\]'     #tput setaf 6
NC='\[\e[0m\]' #no color

og_setprompt=starship
# og_setprompt=posh
# og_setprompt=1
# og_setprompt=$1


LINE_BOTTOM_CORNER="\342\[\224\224\]"   # LINE_BOTTOM_CORNER="\342\224\224"
LINE_STRAIGHT="\342\[\224\200\]"        # LINE_STRAIGHT="\342\224\200"
LINE_UPPER_CORNER="\342\[\224\214\]"      # LINE_UPPER_CORNER="\342\224\214"
END_CHARACTER="|"
ERROR_CHAR="\342\[\234\227\]"   # ✗
#    END_CHARACTER="🦄"   #mess is up
#    "└──  ┌───"   # LINE_BOTTOM_CORNER="\342\224\224"
case "$og_setprompt" in
   1)
        # jays prompt
        BRACKET_COLOR="\[\033[38;5;35m\]"
        CLOCK_COLOR="$BRACKET_COLOR"
        JOB_COLOR="\[\033[38;5;33m\]"
        PATH_COLOR="\[\033[38;5;33m\]"
        # none print char has to be between \[ \]  to they dont count as char
        LINE_COLOR="\[\033[38;5;248m\]"
        LINE_BOTTOM="\342\[\224\200\]"     #this will count 1 char  # LINE_BOTTOM="\342\224\200" (mess up prompt)
        tty -s && export PS1="$LINE_COLOR$LINE_UPPER_CORNER$LINE_STRAIGHT$LINE_STRAIGHT$BRACKET_COLOR[$CLOCK_COLOR\t$BRACKET_COLOR]$LINE_COLOR$LINE_STRAIGHT$BRACKET_COLOR[$JOB_COLOR\j$BRACKET_COLOR]$LINE_COLOR$LINE_STRAIGHT$BRACKET_COLOR[\H:]$PATH_COLOR\w$BRACKET_COLOR]\n$LINE_COLOR$LINE_BOTTOM_CORNER$LINE_STRAIGHT$LINE_BOTTOM$END_CHARACTER\[$(tput sgr0)\] "
        # https://www.learnlinux.tv/10-linux-terminal-tips-and-tricks-to-enhance-your-workflow/
     ;;
   2)
        C3="\342\[\225\274\]"
        tty -s && export PS1="$red$LINE_UPPER_CORNER$LINE_STRAIGHT\$([[ \$? != 0 ]] && echo \"[$red$ERROR_CHAR$GRAY]$LINE_STRAIGHT\")[$(if [[ ${EUID} == 0 ]]; then echo $RED; else echo $GRAY; fi)\u$YELLOW@$CYAN\h$red]$LINE_STRAIGHT[$green\w$red]\n$red$LINE_BOTTOM_CORNER$LINE_STRAIGHT$LINE_STRAIGHT$C3 $NC$YELLOW\\$ ${NC1}"
     ;;
   3)
        green="\001$(tput setaf 2)\002"
        blue="\001$(tput setaf 4)\002"
        dim="\001$(tput dim)\002"
        reset="\001$(tput sgr0)\002"
        PS1="$dim[\t] " # [hh:mm:ss]
        PS1+="$green\u@\h" # user@host
        PS1+="$blue\w\$$reset " # workingdir$
        export PS1
        unset green blue dim reset
   ;;
esac

