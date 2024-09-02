function start_pipenv
  if test -n "$PROJECT_DIR" && test -f "$PROJECT_DIR/Pipfile" && not test -n "$PIPENV_ACTIVE" 
    command pipenv shell
  end 
end 

