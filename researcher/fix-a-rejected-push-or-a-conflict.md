# Fix a rejected push or a conflict

Both mean that someone pushed to the project before you.

## A rejected push

**Ask Claude.** In the project:

```prompt
My push was rejected.
```

Claude pulls and says what came. If code, versions or results came, it runs everything, names each file the run rewrote, and commits those files too. Then it pushes again, once. If GitHub refuses again, Claude tells you git's words.

## A conflict

A conflict means that you and a colleague changed the same lines.

**Ask Claude.**

```prompt
There is a conflict.
```

For each file, Claude shows both versions in plain words.

**Claude will ask you.** Which version to keep, if the difference is a scientific choice. Otherwise it proposes what to keep and waits for your yes.

Claude then finishes the merge. If code, versions or results were in conflict, it runs everything and names what the run rewrote. It commits the merge and says so.

Claude pushes only if your original request included a push (such as "Commit and push."); otherwise ask "Push." Nobody merges an exhibit by hand: the full run makes it afresh.

**Check.** Any full run ended `Run complete`, and Claude says that it committed the merge, and that it is pushed if you asked for a push. On Windows, with R or Python steps, [you start each run yourself](work-with-r-steps.md#run-the-project-on-windows).

## If Claude cannot use git on your machine

**Untested on Windows.** Claude needs [Git for Windows](../start/set-up-your-machine.md#install-the-programs-and-sign-in), and your sign-in to GitHub at the first push. Until both work, use GitHub Desktop's buttons: Claude names the files and the summary to type.
