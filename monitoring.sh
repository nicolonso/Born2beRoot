#!/bin/bash

# Architecture
arch=$(uname -a)

# CPU physical
pcpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)

# CPU virtual
vcpu=$(grep "processor" /proc/cpuinfo | wc -l)

# RAM
ram_total=$(free -m | awk '$1 == "Mem:" {print $2}')
ram_use=$(free -m | awk '$1 == "Mem:" {print $3}')
ram_percent=$(free -m | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

# DISK
disk_total=$(df -BG | grep '^/dev/' | grep -v '/boot$' | awk '{disk_t += $2} END {print disk_t}')
disk_use=$(df -BG | grep '^/dev/' | grep -v '/boot$' | awk '{disk_u += $3} END {print disk_u}')
disk_percent=$(df -BG | grep '^/dev/' | grep -v '/boot$' | awk '{disk_u += $3} {disk_t += $2} END {print (disk_u/disk_t)*100}')

# CPU load
cpul=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf("%.1f", usage)}')

# Last boot
lbt=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# LVM use
lvmuse=$(lsblk -o TYPE | grep -iq "lvm"; echo $? | awk '{if ($1 == 0) print "yes"; else print "no"; fi}')

# TCP connections
ctcp=$(ss -Ht state established | wc -l)

# User log
ulogs=$(users | wc -w)

# Network
ip=$(hostname -I | awk '{print $1}')
mac=$(ip link show | grep "ether" | awk '{print $2}')

# Sudo
cmd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "#Architecture: $arch
#CPU physical : $pcpu
#vCPU : $vcpu"