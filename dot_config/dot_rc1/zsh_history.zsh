#http://zsh.sourceforge.net/Doc/Release/Options.html

# Set history file
# HISTFILE=~/.zhistory
HISTFILE=~/.zsh_history

# export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"

# Set history size
HISTSIZE=1000

# Set the number of lines in $HISTFILE
SAVEHIST="${HISTSIZE}"

# Enable history search with up and down arrows
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "$key[Up]"   ]] && bindkey -- "$key[Up]"   up-line-or-beginning-search
[[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search

# All terminal sessions append to the history file immediately as commands are entered
setopt inc_append_history

# save timestamp of command and duration
setopt EXTENDED_HISTORY

# when trimming history, lose oldest duplicates first
setopt hist_expire_dups_first

# When a duplicate command is entered, remove the oldest duplicate
setopt hist_ignore_all_dups


# remove command line from history list when first character on the line is a space
setopt hist_ignore_space

# Remove extra blanks from each command line being added to history
setopt hist_reduce_blanks

# Reads the history file every time history is called
# This means that the history command will show recent entries, even between terminal sessions
setopt share_history

# setopt histignorealldups
# setopt    appendhistory     #Append history to the history file (no overwriting)
# setopt    sharehistory      #Share history across terminals
# setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed

# HISTORY
# setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
# setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
# setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
# END HISTORY



# https://zsh.sourceforge.io/Doc/Release/Options.html