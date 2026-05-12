# og_setprompt=starship
og_setprompt=posh
if [ "${og_setprompt}" = 'starship' ]; then
  # in does not support  transient prompt (when command executed prompt it self deleted command and output remains) on zsh
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

	# starship preset pastel-powerline > ~/.config/starship.toml
	export STARSHIP_CONFIG=~/.config/starship_my.toml
	eval "$(starship init ${MYSHELL})"

elif [ "${og_setprompt}" = 'posh' ]; then
	# [ ! -x "$(command -v oh-my-posh)" ] && source ~/.apps/prompts/ohmyposh.sh

	# eval "$(oh-my-posh init ${MYSHELL})"
  # oh-my-posh config export --output ~/.config/myposh_default.json
  # oh-my-posh config export --output ~/.config/myposh_default.toml --format toml

# catppuccin.omp.json  tokyonight_storm.omp.json

  # oh-my-posh config export --output ~/.config/myposh_current.toml --format toml    # .json .yaml
  # oh-my-posh config export --config ~/.config/ohmyposh/slim.omp.json --output ~/.config/slim.omp.jsom.toml --format toml
  # oh-my-posh config export --config ~/.config/prompt.myposh.omp.json --output ~/.config/prompt.myposh.omp.json.toml --format toml
  # oh-my-posh config export --config ~/.config/prompt.myposh.omp-02.json --output ~/.config/prompt.myposh.omp.json-02.toml --format toml
	# eval "$(oh-my-posh init ${MYSHELL} --config ~/.config/prompt.myposh.omp.json)"
	# eval "$(oh-my-posh init ${MYSHELL} --config ~/.config/prompt.myposh.omp-02.json)"
	eval "$(oh-my-posh init ${MYSHELL} --config ~/.config/myposh.zen.omp.toml)"
	# eval "$(oh-my-posh init ${MYSHELL} --config ~/.config/myposh_my.omp.toml)"

fi
