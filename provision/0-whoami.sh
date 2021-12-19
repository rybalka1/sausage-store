#!/bin/sh

set -eu

echo "Provisioned at $(date -Iseconds)"
echo "I am $(whoami)"
echo "I am at $(pwd)"
echo "My host name is $(hostname -f)"
echo "I run on kernel $(uname -a)"
echo "I run on vagrant instance '$VAGRANT_HOST'"
