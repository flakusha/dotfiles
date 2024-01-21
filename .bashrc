# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

# Path to your oh-my-bash installation.
export OSH=/usr/share/oh-my-bash

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-bash is loaded.
# OSH_THEME="font"
OSH_THEME="powerline-naked"

# Uncomment the following line to use case-sensitive completion.
# OMB_CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# OMB_HYPHEN_SENSITIVE="false"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_OSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you don't want the repository to be considered dirty
# if there are untracked files.
# SCM_GIT_DISABLE_UNTRACKED_DIRTY="true"

# Uncomment the following line if you want to completely ignore the presence
# of untracked files in the repository.
# SCM_GIT_IGNORE_UNTRACKED="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.  One of the following values can
# be used to specify the timestamp format.
# * 'mm/dd/yyyy'     # mm/dd/yyyy + time
# * 'dd.mm.yyyy'     # dd.mm.yyyy + time
# * 'yyyy-mm-dd'     # yyyy-mm-dd + time
# * '[mm/dd/yyyy]'   # [mm/dd/yyyy] + [time] with colors
# * '[dd.mm.yyyy]'   # [dd.mm.yyyy] + [time] with colors
# * '[yyyy-mm-dd]'   # [yyyy-mm-dd] + [time] with colors
# If not set, the default value is 'yyyy-mm-dd'.
# HIST_STAMPS='yyyy-mm-dd'

# Uncomment the following line if you do not want OMB to overwrite the existing
# aliases by the default OMB aliases defined in lib/*.sh
# OMB_DEFAULT_ALIASES="check"

# Would you like to use another custom folder than $OSH/custom?
# OSH_CUSTOM=/path/to/new-custom-folder

# To disable the uses of "sudo" by oh-my-bash, please set "false" to
# this variable.  The default behavior for the empty value is "true".
OMB_USE_SUDO=true

# To enable/disable display of Python virtualenv and condaenv
# OMB_PROMPT_SHOW_PYTHON_VENV=true  # enable
# OMB_PROMPT_SHOW_PYTHON_VENV=false # disable

# Which completions would you like to load? (completions can be found in ~/.oh-my-bash/completions/*)
# Custom completions may be added to ~/.oh-my-bash/custom/completions/
# Example format: completions=(ssh git bundler gem pip pip3)
# Add wisely, as too many completions slow down shell startup.
completions=(
  git
  ssh
)

# Which aliases would you like to load? (aliases can be found in ~/.oh-my-bash/aliases/*)
# Custom aliases may be added to ~/.oh-my-bash/custom/aliases/
# Example format: aliases=(vagrant composer git-avh)
# Add wisely, as too many aliases slow down shell startup.
aliases=(
  general
)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  bashmarks
  npm
  nvm
  progress
  zoxide
)

# Which plugins would you like to conditionally load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format:
#  if [ "$DISPLAY" ] || [ "$SSH" ]; then
#      plugins+=(tmux-autoattach)
#  fi

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-bash libs,
# plugins, and themes. Aliases can be placed here, though oh-my-bash
# users are encouraged to define aliases within the OSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias bashconfig="mate ~/.bashrc"
# alias ohmybash="mate ~/.oh-my-bash"

# PS1='[\u@\h \W]\$ '

BASH_CACHE_DIR=$HOME/.cache/oh-my-bash
if [[ ! -d $BASH_CACHE_DIR ]]; then
	mkdir $BASH_CACHE_DIR
fi

source "$OSH"/oh-my-bash.sh


# SSH Agent connection
# if [ ! -S ~/.ssh/ssh_auth_sock ]; then
#   eval $'(ssh-agent)'
#   ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
# fi
# export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
# ssh-add -l > /dev/null || ssh-add

# Ensure that we have an ssh config with AddKeysToAgent set to true
 if [ ! -f ~/.ssh/config ] || ! cat ~/.ssh/config | grep AddKeysToAgent | grep yes > /dev/null; then
     echo "AddKeysToAgent  yes" >> ~/.ssh/config
 fi
 # Ensure a ssh-agent is running so you only have to enter keys once
 if [ ! -S ~/.ssh/ssh_auth_sock ]; then
   eval `ssh-agent`
   ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
 fi
 export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lah'
