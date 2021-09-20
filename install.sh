#!/bin/bash

repo_path="${HOME}/git/unix-profiles"

for file in .bash_profile .bashrc .gitconfig .tmux.conf .vimrc; do
	ln -sf ${repo_path}/$file ~/.
done

mkdir ~/.ssh 2> /dev/null
chmod 700 ~/.ssh
for file in rc config; do
	ln -sf ln -sf ${repo_path}/.ssh/$file ~/.ssh/.
done
chmod 750  ~/.ssh/rc
chmod 600  ~/.ssh/config

