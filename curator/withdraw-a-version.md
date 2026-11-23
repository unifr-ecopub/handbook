# Withdraw a version

A released version is never changed or deleted. If it is wrong, you withdraw it: a file in its folder gives the reason and names the version to use.

**Ask Claude.** In `data-processing`:

```prompt
Withdraw <dataset> v<N>.
```

**Claude will ask you.** For the fault, and for the version that replaces this one. It drafts the reason with you in a few plain sentences.

**Only you do.** Claude never writes under `processed/`.

1. Paste the reason into Notepad.
2. Choose **File › Save as**, and pick `processed/<dataset>/v<N>/` in the data root.
3. Name the file `WITHDRAWN`, with no ending, and set **Save as type** to **All Files**.

**Check.** Claude checks that the folder holds `WITHDRAWN`, not `WITHDRAWN.txt`. Each project that loads the version now sees this warning, then your reason:

```text
chair_use: warning: <dataset> v<N> is withdrawn. It still loads; the curator wrote:
```

The version loads as before, so a paper that used it can be reproduced. Nothing else announces a withdrawal: a researcher learns of it at the next run that loads the version.
