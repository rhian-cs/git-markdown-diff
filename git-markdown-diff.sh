#!/bin/bash

function git_log_full_hash() {
  git log --format="format:%H" --reverse
}

COMMIT_HASHES=`git_log_full_hash`
FIRST_COMMIT_HASH=`git_log_full_hash | head -n1`
EMPTY_TREE_HASH="4b825dc642cb6eb9a060e54bf8d69288fbee4904"

for COMMIT_HASH in $COMMIT_HASHES; do
  # Show content as header
  git show "${COMMIT_HASH}" --format="format:[%h] <strong>%B</strong>" -s
  echo

  MODIFIED_FILEPATHS=`git show "${COMMIT_HASH}" --name-only --format=format:`

  for FILEPATH in $MODIFIED_FILEPATHS; do
    echo
    echo "$FILEPATH:"
    echo

    # Get the relevant diff contents
    if [[ $COMMIT_HASH == $FIRST_COMMIT_HASH ]]; then
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
