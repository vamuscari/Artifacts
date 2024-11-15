# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

# Check for $PROJECT_IR that is declared on sessionizer
if [[ $PROJECT_DIR ]]; then
    # cd $PROJECT_DIR
		# If noe current pipenv running check for one the run it.
    if [ ! -n "${PIPENV_ACTIVE+1}" ]; then
				if [[ -f $PROJECT_DIR/Pipfile ]]; then
							pipenv shell --quiet
				fi
    fi
fi

alias ls='ls -G --color=auto'
alias ll='ls -lG --color=auto'
alias ip='ip --color=auto'


# Tmux Alias
alias tt='tmux new-session -A -s Home -c ~'

alias :q='exit'
alias vim='nvim'

# Server Conncetion
# alias exampleServer="ssh user@192.168.1.1 -i ~/.ssh/exampleServerKey -t tmux a"

# For finding mason installs 
export MASON="$HOME/.local/share/nvim/mason"

# Neovim Appimage
export PATH="$PATH:/opt/nvim/"


export PATH="$PATH:/opt/mssql-tools18/bin"
