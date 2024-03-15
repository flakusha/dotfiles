# /etc/skel/.bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
if [[ -f ~/.bashrc ]] ; then
	. ~/.bashrc
fi

if test -z "${XDG_RUNTIME_DIR}"; then
	UID="$(id -u)"
	export XDG_RUNTIME_DIR=/tmp/"$(UID)"-runtime-dir
	
	if ! test -d "${XDG_RUNTIME_DIR}"; then
		mkdir "${XDG_RUNTIME_DIR}"
		chmod 0700 "${XDG_RUNTIME_DIR}"
	fi
fi

export HELIX_DEFAULT_RUNTIME=$HOME/git-repos/helix/runtime

