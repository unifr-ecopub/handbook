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

**Only you do.** If a window opens to sign in to GitHub, sign in with your GitHub account. If the pull or the push fails for want of a sign-in, press **Pull** or **Push** in GitHub Desktop, which shows the commit.

**Check.** Claude says what its pull brought and that the commit is pushed. On github.com, `data-processing` shows your commit.

**What can go wrong.**

- Someone pushed first: Claude pulls, says what came, and pushes again.
- A conflict: Claude shows both versions of each file and changes nothing until you choose. Until the merge is finished, it runs no build and no release.
- A pull that git refuses because of changes not yet committed: Claude stops, lists those files and discards nothing. The commit is made, stays on this machine and is not pushed.
- A pull that brought commits while a candidate waits: Claude says whether they touch the code that makes that dataset. If they do, Claude says that its build must be run again before a release, and runs it when you ask.

## Run the tests before a push that changed code

If the files to commit, the commits not yet pushed, or what a pull or a merge brought touch `code/`, `ado/` or `tests/`, Claude runs [the repo's tests](test-a-changed-chair-program.md) and gives the count before it pushes. If one fails, nothing is pushed.
