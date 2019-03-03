#!/bin/bash

auth_socket="/tmp/ssh-*/agent.*"
auth_socket_link="${HOME}/.ssh/ssh_auth_sock"

YesNo () { 
    condition="1"
    while [ $condition == "1" ]; do
        echo -n "Enter (y/n): "
        read choice
        if [[ $choice == "" ]]; then
            choice="blahblahblah"
        fi
        if [ $choice != "n" ] && [ $choice != "y" ]; then
            echo "Enter 'y' or 'n'!"
        fi
        if [ $choice = "y" ]; then
            condition="0"
        fi
        if [ $choice = "n" ]; then
            condition="0"
            exit
        fi
done
} 

echo "Avaible sockets: "

for i in $auth_socket; do

    if [ -a $i ]; then
        ls -la  $i
    fi

done

echo -e "\nCreate symlink $auth_socket_link to $i?"
YesNo
if ln -sf $i $auth_socket_link; then
    echo -e "\nOk\n"
    stat $auth_socket_link

else
    echo -e "\nError!\n"
    echo -e "Try a command\n:    ln -sf $i $auth_socket_link"
fi
