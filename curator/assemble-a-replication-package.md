# Assemble a replication package

A journal asks for one folder, `<project>-replication/`: the project, the code that made each shared dataset it reads, and the data that may be shared. A replicator runs it from its `README.md` alone, without Claude.

Before you ask, the project's commit with the paper's results must be pushed. What may be shared, and the licences, are the authors' to say.

## Ask Claude

**Ask Claude.** In `data-processing`:

```text
Assemble the replication package for <project>.
```

Claude looks for the project's clone beside your clone of `data-processing`, and asks for its folder if it finds none.

**Claude will ask you.** Everything at once, so that you can pass the message to the authors.

- Is the commit it found the one with the paper's results?
- Which new folder, outside every clone and every synced folder, takes the package?
- May the package share each delivery, each version and each table made by hand? If not, who grants access?
- The paper's title, its label for each exhibit, and the licences for the data and the code.
- Two statements about rights: may the authors use the data, and may they pass it on?
- Which statement fits: all data, some data, or no data can be made publicly available.

## Read the report

**Check.** Claude tests a copy of the package from its `README.md` alone. Its report names:

- each version as `shipped`, or as `rebuild` if the package makes it again from its inputs
- the last line of each test run, and whether every file in `paper/results/` came out the same
- each placeholder that an unanswered question left for the authors

## Before you send it

A package holds no `CLAUDE.md` and no `.claude/` folder. Claude still copies them today, because it copies the project as it was committed. Until Claude leaves them out, you remove them.

**Only you do.** In the package folder:

- Look through `data/` for anything that the authors refused.
- Delete every `CLAUDE.md` file and every `.claude/` folder, at any depth. Then check that none is left.

After you send the package, delete the working folder, `<project>-work/`: it may hold inputs that the package omits.

**What can go wrong.**

- Claude stops if the package needs two versions of one dataset and may not ship both.
- A table made by hand is shipped as it is today, which may differ from what the release read.
- **Untested on Windows.** The test runs Stata in batch mode, and a project with R steps needs Stata's window there.
