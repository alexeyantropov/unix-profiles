#!/bin/bash

repo_path="${HOME}/git/unix-profiles"

install_a_file () {
	path=$1
	file=$2
	mode=$3

	ln -sf ${repo_path}/${path}/${file} ~/${path}/.
	chmod -R $mode ~/${path}/${file}
}

# shell
install_a_file "" .bash_profile 640
install_a_file "" .bashrc 640
install_a_file "" .tmux.conf 640

# git
install_a_file "" .gitconfig 640

# vim
install_a_file "" .vimrc 640
install_a_file "" .vim 750

# ssh-clinet
mkdir -p  ~/.ssh || true
chmod 700 ~/.ssh

install_a_file .ssh rc 700 
install_a_file .ssh config 600

if (ssh -V 2>&1 | egrep 'OpenSSH_7.4'); then
	# it's sad
	ln -sf ${repo_path}/.ssh/config_7.5 ~/.ssh/config
	ln -sf ${repo_path}/.ssh/rc_7.5 ~/.ssh/rc
fi
