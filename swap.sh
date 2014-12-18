#!/bin/sh

if [ "$(id -u)" != "0" ]; then
	echo "Sorry, you are not root."
	exit 1
fi

# Do argument checks
if [ ! "$#" -ge 1 ]; then
    echo "Usage: $0 {size}"
    echo "Example: $0 2G"
    echo "Optional path: Usage: $0 {size} {path}"
    exit 1
fi

# Setup variables
SWAP_SIZE=$1
SWAP_PATH="/swapfile"
if [ ! -z "$2" ]; then
    SWAP_PATH=$2
fi

if [ -f $SWAP_PATH ]; then
    echo "You already have this swap file!"
    exit 1
fi

# Start script
fallocate -l $SWAP_SIZE $SWAP_PATH
chmod 600 $SWAP_PATH
mkswap $SWAP_PATH
swapon $SWAP_PATH
echo "$SWAP_PATH   none    swap    sw    0   0" | tee /etc/fstab -a
sysctl vm.swappiness=10
echo "vm.swappiness=10" | tee /etc/sysctl.conf -a
sysctl vm.vfs_cache_pressure=50
echo "vm.vfs_cache_pressure=50" | tee /etc/sysctl.conf -a



