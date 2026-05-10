# https://zsh.sourceforge.io/Doc/Release/Completion-System.html
#ZSH Autocomplete
#The autoload command load a file containing shell commands. Zsh will look in Zsh file search path, defined in the variable $fpath, and search a file called compinit. When compinit is found, its content will be loaded as a function
#fpath=($HOME/.local/share/zsh/completions $fpath) # Setup a custom completions directory
# zmodload loads a module supplied with Zsh itself. Modules are written in the C programming language.
# autoload declares a function to be loaded on demand from your $fpath. Functions are written in Zsh’s shell script language.

autoload -Uz compinit
compinit
#compinit -i # Initialize all completions on $fpath and ignore (-i) all insecure files
# zmodload -i zsh/complist

_comp_options+=(globdots) # With hidden files
# zstyle ':completion:*' menu select
zstyle ':completion:*' menu select=2  #if 2 or more choises menu select starts
# zstyle ':completion:*' menu select=long # if it doesnt fit the screen you can use both number and long

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
# # Make the list prompt friendly
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
# # Make the selection prompt friendly when there are a lot of choices
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
# # Add simple colors to kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
#   zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# # Make directories blue when autocompleting
[ -c "dircolors" ] && eval "$(dircolors -b)"
zstyle ':completion:*' list-colors ''
# zstyle ':completion:*' list-colors 'di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# zsh recomended
# zstyle ':completion:*' auto-description 'specify: %d'
# zstyle ':completion:*' format 'Completing %d'
# zstyle ':completion:*' group-name ''
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
# zstyle ':completion:*' use-compctl false
# zstyle ':completion:*' verbose true
# zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


# # Enable completion caching, use rehash to clear
# zstyle ':completion::complete:*' use-cache on
# zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# # Use menu, also llows you to use arrow keys
# zstyle ':completion:*' menu select=2 _complete _ignored _approximate

# # insert all expansions for expand completer
# zstyle ':completion:*:expand:*' tag-order all-expansions

# # match uppercase from lowercase
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# # offer indexes before parameters in subscripts
# zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# # formatting and messages
# zstyle ':completion:*' verbose yes
# zstyle ':completion:*:descriptions' format '%B%d%b'
# zstyle ':completion:*:messages' format '%d'
# zstyle ':completion:*:warnings' format 'No matches for: %d'
# zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
# zstyle ':completion:*' group-name ''

# # ignore completion functions (until the _ignored completer)
# zstyle ':completion:*:functions' ignored-patterns '_*'
# zstyle ':completion:*:scp:*' tag-order files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
# zstyle ':completion:*:scp:*' group-order files all-files users hosts-domain hosts-host hosts-ipaddr
# zstyle ':completion:*:ssh:*' tag-order users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
# zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host users hosts-ipaddr
# zstyle '*' single-ignored show

# zstyle ':completion::complete:lsof:*' menu yes select

# zstyle ':completion:*:*:cp:*' file-sort size
# zstyle ':completion:*' file-sort modification
# If you hit TAB after typing cp, the possible files matched by the completion system will be ordered by size.
# When you match files using the completion, they will be ordered by date of modification.