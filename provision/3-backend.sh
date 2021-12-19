#!/bin/sh

set -eu

sudo -s
cp /home/vagrant/sausage-store.service /etc/systemd/system/sausage-store.service
systemctl daemon-reload
systemctl enable sausage-store.service
systemctl start sausage-store.service
