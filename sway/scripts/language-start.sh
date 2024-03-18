fcitx5 -dr --enable all
ibus-daemon -drx --panel=disabled # /usr/libexec/ibus-ui-gtk3
export WAYLAND_SOCKET=$SWAYSOCK
sleep 5
/usr/libexec/fcitx5-wayland-launcher
/usr/libexec/ibus-wayland
