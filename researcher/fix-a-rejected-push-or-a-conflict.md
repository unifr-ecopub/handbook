# Fix a rejected push or a conflict

Both mean that someone pushed to the project before you.

## A rejected push

**Ask Claude.** In the project:

```text
My push was rejected.
```

Claude pulls and says what came. If code, versions or results came, it runs everything. Then it pushes again.

## A conflict

A conflict means that you and a colleague changed the same lines.

**Ask Claude.**

```text
There is a conflict.
```

For each file, Claude shows both versions in plain words.

**Claude will ask you.** Which version to keep, if the difference is a scientific choice. Otherwise it proposes what to keep and waits for your yes.

Claude then finishes the merge, runs everything if code, versions or results were in conflict, commits and pushes. Nobody merges an exhibit by hand: the full run makes it afresh.

**Check.** Any full run ended `Run complete`, and Claude says that it is pushed. On Windows, with R steps, [you start each run yourself](work-with-r-steps.md#run-the-project-on-windows).

## If Claude cannot use git on your machine

**Untested on Windows.** Claude needs Git for Windows, and your sign-in to GitHub at the first push. Until both work, use GitHub Desktop's buttons: Claude names the files and the summary to type.
