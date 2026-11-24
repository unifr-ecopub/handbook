# Save a table made by hand for a build

A build may read a table that a person made, such as a lookup table or figures typed from a printed source.

**Ask Claude.** In `data-processing`:

```prompt
Where do I put a table I made by hand?
```

Claude names the folder and gives you the header line to type.

**Claude will ask you.** Which build will read the table, if you did not say. If no step reads such a table yet, its columns: Claude proposes none.

**Only you do.** Make the table. Claude never changes its content.

- Save it as `.csv` or `.dta`. A build takes each `.xlsx` in `intermediate/<dataset>/` for a review sheet.
- Give it a short name of its own, in lower case. It may not have the name of a file that the build makes.

Claude copies it into `intermediate/<dataset>/` in the data root when you ask, never into `raw/` or a repo. It replaces a file of the same name only on your yes for that file.

**What can go wrong.** The table has neither a version nor a pin. If it changes, the next build's result changes with no error.
