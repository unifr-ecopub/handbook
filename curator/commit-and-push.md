# Commit and push as the data curator

In every repo, `data-processing` too, Claude commits and pushes when you ask "Commit and push.", and never on its own. It asks before `release.do`. Scientific choices are yours, or the build author's, and Claude writes them into the build's `decisions.md`.

**Untested on Windows.** Until Claude's git works there, [GitHub Desktop's buttons](../researcher/fix-a-rejected-push-or-a-conflict.md#if-claude-cannot-use-git-on-your-machine) stand in: Claude names the files and the summary to type.

## Commit and push data-processing

Claude ends each task that changed a file with the files and a summary of one line.

**Ask Claude.** In `data-processing`:

```prompt
Commit and push.
```

**Claude will ask you.** For your yes, if the list of changed files holds one that Claude did not name to you. A file you say to leave out stays out.

**Only you do.** If a window opens to sign in to GitHub, sign in with your GitHub account. If the pull or the push fails because you are not signed in, press **Pull** or **Push** in GitHub Desktop, which shows the commit.

**Check.** Claude says what its pull brought and that the commit is pushed. On github.com, `data-processing` shows your commit.

**What can go wrong.**

- Someone pushed first: Claude pulls, says what came, and pushes again.
- A conflict: Claude shows both versions of each file and changes nothing until you choose. Until the merge is finished, it runs no build and no release.
- A pull that git refuses because of changes not yet committed: Claude stops, lists those files and discards nothing. Claude still makes the commit on this machine and does not push it.
- A pull that brought commits while a candidate waits: Claude says whether they touch the code that makes that dataset. If they do, Claude says that its build must be run again before a release, and runs it when you ask.

## A commit you did not make

GitHub adds a commit of its own to `data-processing` when [the pages of the data map](../data/data-map.md#the-map-as-pages) change. It rebuilds the pages after a push that changes `datamap.csv`, or a build's `README.md` or `decisions.md`. Where the pages differ, it commits them to `main` as `github-actions[bot]`, with the message `Rebuild docs from the data map`.

Your next pull can bring that commit. GitHub can also reject a push you make before pulling: Claude then pulls, says what came, and pushes again, as above. The commit changes only the pages in `docs/`, which make no dataset, so no build needs to run again.

## Run the tests before a push that changed code

Whenever files to commit, unpushed commits, or changes from a pull or merge touch `code/`, `ado/` or `tests/`, Claude runs [the repo's tests](test-a-changed-chair-program.md) and gives the count. Claude runs them before committing local changes, and again before pushing after a pull or merge that brought such changes. If a test fails before the commit, Claude commits nothing; if one fails after, Claude pushes nothing.
