# commands to ignore
cmdignore=(htop tmux top vim nvim nano iotop nethogs alsamixer ptipython man less more bash zsh ssh mosh vi emacs ipython ipython2 ptipython ptipython2 ptpython ptpython2 e l ll la watch sudo su)

# end and compare timer, notify-send if needed
function notifyosd-precmd() {
	retval=$?
    cmd_window_focused="$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}')"
    if [[ ${cmdignore[(r)$cmd_basename]} == $cmd_basename ]]; then
        return
    elif [[ "$cmd_window_focused" == "$cmd_window_start" ]]; then
        return
    else
        if [ ! -z "$cmd" ]; then
            cmd_end=`date +%s`
            ((cmd_time=$cmd_end - $cmd_start))
        fi
        if [ $retval -gt 0 ]; then
			cmdstat="with warning"
			sndstat="/usr/share/sounds/gnome/default/alerts/sonar.ogg"
		else
            cmdstat="successfully"
			sndstat="/usr/share/sounds/gnome/default/alerts/glass.ogg"
        fi
        if [ ! -z "$cmd" -a $cmd_time -gt 30 ]; then
            if [ ! -z $SSH_TTY ] ; then
                notify-send -i utilities-terminal -u low "$cmd_basename on `hostname` completed $cmdstat" "\"$cmd\" took $cmd_time seconds"; #play -q $sndstat
            else
                notify-send -i utilities-terminal -u low "$cmd_basename completed $cmdstat" "\"$cmd\" took $cmd_time seconds"; #play -q $sndstat
            fi
        fi
        unset cmd
    fi
}

if [ ! -z $DISPLAY ]; then
    # make sure this plays nicely with any existing precmd
    precmd_functions+=( notifyosd-precmd )
fi

# get command name and start the timer
function notifyosd-preexec() {
    cmd=$1
    cmd_basename=${${cmd:s/sudo //}[(ws: :)1]}
    cmd_start=`date +%s`
    cmd_window_start="$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}')"
}

if [ ! -z $DISPLAY ]; then
    # make sure this plays nicely with any existing preexec
    preexec_functions+=( notifyosd-preexec )
fi
