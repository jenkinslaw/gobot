#!/bin/bash
# Synopsis:
# gobot [<command>]

command=''

setSourceDirgobotry()
{
  scriptPath=$(which $0)

  if [ -L $scriptPath ]; then
    DIR=$(dirname $(readlink -f $scriptPath))
  else
    DIR=$(dirname $scriptPath)
  fi
}

# Help.
synopsis()
{
  echo ''
  echo 'Synopsis:'
  echo '---------'
  echo 'gobot --help        Show this synopsis.'
  echo 'gobot [<command>]   The basic signature for the gobot command.'
  echo ''
  echo  Commands:
  echo '---------'
  echo 'add-restart-event   Adds 'Live Site Server Restarted' event to IT Events Calendar.'
  echo ''
  echo ''
}


setSourceDirgobotry

# At least one argument must be passed to to gobot.
if [ $# -lt 1 ]
then
  echo "You must provided a command argument."
  synopsis
  exit 64
fi

# View the help.
if [ $1 = '--help' -o $1 = '-h' -o $1 = '-help' ]
then
  synopsis
  exit 64
fi


# Set up command.
if [ $1 = 'add-restart-event' ]
then
  command="add_restart_event"
elif [ $1 = 'selftest' ]
then
  command='selftest'
else
  echo "You must provide a command."
  synopsis
  exit 64
fi


# Run command.
if [ $1 = "selftest" ]
then
  rake -f $DIR/../Rakefile
else
  rake -f $DIR/../Rakefile $command
fi

