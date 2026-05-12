# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# og_setprompt=starship
#og_setprompt=posh
og_setprompt=p10k
# og_setprompt=custom
# og_setprompt=prompt
# og_setprompt=vcs
case "$og_setprompt" in
   p10k)
		zplugindir="/usr/share/zsh/plugins"  #default ~

		# sudo rm -rf $zplugindir/powerlevel10k
		[ ! -d $zplugindir/powerlevel10k ] && sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $zplugindir/powerlevel10k
		# echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
		source "$zplugindir/powerlevel10k/powerlevel10k.zsh-theme"
		#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
		# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${zplugindir:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

		# # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
		[ -f ~/.config/.rc/prompt.p10k.zsh ] && source ~/.config/.rc/prompt.p10k.zsh
		#source $zplugindir/powerlevel10k/config/p10k-classic.zsh
		#source $zplugindir/powerlevel10k/config/p10k-lean-8colors.zsh
		#source $zplugindir/powerlevel10k/config/p10k-lean.zsh
		#source $zplugindir/powerlevel10k/config/p10k-pure.zsh
		#source $zplugindir/powerlevel10k/config/p10k-rainbow.zsh
		#source $zplugindir/powerlevel10k/config/p10k-robbyrussell.zsh
	;;
	prompt)
		# initialize advanced prompt support:
		autoload -U promptinit
		promptinit
		# prompt -p  #list available
		prompt adam1
		# prompt -l  #list the prompts
		# adam1 adam2 bart bigfade clint default elite2 elite fade fire off oliver pws redhat restore suse walters zefram
	;;
	vcs)
		[[ ! -f ~/.config/.rc/prompt.zsh_vcs_info.sh ]] || source ~/.config/.rc/prompt.zsh_vcs_info.sh
	;;
	*)
		# Enable colors and change prompt:
		autoload -U colors && colors
		# PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

		# Set the prompt
		newline=$'\n'
		UNICORN_UTF8=$'\360\237\246\204' # 🦄
		FIRE_UTF8=$'\xF0\x9F\x94\xA5'  # 🔥
		prompt="%F{35}%* [%j]${git_prompt} [%m:%F{75}%f%F{69}%c%f%F{35}] %#%f ${newline}$FIRE_UTF8 "
	# %T	System time (HH:MM).
	# %*	System time (HH:MM:SS).
	# %D	System date (YY-MM-DD).
	# %n	Current username.
	# %B - %b	Begin - end bold print.
	# %U - %u	Begin - end underlining.
	# %d	The current working directory.
	# %~	The current working directory, relative to the home directory.
	# %M	The computer's hostname.
	# %m	The computer's hostname (truncated before the first period).
	# %l	The current tty.
	# PS1="[%* - %D] %d %% "
	;;
esac	#


