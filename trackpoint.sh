#!/usr/bin/env sh
# sets Thinkpad trackpoint sensitivity

echo -n 125 > /sys/devices/platform/i8042/serio1/serio2/sensitivity
