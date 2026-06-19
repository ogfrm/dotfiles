# if [ -n "$BASH_VERSION" ]; then   [ -n "$ZSH_VERSION" ]
MYSHELL=`basename $(readlink /proc/$$/exe)` # MYSHELL=`ps -cp "$$" -o command=""`

#######################################################
# Prompt
#######################################################
og_setprompt=posh
if [ "${og_setprompt}" = 'starship' ]; then   # https://starship.rs/config/#prompt
	export STARSHIP_CONFIG=~/._my/prompt.my.star.toml
	eval "$(starship init ${MYSHELL})"
elif [ "${og_setprompt}" = 'posh' ] && command -v oh-my-posh &> /dev/null; then
	eval "$(oh-my-posh init ${MYSHELL} --config ~/._my/prompt.my.omp.yaml)" # slimfat
	# eval "$(oh-my-posh init $(oh-my-posh get shell) --config ~/._my/prompt.my.omp.yaml)" # slimfat
fi

#######################################################
# Shell integrations
#######################################################

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init --cmd cd ${MYSHELL})"  # --cmd will use cd instead of z   cdi instead of zi
fi

#######################################################
# FZF integrations  CTRL+R: history  CTRL+T: find file or dir  ALT+C search for a directory and cd
#######################################################
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "cat {}"' # Preview files on right 'cat'
# export FZF_DEFAULT_OPTS="--color=bg+:24 --border=bold --border=rounded --layout=reverse --margin=3% --color=dark,bg+:24"

if type rg &>/dev/null; then # Use ripgrep (rg) if installed for faster, cleaner searches
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
fi

# Git fzf ^G ( ? this list ^F Files ^B Branches ^T Tags ^R Remotes ^H commit Hashes ^S Stashes ^L reflogs ^W Worktrees ^E Each ref (git for-each-ref)   # https://github.com/junegunn/fzf-git.sh
[ -f "$HOME/.local/share/fzf-git/fzf-git.sh" ] && source "$HOME/.local/share/fzf-git/fzf-git.sh"
[ -f "/usrlocal/share/fzf-git/fzf-git.sh" ] && source "/usr/local/share/fzf-git/fzf-git.sh"

if [[ ! "$PATH" == *$HOME/.config/.installs* ]]; then
   export PATH="${PATH:+${PATH}:}$HOME/.config/.installs"
fi
