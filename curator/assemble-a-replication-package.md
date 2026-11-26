# Assemble a replication package

A journal asks for one folder, `<project>-replication/`: the project, the code that made each shared dataset it reads, and the data that may be shared. A replicator runs it from its `README.md` alone, without Claude.

The authors decide what the package may share, the licences and the statements. The project's commit with the paper's results needs to reach GitHub before you send the package; Claude names any unpushed commit.

## Ask Claude to assemble it

**Ask Claude.** In `data-processing`:

```prompt
Assemble the replication package for <project>.
```

Claude looks for the project's clone beside your clone of `data-processing`, and one folder further down. A short question comes first only if it finds no clone or finds it twice, or if a version's commit is missing.

**Claude will ask you.** Everything in one message, so that you can pass it to the authors:

- Is the state it found the one with the paper's results?
- Which new folder, outside every clone and every synced folder, should receive the package?
- May the package share each delivery, each version, each version's decisions and each table made by hand? If not, who grants access, and how do replicators apply? And may Claude copy each input marked no into its test copy, for the test only?
- The paper's title, its label for each exhibit, and the licences for the data and the code.
- Where no log gave them, the Stata version and edition of the authors' run.
- Two statements about rights: may the authors use the data, and may they pass it on?
- Which statement fits: all data, some data, or no data can be made publicly available?
- Shall the package's `README.md` carry a line on AI use? The line names no tool. If the project's history does not name the AI tool and model, which ones did the authors use?
- Does the journal ask for anything beyond the standard `README.md` and folder?
- Whether to go on with the package as it stands when any provisional decision in the project's or a build's `decisions.md` is not yet under **Decided**: Claude lists each one and says that the checklist requires confirming or overturning every provisional decision before submission.
- May Claude bring `data-processing` up to date from GitHub, to see a version marked as wrong or a provisional decision confirmed since a release?

## Read the report

**Check.** Claude tests a copy of the package from its `README.md` alone. Its report names:

- before anything else, each version whose line in its build's `README.md` says it is not to be used. Claude still assembles the package with that version; moving to another version is the authors' decision before sending the paper;
- each version as `shipped`, or as `rebuild` if the package makes it again from its inputs;
- the last line of each test run, and whether every file in `paper/results/` came out the same;
- each placeholder that an unanswered question left for the authors;
- each file of the package in which the word Claude is left;
- each provisional decision of a build confirmed after the version's release (the dataset, its D-number and the date), because the package copies that build's `decisions.md` from the version's commit and does not show that confirmation;
- a draft of the paper's statement on AI use. Claude also saves this draft in the working folder, and in no file of the package. The authors decide its words and where it goes.

A package holds no `CLAUDE.md`, no `AGENTS.md` and no `.claude/`. In the package's copies, Claude also drops:

- the passages that name Claude at the top of `checklist.md` and `decisions.md`
- the comment at the top of `README.md`
- the lines of `.gitignore` and `.gitattributes` that name `.claude`, `CLAUDE.md` or `AGENTS.md`
- the words in each `decisions.md` that say who wrote a row down (a row under Provisional and a person's quoted words stay)

Claude names any other mention of Claude in the report for you to decide on.

Each build in the package keeps its `README.md` as it was at the version's commit, with only its table of versions brought up to date from `data-processing`. For each input the package omits, the package's `README.md` lists every file's name, size in bytes and Stata `checksum` value, so a replicator can confirm they hold the same extract.

## Before you send it

**Only you do.**

- Look through `data/` for anything that the authors refused.
- Do not send the package while the report names a file or folder that holds the name `data-processing`.
- Before sending the package, decide on any file where the report names the word Claude (other than a row under Provisional or a person's quoted words in a `decisions.md`).

After you send the package, delete the working folder, `<project>-work/`: it may hold inputs that the package omits.

**What can go wrong.**

- Claude stops if the package needs two versions of one dataset and may not ship both.
- Claude ships a table made by hand as it is today, which may differ from what the release read.

**Untested on Windows.** For a project with R or Python steps, Claude asks you to start the test run there. Double-click `code/master.do` of the test copy, click **Do**, and tell Claude when it has ended.
