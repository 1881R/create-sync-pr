#!/bin/sh
# e is for exiting the script automatically if a command fails, u is for exiting if a variable is not set
# x would be for showing the commands before they are executed
set -eu

# FUNCTIONS
# Function for setting up git env in the docker container (copied from https://github.com/stefanzweifel/git-auto-commit-action/blob/master/entrypoint.sh)
_git_setup ( ) {
    cat <<- EOF > $HOME/.netrc
      machine github.com
      login $GITHUB_ACTOR
      password $GITHUB_TOKEN
      machine api.github.com
      login $GITHUB_ACTOR
      password $GITHUB_TOKEN
EOF
    chmod 600 $HOME/.netrc

    git config --global user.email "actions@github.com"
    git config --global user.name "GitHub Action"

echo $BRANCHES

SAVEIFS=$IFS   # Save current IFS
IFS=$'\n'      # Change IFS to new line
branchlist=($BRANCHES) # split to array $names
IFS=$SAVEIFS   # Restore IFS

for (( i=0; i<${#branchlist[@]}; i++ ))
do
    echo "$i: ${names[$i]}"
    git checkout ${names[$i]}
    git merge master
done