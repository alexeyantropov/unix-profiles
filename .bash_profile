# use symlink .bashrc -> .bash_profile for any sessions-type
# main env
export PATH=$PATH:$HOME/bin
export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export GREP_OPTIONS="--color=auto"
export EDITOR="vim"

# bash promt
if [ `whoami` = 'root' ]; then
	export PS1='\[\033[1;31m\]\u@\h \w \$\[\033[00m\] '
else
	export PS1='\[\033[1;32m\]\u@\h \w \$\[\033[00m\] '
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
if [ $TERM = "screen" ]; then
	export PROMPT_COMMAND='echo -ne "\033k`hostname -s`\033\\"'
fi

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

# ssh logins
host_short_name () {
	echo $1 | awk -F '.' '{print $1}'
}
set_window_title () {
	echo -ne "\033k`host_short_name $1`\033\\"
}
sshs () {
	set_window_title $1
	ssh -o 'StrictHostKeyChecking no' $1
}
ssha () {
	set_window_title $1
	ssh -A -o 'StrictHostKeyChecking no' $1
}

