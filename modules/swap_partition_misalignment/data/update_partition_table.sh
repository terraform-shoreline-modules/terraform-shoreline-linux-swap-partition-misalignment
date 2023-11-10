#!/bin/bash

# Define the partition device and the sector size
PARTITION=${PARTITION_DEVICE}
SECTOR_SIZE=${SECTOR_SIZE}

# Calculate the correct offset value for the swap partition
OFFSET=$(echo "$SECTOR_SIZE * ${SWAP_START_SECTOR}" | bc)

# Adjust the partition boundaries using fdisk
fdisk ${PARTITION} ${<EOF
d
<swap_partition_number}
n
p
${SWAP_PARTITION_NUMBER}
${OFFSET}

w
EOF

# Display the updated partition table
fdisk -l ${PARTITION}

# Reboot the system to apply changes
reboot