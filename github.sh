#!/bin/bash

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
  (umask 077; ssh-agent >| "$env")
  . "$env" >| /dev/null ;
}

github () {
  env=~/.ssh/agent.env

  agent_load_env
  # agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2=agent not running
  agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

  if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    echo "Establishing SHH connection to GitHub..."
    agent_start
    ssh-add ~/.ssh/github_rsa
  elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    echo "Establishing SHH connection to GitHub..."
    ssh-add ~/.ssh/github_rsa
  elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 0 ]; then
    echo "Reusing an existing SHH connection to GitHub..."
  fi

  unset env
}
