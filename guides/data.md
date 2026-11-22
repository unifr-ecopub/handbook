# The shared data

This guide is for everyone who reads the chair's shared data or helps prepare it: what a file is,
which version you are reading, and what you may do with it. Setting up your machine, the daily
routine and the "never do" list are in the [researcher's guide](researcher.md). Deliveries, builds,
review rounds, releases and replication packages are in the [curator's guide](curator.md). Claude
commits and pushes when you ask, and never on its own; it asks before `release.do`. Scientific
choices are yours, and Claude writes them into `decisions.md`.

## The data root

The shared data sits in one folder on Dropbox, `chair-research-data`: the data root, named once per
machine in `C:/Users/<you>/chair-research-data.txt`. The guides write its path as
`C:/Users/<you>/Dropbox/chair-research-data`; yours is the one that file names. It has three
folders, in the order the data moves through them.

| Folder | Holds | Who writes |
| --- | --- | --- |
| `raw/<source>/<date>/` | A delivery exactly as a provider sent it | The curator only; view-only for everyone else |
| `intermediate/<dataset>/` | The candidate for the next release, the review sheets, and the tables made by hand that a build reads | Every member and assistant |
| `intermediate/<project>/` | The tables made by hand that one project reads | Every member and assistant |
| `processed/<dataset>/v<N>/` | A released version | The curator only, through the release step; view-only for everyone else |

## The words

The guides and the code use these words and no others. The last column is where each thing sits in
the chair's folders of today; `03_Code` becomes a project's `code/`, its dated master file
`code/master.do`.

| Word | Where | What it is | In the chair's folders today |
| --- | --- | --- | --- |
| raw | `raw/<source>/<date>/` | A delivery exactly as a provider sent it, and nothing made at the chair. Never edited; a new delivery gets a new dated folder | `01_Raw_data` |
| intermediate | `intermediate/<dataset>/`, `intermediate/<project>/` | What is neither a delivery nor released: the candidate (a build's finished files, listed in `staged.txt`, waiting for release), review sheets, tables made by hand. The one folder members can write | Excel sheets and hand-made crosswalks shared on Dropbox |
| review sheet | `intermediate/<dataset>/` | An Excel file of the cases code could not decide, with an assistant's `decision` and `note` | Excel sheets shared on Dropbox |
| table made by hand | `intermediate/<dataset>/`, `intermediate/<project>/` | A crosswalk, the shares for a divided municipality, figures typed from a printed source: code reads it and cannot rebuild it | hand-made crosswalks shared on Dropbox |
| processed | `processed/<dataset>/v<N>/` | A cleaned dataset, one or more `.dta` files, ready to merge, with standard keys | `02_Processed_data/final` |
| build | `data-processing/builds/<dataset>/` | The code that turns raw deliveries into a processed dataset | data preparation in the master |
| version, release | `v1`, `v2`, … | A version is a frozen copy of a processed dataset. Releasing is the curator publishing a candidate | `_corr`, dates in file names |
| pin | `code/pins.do` | The line that says which version or raw delivery a project reads | the `global path` line |
| working files, logs | `temp/`, `logs/` in your clone | Every file a step saves for a later step, and the dataset the estimates run on: delete and rerun, and only computing time is lost. A dated log per run, and in `logs/qa/` the rows a merge did not match, with a note, written before any is dropped: kept | `02_Processed_data/temp` |
| results | `paper/results/` | The exhibits that go in the paper | `04_Results/Figures`, `Tables` |

## The data map

The data map is one table, `datamap.csv`, at the top of the `data-processing` repo, which github.com
shows as a table you can search. One row per raw source and per processed file answers "what is this
file?".

| Column | Answers |
| --- | --- |
| `name` | The source's folder under `raw/`, or `<dataset>/<file>` for a processed file |
| `kind` | `raw` or `processed` |
| `description` | What one row of the file is |
| `origin`, `received` | Who or where it came from, and the dates of the deliveries held |
| `unit` | The unit of observation, for example `municipality-year` |
| `key` | The variables that identify a row |
| `boundary_year` | For municipality numbers: the boundary year (below); for a raw source, the list or date it says it follows |
| `terms` | The terms of use: `open`, `chair only`, or the restriction in words |
| `built_from` | The raw sources and processed datasets a processed file is made from, and `intermediate/<dataset>` where its build reads a table made by hand or a review sheet |

`unknown` means nobody knows; `none` means the field does not apply. A table made by hand has no row
of its own. What depends on what is `built_from` together with each project's `code/pins.do`.

## Versions and pins

**A version is never changed.** It is a folder `processed/<dataset>/v<N>/` with the data files and
`manifest.txt`, which names the dataset, the version, the date, the commit of the build that made it
and the files. The release step writes the manifest last. A version loads only when its folder holds
`manifest.txt`. Where your copy of the folder has none, the loader says to check the version on its
line in `code/pins.do` and, if that is right, to let Dropbox finish syncing and run again; in a
replication package, which has no Dropbox, an R step's loader points to the package's `README.md`
instead. A correction is a new version, and a project moves to it when it chooses.

**A pin** is one line of a project's `code/pins.do`, one line per name; a name pinned on two lines
stops the run.

```stata
global pin_<dataset> "v<N>"          // a processed version: each - of <dataset> written _, and a _ before a leading digit
global raw_<name> "<source>/<date>"  // a raw delivery
```

The code loads a processed file with `chair_use <dataset>/<file>`, which takes the version from the
pin and prints this line in the log:

```text
chair_use: <dataset>/<file> v<N>
```

**A withdrawn version** holds a `WITHDRAWN` file in which the curator says why, and which version to
use instead. It still loads, so papers that used it still reproduce, and every load prints the
reason as a warning. In Stata the curator's text follows the first line, as below; in R it stands on
the same line:

```text
chair_use: warning: <dataset> v<N> is withdrawn. It still loads; the curator wrote:
<the curator's reason>
```

### See which version a project reads

**Ask Claude.** In a session opened on `C:/Users/<you>/GitHub/<project>/`: "Which version of
`<dataset>` does this project read?"

**Claude will ask you.** Nothing.

**Only you do.** Nothing: Claude reads `code/pins.do` and changes no file.

**Check.** Claude names the version on the dataset's line of `code/pins.do`. To move to a new
version, see the [researcher's guide](researcher.md#5-moving-to-a-new-version-of-a-dataset).

## Municipal data

**A boundary year** is the state of the municipalities on the list of the Federal Statistical Office
(FSO) of 1 January of that year, and the chair puts it in the key's name: `gdenr_2012`,
`gdenr_2018`. A processed municipality file has its numbers at one stated boundary year. Its key is
`gdenr_<yyyy>`, with `year` in a panel, and it always carries `ctn`, the canton at that boundary
year.

Where the map's `boundary_year` reads `<yyyy>`, numbers and territory were brought to that year, and
**two files harmonised to the same boundary year merge in one line.** Where it reads `<yyyy>, own
territory`, the numbers are on that year's list but the figures cover each period's own territory,
because the source gives none for the municipalities that were absorbed. Such a file carries
`own_territory`: 1 on each row whose territory in that period differs from the municipality's at the
boundary year, 0 otherwise. Merged with a harmonised file, it runs to the end, and on the flagged
rows it compares a different past territory with today's figures.

### Merge with an own-territory file

**Ask Claude.** In a session opened on `C:/Users/<you>/GitHub/<project>/`: "Write a step that merges
`<file>` with `<file>`."

**Claude will ask you.** The `boundary_year` of both files in the data map, where it cannot read the
map: a project holds no copy of it, so have it open on github.com. Then the scientific choices the
step needs. After the merge, the step makes a table of `own_territory` against the merge's result,
and Claude tells you how many matched rows have `own_territory == 1`.

**Only you do.** Decide what happens to those rows: drop them, or keep them and say so. Tell
Claude: either way it records your choice in `decisions.md` under Decided, with your words, and
tells you its D-number.

**Check.** The count Claude tells you, the row it says it wrote in `decisions.md`, with your words
and name, and the step's `DECISIONS APPLIED` line, which names the decision. "Review my code."
reports a merge on such a file that ignores the flag.

## A table made by hand

A table made at the chair is not a delivery. It lives in `intermediate/<dataset>/` when a build
reads it, and in `intermediate/<project>/` when one project reads it, with a `source` and a `notes`
column where they help; never in `raw/`, which holds only what a provider sent, and never in git.
Beside review sheets it is a `.csv` or `.dta` file under a name of its own, because a build with a
review step reads every `.xlsx` there as a review sheet, but one whose name begins with `~`. In a
project's folder any format will do, an Excel workbook too. It has no version, no pin and no row in
the map: it is one file, changed in place, and a rerun after a change gives another result with no
error. The committed exhibits show what the results were.

**Ask Claude.** In a session opened on `C:/Users/<you>/GitHub/<project>/`, name the file for the
step that reads it: "Write a step that reads my table `<full path of the file>`." A table that a
build reads is in the [curator's guide](curator.md#save-a-table-made-by-hand).

**Claude will ask you.** Whether it may copy the file into
`C:/Users/<you>/Dropbox/chair-research-data/intermediate/<project>/`. It copies it and never moves
it, so the original stays where it was; where a file of that name is there already, it replaces
nothing and asks you.

**Only you do.** Make the table; once it is copied, make any change to it in that folder. Where
Claude says it cannot write the folder, copy the file there in Explorer, or ask the curator.

**Check.** Claude says where the copy now is and that it is identical to your file. No data enters
git: GitHub Desktop lists no change for it.

## For an assistant

### Fill in a review sheet

A build with a review step writes each review sheet into `intermediate/<dataset>/` as
`<dataset>-review-<n>.xlsx` (on a machine that cannot write there, into the build's `logs/`, and the
curator copies it, as in the [curator's guide](curator.md#a-review-round)): one row per case code
could not decide, each case in one sheet only, with its key, the columns you need to see, and an
empty `decision` and `note`.

**Ask Claude.** Nothing: the sheet is yours, in Excel. **Claude will ask you.** Nothing.

**Only you do.** Open the sheet in Excel, in the data root. Fill in `decision`, `1` for yes, `0` for
no, blank for a case you cannot decide, and `note`. Change nothing else: no column is renamed or
removed. Sorting the rows is fine: the build joins each row on its key. Save and close the sheet,
and tell the curator it is ready; nothing is sent back. A sheet follows the terms of its source.
A wrong decision is yours to change, in Excel.

**Check.** The curator's build stops on a decision that is not 1, 0 or blank, with this line:

```text
<n> rows of the sheets in <folder> hold a decision that is not 1, 0 or blank. The assistant corrects them in Excel; then run again.
```

It also stops on two rows that decide one case differently:

```text
<n> rows of the sheets in <folder> decide the same case differently (two sheets, a conflicted copy from Dropbox, or one case listed twice). The assistant settles them in Excel; then run again.
```

### Look over a candidate

Before a release you may look over the candidate: the files `staged.txt` lists in
`intermediate/<dataset>/`, and the build's code in `data-processing/builds/<dataset>/`.

**Ask Claude.** Nothing: the look is a person's. **Claude will ask you.** Nothing.

**Only you do.** Go through every item of the build's `checklist.md`, open the files, read the code,
and tell the curator what you found. It is a habit between people: nothing waits for it and nothing
records it. If the build runs again afterwards, the candidate is a new one, and your look does not
cover it.

**Check.** `staged.txt` names the commit and the date of the build that made the candidate.

## Terms of use

Every source is for the whole team, and for Claude, unless its row in the map says otherwise; a
source with stated terms also carries a `README.md` in its folder in `raw/` that repeats them. Where
the terms bar outside services, AI providers included, Claude is told to open none of the source's
files and to say so when a task would read one. No setting enforces this. [Working with
Claude](claude.md) says what Claude sends when it reads a file.

No data ever enters git, a table made by hand included. The repos' ignore rules leave out the usual
data file types (`.dta`, `.csv`, `.xlsx` and the like) and the working folders `temp/` and `logs/`,
so they are never among the changed files Claude or GitHub Desktop lists. Any other data file
listed there is never committed: move it out of the repo's folder.
