# Messages of a build, a release and the tests

The messages that a build, a review round and a release print, and who acts after each. `<…>` marks a part that varies. Claude reports these lines.

## How a build ends

```text
Run complete at commit <commit>. Staged in the data root's intermediate/<dataset>/ with staged.txt, <date>: the candidate for release, by release.do in code/ beside builds/.
```

A full run of the build finished on the data curator's machine, and a candidate waits. If it replaced one, the line ends with one more sentence:

```text
It replaced the candidate that was there; no review sheet or hand-made table was touched.
```

```text
Run complete at commit <commit>. Not staged: only the curator's machine, which can write the data root's processed/, stages; the finished files are in this build's temp/.
```

A full run of the build finished on another machine. **The build author:** ask Claude to commit and push.

```text
Withdrew the candidate that was waiting in the data root's intermediate/<dataset>/: the files its staged.txt listed, and staged.txt. This run stages a new one when it ends with 'Run complete'; until then nothing is staged for <dataset>.
```

A data curator's build started. If it fails now, no candidate is left.

```text
Failed: the code that makes <dataset> changed while this build ran: <what>. The files the run made may not be what the code as it stands makes, so nothing was staged. Once the code is as it should be, run the whole build again (r(459))
```

If a candidate was waiting, a sentence before the last one says that it was withdrawn when the run began, so nothing is staged. **The data curator:** once nothing else is changing the code, ask for the build again.

A failed step and a single step print the same lines as in [a project run](messages-project-run.md#how-a-run-ends).

## Before a build runs

A build stops with a project's sentences when [the data root was not found](messages-project-run.md#before-anything-runs-the-machine-checks) and when [a pinned raw delivery is not there](messages-project-run.md#the-pins). Unlike a project, a build has opened its dated log before these checks, so such a stop leaves one.

```text
Failed: intermediate/<dataset>/<file>.dta in the data root is not a file of the candidate: no staged.txt there lists it. This build makes a file of that name, so nothing was run and nothing was staged. A hand-made table needs another name: rename it or move it away, and run the whole build again (r(602))
```

Claude does not delete that file. **The data curator:** say whether Claude may rename the file or move it away; it does so only on your yes for that file.

## A review round

```text
Wrote intermediate/<dataset>/<dataset>-review-<n>.xlsx in the data root, with <n> cases: the assistant fills in decision (1, 0 or blank) and note there.
```

**The data curator:** tell the assistant.

```text
Wrote this build's logs/<dataset>-review-<n>.xlsx with <n> cases: this machine cannot write intermediate/<dataset>/ in the data root, so copy the file into that folder; the assistant fills in decision (1, 0 or blank) and note there.
```

**The data curator:** ask Claude to copy the sheet into `intermediate/<dataset>/`, then tell the assistant. Claude copies it if this machine can write that folder; if it cannot, Claude says so.

```text
<n> rows of the sheets in <folder> hold a decision that is not 1, 0 or blank. The assistant corrects them in Excel; then run again.
<n> rows of the sheets in <folder> decide the same case differently (two sheets, a conflicted copy from Dropbox, or one case listed twice). The assistant settles them in Excel; then run again.
```

**The assistant:** correct the sheet in Excel. **The data curator:** ask for the build again.

A third stop names a sheet that lacks a column. The two lines of counts are quoted in [Run a review round](../curator/run-a-review-round.md#apply-the-filled-sheet).

## A release

A release that worked ends with the two lines quoted in [Release a version](../curator/release-a-version.md#ask-claude-to-release-it). Between them, a line may say that the candidate could not be removed:

```text
The candidate could not be removed from <folder>/: <files> remain there. They belong to the candidate released as <dataset> v<N>: do not release them again. Close any program that has them open, then delete them from that folder; or leave them, and the next full build of <dataset> withdraws them.
```

The version is released. **The data curator:** ask Claude to delete those files, which it does only on your yes, or leave them for the next build.

Every refusal ends `Nothing was released.` A refusal that sends you back to the build says what to do, as this one does:

```text
release.do: the code that makes <dataset> is not what it was when the build ran, so the candidate may not be what that code makes. Since the build, a step or another file of builds/<dataset>/code/, a file of ado/, code/build.do, or the rows of <dataset> in datamap.csv or its first line was changed, added or removed; or the build ran with such a change and it was undone since. The logs Stata writes in builds/<dataset>/code/ and the folder builds/<dataset>/code/explore/ do not count; a log under ado/, and a folder named explore anywhere else, do. What to do: put right, or undo, what this sentence names; then run the build's master.do again; then commit and push whatever is not yet committed and pushed, exactly as it is then; then run release.do again. Nothing was released.
```

**The data curator:** ask for the build, then for a commit and push, then for the release.

```text
release.do: <dataset> v<N> is released and cannot be changed. Release the next number. Nothing was released.
```

**The data curator:** ask for the release of the next number. Do not ask for a build: it would replace a candidate that waits.

```text
release.do: nothing is staged for <dataset>: <folder>/ holds no staged.txt. A full run of the build's master.do on the data curator's machine stages its files there. What to do: put right, or undo, what this sentence names; then run the build's master.do again; then commit and push whatever is not yet committed and pushed, exactly as it is then; then run release.do again. Nothing was released.
```

**The data curator:** ask for the build, then for a commit and push of whatever is not yet committed and pushed, exactly as it is then, then for the release.

```text
release.do: the map's row for <dataset>/<file> does not name its <fields> (blank, or unknown): a release needs the key and the terms of use. Nothing was released.
```

**The data curator:** give Claude the missing fields. The dataset's rows in the map make the dataset, so ask for the build again, and for a commit and push, before the release.

```text
release.do: <key> does not identify the rows of <dataset>/<file>, or is missing in some. Nothing was released.
```

The fault is in the build. **The build author:** correct the step with Claude.

The tests end with a line of counts, quoted in [Test and copy a changed chair program](../curator/test-a-changed-chair-program.md).
