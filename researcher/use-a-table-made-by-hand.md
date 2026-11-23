# Use a table you made by hand in a project

Some tables are read by a step and cannot be rebuilt by code: a crosswalk, or figures typed from a printed source. Such a table lives in the data root, in `intermediate/<project>/`, and never in `raw/` or in the repo.

**Ask Claude.** In the project, name the file, its folder, and the step that should read it.

**Claude will ask you.** For your yes to a copy into `intermediate/<project>/`. Claude then copies the file and compares the two. Your original stays in its place, and Claude never replaces a file of that name.

**Check.** Claude tells you the copy's place. The step reads the table from there.

**Only you do.** If Claude cannot write the folder, it says what failed. Then copy the file yourself in Explorer. If that fails too, ask the curator.

Claude never edits the table. Change it yourself, in the copy.

**What can go wrong.** The table has neither a version nor a pin. If it changes, the next run's results change with no error.
