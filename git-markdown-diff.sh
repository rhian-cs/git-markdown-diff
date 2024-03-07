#!/bin/bash

####                      Usage                     ####
#
#  git markdown-diff {{start_commit}} {{end commit}}
#
#  Examples:
#    git markdown-diff
#    git markdown-diff 4af405e
#    git markdown-diff 4af405e 610ecbc
#
########################################################


####     Validate if Git Works     ####
git status > /dev/null
if [[ "$?" != "0" ]]; then
  echo "Git command did not succeed. Script cannot proceed."
  exit 1
fi
#######################################

####         Configuration         ####
function git_log_full_hash() {
  git log --format="format:%H" --reverse $@
}

EMPTY_TREE_HASH="4b825dc642cb6eb9a060e54bf8d69288fbee4904"
FIRST_COMMIT_EVER_HASH=`git_log_full_hash | head -n1`
#######################################

#### Parse CLI Arguments and create range ####
START_RANGE="$1"
END_RANGE="$2"

SELECTED_COMMIT_HASHES=`git_log_full_hash`

FILTERED_COMMIT_HASHES=""
if [[ $START_RANGE == "" ]]; then
  ACCEPT_NEW_ENTRIES=true
else
  ACCEPT_NEW_ENTRIES=false
fi

for COMMIT_HASH in $SELECTED_COMMIT_HASHES; do
  if [[ $START_RANGE != "" && "$COMMIT_HASH" == "$START_RANGE"* ]]; then
    ACCEPT_NEW_ENTRIES=true
  fi

  if [ $ACCEPT_NEW_ENTRIES = true ]; then
    FILTERED_COMMIT_HASHES="$FILTERED_COMMIT_HASHES $COMMIT_HASH"
  fi

  if [[ $END_RANGE != "" && "$COMMIT_HASH" == "$END_RANGE"* ]]; then
    ACCEPT_NEW_ENTRIES=false
  fi
done
#######################################

#### Iterate over selected commits ####
for COMMIT_HASH in $FILTERED_COMMIT_HASHES; do
  # Show content as header
  git show "${COMMIT_HASH}" --format="format:[%h] <strong>%B</strong>" -s
  echo

  MODIFIED_FILEPATHS=`git show "${COMMIT_HASH}" --name-only --format=format:`

  for FILEPATH in $MODIFIED_FILEPATHS; do
    echo
    echo "$FILEPATH:"
    echo

    # Get the relevant diff contents
    if [[ $COMMIT_HASH == $FIRST_COMMIT_EVER_HASH ]]; then
      DIFF_CONTENTS=`git diff --no-prefix $EMPTY_TREE_HASH..$COMMIT_HASH -- $FILEPATH`
      # Remove first FIVE lines and output
      DIFF_CONTENTS=`echo "$DIFF_CONTENTS" | tail -n +6`
    else
      DIFF_CONTENTS=`git diff --no-prefix $COMMIT_HASH^1..$COMMIT_HASH -- $FILEPATH`
      # Remove first FOUR lines and output
      DIFF_CONTENTS=`echo "$DIFF_CONTENTS" | tail -n +5`
    fi

    echo '```diff'
    echo "$DIFF_CONTENTS"
    echo '```'
    echo
  done
done
