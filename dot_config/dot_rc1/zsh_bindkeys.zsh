
# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

#control arrow keys
# bindkey "\eOc" forward-word
# bindkey "\eOd" backward-word
# bindkey "\e[1;5C" forward-word
# bindkey "\e[1;5D" backward-word
# bindkey "\e[5C" forward-word
# bindkey "\e[5D" backward-word
# bindkey "\e\e[C" forward-word
# bindkey "\e\e[D" backward-word

# Key-bindings
# bindkey -s '^o' 'ranger^M'
# bindkey -s '^f' 'zi^M'
# bindkey -s '^s' 'ncdu^M'
# # bindkey -s '^n' 'nvim $(fzf)^M'
# # bindkey -s '^v' 'nvim\n'
# bindkey -s '^z' 'zi^M'
# bindkey '^[[P' delete-char
# bindkey "^p" up-line-or-beginning-search # Up
# bindkey "^n" down-line-or-beginning-search # Down
# bindkey "^k" up-line-or-beginning-search # Up
# bindkey "^j" down-line-or-beginning-search # Down
# bindkey -r "^u"
# bindkey -r "^d"


# Custom ZSH Binds
# bindkey '^ ' autosuggest-accept

# https://www.zsh.org/mla/users/2014/msg00266.html

# Control-x-e to open current line in $EDITOR, awesome when writting functions or editing multiline commands.
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Restore history searching with ^r
bindkey '^r' history-incremental-search-backward

# This makes Alt+Left cd "back" in history, and Alt+Up move up a directory
# zle user-defined ZLE widgets which can be bound to keystrokes in interactive shells
cdUndoKey() {
	popd 2> /dev/null
    if (( $? == 0 )); then
        for precmd in $precmd_functions; do
            $precmd
        done
		zle && zle      reset-prompt
    fi
}
cdParentKey() {
	pushd .. > /dev/null
    if (( $? == 0 )); then
        local precmd
        for precmd in $precmd_functions; do
            $precmd
        done
		zle && zle      reset-prompt
    fi
}
zle -N                 cdParentKey
zle -N                 cdUndoKey
bindkey '^[[1;3A'      cdParentKey
bindkey '^[[1;3D'      cdUndoKey

# making the up arrow only list completions starting with what I already typed. So if I type ls<Up> it will only list completion items starting with ls.

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A'  up-line-or-beginning-search    # Arrow up
bindkey '^[OA'  up-line-or-beginning-search
bindkey '^[[B'  down-line-or-beginning-search  # Arrow down
bindkey '^[OB'  down-line-or-beginning-search