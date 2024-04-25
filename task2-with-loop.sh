#!/bin/bash

# Author: Malik Shakeel Arshad

# Getting list of all of the users on a system.
all_system_users=$(getent passwd | cut -d: -f1)

# Printing header.
printf "%-20s %-20s %-20s %-20s\n" "USER" "Num Setuid Files" "Num Setgid Files" "Num World-writable Files"

# Initializing the counters for the unowned and total files.
unowned_files=0
total_files=0

# Loop through each of the users.
for user in $all_system_users; do
    # Counting the setuid files
    setuid_number=$(find / -type f -user $user -perm -4000 2>/dev/null | wc -l)

    # Counting the setgid files
    setgid_number=$(find / -type f -group $user -perm -2000 2>/dev/null | wc -l)

    # Counting the world-writable files
    world_writable_number=$(find / -type f \( -perm -o+w -o -perm -o+w,o+t \) -user $user 2>/dev/null | wc -l)

    # Updating total files count
    total_files=$((total_files + setuid_number + setgid_number + world_writable_number))

    # Printing permissions of user's file
    printf "%-20s %-20s %-20s %-20s\n" "$user" "$setuid_number" "$setgid_number" "$world_writable_number"
done | sort -nr -k 2,2 -k 3,3 -k 4,4

# Counting the unowned files.
unowned_files=$(find / -type f -nouser 2>/dev/null | wc -l)
echo "Number of unowned files: $unowned_files"

# Comment Security Risks.
echo "Examining the file list and looking into any possible security threats are crucial. Files having world-writable or setuid/setgid permissions may be acceptable for specific system functions, but they can also be dangerous if improperly secured or not intended. Similarly, unowned files could be a sign of an impending security breach if they contain important system data or files, but they could also be orphaned or transient files. Thus, in order to guarantee system security, a careful examination and analysis of these files are required." 
