# og_setprompt=starship
# og_setprompt=posh
# og_setprompt=custom
# og_setprompt=prompt
case "$og_setprompt" in
	prompt)
		# initialize advanced prompt support:
		autoload -U promptinit
		promptinit
		# prompt -p  #list available
    # prompt -l  #list the prompts
		# adam1 adam2 bart bigfade clint default elite2 elite fade fire off oliver pws redhat restore suse walters zefram
		prompt fade blue
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


