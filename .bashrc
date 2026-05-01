# Enable the subsequent settings only in interactive sessions
case $- in
*i*) ;;
*) return ;;
esac

# Load additional aliases
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] \
	&& . /usr/share/bash-completion/bash_completion

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vim'
else
	export EDITOR='hx'
fi

# SSH Agent connection
# if [ ! -S ~/.ssh/.ssh-auth-sock ]; then
# eval $'(ssh-agent)'
# ln -sf "$SSH_AUTH_SOCK" ~/.ssh/.ssh-auth-sock
# fi
# export SSH_AUTH_SOCK=~/.ssh/.ssh-auth-sock
# ssh-add -l > /dev/null || ssh-add

# Ensure that we have an ssh config with AddKeysToAgent set to true
# if [ ! -f ~/.ssh/config ] || ! cat ~/.ssh/config | grep AddKeysToAgent | grep yes > /dev/null; then
# echo "AddKeysToAgent yes" >> ~/.ssh/config
# fi

# Ensure a ssh-agent is running so you only have to enter keys once
if [ ! -S ~/.ssh/.ssh-auth-sock ]; then
	eval "$(ssh-agent)"
	ln -sf "$SSH_AUTH_SOCK" ~/.ssh/.ssh-auth-sock
fi

export SSH_AUTH_SOCK=~/.ssh/.ssh-auth-sock

# Configure GPG
GPG_TTY=$(tty)
export GPG_TTY

alias ls='ls --color=auto'
alias ll='ls -lahg --time-style=long-iso --hyperlink=auto'
alias grep='grep --color=auto'
alias ez='eza -laghmuU --icons --group-directories-first --hyperlink --time-style long-iso -F=auto'
alias wez='wezterm'

alias i3-start="(
	#export SDL_VIDEODRIVER=x11
	export XDG_SESSION_TYPE=x11
	export XDG_SESSION_DESKTOP=i3
	export XDG_CURRENT_SESSION=i3
	export QT_QPA_PLATFORM=xcb
	export MOZ_ENABLE_WAYLAND=0
	export GTK_THEME='Catppuccin-Mocha-Standard-Teal-Dark:dark'
	export $(dbus-launch)
	exec dunst -conf ~/.config/dunst/dunstrc &
	exec dbus-launch --exit-with-session startx ~/.xinitrc i3
	exec xrandr --dpi 98 &
)"

alias sway-start="(
	export SDL_VIDEODRIVER='wayland,x11'
	# export SDL_VIDEODRIVER=x11
	export QT_QPA_PLATFORM='wayland;xcb'
	# export QT_QPA_PLATFORM=wayland
	# Theme settings
	# export GTK_THEME='Catppuccin-Mocha-Standard-Teal-Dark:dark'
	export XCURSOR_THEME='Catppuccin-Mocha-Teal'
	export XCURSOR_SIZE=24
	export XCURSOR_PATH=/usr/share/icons
	export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
	export QT_STYLE_OVERRIDE=kvantum
	# Wayland integration
	export XDG_SESSION_TYPE=wayland
	export XDG_SESSION_DESKTOP=sway
	export XDG_CURRENT_DESKTOP=KDE
	export OZONE_PLATFORM=wayland
	export MOZ_ENABLE_WAYLAND=1
	# export GTK_USE_PORTAL=1
	export GDK_BACKEND=wayland
	# export WLR_RENDERER_ALLOW_SOFTWARE=1
	# export WLR_NO_HARDWARE_CURSORS=1
	export GTK_IM_MODULE=fcitx
	export QT_IM_MODULE=fcitx
	export XMODIFIERS='@im=fcitx'
	export SDL_IM_MODULE=fcitx
	export IMSETTINGS_INTEGRATE_DESKTOP=yes
	export IMSETTINGS_MODULE=fcitx
	export EDITOR=hx
	export RUSTICL_ENABLE=radeonsi
	export GDK_SCALE=0.75
	export STEAM_FORCE_DESKTOPUI_SCALING='0.5'
	export LC_LOCALE=en_IE.UTF-8
	# ESYNC and FSYNC are not guaranteed to work
	# export WINEESYNC=1
	export WINEFSYNC=1
	# exec dbus-launch --sh-syntax --exit-with-session sway
	exec dbus-run-session sway
)"

