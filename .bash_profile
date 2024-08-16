# use symlink .bashrc -> .bash_profile for any sessions-type
# main env
export PATH=$PATH:$HOME/bin
export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export GREP_OPTIONS="--color=auto"
export EDITOR="vim"
export BASH_SILENCE_DEPRECATION_WARNING=1
if [ $TERM = "tmux-256color" -o $TERM = "tmux" ]; then
	export TERM="screen"
fi
unix_profiles_dir="${HOME}/git/unix-profiles"

# git
unset -f git-commit-and-push-all
git-commit-all-and-push () {
	git add -A :/ && git commit -a && git push
}
git-commit-all () {
	git add -A :/ && git commit -a
}
git-pull-push () {
	git pull && git push
}
git-tag () {
	git tag -a "$1" -m "$1 release" && git push origin $1
}
git_ps1 () {
	git rev-parse --git-dir &> /dev/null
	retval=$?
	output=""
	if test $retval -eq 0; then
		repo_name=$(basename $(git rev-parse --show-toplevel))
		branch=$(git rev-parse --abbrev-ref HEAD)
		changes=$(git status -s | wc -l | xargs)
		output=" (${repo_name}:${branch}:${changes})"
	fi
	echo "$output"
}
date_ps1 () {
	echo "$(date +%c)"
}
git_completion_file="${unix_profiles_dir}/git-completion.bash"
if test -f "$git_completion_file"; then
	source "$git_completion_file"
fi

# bash promt
export PS1='\[\033[0;32m\]\u\[\033[1;37m\]@\[\033[0;32m\]\h$(git_ps1) \W\n$(date_ps1) \$\[\033[00m\] '

# aliases
unalias -a
## common
alias bim="vim"
alias screen="screen -h 10000"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
## tmux
alias tmux="tmux -2 -u"
alias ssx="tmux attach -d -t"
alias ssn="tmux new -s"
alias sss="tmux list-sessions"
alias bashprofileup="source ~/.bash_profile"
tmux_send_command_to_every_pane() {
	for pane in $(tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}'); do
		tmux send-keys -t $pane "$@" C-m
	done
	unset pane
}

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

# get resolvers from dhcp-server for mac os
resolv-dhcp () {
	sudo networksetup -setdnsservers Wi-Fi empty
	sudo networksetup -setdhcp Wi-Fi
}

# ssh logins and fit in tmux
set_window_title () {
	git rev-parse --git-dir &> /dev/null
	retval=$?
	if test $retval -eq 0; then
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
	if test ! -z $1; then
		prompt=`echo $1 | awk -F '.' '{print $1}'`
	fi
	echo -ne "\033k${prompt}\033\\"
}

if [ $TERM = "screen" -o $TERM = "tmux-256color" -o $TERM = "tmux" ]; then
	export PROMPT_COMMAND=set_window_title
fi

sshs () {
	set_window_title $1
	ssh $1
	set_window_title
}
ssha () {
	set_window_title $1
	ssh -A $1
	set_window_title
}
