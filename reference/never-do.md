# What never to do

## Where files go

1. **Never clone into Dropbox, OneDrive or any folder that syncs.** A sync changes files while Stata and git use them.
2. **Never name a folder `data` inside a project.** `master.do` takes it for the data root.
3. **Never copy data into a project.** Data stays out of git.
4. **Never save a file by hand into `temp/`.** A full run deletes everything there.
5. **Never put a table made by hand into `raw/` or into a repo.** It belongs in `intermediate/`.

## How code runs

6. **Never run a file through Stata's menu.** **File › Open** runs it in Stata's current folder, which may be another project's. With two copies of one project on your machine, close Stata first, then double-click the `master.do` you mean.
7. **Never type a path into code.** A typed path works on one machine only.
8. **Never edit `code/pins.do` during a run.** With R steps, the run then mixes two versions, with no error.
9. **Never edit `code/_config.R`.** It must stay the same in every project.

## Results

10. **Never edit an exhibit by hand.** The paper must show what the code made.
11. **Never export an exhibit with `replace`.** One result then replaces another unseen.

## Git

12. **Never make a branch.** Each repo has one line of history, `main`.
13. **Never commit data, `temp/` or `logs/`.** The ignore rules keep them out.

## Shared data

14. **Never change a file in `raw/` or `processed/`.** A correction is a cleaning step, or the next version.
15. **Never rename or remove a column of a review sheet.** The build stops on a sheet that lacks one.
