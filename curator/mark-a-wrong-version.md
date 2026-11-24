# Mark a version that is wrong

A released version is never changed or deleted, so that work that used it can still be reproduced. If a version is wrong, its line in the table of versions in the build's `README.md` says so, and names the version to use instead.

**Ask Claude.** In `data-processing`:

```prompt
v<N> of <dataset> is wrong.
```

"Withdraw v<N> of <dataset>." asks the same. Claude first checks that `v<N>` is a released version of `<dataset>` in the data root. If it is not, Claude says so and does nothing more.

**Claude will ask you.** What is wrong with the version, and which version to use instead. If the corrected version is not released yet, Claude builds and [releases](release-a-version.md) it when you ask.

**Check.** Claude writes your words on the version's line in the table of `builds/<dataset>/README.md`: that it is not to be used, why, and which version to use instead. It shows you the line, and commits and pushes it when you ask. Nothing is written into the version's folder in the data root, and the version loads as before.

**Only you do.** Tell the chair: the researchers who read the dataset.

**What can go wrong.** A project that pins the wrong version gets no warning when it loads it. Its authors learn of it from you, or from the build's `README.md`.
