#!/bin/sh

session=${1:-i3}

case $session in
    i3|i3wm           ) export XDG_SESSION_TYPE=i3; \
                        exec dbus-launch --exit-with-session i3;;
    kde               ) exec startplasma-x11;;
    xfce|xfce4        ) exec startxfce4;;
    # No known session, try to run it as command
    *                 ) exec $1;;
esac