alias grep='grep --color=auto'
alias hx='helix'
alias ez='eza -FlaghmuU --icons --group-directories-first --hyperlink --time-style long-iso'

alias i3-start='(
  export XDG_SESSION_TYPE=x11
  export XDG_SESSION_DESKTOP=i3
  export XDG_CURRENT_SESSION=i3
  export QT_QPA_PLATFORM=xcb
  export MOZ_ENABLE_WAYLAND=0
  #export SDL_VIDEODRIVER=x11
  export $(dbus-launch)
  exec pipewire &
  exec dunst -conf ~/.config/dunst/dunstrc &
  exec dbus-launch --exit-with-session startx ~/.xinitrc i3
  exec xrandr --dpi 98 &
)'

alias sway-start='(
  #export SDL_VIDEODRIVER="wayland,x11"
  #export SDL_VIDEODRIVER=wayland
  export QT_QPA_PLATFORM="wayland;xcb"
  export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
  export XDG_SESSION_TYPE=wayland
  export XDG_SESSION_DESKTOP=sway
  export XDG_CURRENT_DESKTOP=sway
  export MOZ_ENABLE_WAYLAND=1
  #exec dbus-run-session sway
  export $(dbus-launch)
  exec dbus-launch --exit-with-session sway
  firewall-applet
)'

alias hyprland-start='(
  #export SDL_VIDEODRIVER="wayland,x11"
  #export SDL_VIDEODRIVER=wayland
  export QT_QPA_PLATFORM="wayland;xcb"
  export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
  export XDG_SESSION_TYPE=wayland
  export XDG_SESSION_DESKTOP=Hyprland
  export XDG_CURRENT_DESKTOP=Hyprland
  export MOZ_ENABLE_WAYLAND=1
  export $(dbus-launch)
  exec dbus-launch --exit-with-session Hyprland
  firewall-applet
)'

alias gdm-start='(
  sudo rc-service gdm start
)'

alias sddm-start='(
  sudo rc-service sddm start
)'

alias rust-apps-update='(
  sudo rsync -uP ~/.cargo/bin/* \
  ~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/rust-analyzer \
  /usr/local/bin/
)'

alias backup-to-cold-drive='(
  echo "Home backup"
  rsync -aEhu --progress --delete --stats \
  --exclude=".cache" \
  --include=".cache/paru/clone" \
  /home/$LOGNAME /home/ext/
  echo "Shared backup"
  rsync -aEhuc --progress --delete --stats /home/shared /home/ext/
)'

alias gamescope-steam='(
  export RADV_PERFTEST="rt"
  export VKD3D_CONFIG=dxr
  gamemoderun vk_radv gamescope -w 3840 -h 2160 -W 3840 -H 2160 \
  -r 144 -o 15 \
  --expose-wayland \
  -e -f --rt --adaptive-sync \
  -- steam
)'

alias gamescope-steam-native='(
  export RADV_PERFTEST="rt"
  export VKD3D_CONFIG=dxr
  gamemoderun vk_radv gamescope -w 3840 -h 2160 -W 3840 -H 2160 \
  -r 144 -o 15 \
  --expose-wayland \
  -e -f --rt --adaptive-sync \
  -- steam-native
)'

# Rate these mirrors
alias rate-mirrors-all='(
  rate-mirrors \
  --entry-country JP \
  --country-neighbors-per-country 10 \
  --country-test-mirrors-per-country 10 \
  --top-mirrors-number-to-retest 30 \
  --save mirrorlist artix; \
  rate-mirrors \
  --entry-country JP \
  --country-neighbors-per-country 10 \
  --country-test-mirrors-per-country 10 \
  --top-mirrors-number-to-retest 30 \
  --save mirrorlist-arch arch; \
  rate-mirrors \
  --entry-country JP \
  --country-neighbors-per-country 10 \
  --country-test-mirrors-per-country 10 \
  --top-mirrors-number-to-retest 30 \
  --save mirrorlist-chaotic chaotic-aur
)'

PATH=$PATH:~/.cargo/bin
PATH=$PATH:~/node_modules/.bin

eval "$(thefuck --alias)"
eval "$(zoxide init bash)"
source "$HOME/.config/broot/launcher/bash/br"

# Clean up PATH from repeating entries
PATH=`printf %s "$PATH" | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}'`