alias hypr-start="(
	# exec dbus-run-session Hyprland 
	AQ_DRM_DEVICES=/dev/dri/card0:/dev/dri/card1 exec dbus-run-session start-hyprland
	# &>> ~/hypr.log
	# exec dbus-launch --sh-syntax --exit-with-session Hyprland &>> ~/hypr.log
)"

alias plasma-start="(exec dbus-run-session startplasma-wayland)"

alias gnome-start="(doas rc-service display-manager start)"

# alias sddm-start='(sudo rc-service sddm start)'

# Moved it from rsync
# It's not required to send the rust-analyzer binary, as we can install it with useflag in Gentoo
# ~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/rust-analyzer \
alias rust-apps-update='(
	doas rsync -uP ~/.cargo/bin/[^.]*[^.] \
	/usr/local/bin/
)'

# Temporary disable this
# alias backup-to-cold-drive='(
# echo "Home backup"
# rsync -aEhu --progress --delete --stats \
# 	--exclude=".cache" \
# 	--include=".cache/paru/clone" \
# 	/home/$LOGNAME /home/ext/
# echo "Shared backup"
# rsync -aEhuc --progress --delete --stats /home/shared /home/ext/
# )'

# alias sync-disks=~/.config/sync-disks.sh

alias gamescope-steam='(
	gamemoderun gamescope -w 3840 -h 2160 -W 3840 -H 2160 \
	-r 144 -o 15 \
	-e \
	-f --rt -R --adaptive-sync \
	-- flatpak run com.valvesoftware.Steam --tenfoot
)'

alias gamescope-steam-native='(
	export RADV_PERFTEST="rt"
	export VKD3D_CONFIG=dxr
	gamemoderun gamescope -w 3840 -h 2160 -W 3840 -H 2160 \
	-r 144 -o 15 \
	--expose-wayland \
	-e -f --rt --adaptive-sync \
	-- steam-native
)'

# alias git-pull-full='(
# git fetch -fptP --all --recurse-submodules && \
# git submodule update --init && \
# git merge --no-commit
# )'

# alias npm-reset-registry='npm config set registry https://registry.npmjs.org/'
alias madge-circular='madge --circular --extensions js,mjs,ts'
alias dpdm='dpdm --no-warning --no-tree --transform'

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"
HISTSIZE=90000000
HISTFILESIZE=90000000
HISTTIMEFORMAT='#%s%n'

# You may need to manually set your language environment
export LANG=en_IE.UTF-8
export LC_COLLATE="C"

# Possible G$$GL issues
export GOPROXY=direct
export GOSUMDB=off
export GOTELEMETRY=off
export GOTOOLCHAIN=local

# Set home directories
export XDG_DESKTOP_DIR="$HOME"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Videos"

export PAGER=/usr/bin/bat
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

# Experimental change (build in RAM, but only 1 package)
export CARGO_TARGET_DIR=/tmp/cargo

# UV package manager don't get cache so huge lol
# Kind of useless - breaks some packages due to no symlink following and still inflates
# to 100s of gigs
# export UV_LINK_MODE=symlink

export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional

# Add locally installed and compiled packages
# PATH=$PATH:~/.cargo/bin

PATH=$PATH:~/node_modules/.bin
PATH=$PATH:~/go/bin
PATH=$PATH:~/.local/bin
# PATH=$PATH:~/.local/share/uv/tools
PATH=$PATH:~/.venv/bin
PATH=$PATH:~/.bun/bin

# Load useful things
eval "$(fzf --bash)"
eval "$(zoxide init bash)"
eval "$(atuin init bash --disable-up-arrow --disable-ai)"
source <(carapace _carapace)
source <(sk --shell bash)

# Load fancy things only in GUI
export IN_TTY=0

case $(tty) in
/dev/tty[1-9])
	IN_TTY=1 # NOTE Noop branch
	;;
*)
	eval "$(starship init bash)"
	[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
	;;
esac

# Clean up PATH from repeating entries
PATH=$(printf %s "$PATH" | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}')

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	# This one is the recommended approach that spawns new window though
	# if [ -n "${ZELLIJ:-}" ]; then
	# 	TERM=xterm-kitty
	# fi

	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Zellij - tty no decorations
function zellij() {
	if [[ $IN_TTY -eq 1 ]]; then
		command zellij options --simplified-ui true
	else
		command zellij
	fi
}
