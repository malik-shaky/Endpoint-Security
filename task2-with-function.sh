#!/bin/bash

# Author: Malik Shakeel Arshad

# Function to count the files for every user.
files_count() {
    user=$1
    # Counting the Setuid files
    num_setuid=$(find / -user $user -perm -4000 2>/dev/null | wc -l)
    # Counting the Setgid files
    num_setgid=$(find / -group $user -perm -2000 2>/dev/null | wc -l)
    # Counting world-writable files
    num_world_writable=$(find / -perm -o+w -user $user 2>/dev/null | wc -l)
    # Printing the counts
    printf "%-20s %-20s %-20s %-20s\n" "$user" "$num_setuid" "$num_setgid" "$num_world_writable"
}

# Main function
main() {
    # Get a list of unique users.
    users=$(getent passwd | cut -d: -f1)

    # Printing header.
    printf "%-20s %-20s %-20s %-20s\n" "USER" "Num Setuid Files" "Num Setgid Files" "Num World-writable Files"

    # Iterate through every user.
    for user in $users; do
        # Calling the count files function for each user
        files_count $user
    done

    # Counting the unowned files.
    num_unowned_files=$(find / -nouser 2>/dev/null | wc -l)

    # Output the number of unowned files.
    printf "Number of unowned files: %d\n" $num_unowned_files
}

# Calling the main function.
main
