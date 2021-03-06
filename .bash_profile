# use symlink .bashrc -> .bash_profile for any sessions-type
# main env
export PATH=$PATH:$HOME/bin
export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export GREP_OPTIONS="--color=auto"
export EDITOR="vim"
export BASH_SILENCE_DEPRECATION_WARNING=1

# bash promt
git_ps1 () {
	git rev-parse --git-dir &> /dev/null
	retval=$?
	if test $retval -eq 0; then
		repo_name=$(basename $(git rev-parse --show-toplevel))
		branch=$(git rev-parse --abbrev-ref HEAD)
		changes=$(git status -s | wc -l | xargs)
		output=" (${repo_name}:${branch}:${changes})"
	else
		output=""
	fi
	echo "$output"
}

if [ `whoami` = 'root' ]; then
	export PS1='\[\033[1;31m\]\u@\h$(git_ps1) \W \$\[\033[00m\] '
else
	export PS1='\[\033[1;32m\]\u@\h$(git_ps1) \W \$\[\033[00m\] '
fi

# aliases
unalias -a
## common
alias bim="vim"
alias screen="screen -h 10000"
## tmux
alias tmux="tmux -2 -u"
alias ssx="tmux attach -d -t"
alias ssn="tmux new -s"
alias sss="tmux list-sessions"
alias bashprofileup="source ~/.bash_profile"

# custom functions
host-idn () {
	host `idn --quiet $1`
}
whois-idn () {
	whois -h whois.ripn.net `idn --quiet $1`
}
mkcd () {
	mkdir $1; cd $1
}
srv () { # get hostname of server by ptr-record
	for i in `host -ta $1 | awk '{print $4}'`; do host $i| awk '{print $5}'; done;
}

# include local config (for home, work, etc)
if [ -f ~/.bash_local* ]; then
	. ~/.bash_local*
fi

# set window title

# print tmux or screen sessions after login
if [ $TERM = "xterm" ]; then 
	tmux_top_sessions=10
	echo -e "\n*** tmux and screen top $tmux_top_sessions sessions\n"
	tmux list-sessions | head -${tmux_top_sessions}
	echo
	screen -ls | head -${tmux_top_sessions}
fi

# get resolvers from dhcp-server for mac os
resolv-dhcp () {
	sudo networksetup -setdnsservers Wi-Fi empty
	sudo networksetup -setdhcp Wi-Fi
}

# git
git-commit-and-push-all () {
	git add -A :/ && git commit -a && git push
}
git-pull-push () {
	git pull && git push
}
git-tag () {
	git tag -a "$1" -m "$1 release" && git push origin $1
}

# ssh logins and fit in tmux
set_window_title () {
	if git rev-parse --git-dir &> /dev/null; then
		repo_name=$(basename $(git rev-parse --show-toplevel))
		name_chars=`echo $repo_name|wc -m`
		if test $name_chars -gt 15; then
			suff="..."
		else
			suff=""
		fi
		prompt_t=`echo ${repo_name} | cut -c 1-15`
		prompt=${prompt_t}${suff}
	else
		prompt=`hostname -s`
	fi
	echo -ne "\033k${prompt}\033\\"
}

if [ $TERM = "screen" ]; then
	export PROMPT_COMMAND=set_window_title
fi

sshs () {
	set_window_title $1
	ssh -o 'StrictHostKeyChecking no' $1
}
ssha () {
	set_window_title $1
	ssh -A -o 'StrictHostKeyChecking no' $1
}
