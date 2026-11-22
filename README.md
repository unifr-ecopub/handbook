# handbook

The guides to the chair's research platform, and the tests of `project-template`. Code is on
GitHub and data on Dropbox; you work with Stata, GitHub Desktop and Claude Code. This repo holds
no data.

## The guides

- [Researcher's guide](guides/researcher.md): for every researcher. Setting up a machine, the
  daily routine, and what never to do. A draft, to be tried at a first session with a researcher.
- [Curator's guide](guides/curator.md): for the curator. Deliveries, builds, review rounds,
  releases, replication packages, new project repos and people on github.com.
- [Data guide](guides/data.md): for anyone who reads the shared data. Raw, processed, versions,
  pins and the data map.
- [Claude guide](guides/claude.md): for anyone new to working with Claude. What Claude does and
  does not do, and how to ask it.

## The template's tests

For the curator. `tests/` holds the tests of `project-template`, which sits in the folder beside
this repo. To run them, open Claude Code on this repo and ask "Run the project-template tests."
Claude gives the counts of passed, failed and skipped cases. The R cases are skipped where R at the
minor version the template's `renv.lock` names is not found, where their one restore of the R
packages does not finish, and on Windows whenever Claude runs them. The
[curator's guide](guides/curator.md#change-a-chair-program-and-run-the-tests) says more.
