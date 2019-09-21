#!/usr/bin/env bash
# Installs and enables all service files in this directory at a system level

SERVICES=*.service

for service in ${SERVICES[@]}; do
    echo "Installing $service"
    if [ -L /etc/systemd/system/${service} ]; then
        sudo rm /etc/systemd/system/${service}
    fi
    sudo cp "$service" /etc/systemd/system/
    sudo chown root:root /etc/systemd/system/${service}
    sudo chmod 644 /etc/systemd/system/${service}
    echo "Starting and enabling $service"
    sudo systemctl enable $service
    sudo systemctl start $service
done

