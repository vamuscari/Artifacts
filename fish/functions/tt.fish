function tt --wraps='tmux new-session -A -s Home -c ~' --description 'alias tt=tmux new-session -A -s Home -c ~'
  tmux new-session -A -s Home -c ~ $argv
        
end
