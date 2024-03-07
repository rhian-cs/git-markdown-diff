#!/bin/bash

# This scripts creates a sample git repository for the purposes
# of manual testing.
#
# This script is NOT idempotent.

mkdir -p tmp/sample_repo

cd tmp/sample_repo

git init

git config user.email "git-user@example.org"
git config user.name "git-user"

cat > file1.txt <<EOL
line 1, Here's the next
line 2,
line 3, thing
EOL

git add .
git commit -m "Add file1.txt"

cat > file1.txt <<EOL
line 1, Here's the next
line 2, BIG
line 3, thing
EOL

git add .
git commit -m "Update file1.txt"

cat > file1.txt <<EOL
line 1, Here's the next
line 2, BIG
line 4, thing
EOL

git add .
git commit -m "Add line 4 to file1.txt"

echo "Script has completed running."
