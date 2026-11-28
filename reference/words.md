# Words

Each thing on the platform has one name.

| Word | Meaning |
|---|---|
| Repo | One project's code on GitHub, with its history. |
| Template | `project-template`, the repo that starts every project. |
| Clone | Your copy of a repo on your machine. |
| Pull | Bring in what others pushed. |
| Commit | Record the changed files, with a summary. |
| Push | Send your commits to GitHub. |
| `master.do` | The one file that runs a project or a build. |
| Step | One `.do`, `.R` or `.py` file that `master.do` runs. |
| Helper | A file of `code/helpers/` that holds what several steps share. A step pulls it in; it is never run on its own. |
| Full run | A run of every step, from empty working files. |
| Working files | What a step saves in `temp/` for a later step. |
| Explore file | A file that looks at data and changes no result. |
| Exhibit | A table, a figure or a number that code writes for the paper. |
| Data flow page | `code/README.md`: what the last full run read, saved, merged and appended, with keys and counts. |
| D-number | The number of a choice in `decisions.md`. |
| Data root | The folder of shared data on Dropbox, `chair-research-data`. |
| Delivery | A source's files as received. |
| Build | The code that makes a dataset, a cleaned and shared set of files. |
| Candidate | A build's finished files, before a release. |
| Version | A released copy of a dataset, `v<N>`. It never changes. |
| Pin | A line of `code/pins.do` that names the version, delivery or, provisionally, old-folder input to read. |
| Data map | `datamap.csv`, which describes each source and each file. |
| Table made by hand | A table that a person made and code cannot rebuild. |
| Review sheet | The Excel file in which an assistant decides cases. |
| Data curator | Who adds deliveries, releases versions, marks a version that is wrong, assembles replication packages, and looks after the shared repos. Messages and Claude say "curator" for short. |
| Assistant | Who fills review sheets. |
| Build author | Who writes a build and decides its choices. |
