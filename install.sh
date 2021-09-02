#!/bin/bash

repo_path="${HOME}/git/unix-profiles"

for file in .bash_profile .bashrc .gitconfig .tmux.conf .vimrc; do
	ln -sf ${repo_path}/$file ~/.
done

mkdir ~/.ssh
chmod 700 .ssh
for file in rc config; do
	ln -sf ln -sf ${repo_path}/.ssh/$file ~/.ssh/.
done

