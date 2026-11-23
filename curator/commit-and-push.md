# Commit and push as the data curator

In a project, in `project-template` and in `handbook`, Claude commits and pushes when you ask "Commit and push." In `data-processing`, both are still yours, in GitHub Desktop.

**Untested on Windows.** Until Claude's git works there, [GitHub Desktop's buttons](../researcher/fix-a-rejected-push-or-a-conflict.md#if-claude-cannot-use-git-on-your-machine) stand in.

## Commit and push data-processing in GitHub Desktop

Claude ends each task that changed a file there with the files, a summary of one line, and the words "Commit and Push in GitHub Desktop".

**Only you do.** The button names follow GitHub's documentation.

1. Before Claude edits the data map, pull: click **Fetch origin**, and **Pull origin** when that button appears.
2. After Claude's task, look through the files under **Changes**.
3. Type Claude's summary into **Summary**.
4. Click **Commit to main**, then **Push origin**.

**Check.** On github.com, `data-processing` shows your commit.

If GitHub refuses the push, someone pushed first. Pull as in step 1, then click **Push origin** again. No rule of `data-processing` covers a conflict yet.

## Run the tests before a push that changed code

If `code/`, `ado/` or `tests/` changed, Claude runs [the repo's tests](test-a-changed-chair-program.md) and gives the count before it ends. Push only if none failed.
