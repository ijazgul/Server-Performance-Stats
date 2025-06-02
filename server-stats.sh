#!/bin/bash

# server-stats.sh - A basic Linux server monitoring script

echo "======================================="
echo "      Server Performance Statistics"
echo "======================================="

# OS and Host Info
echo -e "\n🖥️  OS and Host Information:"
hostnamectl | grep -E 'Operating System|Kernel|Architecture'

# Uptime and Load Average
echo -e "\n⏱️  Uptime and Load Average:"
uptime

# Logged-in users
echo -e "\n👤 Logged-in Users:"
who

# CPU Usage
echo -e "\n🧠 Total CPU Usage:"
top -bn1 | grep "Cpu(s)" | awk '{print "Used: " $2 + $4 "%, Idle: " $8 "%"}'

# Memory Usage
echo -e "\n📈 Memory Usage:"
free -h
used_mem=$(free | awk '/Mem:/ {print $3}')
total_mem=$(free | awk '/Mem:/ {print $2}')
mem_percent=$(awk "BEGIN {printf \"%.2f\", (${used_mem}/${total_mem})*100}")
echo "Memory Usage: $used_mem / $total_mem (${mem_percent}%)"

# Disk Usage
echo -e "\n💾 Disk Usage (Root Partition):"
df -h /
disk_used=$(df / | awk 'NR==2 {print $3}')
disk_total=$(df / | awk 'NR==2 {print $2}')
disk_percent=$(df / | awk 'NR==2 {print $5}')
echo "Disk Usage: $disk_used / $disk_total (${disk_percent})"

# Top 5 processes by CPU usage
echo -e "\n🔥 Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

# Top 5 processes by Memory usage
echo -e "\n💾 Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

# (Stretch) Failed login attempts (last 24 hours)
echo -e "\n🚫 Failed Login Attempts (last 24h):"
lastb -w | awk -v d="$(date --date="24 hours ago" '+%Y-%m-%d %H:%M:%S')" '
$0 ~ /^[a-zA-Z0-9]/ && $(NF-2) != "still" {
  cmd="date -d \""$4" "$5" "$6"\" +%Y-%m-%d\ %H:%M:%S"
  cmd | getline log_time
  close(cmd)
  if (log_time >= d) print
}' | wc -l

echo -e "\n✅ Script completed."
