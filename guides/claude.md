# Working with Claude

This guide is for anyone at the chair who has not worked with Claude Code, the professor
included: what it does on this platform, what it never does, and how you keep control. Claude
commits and pushes when you ask, and never on its own; it asks before `release.do`. Scientific
choices are yours, and Claude writes them into `decisions.md`. Setting up a machine and the daily
routine are in the [researcher's guide](researcher.md); the curator's tasks are in the
[curator's guide](curator.md).

## What Claude Code is here

Claude Code is a program on your machine. You open it on the folder of one repo, for example
`C:/Users/<you>/GitHub/<project>/`. It reads and writes that repo's files, runs Stata for you,
reads the log, and tells you what happened. On Windows it cannot start a run of a project with R
steps: you start it in Stata's window and tell Claude what Stata showed (the
[researcher's guide, section 8](researcher.md#8-a-project-with-r-steps)). You use it in the
desktop app (the **Code** tab) or from the command line; both read the same settings.

**The folder matters.** Each repo holds its own instructions for Claude: `CLAUDE.md`; in a
project, also the rules in `.claude/rules/`; the skills in `.claude/skills/` (written procedures
for tasks such as a code review), in a project and in `data-processing`; and the settings in
`.claude/settings.json`. Claude reads the repo's settings, which say which commands it runs
without asking (in a project, `code/master.do`) and, in `data-processing`, that it asks before
`release.do`, only from the folder the session opens. So open the repo's own folder: never `code/`
inside it, and never a folder on Dropbox.

**Outside the repo,** the platform's tasks have Claude read and write these, and what it reads
is sent to Anthropic's servers ([Data and outside services](#data-and-outside-services));
nothing in the repos' settings stops it from reading other files:

- **The data root.** Claude lists its folders and reads a source's `README.md`, a version's
  `manifest.txt` and `WITHDRAWN`, and `staged.txt`; for a new delivery or build, the first lines of
  each text file (unless the source's terms keep its records from outside services), and the
  register's list. Stata, which Claude starts, reads the shared data through the pins. In
  `data-processing` the runs Claude starts write there: a build writes review sheets and the
  candidate in `intermediate/<dataset>/`, and `release.do`, after the curator's Yes, a version in
  `processed/`. In a project, with your yes, Claude copies a table you made by hand into
  `intermediate/<project>/`: a copy, so the original stays, and never over a file already there.
  No other task has Claude write, move or delete a file there itself.
- On a new machine Claude writes one line, the data root's path, into
  `C:/Users/<you>/chair-research-data.txt`, and only once you give it the path.
- In a project, it reads the data map in a clone of `data-processing` beside it, if there is
  one. To bring an old project in, it reads the old folder and changes nothing there; to copy a
  Stata package into a project, with your word, it reads your own Stata's package folder, and to
  fetch one, with your word, it downloads it from SSC into the project's `ado/`.
- For the curator, it reads the project's clone, copies files out of the data root into a
  replication package, and writes the package, and a copy to test it in, into new folders outside
  every clone; when asked, it copies a changed chair program into `project-template/ado/c/`.
- Claude Code keeps a plain-text copy of each session in `C:/Users/<you>/.claude/projects/`, for
  30 days by default, and there too the notes it writes for itself. Your own settings are in
  `C:/Users/<you>/.claude/settings.json`.

## A first session

**Ask Claude.** Open a session on your project's folder, `C:/Users/<you>/GitHub/<project>/`. In the
desktop app's **Code** tab, in the row under the prompt box, select the top entry in the **Local**
group of the environment selector (your clone and Stata are on this machine), then the folder with
the project folder control, and check that the mode selector shows **Auto** (below). On the command
line, go to the folder and type `claude`. Then type "Run everything."

**Claude will ask you.** Usually nothing. On a new machine Claude quotes the sentence Stata
printed and asks for the full path of the data root (the
[researcher's guide, section 1](researcher.md#1-set-up-your-machine-once)).

**Only you do.** After a task that changed files, look at the files Claude lists and its one-line
summary (GitHub Desktop's **Changes** shows each changed line), then, if you want them on GitHub,
ask: "Commit and push."

**Check.** Claude quotes the run's last line. After a first full run in a fresh clone GitHub
Desktop lists no file, so there is nothing to commit; if it lists exhibits, they differ from the
committed ones, and Claude says which. After "Commit and push.", Claude lists the files it
commits and says that it has pushed.

## What you can ask

**In a project**, on `C:/Users/<you>/GitHub/<project>/`, ask in your own words, for example
(where a task uses a skill, Claude says which):

- "Run everything." or "Run only the step that makes the main table." Before one step, Claude
  says whether an earlier step or `code/pins.do` changed since your last full run and proposes
  to run everything first; you decide.
- "Did my run finish?" Claude reads the log and says how it ended.
- "Write a step that merges the finances with the population." Scientific choices stay yours:
  Claude asks you each one and records your answer in `decisions.md`.
- "The run failed: why?" or "This number looks wrong." Claude finds and explains the cause, with
  the file and the line, before it changes anything, and changes code only on your word.
- "Move to the new version of the register." Claude changes its line in `code/pins.do` and runs
  everything.
- "Review my code.", "Review my paper." or "Do the numbers in my paper match the tables?"
  Claude checks every step, or the text and each typed number, against every item of
  `checklist.md`. A review changes nothing; each finding quotes its line or sentence.
- "Bring my old project in from this folder." Claude copies your old do-files and R scripts in
  as steps, runs them, and compares each table and figure with the old one. It asks whether to
  keep or change each scientific choice and seed of the old code, and writes each into
  `decisions.md`: under Decided where you answered, under Open where you did not, the old code
  kept meanwhile.
- "Commit and push." Claude lists the changed files, commits them to `main` with its one-line
  summary, pushes, and says so. Where exhibits changed and no full run made them, it proposes to
  run everything first; you decide.
- "Pull.", "This is a new computer.", "My push was rejected." or "There is a conflict." In a
  conflict Claude shows both versions of each file and asks you which to keep.

**In `data-processing`**, the curator's and the assistants' repo, Claude records a new delivery
in the data map, says where a table made by hand goes, starts a build from a source, runs a
review round, releases versions, drafts the reason for withdrawing one, and assembles a
replication package. There the commit and the push are still the curator's, in GitHub Desktop.
The requests, and what you answer, are in the [curator's guide](curator.md).

## What stays yours

- **Scientific choices.** A sample, a threshold, a boundary year, a clustering level. Claude
  asks and proposes; the choice is yours, and Claude writes it down. A question you have not
  answered stays under Open in `decisions.md`, and code that needs it waits. A choice you state in
  plain words Claude records under Decided, with your words quoted, the name you give and the
  date, and tells you its D-number. If you hand a choice to Claude, it records it as Provisional
  until you confirm it. A licence stays under Open until an author writes the row by their own
  hand.
- **When to commit and push.** Claude does both only when you ask. In `data-processing` the
  curator commits and pushes, in GitHub Desktop.
- **A delivery copied into `raw/`**, by the curator, in Explorer.
- **A review sheet**, filled in Excel by an assistant or the curator: each decision in it is a
  person's.
- **A table made by hand**, made and changed by whoever made it. In a project Claude copies it
  into `intermediate/<project>/`, with your yes.
- **Yes before a release**: Claude shows the command and waits for your word.
- **The statement on AI tools a journal asks for.** `checklist.md` asks, before submission,
  that the target journal's policy on AI tools be checked and the manuscript make the statement
  it requires.

## What Claude does only when asked, what it never does, and how that is held

| Claude | In a project and in `handbook` | In `data-processing`, today | How it is held |
| --- | --- | --- | --- |
| commits and pushes; pulls; settles a rejected push and a conflict | only when you ask, never on its own; in a conflict it asks which version to keep and waits | never: the curator pulls, commits and pushes in GitHub Desktop | The repo's `CLAUDE.md` says so; `data-processing`'s settings also refuse `git add`, `git commit` and `git push` |
| runs `release.do` | (no such step) | only after the curator's Yes, asked each time | `data-processing/CLAUDE.md` says to ask first, and its settings hold an ask rule for that command |
| copies a table made by hand into `intermediate/` | in a project, after your yes: a copy, never over a file already there, and never edited | never: the person saves it there | The repo's `CLAUDE.md` and, in `data-processing`, the skill `add-delivery` |
| force-pushes, makes a branch, rewrites commits already pushed, or commits a file you have not seen listed | never | never (it commits nothing) | The repo's `CLAUDE.md`; the automatic mode also blocks a force push by default |
| writes under `raw/` or `processed/`, or edits a review sheet | no task does | never: its `CLAUDE.md` says so | `data-processing`'s settings also refuse edits under `chair-research-data/raw/` and `chair-research-data/processed/` |

**The settings are tripwires, not a wall.** A rule matches the text of a command: the same
thing written another way, or done inside a script, gets past it, and the two folder rules of
`data-processing` match only a data root named `chair-research-data`. What protects the shared
pieces is GitHub's history and roles (every pushed change can be seen and undone, and only the
curator, with the assistants for `data-processing`, can write a shared repo) and the view-only
folders of the data root.

## How Claude tells you how a run ended

Stata's batch mode reports success whatever happens. So after each run Claude reads the newest
log in the folder Stata ran in, written by its own command, and quotes the last of these lines:

```text
Run complete. Exhibits and the results page: <folder>
Step complete: <step>
Failed: <step> (r(<code>))
```

Some stops come before any step runs: `Failed:` and one sentence that says what to do. No such
line means the run did not finish, and Claude says so. For a run you started yourself in
Stata's window, Claude asks what Stata showed. In `data-processing` a build's lines differ a
little (the [curator's guide](curator.md#release-a-version) gives them), and a release ends
with one of these:

```text
Released <dataset> v<N> to <folder> (build commit <commit>).
<the reason>. Nothing was released.
```

In a project, when you ask why a run failed, Claude finds the cause and changes no code without
your word (the skill `diagnose`). While it writes a build or moves a project in, it fixes slips of
its own and asks about anything else. A single step is not a full run: results for the paper come
from "Run everything."

## How you keep control

- **In a project, Claude says what it does** in one plain sentence, and its plan in two or three
  lines before a task of several steps; elsewhere, ask for it. If it is not what you meant, say so.
- **Stop it at any time.** In the desktop app, click the stop button or press `Esc`; on the
  command line, press `Esc`. Claude keeps what it has done so far: then say what you want.
- **Undo a change you do not want** in GitHub Desktop: under **Changes**, right-click the file,
  choose **Discard Changes** and confirm. It goes back to its last commit; a new file is removed.
- **For a larger change, choose Plan in the mode selector** first: Claude reads and proposes a
  plan without editing the code. Switch back to Auto to carry it out.
- **Look at every changed file before you ask for the commit:** Claude lists them, and GitHub
  Desktop's **Changes** shows each changed line. Nothing reaches github.com until Claude pushes,
  when you ask.
- **Read `decisions.md`.** Each row Claude says it recorded for you holds your own words, the
  name you gave and the date. Each step names in its header the decisions it applies.

Claude can be wrong. That is why the choices, the review and the word to commit stay with you.

## The permission mode

Researchers use the automatic mode, **Auto**: Claude works without asking before each command,
and a separate check reviews commands before they run. The repo's settings still hold in it:
what they refuse stays refused, and `release.do` still asks. The mode itself blocks a force push
by default. A repo cannot switch Auto on, so you set it once per machine in your own Claude
settings, as the
[researcher's guide, section 1](researcher.md#1-set-up-your-machine-once) shows. In the desktop
app, a mode picked in the selector is remembered per folder, so check that it shows **Auto**
before your first message; the command line shows `auto mode on`. If a session does not start
in Auto, tell the curator.

## Data and outside services

Claude Code runs on your machine, but to answer it sends the conversation to Anthropic's
servers. That includes what Claude has read: lines of a file, a log, what a command printed. A
Stata log holds what a step listed or tabulated. What Anthropic keeps, and for how long, depends
on the kind of account; its page on data usage, <https://code.claude.com/docs/en/data-usage>,
says how.

So every source is open to the team and to Claude unless its row in the data map says
otherwise. For a source whose terms bar outside services, AI providers included, its row in the
map and the `README.md` in its folder state the terms. Claude is told to open none of its files,
and to say so when a task would read one; no setting enforces this. The [data guide](data.md)
explains terms of use.

## Where Claude is not assumed

A replication package runs without Claude. A journal's replicator follows the package's README
with Stata, and R where the project has R steps: `master.do`, and the builds that rebuild a
dataset, need no Claude. The curator assembles the package with Claude (the
[curator's guide](curator.md#assemble-a-replication-package)).
