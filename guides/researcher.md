# The researcher's guide

**A draft, to be tried at a first session with a researcher.** As you follow it, note every
point where you stopped, were unsure or had to ask someone, and give the list to the curator.

You work with Stata, GitHub Desktop and Claude Code. Claude commits and pushes when you ask, and
never on its own; it asks before `release.do`. Scientific choices are yours, and Claude writes
them into `decisions.md`.

Each task has four parts: **Ask Claude.** what to type; **Claude will ask you.** the answers to
have ready; **Only you do.** what Claude does not do; **Check.** what to look at before you go on;
and, where a limit must be known, **What can go wrong.**
Every task here is asked in a Claude Code session opened on your project's folder,
`C:/Users/<you>/GitHub/<project>/`, never on a folder inside it. The shared data is explained in
the [data guide](data.md), and what Claude does in the [Claude guide](claude.md).

## Words

- **Repo:** a project's folder of code, kept on GitHub. Your copy of it on this machine is a
  **clone**. **`main`** is the one line of history of every repo; everyone works on it, and
  nobody makes a **branch**, a second line beside it.
- **Pull, commit, push:** a pull brings the others' changes into your clone; a commit records
  yours there, with a one-line summary; a push sends them to GitHub. Claude does each when you
  ask.
- **Step:** one do-file or `.R` file in `code/dataprep/` or `code/analysis/`. `code/master.do`
  runs the steps in order.
- **`ado/`:** the project's folder of Stata packages; the code uses no others. It comes with
  `estout`, whose `esttab` writes the tables.
- **Exhibit:** a table, figure or number the code writes into `paper/results/`, for the paper.
- **Working files:** what a step saves for a later step, in `temp/`. A full run deletes and
  remakes them. A run that gets past its first checks writes a dated log to `logs/`.
- **Pin:** the line of `code/pins.do` that names the version of a dataset, or the raw delivery,
  that the project reads.
- The paper is written in LaTeX in `paper/draft/`: `main.tex` and one file per section.

## 1. Set up your machine, once

