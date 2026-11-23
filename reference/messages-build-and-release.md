# Messages of a build, a release and the tests

The messages that a build, a review round and a release print, and who acts after each. `<…>` marks a part that varies. Claude reports these lines.

## How a build ends

```text
Run complete at commit <commit>. Staged in the data root's intermediate/<dataset>/ with staged.txt, <date>: the candidate for release, by release.do in code/ beside builds/.
```

A full run of the build finished on the data curator's machine, and a candidate waits.

```text
Run complete at commit <commit>. Not staged: only the curator's machine, which can write the data root's processed/, stages; the finished files are in this build's temp/.
```

A full run of the build finished on another machine. **The build author:** commit and push.

```text
Withdrew the candidate that was waiting in the data root's intermediate/<dataset>/: the files its staged.txt listed, and staged.txt. This run stages a new one when it ends with 'Run complete'; until then nothing is staged for <dataset>.
```

A data curator's build started. If it fails now, no candidate is left.

A failed step and a single step print the same lines as in [a project run](messages-project-run.md#how-a-run-ends).

## Before a build runs

A build checks the data root and the pins [as a project does](messages-project-run.md#before-anything-runs-the-machine-checks).

```text
Failed: intermediate/<dataset>/<file>.dta in the data root is not a file of the candidate: no staged.txt there lists it. This build makes a file of that name, so nothing was run and nothing was staged. A hand-made table needs another name: rename it or move it away, and run the whole build again (r(602))
```

Claude deletes nothing. **The data curator:** rename the file or move it away.

## A review round

```text
Wrote intermediate/<dataset>/<dataset>-review-<n>.xlsx in the data root, with <n> cases: the assistant fills in decision (1, 0 or blank) and note there.
```

**The data curator:** tell the assistant.

```text
<n> rows of the sheets in <folder> hold a decision that is not 1, 0 or blank. The assistant corrects them in Excel; then run again.
<n> rows of the sheets in <folder> decide the same case differently (two sheets, a conflicted copy from Dropbox, or one case listed twice). The assistant settles them in Excel; then run again.
```

**The assistant:** correct the sheet in Excel. **The data curator:** ask for the build again.

A third stop names a sheet that lacks a column. The two lines of counts are quoted in [Run a review round](../curator/run-a-review-round.md#apply-the-filled-sheet).

## Stops of the boundary command

Each stop of `chair_boundary` is a choice for the build author. The answer goes into the build's `decisions.md`.

```text
chair_boundary: <n> number(s) are on no list of the register: <numbers>. Correct the source or the build; nothing was changed.
```

A wrong number, or a row that is no municipality. **The build author:** say which rows to drop.

```text
chair_boundary: numbers of different lists go to one number of <yyyy> for the same <variables> (<n> rows): <numbers> into <numbers>. The source lists a number beside its successor; keep the rows you mean (a decision of the build), then run chair_boundary again.
```

Both rows together would count one territory twice. **The build author:** say which rows to keep.

```text
chair_boundary: these numbers are split between several numbers on the list of <yyyy>, and split() gives no rule or weight: <numbers>. The FSO's list holds no weights; the build decides them (split(equal) or split(<file.dta>)).
```

"The FSO" is `<source>`, whose list the register follows. **The build author:** choose equal shares, or [make a table of shares](../curator/save-a-table-made-by-hand.md).

## A release

A release that worked ends with the two lines quoted in [Release a version](../curator/release-a-version.md#ask-claude-to-release-it). Every refusal ends `Nothing was released.`

```text
release.do: <dataset> v<N> is released and cannot be changed. Release the next number. Nothing was released.
```

**The data curator:** ask for the release of the next number. Do not ask for a build: it would replace a candidate that waits.

```text
release.do: nothing is staged for <dataset>: <folder>/ holds no staged.txt. Run the build's master.do on the curator's machine: a full run stages its files there. Nothing was released.
```

**The data curator:** ask for the build, then for the release.

```text
release.do: the map's row for <dataset>/<file> does not name its <fields> (blank, or unknown): a release needs the key, the boundary year (none for a file without municipality numbers) and the terms of use. Nothing was released.
```

**The data curator:** give Claude the missing fields, commit, and ask for the build again.

```text
release.do: <key> does not identify the rows of <dataset>/<file>, or is missing in some. Nothing was released.
release.do: <n> numbers of <dataset>/<file> are not in the register (v<N>) at boundary year <yyyy>. Nothing was released.
release.do: <dataset>/<file> is <yyyy>, own territory in the map but has no variable own_territory (chair_boundary, own() writes it). Nothing was released.
```

The fault is in the build. **The build author:** correct the step with Claude.

The tests end with a line of counts, quoted in [Test and copy a changed chair program](../curator/test-a-changed-chair-program.md).
