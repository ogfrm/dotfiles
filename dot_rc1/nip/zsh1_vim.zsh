Activating Vi Mode
Zsh has a Vi mode you can enable by adding the following in your .zshrc:

bindkey -v
export KEYTIMEOUT=1
You can now switch between INSERT and NORMAL mode (called also COMMAND mode) with the ESC key, and use the familiar Vim keystrokes to edit what you’re typing in your shell prompt. I write the different modes in uppercase here for clarity, but it doesn’t have to be.

The second line export KEYTIMEOUT=1 makes the switch between modes quicker.

Changing Cursor
A visual indicator to show the current mode (NORMAL or INSERT) could be nice. In Vim, my cursor is a beam | when I’m in INSERT mode, and a block █ when I’m in NORMAL mode. I wanted the same for Zsh.

You can add the following in your zshrc, or autoload it from a file, as I did.

cursor_mode() {
    # See https://ttssh2.osdn.jp/manual/4/en/usage/tips/vim.html for cursor shapes
    cursor_block='\e[2 q'
    cursor_beam='\e[6 q'

    function zle-keymap-select {
        if [[ ${KEYMAP} == vicmd ]] ||
            [[ $1 = 'block' ]]; then
            echo -ne $cursor_block
        elif [[ ${KEYMAP} == main ]] ||
            [[ ${KEYMAP} == viins ]] ||
            [[ ${KEYMAP} = '' ]] ||
            [[ $1 = 'beam' ]]; then
            echo -ne $cursor_beam
        fi
    }

    zle-line-init() {
        echo -ne $cursor_beam
    }

    zle -N zle-keymap-select
    zle -N zle-line-init
}

cursor_mode
You can now speak about beams and blocks with passion and verve.

Vim Mapping For Completion
To give Zsh more of a Vim taste, we can set up the keys hjkl to navigate the completion menu.

First, add the following to your zshrc:

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
We load here the Zsh module complist. Modules have functionalities which are not part of the Zsh’s core, but they can be loaded on demand. Many different modules are available for your needs.

Here, the module complist give you access to the keymap menuselect, to customize the menu selection during completion, including how to select what you want.

In general, the command bindkey -M bind a key to a specific keymap. A keymap is a set of keystrokes bind to specific Zsh functions. In this case, the keymap menuselect bind keystrokes with selecting something in a list.

To list all the keymaps available (depending on the modules you’ve loaded), you can run in your shell bindkey -l (for list). You can also find the default ones here.

Last thing: you should always load the module zsh/complist before autoloading compinit.

Editing Command Lines In Vim
Good news: you can use your favorite editor to edit the commands you’re typing in your prompt! Let’s add these lines in your .zshrc to do so:

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
Here, we autoload edit-command-line, a function from the module zshcontrib, which includes many contributions from Zsh users. This specific function let you edit a command line in your visual editor, defined by the environment variable $VISUAL (or $EDITOR). Great! That’s what we wanted.

We already saw bindkey -M. Using the keymap vicmd, we can bind commands to some NORMAL mode keystrokes. It means that, when you’re in NORMAL mode, you can hit v to directly edit your command in your editor.

Adding Text Objects
If you use the Vi-mode of Zsh for a while, you’ll notice that there are no text objects for quotes or brackets: impossible to do something like da" (to delete a quoted substring) or ci( (to change inside parenthesis). Zsh supports these, you just need to generate and bind them to specific Zsh widgets:

autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km $c select-bracketed
  done
done
If you want to know more about Zsh widgets, I’ve written another article about that, where I also explain the code above.

Surrounding
Zsh also allows us to mimic the famous Tim Pope’s surround plugin. Just add the following to your zshrc:

autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround
You can then use cs (change surrounding), ds (delete surrounding), ys (add surrounding) in Zsh’s NORMAL mode.