- **Only you do.**

  - Install Stata 18 or later, GitHub Desktop, and Claude Code (the desktop app, or the command
    line). R and RStudio come later, and only for a project with R steps (section 8).
  - Sign in to Claude Code with the account the chair gives you.
  - Create an account on github.com if you have none, and sign in to GitHub Desktop with it.
    Give your GitHub user name to the curator, who invites you to the chair's organisation. The
    invitation comes by email: click its link within seven days. Until you have joined, the
    chair's projects do not appear in GitHub Desktop.
  - Install Git for Windows (<https://git-scm.com/downloads/win>), keeping the choices its
    installer proposes: Claude uses it to pull, commit and push when you ask. The first time
    Claude pushes, a window opens to sign in to GitHub: sign in, once, with the account you use
    in GitHub Desktop.
  - `<you>`, in every path of this guide, is your Windows user name: the folder under
    `C:/Users/` that holds your own files.
  - In Explorer, check that Dropbox holds the chair's data folder, `chair-research-data`; if
    Dropbox or the folder is not there, ask the curator. Click the folder's address bar and copy
    its full path, for example `C:/Users/<you>/Dropbox/chair-research-data`. This folder is the
    data root.
  - Clone the project, under the name the curator gives you: in GitHub Desktop, **File › Clone
    Repository**, pick the project, set **Local Path** to `C:/Users/<you>/GitHub/<project>`,
    and click **Clone**. It must be outside Dropbox, OneDrive and every folder that syncs. If
    GitHub Desktop proposes a folder under `Documents`, change it: OneDrive may sync it.
  - Set the automatic permission mode, **Auto**, so that every session, in the app and on the
    command line, starts in it. A project cannot set it for you. First open a session on the
    project's folder as below (it does not show **Auto** yet), ask "What is this project?", and
    close Claude Code: it keeps its sessions in `C:/Users/<you>/.claude/`, so that folder now
    exists. If it does not, make it in Explorer: in `C:/Users/<you>/`, right-click an empty space,
    choose **New › Folder**, and name it `.claude`. If the folder already holds a `settings.json`,
    change nothing and tell the curator. Otherwise open Notepad and type:

    ```json
    {
      "permissions": {
        "defaultMode": "auto"
      }
    }
    ```

    Then **File › Save as**: the folder `C:/Users/<you>/.claude/`, the name `settings.json`,
    and **Save as type: All Files**.
- **Ask Claude.** Open a session on the project's folder, `C:/Users/<you>/GitHub/<project>/`,
  never on `code/`: Claude reads the project's settings, which let it run `code/master.do`
  without asking, only from the folder the session opens. In the desktop app, open the
  **Code** tab. In the row under the prompt box, click the first control, the environment
  selector, and select the top entry in the **Local** group (the clone and Stata are on this
  machine); then choose the folder with the project folder control beside it (**Open folder…**),
  and check that the mode selector in the same row shows **Auto**. On the command line, go to
  that folder, type `claude`, and check that it shows `auto mode on`. If a session does not start
  in Auto, tell the curator. If the project has R steps (ask "Does this project have R steps?"),
  go on in section 8: on Windows such a project is run in Stata's window. Otherwise ask: "This is
  a new computer: run everything."
- **Claude will ask you.** The full path of the data root, after quoting what Stata printed:

  ```text
  Failed: the data root was not found: the file C:/Users/<you>/chair-research-data.txt is missing or empty. Write one line into that file, the full path of the data root on this machine (chair-research-data on Dropbox), as in C:/Users/<you>/Dropbox/chair-research-data (r(601))
  ```

  Give it the path you copied. Claude writes that one line into
  `C:/Users/<you>/chair-research-data.txt` and runs everything again. It never guesses a path.
  If Stata stops with another `Failed:` sentence, Claude tells you what it says, and does it
  only where that is Claude's to do.
- **Check.** The run ends `Run complete`, and GitHub Desktop then lists no changed file. If it
  lists exhibits, they differ from the committed ones: Claude says which before anyone commits.

## 2. Your day

Pull, work on steps, run everything, then commit and push. Steps are the daily unit: a full run
can take most of an hour. They are in `C:/Users/<you>/GitHub/<project>/code/dataprep/` (they
make the working files) and `C:/Users/<you>/GitHub/<project>/code/analysis/` (the exhibits). In
a project with R steps, on Windows, you start every run yourself, as section 8 says: wherever
this guide says Claude runs something there, it asks you to start it. If you prefer GitHub
Desktop's buttons (**Pull origin**, **Commit to main**, **Push origin**), they still work.

### Pull

- **Ask Claude.** "Pull." Claude says in one sentence what the pull brought.
- **Claude will ask you.** Whether to run everything, where the pull brought code,
  `code/pins.do` or exhibits.
- **Only you do.** Say yes or no to that run. To look at what came yourself: in GitHub Desktop,
  **History**, then each new commit.
- **Check.** What Claude says came; after a run, its last line, which Claude quotes (below).

### Work on a step

- **Ask Claude.** For example: "Write a step that merges the finances with the population.",
  then "Run only the step that makes the main table."
- **Claude will ask you.** Each scientific choice the step needs (section 7). Before it merges
  two municipality files, their two rows of the data map, if it cannot read the map: open
  `datamap.csv` in `data-processing` on github.com. For a Stata package the code needs and
  `ado/` lacks, your word to fetch it from SSC into `ado/`, and with it the packages it fetches
  when it runs. For a command of Stata's that must be activated once, such as `grmap`, your word
  to run the activation, which writes a file into `ado/`. Before it runs one step, whether to run
  everything first, where an earlier step or `code/pins.do` changed since the last full run on
  this machine, or there is none: you decide.
- **Only you do.** Answer each question; the choices are yours.
- **Check.** The run's last line, `Step complete: <step>` (below). After one step Claude says what
  the step wrote, from the working files as they were; it never says that no number changed:
  results count after a full run. For a package it fetched, Claude names its version, where it
  came from and the new files in `ado/`, its list of packages `stata.trk` among them, which are
  committed with the step.
- **What can go wrong.** A new file in `ado/` after a run comes from a package that fetches
  others when it runs; Claude names such a package when it fetches or copies it. Never let such
  a file be committed before Claude has said where it came from.

### Look at data

- **Ask Claude.** For example: "Look at `<dataset>`: how many rows have no `<variable>`?" Claude
  writes a file in `code/explore/` and runs it with the project's paths and pins. It saves only
  under `temp/explore/` and is never part of a full run.
- **Claude will ask you.** Nothing.
- **Only you do.** Nothing.
- **Check.** The run's last line, `Step complete: explore/<file>`, and the answer from its log.

### Run everything, then commit and push

- **Ask Claude.** "Run everything." A full run empties `temp/` and `paper/results/` and writes
  every exhibit again. Then: "Commit and push."
- **Claude will ask you.** Where exhibits changed and no full run finished since the last change
  to code or `code/pins.do`, whether to run everything before it commits: you decide.
- **Only you do.** Before you ask for the commit, look at the files Claude listed at the end of
  its task, with its one-line summary; GitHub Desktop's **Changes** shows each changed line.
- **Check.** The last line of each run, which Claude quotes from the run's log:

  ```text
  Run complete. Exhibits and the results page: <folder>
  Step complete: <step>
  Failed: <step> (r(<code>))
  ```

  Some stops come before any step runs, with `Failed:` and one sentence that says what to do.
  No such line means the run did not finish, and Claude says so. When you ask for the commit,
  Claude lists the files it commits: check they are those you expected (steps, `code/master.do`
  (its list of steps), `code/pins.do`, `decisions.md`, `ado/`, `paper/results/`), and that it
  says it has pushed. The ignore rules leave out the usual data file types, `temp/` and `logs/`,
  so they are never listed; any other data file listed is never committed.
- **What can go wrong.** You can also start a full run yourself: double-click
  `C:/Users/<you>/GitHub/<project>/code/master.do` in Explorer, click **Do**, and tell Claude
  what Stata showed. Never **File › Open**: a `master.do` of another project opened that way can
  empty this project's results. After a run, you can run lines of a step again in Stata's
  do-file editor, in the same Stata.

## 3. A rejected push, or a conflict

- **Ask Claude.** "My push was rejected." Someone pushed first. Claude also meets this itself,
  on a push you asked for.
- **Claude will ask you.** Nothing.
- **Only you do.** Nothing.
- **Check.** What Claude says came; `Run complete`, where code, pins or exhibits came; and that
  it says it has pushed.

For a conflict, where one file was changed on both sides:

- **Ask Claude.** "There is a conflict." Claude also stops on one itself, in a pull.
- **Claude will ask you.** For each file, it shows both versions in plain words: which to keep,
  or how to combine them. Where the difference is a scientific choice, the answer is yours;
  otherwise it proposes one and waits for your yes.
- **Only you do.** Choose, for each file.
- **Check.** What Claude says it kept; `Run complete`, where code, pins or exhibits were in
  conflict (an exhibit is never merged by hand: the run writes it again); and that it says it
  has pushed.

## 4. When a run fails or a number looks wrong

- **Ask Claude.** "The run failed: why?", "This number looks wrong." or "The table changed."
  Claude finds the cause before it changes anything: it runs the step again and looks at the
  data with files in `code/explore/`.
- **Claude will ask you.** Before it runs the step again, whether to run everything first, where an
  earlier step or `code/pins.do` changed since the last full run on this machine; what you expected,
  when neither the log nor the committed exhibits show it; your word before it changes code; and at
  the end, whether to keep each `check_` file it made in `code/explore/`, which it otherwise
  removes. Where the fix is a scientific choice, it writes the question into `decisions.md` as Open
  and waits.
- **Only you do.** Say yes or no to the change it proposes. A failed run leaves exhibits
  deleted, which are never committed: a full run after the fix writes them again, or, with your
  word, Claude brings back the committed ones.
- **Check.** The cause comes in one or two sentences with the file and the line, and everything
  is run again, to `Run complete`, before results are committed. A `check_` file is among the
  changed files only if you kept it. A fault in a processed version is the curator's, fixed in a
  new version.

## 5. Moving to a new version of a dataset

The curator tells the chair when a version is released. Your project reads the version its line
in `code/pins.do` names until you choose to move ([data guide](data.md)).

- **Ask Claude.** "Move to `v<N>` of `<dataset>`." Claude changes the number on that dataset's line
  of `code/pins.do`, runs everything, and says which results changed. Then: "Commit and push."
- **Claude will ask you.** Nothing.
- **Only you do.** Look at the exhibits that changed before you ask for the commit.
- **Check.** The run ends `Run complete`; `code/pins.do` is among the changed files; and the line
  `chair_use`, which loads a version, prints for it; Claude quotes it:

  ```text
  chair_use: <dataset>/<file> v<N>
  ```

## 6. Review

- **Ask Claude.** "Review my code.", "Review my paper." or "Do the numbers in my paper match the
  tables?" Claude reviews against every item of `checklist.md`, the numbers typed in the paper
  included. Ask "Run everything." first: Claude calls the exhibits current only after a full run
  in the same session.
- **Claude will ask you.** Nothing: a review reads, and runs and changes nothing.
- **Only you do.** Before submission, a colleague clones the project afresh, runs everything on
  their own machine and matches the main results. You check the target journal's policy on AI
  tools. A person reads the PDF in full against `checklist.md` and records it there, with the
  commit the PDF was built from: ask Claude "Which commit is the project at?"
- **Check.** Each finding gives the file, the line or sentence quoted, and the checklist item,
  and the end lists what Claude could not judge. A review changes nothing: ask for each fix.

## 7. Your scientific choices

A sample, a threshold, a target boundary year, a clustering level: these are yours; Claude writes
them down. `decisions.md` holds each under Open, Provisional or Decided, with a D-number.

- **Ask Claude.** For example: "Propose the clustering level for the main table." Claude gives the
  options and writes the question under Open, and code that needs it waits. When you answer in
  plain words, or state a choice without being asked, Claude records it under Decided, with your
  words quoted, the name you give and the date, and tells you its D-number. If you hand a choice
  to Claude ("Decide it for me."), it decides, records it under Provisional with the alternatives
  and the reason, and goes on.
- **Claude will ask you.** Your answer to each Open question that code waits for; "whatever is
  usual" is no answer, and Claude asks again. Once, the name to write as the person who decided:
  Claude never takes it from git or your computer.
- **Only you do.** Make each choice and say it. Before submission, confirm or overturn every
  Provisional row: tell Claude, and it records your choice under Decided, under the same D-number.
  The licences of the replication package are the authors' alone: Claude leaves them under Open,
  whatever you tell it, until an author writes the row under Decided themselves, with their name
  and the date.
- **Check.** The row Claude says it wrote, in `decisions.md` among the changed files: your own
  words, your name, the date. To change your mind, tell Claude: it adds a row
  under the same D-number with the new date, and the old row stays. Each step's header names the
  D-numbers it applies, under `DECISIONS APPLIED`.

## 8. A project with R steps

- **Ask Claude.** "Write an R step that `<does what you need>`." An R step is one `.R` file, and
  runs through `code/master.do` like a Stata step. On a new machine, or in a fresh clone of a
  project that has R steps already: "Which version of R does this project's renv.lock name?",
  then "This is a new computer. My data root is `C:/Users/<you>/Dropbox/chair-research-data`:
  write my data-root file.", with the path you copied in section 1, and "Restore the R packages."
- **Claude will ask you.** For the project's first R step: is R installed at the version
  `code/templates/r-project/renv.lock` names (Claude tells you which), and is the network on?
  It then copies the starter files and restores the R packages, which takes a few minutes. In a
  project with R steps already, the version is the one named in `renv.lock` at the project's
  top, and a fresh clone needs the same restore once, with the network on.
- **Only you do.**

  - Install R at the version Claude names, and RStudio.
  - Where Claude finds no `Rscript`, R's command-line program, for the restore: open
    `C:/Users/<you>/GitHub/<project>/project.Rproj` in RStudio and type `renv::restore()` in
    the Console.
  - Where R is installed in a folder of your own and Stata finds no R: put the line Stata's
    message gives, `global RSCRIPT_PATH "<path to Rscript>"`, into the file
    `C:/Users/<you>/profile.do`, the place Stata's own documentation recommends. If there is
    none, make it in Notepad (**Save as type: All Files**).
  - To write and try an R step, open `project.Rproj` and run the step line by line: its
    exhibits are overwritten then, so results for the paper come from a full run.
  - On Windows every run of a project with R steps is started by you, in Stata's window, not in
    batch mode (the way Claude starts Stata, without its window): a full run, one step (a Stata
    step too) and a look at data. In any project, so is a look at data written in R. Claude
    cannot start these runs: it asks you to, and you tell it what Stata showed. For a full run,
    double-click `C:/Users/<you>/GitHub/<project>/code/master.do` and click **Do**; for one step
    or a look at data, ask Claude what to type in Stata's window. **Untested:** no R step has
    run on Windows yet, in the window or in batch.
- **Check.** Stata's last line reads `Run complete`. With the first R step, `.Rprofile`,
  `renv.lock`, `renv/` and `project.Rproj` are among the changed files, committed with the step.

## 9. Moving an existing project in

The repo is first made from the template (section 10); this takes under an hour, plus one full
run. Two folders now exist: open the session on the new one, `C:/Users/<you>/GitHub/<project>/`,
never on the old folder.

- **Ask Claude.** "Bring my old project in from `<full path of the old folder>`." Claude copies
  the do-files and R scripts in as steps, pins the data they read, runs everything, and compares
  each table and figure with the old one. It changes nothing in the old folder. A seed the old
  code sets stays where it is, so that a bootstrap or a simulation gives the old numbers.
- **Claude will ask you.** In one message: whether the files it matched in the shared data are
  right; for each table you made by hand, whether it may copy it from the old folder into
  `C:/Users/<you>/Dropbox/chair-research-data/intermediate/<project>/` (the original stays where
  it is); where the old final tables and figures are; whether it may copy Stata packages from
  your own Stata, and fetch from SSC those your Stata does not have, with the packages they
  fetch when they run; for R scripts, whether R is installed at the version `renv.lock` names
  and the network on; whether anyone else at the chair uses a dataset the project makes; for each
  scientific choice and each seed it found, quoted with its file and line, whether to keep it or
  change it; and the name to write as the person who decided.
- **Only you do.** Answer for each choice and seed: what you say, Claude records under Decided,
  with your words; a change you ask for is made in the step, and the comparison shows its effect.
  One you leave unanswered stays under Open while the code keeps the old behaviour, until you
  decide it by saying so (section 7). A table you did not let Claude copy, or one it says it
  could not copy because the folder cannot be written, you copy there in Explorer, or ask the
  curator. A raw file or processed dataset missing from the data root is the curator's to add.
  With R scripts, on Windows, you start the runs (section 8).
- **Check.** Each table Claude copied, and where it now is. The D-numbers Claude says it recorded
  under Decided: read those rows in `decisions.md`, with your words and name. The comparison,
  difference by difference, before you ask for the commit. Each step that keeps a seed names
  its D-number under `DECISIONS APPLIED`. If the old project built data that others read, that
  part moves to a build with the curator: about half a day.

## 10. Starting a new project

- **Only you do.** Ask the curator to create the repo on github.com from `project-template`,
  under the project's bare name (`data`, `data-processing`, `handbook` and `project-template`
  are taken). Clone it as in section 1, into `C:/Users/<you>/GitHub/<project>`.
