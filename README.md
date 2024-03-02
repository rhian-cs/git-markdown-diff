## Git Markdown Diff

Create a markdown file representing the iterations over each file, embedding the `diff` of each file for every commit.

Use the `git-markdown-diff.sh` script in any git repository.

By default the output goes to stdout, you may want to redirect it to a `.md` file for convenience.

```sh
/path/to/git-markdown-diff.sh > tutorial.md
```

## Development

Use the following script to create a sample git repository:

```sh
./create-sample-git-repo.sh
```
