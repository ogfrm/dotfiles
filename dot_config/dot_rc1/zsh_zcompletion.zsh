
_comp_options+=(globdots) # With hidden files

zstyle ':completion:*' menu select=2  #if 2 or more choises menu select starts
# zstyle ':completion:*' menu select=long # if it doesnt fit the screen you can use both number and long
# zstyle ':completion:*' menu select=2 _complete _ignored _approximate  # Use menu, also allows you to use arrow keys

zstyle ':completion:*::::' completer _expand _complete _ignored _approximate # list of completers to use
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s' # # Make the list prompt friendly
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s' # Make the selection prompt friendly
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01' # Add simple colors to kill

# zsh recomended
# zstyle ':completion:*' auto-description 'specify: %d'
# zstyle ':completion:*' format 'Completing %d'
# zstyle ':completion:*' group-name ''
# zstyle ':completion:*' use-compctl false
# zstyle ':completion:*' verbose true
# zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# # Enable completion caching, use rehash to clear
# zstyle ':completion::complete:*' use-cache on
# zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# # insert all expansions for expand completer
# zstyle ':completion:*:expand:*' tag-order all-expansions

# # offer indexes before parameters in subscripts
# zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# # formatting and messages
# zstyle ':completion:*' verbose yes
# zstyle ':completion:*:descriptions' format '%B%d%b'
# zstyle ':completion:*:messages' format '%d'
# zstyle ':completion:*:warnings' format 'No matches for: %d'
# zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'

# # ignore completion functions (until the _ignored completer)
# zstyle ':completion:*:functions' ignored-patterns '_*'
# zstyle ':completion:*:scp:*' tag-order files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
# zstyle ':completion:*:scp:*' group-order files all-files users hosts-domain hosts-host hosts-ipaddr
# zstyle ':completion:*:ssh:*' tag-order users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
# zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host users hosts-ipaddr
# zstyle '*' single-ignored show

# zstyle ':completion::complete:lsof:*' menu yes select

# zstyle ':completion:*:*:cp:*' file-sort size # TAB after cp, files will be ordered by size.
# zstyle ':completion:*' file-sort modification # match files using the completion, will be ordered by date of modification.