- **Ask Claude.** On that folder, before you edit anything: "Run everything." Once the project
  has its first steps: "Write the top of the project's README.md: what the project is, who
  works on it, and how long a full run takes."
- **Claude will ask you.** Nothing for the run. Once the project has its first steps, Claude
  proposes the text of the README's top on its own, and you confirm it or say what to change.
- **Check.** The run ends `Run complete`, and GitHub Desktop lists no changed file. After the
  README, Claude lists `README.md` alone as changed: then "Commit and push."

## 11. Never do

- **Never clone into Dropbox or OneDrive,** or any folder that syncs: the sync program and git
  would both write the same files.
- **Never save into the data root,** but for a review sheet or a table made by hand in
  `intermediate/`: nothing a project's code can rebuild belongs on Dropbox.
- **Never put a table you made by hand in `raw/` or in a repo:** `raw/` holds only what a
  provider delivered, and no data enters git. It goes in `intermediate/<project>/`.
- **Never make a folder named `data` in a project:** the code takes it for the data root, and
  the run stops.
- **Never copy data into a project folder:** `temp/` holds only what the code makes, and no data
  enters git.
- **Never type a path into code:** every input comes through `code/pins.do` and the folders
  `code/master.do` sets, so the code runs on every machine.
- **Never make a branch:** everyone works on `main`, and Claude makes none.
- **Never commit a file Claude has not explained,** a new file in `ado/` after a run included:
  look at what Claude lists before you ask for the commit.
- **Never edit an exhibit by hand:** the code writes it, and the next full run replaces it.
