#!/bin/bash

function createuser {
    read -p "Enter the username: " username
    cnt=$(cat /etc/passwd | grep "$username" | wc | awk '{print $1}')
    if [ "$cnt" -ge 1 ]; then
        echo "User already exists. Try again."
    else
        read -p "Enter password: " password
        sudo useradd -m "$username"
        echo "$username:$password" | sudo chpasswd
        echo "User created successfully"
    fi
}

function deleteuser {
    read -p "Enter the username: " username
    cnt=$(cat /etc/passwd | grep "$username" | wc | awk '{print $1}')
    if [ "$cnt" -ge 1 ]; then
        sudo userdel "$username"
        c=$(cat /etc/passwd | grep "$username" | wc | awk '{print $1}')
        if [ "$c" -eq 0 ]; then
            echo "User deleted successfully. Word count: $c"
        else
            echo "Unable to delete user"
        fi
    else
        echo "User doesn't exist. Enter a valid username."
    fi
}

function resetpassword {
    read -p "Enter the username: " username
    cnt=$(cat /etc/passwd | grep "$username" | wc | awk '{print $1}')
    if [ "$cnt" -ge 1 ]; then
        read -p "Enter new password: " newpassword
        echo "$username:$newpassword" | sudo chpasswd
        echo "Password updated successfully"
    else
        echo "User doesn't exist. Enter a valid username."
    fi
}
function help {
	echo "Usage: $0 [-c|--create] To create user"
	echo "Usage: $0 [-d|--delete] To delete user"
	echo "Usage: $0 [-r|--reset]  To Reset password"
	echo "Usage: $0 [-l|--list]   To List users"

}

function list {
	awk -F: '$3 >= 1000 && $3 < 65534 { print $1 }' /etc/passwd
}

if [[ "$1" == "-c" || "$1" == "--create" ]]; then
    createuser
elif [[ "$1" == "-d" || "$1" == "--delete" ]]; then
    deleteuser
elif [[ "$1" == "-r" || "$1" == "--reset" ]]; then
    resetpassword
elif [[ "$1" == "-h" || "$1" == "--help" ]]; then
    help
elif [[ "$1" == "-l" || "$1" == "--list" ]]; then
    list
else 
	echo "Use -h or --help for the help"
fi

