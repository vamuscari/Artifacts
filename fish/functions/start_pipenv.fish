function start_pipenv
  if $PROJECT_DIR && -n $PIPENV_ACTIVE && -f $PROJECT_DIR/Pipfile
      echo $PIPENV_ACTIVE
  end 
end



#if [[ $PROJECT_DIR ]]; then
    # cd $PROJECT_DIR
		# If noe current pipenv running check for one the run it.
    #    if [ ! -n "${PIPENV_ACTIVE+1}" ]; then
    #		if [[ -f $PROJECT_DIR/Pipfile ]]; then
    #					pipenv shell --quiet
    #		fi
    #fi
    #fi

