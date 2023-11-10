
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Swap Partition Misalignment 
Swap partition misalignment is a technical issue that occurs when the start of a swap partition is not aligned with the start of a physical block on a hard drive. This can happen during partitioning, and can negatively impact system performance. When swap partition misalignment occurs, the operating system has to perform additional operations to access the swap space, which can slow down the system. Therefore, it is important to ensure proper alignment of swap partitions during installation or partitioning in order to avoid this issue.

### Parameters

```shell
export SWAP_PARTITION_LOCATION="PLACEHOLDER"
export ROOT_PARTITION_LOCATION="PLACEHOLDER"
export SECTOR_SIZE="PLACEHOLDER"
export SWAP_PARTITION_NUMBER="PLACEHOLDER"
export SWAP_START_SECTOR="PLACEHOLDER"
export PARTITION_DEVICE="PLACEHOLDER"
export NEW_SIZE_IN_MB="PLACEHOLDER"
export SWAP_PARTITION="PLACEHOLDER"
```

## Debug

### Check system memory usage

```shell
free -h
```

### Show disk space usage and partition information

```shell
df -h
```

### Display swap partition usage

```shell
swapon -s
```

### Check if any swap file/partition has been disabled

```shell
sudo swapon --show=NAME,SIZE,USED,PRIO
```

### Check if the system is using the swap space excessively

```shell
vmstat -s
```

### Check if there is any misalignment in the swap partition

```shell
sudo filefrag -v ${SWAP_PARTITION_LOCATION}
```

### Check if there is any misalignment in the root partition

```shell
sudo filefrag -v ${ROOT_PARTITION_LOCATION}
```

## Repair

### Realigning swap partitions manually: This can be done by calculating the correct offset value for the swap partition and then using a tool like `fdisk` to adjust the partition boundaries. However, this can be time-consuming and risky if not done correctly.

```shell
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
```

### Increasing swap partition size: If the misalignment issue is caused by running out of space on the swap partition, simply increasing

```shell
bash
#!/bin/bash

# Increase swap partition size
sudo swapoff ${SWAP_PARTITION}
sudo dd if=/dev/zero of=${SWAP_PARTITION} bs=1M count=${NEW_SIZE_IN_MB} conv=notrunc
sudo mkswap ${SWAP_PARTITION}
sudo swapon ${SWAP_PARTITION}

# Check swap partition size after resizing
free -m
```