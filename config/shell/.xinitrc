#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# change xterm's font
xrdb -merge ~/.Xresources

# turn off monitor blanking
xset -dpms
xset s off

# startup application in Xwindows
volnoti &
conky &
#blueman-applet &

# export path for android studio
#export ANDROID_SWT=~/android-studio/sdk/tools/lib/x86_64/

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
exec awesome
