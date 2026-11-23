# Save a table made by hand for a build

A build may read a table that a person made, such as a crosswalk or the shares for a divided municipality.

**Ask Claude.** In `data-processing`:

```text
Where do I put a table I made by hand?
```

Claude names the folder and gives you the header line to type. It asks which build will read the table, if you did not say.

**Only you do.** Claude never writes, changes, moves or deletes such a table.

- Save it in `intermediate/<dataset>/` in the data root, never in `raw/` or in a repo.
- Save it as `.csv` or `.dta`. A build takes each `.xlsx` in that folder for a review sheet.
- Give it a short name of its own, in lower case. It may not have the name of a file that the build makes.

A table of shares has four columns: `gdenr`, `from_year`, `to_gdenr` and `share`. The shares of one number in one year add up to 1.

**What can go wrong.** The table has neither a version nor a pin. If it changes, the next build's result changes with no error.
