#!/usr/bin/env bash
# Emails a notification to myself if something fails
# Install this to /usr/local/bin

echo -e "Subject: $1 failure\n\n$(hostname) at $(date)" | sendmail -v kylerjohnston@gmail.com
