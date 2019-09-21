#!/usr/bin/env sh
# sets Thinkpad trackpoint sensitivity
# Install this to /usr/local/bin to work with systemd service

echo -n 125 > /sys/devices/platform/i8042/serio1/serio2/sensitivity

exit $?
