## Git Markdown Diff

It will output markdown representing the iterations over each file, embedding the `diff` of each file for every commit.

Use the `git-markdown-diff.sh` script in any git directory. You may want to redirect the output to a `.md` file for convenience.

```sh
/path/to/git-markdown-diff.sh > tutorial.md
```

## Development

Use the following script to create a sample git repository:

```sh
./create-sample-git-repo.sh
```
