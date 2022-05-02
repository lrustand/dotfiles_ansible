#!/bin/sh
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?* ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

[[ -f ~/.Xresources ]] && xrdb ~/.Xresources

autorandr --change

exec qtile start
