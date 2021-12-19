#!/bin/sh

set -eu

sudo -s
cd ~vagrant/sausage-store/frontend
npm install
npm run build
npm install -g http-server
http-server ./dist/frontend/ -p 80 --proxy http://localhost:8080
