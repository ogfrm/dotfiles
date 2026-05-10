if [ "${og_setprompt}" = 'starship' ]; then
	if ! [ -x "$(command -v starship)" ]; then return; fi
	# https://starship.rs/config/#prompt
	# set an icon based on the distro
	if (ls /etc/*-release 1> /dev/null 2>&1); then
		_distro=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
	elif (ls /System/Library/CoreServices/SystemVersion.plist) 1> /dev/null 2>&1; then
		_distro="macos"
	fi
	case $_distro in
		*kali*)                  ICON="ﴣ";;
		*arch*)                  ICON="";;
		*debian*)                ICON="";;
		*raspbian*)              ICON="";;
		*ubuntu*)                ICON="";;
		*elementary*)            ICON="";;
		*fedora*)                ICON="";;
		*coreos*)                ICON="";;
		*gentoo*)                ICON="";;
		*mageia*)                ICON="";;
		*centos*)                ICON="";;
		*opensuse*|*tumbleweed*) ICON="";;
		*sabayon*)               ICON="";;
		*slackware*)             ICON="";;
		*linuxmint*)             ICON="";;
		*alpine*)                ICON="";;
		*aosc*)                  ICON="";;
		*nixos*)                 ICON="";;
		*devuan*)                ICON="";;
		*manjaro*)               ICON="";;
		*rhel*)                  ICON="";;
		*macos*)                 ICON="";;
		*)                       ICON="";;
	esac
	export STARSHIP_DISTRO="$ICON"


	#curl -sS https://starship.rs/install.sh | sh
	#curl -sS https://starship.rs/install.sh | sh -- sh -s -- --yes
	#sh -c "echo -e 'y' | $(wget https://starship.rs/install.sh -O -)"
	# echo -ne '\n'  |
	# starship preset nerd-font-symbols > ~/.config/starship.toml
	# starship preset no-nerd-font > ~/.config/starship.toml
	# starship preset bracketed-segments > ~/.config/starship.toml
	# starship preset plain-text-symbols > ~/.config/starship.toml
	# starship preset no-runtime-versions > ~/.config/starship.toml
	# starship preset no-empty-icons > ~/.config/starship.toml
	# starship preset pure-preset > ~/.config/starship.toml
	# starship preset pastel-powerline > ~/.config/starship.toml
	# starship preset tokyo-night > ~/.config/starship.toml
	export STARSHIP_CONFIG=~/.config/.rc/prompt.starship.toml
	eval "$(starship init ${MYSHELL})"

elif [ "${og_setprompt}" = 'posh' ]; then
	[ ! -x "$(command -v oh-my-posh)" ] && source ~/.apps/prompts/ohmyposh.sh
	# eval "$(oh-my-posh init ${MYSHELL})"
	eval "$(oh-my-posh init ${MYSHELL} --config ~/.config/.rc/prompt.myposh.omp.json)"
	# eval "$(oh-my-posh init ${MYSHELL} --config ~/.config/.rc/posh_samples/1_shell.omp.json)"
fi
