bash
#!/bin/bash

# Increase swap partition size
sudo swapoff ${SWAP_PARTITION}
sudo dd if=/dev/zero of=${SWAP_PARTITION} bs=1M count=${NEW_SIZE_IN_MB} conv=notrunc
sudo mkswap ${SWAP_PARTITION}
sudo swapon ${SWAP_PARTITION}

# Check swap partition size after resizing
free -m