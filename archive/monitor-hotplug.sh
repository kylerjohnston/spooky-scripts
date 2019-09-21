#!/bin/bash

######################################
## /usr/local/bin/hotplug_monitor.sh
######################################
X_USER=krj
export DISPLAY=:0
export XAUTHORITY=/home/$X_USER/.Xauthority
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

function connect()
{   
    xrandr --output HDMI1 --above eDP1 --preferred --output HDMI1 --primary >> /tmp/screen
}

function disconnect(){
     xrandr --output HDMI1 --off
     xrandr --output eDP1 --primray --auto
}

if [ $(cat /sys/class/drm/card0-HDMI-A-1/status) == "connected" ] ; then
  connect
elif [ $(cat /sys/class/drm/card0-HDMI-A-1/status) == "disconnected" ] ; then
  disconnect
else 
  exit
fi
