# Move an existing project in

Claude moves an existing project from its old folder into [a fresh repo made from the template](start-or-get-a-project.md), cloned on your machine. You need the old folder's full path (in Explorer, click the address bar and copy it).

The move runs in four parts, and Claude reports each before the next begins:

1. Your notes and old code come in at once (within minutes, with no question first).
2. The pipeline becomes steps that run through `master.do`.
3. The paper and slides come in, repointed to the new exhibits.
4. Claude deletes the old pipeline files from `code/legacy/`.

A pipeline of a few files takes under an hour and one full run. Dozens of files take several sittings, and Claude ends each sitting with what is in and what is left.

Claude never changes, moves or deletes anything in the old folder, and no data file enters the project. The moved code keeps computing what it computed before, and any seed the old code sets stays, under its [D-number](../reference/words.md). Two things may still differ, and Claude names them: a package's version, and text sort order in R. Every R step here sorts text in C order (capitals before small letters and accented letters last).

## Ask Claude to bring it in

**Ask Claude.** In the new project, with the old folder's path:

```prompt
Bring my old project in from this folder.
```

Claude first checks that the project is fresh and runs it once; if that run stops on the machine, it [checks the machine](../start/set-up-your-machine.md#let-claude-check-the-machine-and-run-everything) first. It then copies your notes and sources into `docs/` and all old code unchanged into `code/legacy/`. It leaves out:

- data
- old exhibits and compiled PDFs
- logs, LaTeX build files and zips
- backups and earlier copies of a file
- published books or articles
- files that hold a password or a key
- files over 50 MB
- anything marked closed (such as `DO_NOT_OPEN`)

Claude commits nothing yet.

**Claude will ask you.** Everything at once, beside its plan of which old file becomes which step, how each input will be read and what stays in the old folder:

- For an input whose origin the files do not show: whether you received it as it is, typed it by hand, or whether code built it (and whose code).
- Whether it matched the right shared files in the data root, for any match it could not confirm.
- For each input the data root lacks: whether the project may read it from the old folder for now (provisional), and what its terms of use are (may its records be shown, do they bar outside services).
- Whether it may copy your tables made by hand into `intermediate/<project>/` in the data root.
- Which folder holds the old tables and figures that the paper uses.
- Whether it may copy your Stata packages from your own Stata and fetch from SSC those your Stata lacks.
- For R steps: whether the network is on and whether the machine has the right R version.
- For Python steps: whether the network is on and, if Claude does not find `uv`, whether you will install it.
- Whether anyone else at the chair uses a dataset that this project makes.
- With R: what to do at each place where the code depends on the order of text.
- For each seed and each scientific choice in the old code: keep it or change it, and your name once.
- Who works on this project, for `README.md`.

What you confirm or change goes under **Decided** in `decisions.md`, with your words. Every other choice stays as the old code had it, under **Provisional** ("kept from the old project"), so the code runs. This includes any choice you cannot answer, or a "keep everything" said of all at once. A licence stays under **Open**.

**Only you do.**

- Give the old folder's full path, and install any program the machine lacks.
- On Windows, with R or Python steps, [start each run yourself](work-with-r-steps.md#run-the-project-on-windows).
- State the terms of use of any input read from the old folder.
- Confirm or overturn every provisional choice in `decisions.md` before submission, and record any licence there by your own hand.
- Check the lists Claude reports and ask Claude to commit (and push) when you are ready.

## Check the pipeline, paper and slides

**Check.**

- **Notes and old code.** Claude lists what came into `docs/` and `code/legacy/`, and what stayed in the old folder and why (with anything left closed). It confirms that nothing in the old folder changed, and commits nothing yet.
- **The pipeline.** A full run ends `Run complete` (if the steps together took an hour or more, Claude compares the single runs' exhibits first and starts the full run when you say). Claude compares every new exhibit with the old one (or the final working files where the old project wrote no exhibits). It reports each difference with both values and what it knows about the cause. With R steps, it also names every exhibit whose row or column order changed, and tests the packages [in a fresh copy](work-with-r-steps.md#after-a-change-to-the-packages) before calling the pipeline moved. With Python steps, it runs [the same check after a change to `uv.lock`](work-with-python-steps.md#after-a-change-to-the-packages).
- **The paper and slides.** Claude copies the `.tex` sources, bibliography, style files and hand-drawn pictures into `paper/draft/` and `paper/presentation/`. It repoints `\input{}` and `\includegraphics{}` to `paper/results/` (waiting exhibits keep their old path with `% waiting: <step>`). Where `latexmk` is on the machine, Claude compiles once and says whether it succeeded or which waiting exhibits stopped it. Claude then gives the full report, including the list of inputs for the data curator and any rule gaps left for [a code review](review-code-and-paper.md), and proposes the text of `README.md` for you to confirm.

## Inputs still read from the old folder

When the data root lacks an input and you say yes, Claude pins its path inside the old folder on an `old_<name>` line in `code/pins.do`. Claude then writes this machine's input folder into `old-data-folder.txt` at the top of the project (the old folder itself, unless the old code reads its data elsewhere, in which case Claude asks).

If you say no, or the old folder lacks the input too, Claude still copies the steps that read it (and later steps that read what they save) into the project. It leaves those waiting steps out of `master.do`'s step list, so the other steps run to `Run complete`.

While an input waits for delivery, three rules apply:

- **Provisional results.** While any `old_` line stays in `code/pins.do`, every run's log holds a line that begins `Provisional:`, and, after a full run, `paper/results/README.md` holds a line that begins `**Provisional.**`. With every result it reports while an `old_` line stands, Claude says that the result is provisional and why, and [a paper review](review-code-and-paper.md) leads with it.
- **Terms of use.** The old folder has no `README.md` or terms in the data root, so Claude treats every input read from it as [restricted](../data/terms-of-use.md#sources-that-may-not-reach-an-outside-service) (counts only, never records) until you state its terms.
- **When the data curator delivers the input.** Tell Claude. It replaces the `old_` line with a `raw_` or `pin_` line (or adds the raw pin and puts waiting steps back into the step list in order). It then runs everything, says which results changed and compares again.

**What can go wrong.** Git ignores `old-data-folder.txt`, so on a machine without the old folder (such as a co-author's), no run starts until the data curator delivers those inputs. No replication package is made while `code/pins.do` still holds an `old_` line: `master.do` stops in a replication package that reads from the old folder, and the checklist requires every `old_` line to be gone before submission.

## Old code in code/legacy/ and when originals leave

Claude copies all old code unchanged into `code/legacy/` as a record, and never runs or edits anything there. A pipeline file's original stays there only to read its step against. Claude can delete an original pipeline file once four conditions hold:

- its step is in the step list
- a full run ended `Run complete` since any step or `code/pins.do` last changed
- each exhibit of the step matches the old one, or differs only in a way you accepted in your own words (a step that writes no exhibit is shown by every step that reads what it saves)
- the original is in a commit

Claude deletes the old master with the last original. All other files in `code/legacy/` stay, because no step replaces them.

If the originals were not yet committed when the move finished, Claude says they go after your next commit. Once they are committed (or once waiting steps match later), ask:

**Ask Claude.** In the project:

```prompt
Remove the old pipeline files.
```

**Claude will ask you.** Once, how many originals will go and which stay (with what each waits for). With your yes, Claude deletes those originals and any folders they leave empty, and records the last commit in `docs/move-in.md` (the record of the move) and `code/legacy/README.md`.

**Check.** Claude says what went and what stayed, and that git keeps every original.

## What stays for later

- **Data that the old project built for others.** It becomes a build with the data curator, about half a day together. The move-in does not build shared datasets, and the steps that make those files stay in this project until then.
- **Rule gaps in the old code.** A move-in leaves missing checks (such as a `save` without `isid`, or a `merge` without `assert()` or `logs/qa/`) as they were, so they do not stop a run the old code finished. Ask for [a code review](review-code-and-paper.md) next.
