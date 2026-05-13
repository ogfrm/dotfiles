# og_setprompt=starship
og_setprompt=posh
if [ "${og_setprompt}" = 'starship' ]; then
  # in does not support  transient prompt (when command executed prompt it self deleted command and output remains) on zsh
	if ! [ -x "$(command -v starship)" ]; then return; fi
	# https://starship.rs/config/#prompt
	if (ls /etc/*-release 1> /dev/null 2>&1); then
		_distro=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
	elif (ls /System/Library/CoreServices/SystemVersion.plist) 1> /dev/null 2>&1; then
		_distro="macos"
	fi

	# starship preset pastel-powerline > ~/.config/starship.toml
  starship preset nerd-font-symbols -o ~/.config/nerd-font-symbols.toml
	export STARSHIP_CONFIG=~/.config/starship_my.toml
	eval "$(starship init ${MYSHELL})"
elif [ "${og_setprompt}" = 'posh' ]; then
	# [ ! -x "$(command -v oh-my-posh)" ] && source ~/.apps/prompts/ohmyposh.sh

	eval "$(oh-my-posh init ${MYSHELL})"
  # oh-my-posh config export --output ~/.config/myposh_default.toml --format toml

  # oh-my-posh config export --config ~/.config/ohmyposh/slim.omp.json --output ~/.config/slim.omp.json.toml --format toml
  # oh-my-posh config export --config ~/.config/ohmyposh/catppuccin.omp.json --output ~/.config/catppuccin.omp.json.toml --format toml
  # oh-my-posh config export --config ~/.config/ohmyposh/tokyonight_storm.omp.json --output ~/.config/tokyonight_storm.omp.json.toml --format toml
  # oh-my-posh config export --config ~/.config/myposh.my.omp.json --output ~/.config/myposh.my.omp.json.toml --format toml
  # oh-my-posh config export --config ~/.config/myposh.my.omp.json --output ~/.config/myposh.my.omp.json.yaml --format yaml
	# eval "$(oh-my-posh init ${MYSHELL} --config ~/.config/myposh.zen.omp.toml)"
	# eval "$(oh-my-posh init ${MYSHELL} --config ~/.config/slim.omp.json.toml)"
	# eval "$(oh-my-posh init ${MYSHELL} --config ~/.config/ohmyposh/slimfat.omp.json)"
	eval "$(oh-my-posh init ${MYSHELL} --config ~/.config/myposh.my.omp.json)"

  oh-my-posh config export --output ~/.config/myposh_current.yaml --format yaml    # .json .yaml

fi
