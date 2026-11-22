# The curator's guide

You do each task below with Claude Code, in the desktop app or from the command line. Claude
commits and pushes when you ask, and never on its own; it asks before `release.do`. Scientific
choices are yours, or the build author's, and Claude writes them into the build's `decisions.md`.
In `data-processing` the commit and the push are still yours, in GitHub Desktop: where Claude
changed that repo, it ends with the files it changed and a one-line summary; check those files
under **Changes**, type the summary, click **Commit to main**, then **Push origin**. To pull there
is to click **Fetch origin**, then **Pull origin** if it appears. In `handbook` and in a project,
ask Claude: "Pull." or "Commit and push." What a file of the shared data is, and the words for
it, are in the [data guide](data.md).

## Set up your machine

**Only you do.**

- Install Stata 18 or later, GitHub Desktop and Claude Code (the desktop app or the command line).
  Sign in to Claude Code with the account the chair gives you. Install Git for Windows too, and
  sign in once at Claude's first push, as the [researcher's guide, section
  1](researcher.md#1-set-up-your-machine-once) says: Claude needs it to commit and push in
  `handbook`.
- Before you clone, sign in to GitHub Desktop (**File › Options**, **Accounts**) with the GitHub
  account that owns the chair's organisation. Then, with **File › Clone Repository** and its
  **GitHub** tab, clone `data-processing`, `project-template` and `handbook` side by side in one
  folder, for example `C:/Users/<you>/GitHub/`, outside Dropbox, OneDrive and every other folder
  that syncs: the sync program and git would both write the same files. Clone each project you
  assemble a package for into that folder too, or into a folder inside it.
- Copy the data root's real path from Explorer's address bar, and set the permission mode **Auto**
  once in your own Claude Code settings, both as the [researcher's guide, section
  1](researcher.md#1-set-up-your-machine-once) says, with its first session on
  `C:/Users/<you>/GitHub/data-processing/` in place of a project. In this guide, a path under
  `C:/Users/<you>/Dropbox/chair-research-data/` stands for the folder your data-root file names.

**Ask Claude.** Open the session on the repo's own folder, `C:/Users/<you>/GitHub/data-processing/`,
never on a folder inside it: Claude reads the repo's settings, which make it ask before
`release.do`, only from the folder the session opens. In the desktop app, first select
the top entry in the **Local** group of the environment selector. Before your first message, check
that the mode selector shows **Auto** (the command line shows `auto mode on`); if not, check your
settings file against the [researcher's guide](researcher.md#1-set-up-your-machine-once). Then, with
the path you copied: "This is a new computer. My data root is
`C:/Users/<you>/Dropbox/chair-research-data`: write my data-root file."

**Claude will ask you.** The data root's full path, if you did not give it; it never guesses.

**Check.** `C:/Users/<you>/chair-research-data.txt` holds that one line. Researchers whose session
does not start in Auto tell you. Where a researcher's `C:/Users/<you>/.claude/settings.json` already
exists, open it in Notepad together: it must end up with `"defaultMode": "auto"` inside a
`"permissions"` block, with everything else kept. The whole content of a file that holds nothing
else is in the [researcher's guide, section 1](researcher.md#1-set-up-your-machine-once).

| Folder in the data root | Holds | Who can write |
| --- | --- | --- |
| `raw/<source>/<date>/` | A delivery as received | You |
| `intermediate/<dataset>/` | The candidate for release, review sheets, tables made by hand that a build reads | Every member |
| `intermediate/<project>/` | Tables made by hand that one project reads | Every member |
| `processed/<dataset>/v<N>/` | A released version | You |

## Add a raw delivery

**Ask Claude.** On `data-processing`: "I added a delivery of `<source>`." Say its terms of use in
the same request when you know them. Claude reads the first lines of each text file of the delivery,
and skips that only where the source's row in the map or a `README.md` in `raw/<source>/` states
terms that keep the records from outside services, AI providers included. So for a new source with
such terms, save that `README.md` there before you ask (Notepad, **Save as type: All Files**); for a
new source whose terms you do not know, find them out first.

**Claude will ask you.** In one message, what the files do not show, with its proposal for each
field it could fill: whether you have pulled `data-processing`; where the delivery came from, and
when, if not on the folder's date; its terms of use (`open`, `chair only`, or the restriction in the
provider's own words: have their wording at hand), and, where the terms leave unclear whether the
files may be opened here (sent to an AI provider), that too; for municipality numbers, the list or
date they follow; what one row is and which columns identify it, where the files do not show it. For
a further delivery, only what may have changed.

**Only you do.** Pull `data-processing`. In Explorer, copy the delivery as received into a new
folder `C:/Users/<you>/Dropbox/chair-research-data/raw/<source>/<date>/`: the date as `yyyy-mm-dd`,
the source in lower case with hyphens between words, at most 28 characters. Fix in Explorer what
Claude finds wrong with the folder. Where the terms are not `open`, save the `README.md` text Claude
gives you in Notepad, in `raw/<source>/`, with **Save as type: All Files**.

**Check.** The row Claude shows, and the builds it names that read the source: each keeps the
delivery its `pins.do` names until you ask Claude to move it. GitHub Desktop lists `datamap.csv`.

**What can go wrong.** For a source whose terms bar outside services, its row in the map and the
`README.md` in its folder state the terms, and Claude is told to open none of its files and to say
so when a task would read one. No setting enforces this.

## Save a table made by hand

**Ask Claude.** On `data-processing`: "Where do I put a table I made by hand for `<dataset>`?" A
table that one project alone reads is in the [data guide](data.md#a-table-made-by-hand).

**Claude will ask you.** Nothing, when your request names the dataset.

**Only you do.** Save the table, in Explorer or Excel, where Claude says: in
`intermediate/<dataset>/`, as a `.csv` or `.dta` under a name of its own, never `.xlsx` and never
the name of a file the build makes. Add a `source` and a `notes` column where they help. Never in
`raw/`, never in a repo. A build reads only the file its step names: a new table takes that file's
name, or the step is changed, which is the build author's.

**Check.** The file is in the folder Claude named, and GitHub Desktop lists no change.

**What can go wrong.** A table made by hand has no version and no pin: change it after a release or
after results were made, and the next build or run gives another result, with no error. A build with
a review step reads every `.xlsx` beside its review sheets as a sheet, but one whose name begins
with `~`: it stops on one without the sheet's columns; one with them adds its decisions, and stops
the run on a value that is not 1, 0 or blank or that disagrees with another row's.

## A review round

**Ask Claude.** On `data-processing`: "Run the build for `<dataset>`." Once the sheet is filled:
"The assistant has filled the sheet for `<dataset>`. Apply it."

**Claude will ask you.** Nothing; it reports what the run did.

**Only you do.** You or an assistant fill in `decision` (`1` yes, `0` no, blank for undecided) and
`note` in Excel, in the sheet in `intermediate/<dataset>/`, by the source's terms. Change nothing
else; sorting rows is fine. Save and close the sheet. Copy a sheet the run wrote to the build's
`logs/` into the folder its line names. Where two rows decide one case differently (two sheets, a
Dropbox conflicted copy, or one case listed twice), settle it in Excel, and move a copy you drop out
of the folder.

**Check.** The lines Claude quotes. The review step prints the sheets' folder, then the counts:

```text
Sheets folder: <folder>
Review sheets: <n> read. Cases: <n>. Decided: <n> (<n> yes, <n> no). Not decided yet: <n>.
Decisions that match no current case, not used: <n>.
```

Further down, one of these lines: a new sheet of the cases in no sheet yet; the same, where this
machine cannot write the folder; or none, where every case is in a sheet already.

```text
Wrote intermediate/<dataset>/<dataset>-review-<n>.xlsx in the data root, with <k cases>: the assistant fills in decision (1, 0 or blank) and note there.
Wrote this build's logs/<dataset>-review-<n>.xlsx with <k cases>: this machine cannot write intermediate/<dataset>/ in the data root, so copy the file into that folder; the assistant fills in decision (1, 0 or blank) and note there.
Every case is in a sheet already: no sheet was written.
```

A decision that is not 1, 0 or blank, or two rows that decide one case differently, stop the run:
Claude names the sheets. On your machine, a full run that ends `Run complete ... Staged ...` staged
a new candidate, which holds those decisions and replaced any earlier one.

**What can go wrong.** A release made without a rebuild after the sheet was filled publishes files
made before those decisions. A sheet can change after a release: the version's own `decisions` file
shows what it used. Any full run of a build with a review step writes a new sheet when there are
cases no sheet lists, a build still being written too.

## Start a new build

**Ask Claude.** On `data-processing`: "Start a build for `<dataset>` from `<source>`."

**Claude will ask you.** In one message, with a proposal where the files suggest one: the dataset's
and each finished file's name; what one row is and its key; the variables to keep and what each
measures; rows to keep out; the terms of use; cases code cannot decide; your name, for
`decisions.md`. For municipality numbers: the list they follow; the boundary year (yours: Claude
proposes none); which territory the figures cover; each variable added up or averaged, with which
weight; how to split a divided municipality. An answer in words becomes the closest rule Claude can
write, under Provisional in `decisions.md`, with your words beside it.

**Only you do.** Make every choice: Claude writes each you answer into the build's `decisions.md`
under Decided, with your name and the date, and code that needs a choice still open waits for it.
Make and save any table of shares, as above. When Stata stops on a case code cannot decide, Claude
shows the sentence and the rows, and the answer is yours: for a number on no list, or a number
beside its successor, which rows to keep; for a split without a rule, an equal split or a table of
shares made by hand; for a list year after the boundary year, a later boundary year; for an
own-territory source in which two numbers become one, drop the empty rows or add up instead. A table
of shares that does not add up to 1, or has no share for a split row, is corrected by the person who
made it. A total that is not kept, or a number with no link in the crosswalk, is the curator's to
look into. The skill `new-build` lists each case. When Claude shows the first rows, say whether they
are what you meant. Commit and push the new build and its rows in the map, in GitHub Desktop.

**Check.** The rows of the build's `decisions.md`, and the questions Claude lists as still Open.
The counts, the rows in `logs/qa/`, the first rows Claude shows, and the run's last line.
Where it ends `Run complete ... Staged ...` (your machine), the candidate was made from code not yet
committed: never release it. After the push, ask Claude "Run the build for `<dataset>`." Where it
ends `Run complete ... Not staged: ...`, nothing in the data root was written but a new review
sheet.

**What can go wrong.** For a source whose terms bar outside services, the skill has Claude open none
of its files while it writes the build, but then run it and show you the rows in `logs/qa/` and the
first rows, which come from the source's records: nothing in the skill stops before those.

## Release a version

**Ask Claude.** On `data-processing`: "Release `<dataset>`." Claude first checks that nothing is
uncommitted. It releases the candidate that waits, and builds again only if you ask ("Run the build
for `<dataset>`."); if none waits, it says so and builds.

**Claude will ask you.** To say **Yes** before `release.do`, in a message that shows the command.

**Only you do.** Pull, and leave **Changes** empty before any build you will release. A waiting
candidate is released as it is, and nothing shows how it was built: ask for its release only when
you know it came from a full build run while **Changes** was empty. A candidate built while
**Changes** listed a file is never released, even after that file was committed or discarded; when
you are not sure, ask for the build first, then release. Say **Yes** only when the dataset and
version are right. A file in `intermediate/<dataset>/` that the build stops on is yours to rename or
move. After `Released`, add one line to the build's `README.md`, what changed; commit and push in
GitHub Desktop, and tell the chair. Researchers move when they choose.

**Check.** The outcome lines Claude quotes. On your machine a full build that staged ends with the
first line below, its last sentence only where a candidate was waiting; a release ends with the
other two:

```text
Run complete at commit <commit>. Staged in the data root's intermediate/<dataset>/ with staged.txt, <date>: the candidate for release, by release.do in code/ beside builds/. It replaced the candidate that was there; no review sheet or hand-made table was touched.
Released <dataset> v<N> to <folder> (build commit <commit>).
Next: add one line to builds/<dataset>/README.md, what changed in v<N>; commit, push, and tell the chair.
```

A full run that finished without staging ends with one of these: the first means this machine cannot
write `processed/`, the second that the map has no row for the dataset's files.

```text
Run complete at commit <commit>. Not staged: only the curator's machine, which can write the data root's processed/, stages; the finished files are in this build's temp/.
Run complete at commit <commit>. Not staged: datamap.csv lists no processed file of <dataset>.
```

A refusal ends `Nothing was released.`: give Claude what its reason names, such as a map row's key,
boundary year or terms. A run that ends with neither `Released` nor that sentence has no reported
outcome: Claude says it did not finish. A `v<N>` folder without `manifest.txt` stopped part-way, or
Dropbox has not yet brought all of it to your machine: let Dropbox finish syncing and look again. If
it still has none, release it again with the same number; `release.do` first empties that folder.

**What can go wrong.** A build run with uncommitted edits records the last commit all the same: a
package would carry the wrong code, and nothing notices. On your machine a full build withdraws the
waiting candidate when it starts (`Withdrew the candidate that was waiting ...`): one that fails
after that leaves none, and a long build none until it ends. A stop at its first checks (a name
pinned twice, a file under one of the build's names already in the folder, a data root not found)
leaves the old one; a stop that says the waiting candidate could not be withdrawn may leave part of
it: close any program that has its files open, then ask for the whole build again. A file under one
of the build's names that comes into the folder during the run stops the staging, and leaves none.
If someone looked over the candidate, release what they looked at: a rebuild makes a new candidate
their look does not cover, and nothing records a look. Anyone can change a staged file in
`intermediate/`, and nothing checks it.

## Withdraw a version

**Ask Claude.** On `data-processing`: "Withdraw `<dataset> v<N>`."

**Claude will ask you.** What is wrong and which version to use instead; it drafts the reason.

**Only you do.** Save the text in Notepad as `WITHDRAWN`, with no ending (**Save as type: All
Files**), in `C:/Users/<you>/Dropbox/chair-research-data/processed/<dataset>/v<N>/`. If Claude finds
`WITHDRAWN.txt`, rename it in Explorer.

**Check.** Claude says the folder holds `WITHDRAWN`. The loader prints the reason as a warning and
still loads the version, so papers that used it still reproduce.

## Add the register's yearly list

**Ask Claude.** Add the January list as a raw delivery, as above. Then, on `data-processing`: "The
new January list of the municipalities is in raw/."

**Claude will ask you.** The count of municipalities on the new list.

**Only you do.** Take that count from the Federal Statistical Office. Commit and push in GitHub
Desktop before the build you release; say when to release it and the datasets that read the
register.

**Check.** GitHub Desktop lists the places the register build's `README.md` names for a new list.
The build stops if the list does not hold the count you gave. Then release as above.

## Assemble a replication package

**Ask Claude.** On `data-processing`: "Assemble the replication package for `<project>`." Before its
main message, Claude may ask you one of two things, each on its own: the project's folder, if it
finds no clone of the project beside `data-processing` or one folder further down, or finds two; and
to pull `data-processing`, if the commit that made a version is not in your clone yet.

**Claude will ask you.** In one message to pass to the authors: whether the clone and the commit it
names are the project and the commit with the paper's results (an unpushed commit is named, and the
authors push it before you send the package); a new folder for the package, outside your clones and
synced folders; for each input (a delivery, a version, a version's decisions, a table made by hand)
whether it may be shared, and, for one marked no that is needed, who grants access and how to apply;
the title; the licences for data and code; two rights statements; the availability statement; the
exhibits' labels, where the draft does not show them; the Stata version and edition of the authors'
run, where no log gave it; anything more the journal asks for. If the authors name another commit,
pull the project in GitHub Desktop first; Claude then traces again and asks only what changed.

**Only you do.** Get the authors' answers. Pull `data-processing` when Claude asks. Give Claude any
omitted input you may use for its test. On Windows, for a project with R steps, start the test
copy's run yourself: Claude cannot start any run of such a project there, and the skill starts its
test in batch mode, where an R step does not run. Close Stata, double-click the test copy's
`code/master.do`, click **Do**, and tell Claude what Stata showed (untested: no R step has run on
Windows yet). Read the package's `README.md` against the answers. Send the folder only when Claude's
report shows that no file names the shared repo, that every run of its test ended as the README
says, that the results are identical file by file, and that no placeholder waits for the authors;
otherwise settle what it reports first.

**Check.** Claude's report: where the package is, and the working folder you may delete once it is
sent; each version shipped or rebuilt, and the deliveries, decisions and tables made by hand the
package ships; the last line of each run in its test of a copy from the README alone; whether the
results are identical file by file; every placeholder left for the authors. The folder you send
holds only the inputs the authors allowed: compare its data folder with their answers. Compare the
results with the paper. Where the authors set terms stricter than the map, a copied build's
`datamap.csv` still reads the map's: check **Access exceptions**. Claude stops if a dataset needed
in two versions would have to be rebuilt: the authors must then allow both to be shared.

**What can go wrong.** A table made by hand ships as it stands on the day: nothing shows that it is
the one the release read. Identical results show that the package reproduced the exhibits; nothing
compares a rebuilt version with the released one. The README's placeholder for the steps that set a
seed of their own, under **Controlled randomness**, is one the skill does not yet fill: where the
report lists it, each such seed is in the project's `decisions.md`, under the D-number its step
names.

## Change a chair program, and run the tests

**Ask Claude.** On `data-processing`, after a change to a program in `ado/c/`: "Run the tests." When
they pass: "Copy the changed program into project-template." Then on `handbook`: "Run the
project-template tests." Ask the same before you push a change to either repo's code. Then, in a
session on `C:/Users/<you>/GitHub/project-template/`: "Commit and push."

**Claude will ask you.** Nothing. The tests need no data. The R cases of the template's tests need R
at the minor version that the template's `renv.lock` names (the first two numbers: `4.6` for
`4.6.2`), and the network for their one restore of the R packages.

**Only you do.** Push only once no test fails. Commit and push `data-processing` in GitHub Desktop;
`project-template` Claude commits and pushes when you ask, as above. On Windows,
Claude's batch run skips the R cases of the template's tests: to run them, start the tests yourself
in Stata's window (in Stata, `cd` to `C:/Users/<you>/GitHub/handbook/tests`, then `do run_tests.do`),
and tell Claude what Stata showed (untested).

**Check.** The counts Claude gives from each `results.txt`, a failure quoted in full. In
`data-processing` every line begins `TEST PASS`. In `handbook` each case's line begins `TEST PASS`,
`TEST FAIL` or `TEST SKIP`, and the last line gives the counts:

```text
template tests: <n> passed, <n> failed, <n> skipped (results.txt)
TEST SKIP <id>: rscript does not run R in Stata's batch mode on Windows
TEST SKIP <id>: R <version> was not found on this machine
```

A `TEST SKIP` line says why its case did not run: batch mode on Windows, no R at that version, or a
restore of the R packages that did not finish. Those cases were not tested.
`chair_commit.ado` stays in `data-processing`. Projects made before keep their own copy. For
`project-template`, Claude lists the files it commits and says that it has pushed.

## Change a guide

**Ask Claude.** On `C:/Users/<you>/GitHub/handbook/`, say what to change, for example: "In the
researcher's guide, say that `<what changed>`." When it is right: "Commit and push."

**Claude will ask you.** Nothing; it says what it changes in one plain sentence.

**Only you do.** Read the change before you ask for the commit. Any name of a person, dataset or
source of the chair stays out: this repo is public.

**Check.** The files Claude lists before it commits; that it says it has pushed, and that the
website follows a push by a few minutes.

## Create a project repo, and add or remove people

**Ask Claude.** Nothing: these are clicks on github.com; Claude creates nothing on GitHub.

**Claude will ask you.** Nothing.

**Only you do.** As an owner of the chair's organisation on github.com (members cannot create
repos):

- **A new project.** Open `project-template` on github.com, click **Use this template**, then
  **Create a new repository**. Under **Owner**, choose the chair's organisation. Name the repo after
  the project and nothing more, for example `<project>`; `data`, `data-processing`, `handbook` and
  `project-template` are reserved. Choose **Private**. Click **Create repository from template**.
  Nothing is edited before its first run. In the new repo: **Settings › Collaborators & teams › Add
  teams**, click the team of all members in the list, choose the role **Write**, and click **Add
  `<team>` to `<repo>`**.
- **A new member.** On the organisation's page: **Teams**, the team of all members, **Members › Add
  a member**. Type the username of someone already in the organisation, or the username or email of
  someone not yet in it, and press Enter. Look over the repositories listed, then click **Add
  `<username>` to `<team>`**. Someone not yet in the organisation gets an email invitation, and
  joins the organisation and the team on accepting it. An assistant joins the assistants team too,
  which writes `data-processing`: add them to it once they have accepted.
- **Someone who leaves.** On the organisation's page: **People**, select them, then in the dropdown
  above the list click **Remove from organization**, and confirm with **Remove members**. To take
  someone out of the assistants team only: **Teams**, that team, select them, then in the dropdown
  above the list click **Remove from team**.
- **An outside co-author** gets their own project's repo only, never a team: in that repo,
  **Settings › Collaborators & teams › Add people**, type their username and click their name in the
  list, choose the role **Write**, and click **Add `<name>` to `<repo>`**. They get an invitation,
  and have access once they accept it. Remove them on the same page with **Remove**. Which data they
  receive is your decision, by each source's terms in the map.

**Check.** The new repo lists the template's files and is private. Under **Settings › Collaborators
& teams**, each repo shows the team or person with the role you chose; a person invited has access
only once they accept.
