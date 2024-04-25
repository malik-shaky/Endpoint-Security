#!/bin/bash

# Author: Malik Shakeel Arshad

# Getting list of all of the users on a system.
all_system_users=$(cut -d: -f1 /etc/passwd)

# Initializing the arrays to store CPU, Memory and the file counts for each of the user.
declare -A cpu_usage
declare -A memory_usage
declare -A file_counts

# Loop through the users to calculate the resource utilization.
for user in $all_system_users; do
    # Calculate CPU Utilization for a user
    cpu_usage[$user]=$(ps -u $user -o time= | awk '{split($1, a, ":"); print a[1]*3600 + a[2]*60 + a[3]}' | awk '{s+=$1} END {print s}')

    # Calculate Memory Usage for a user
    memory_usage[$user]=$(ps -u $user -o rss= | awk '{s+=$1} END {print s/1024}')

    # Calculate No of Files opened by a user
    file_counts[$user]=$(lsof -u $user | wc -l)
done

# Printing header.
printf "%-20s %-20s %-20s %-20s\n" "USER" "CPU Utilisation (sec.)" "MEMORY (MB)" "NUMBER OF FILES"

# Loop through the users for printing their resource utilization.
for user in "${!cpu_usage[@]}"; do
    printf "%-20s %-20s %-20s %-20s\n" "$user" "${cpu_usage[$user]}" "${memory_usage[$user]}" "${file_counts[$user]}"
done | sort -k2nr
