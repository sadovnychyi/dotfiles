# Lolcommits hook

Installs a `post-commit` hook with linked-worktree support. Captures are
synchronous for non-interactive callers and retain the configured lolcommits
behavior in a terminal.

From this checkout, run:

```sh
lolcommits/install
```

Or provide a repository path:

```sh
lolcommits/install /path/to/repository
```

The installer follows Git's shared hooks path, so installing from the primary
checkout or any linked worktree has the same result. Existing hook content is
preserved; reinstalling replaces only the managed lolcommits block.
