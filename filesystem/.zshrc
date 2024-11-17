
# Both pipenv and anuglar cli need this for auto comp
autoload -Uz compinit
compinit

# starts to get annoying after awhile
# if [[ -o interactive ]]; then
#     fastfetch -c ~/.config/fastfetch/config.jsonc
# fi


# Check for $PROJECT_IR that is declared on sessionizer
if [[ $TSX_PROJECT_DIR ]]; then
    # cd $PROJECT_DIR
		# If noe current pipenv running check for one the run it.
    if [ ! -n "${PIPENV_ACTIVE+1}" ]; then
				if [[ -f $TSX_PROJECT_DIR/Pipfile ]]; then
							pipenv shell --quiet
				fi
    fi
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export CLICOLOR=1

alias ls='ls -G'
alias ll='ls -lG'

# Tmux Alias
alias tt='tmux new-session -A -s Home -c ~'



# adding color to man
export MANCOLOR=true

# nvimpager call. $ nman tmux
nman() { exec man $1 | nvimpager }
# alias man='nman'

alias :q='exit'
alias vim='nvim'
PATH="/usr/local/bin:$PATH"
PATH="/opt/homebrew/bin:$PATH"


# zsh syntax zsh-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh theme powerlevel10k
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# Set up fzf key bindings and fuzzy completion
# source "$(fzf --zsh)"
# export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# alias keys="sudo ssh-add --apple-load-keychain"
# Load Apple Keys

# Server Conncetion
# alias exampleServer="ssh user@192.168.1.1 -i ~/.ssh/exampleServerKey -t tmux a"

# Created by `pipx` on 2024-06-23 01:09:18
# export PATH="$PATH:/Users/vamuscari/.local/bin"

# For finding mason installs 
# export MASON="$HOME/.local/share/nvim/mason"

# Add quarto to the path
# if [[ -d /Users/vamuscari/Applications/quarto/bin ]]; then
#   export PATH="/Users/vamuscari/Applications/quarto/bin:$PATH"
# fi

# pipenv completion
# eval "$(_PIPENV_COMPLETE=zsh_source pipenv)"
#
# PATH="/Users/vamuscari/perl5/bin${PATH:+:${PATH}}"; export PATH;
# PERL5LIB="/Users/vamuscari/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
# PERL_LOCAL_LIB_ROOT="/Users/vamuscari/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
# PERL_MB_OPT="--install_base \"/Users/vamuscari/perl5\""; export PERL_MB_OPT;
# PERL_MM_OPT="INSTALL_BASE=/Users/vamuscari/perl5"; export PERL_MM_OPT;

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
