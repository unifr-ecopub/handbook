# Move an existing project in

Claude moves an existing project from its old folder into [a fresh repo made from the template](start-or-get-a-project.md), in four parts, and reports after each: the notes and old code, the pipeline, the paper and slides, and last the old pipeline files. You need the old folder's full path (in Explorer, click the address bar and copy it).

## Ask Claude to bring it in

**Ask Claude.** In the new project:

```prompt
Bring my old project in from this folder: <path>
```

Claude changes nothing in the old folder and copies no data into the project. Anything marked closed (such as `DO_NOT_OPEN`) stays unopened.

Within minutes, with no question first, your notes and sources are in `docs/` and the old code, unchanged, in `code/legacy/`, a record that Claude never runs or edits. `docs/move-in.md` lists every file and where it went, or that it stays. Claude never copies data, old exhibits, logs, backups or published books and articles.

**Check.** Claude says what came in and what stayed. It commits nothing until you ask.

## The pipeline becomes steps

Claude runs the new project once; if that run stops on the machine, it [checks the machine](../start/set-up-your-machine.md#let-claude-check-the-machine-and-run-everything) first.

**Claude will ask you.** Everything at once, in numbered questions beside its plan of which old file becomes which step. "Don't know" or "skip" is an answer, and Claude says what it leaves undone.

- The data: may the project read an input that the data root lacks from your old folder for now, and what are its terms of use? May Claude copy your tables made by hand?
- The code: did Claude match the right shared files, and may it copy or fetch your Stata packages? With R or Python steps, is the network on?
- The paper: which folder holds the old tables and figures?
- The people: who works on the project, does anyone else use a dataset that it makes, and your name, once.
- Each scientific choice and each seed in the old code: keep it, or change it?

What you confirm goes under **Decided** in `decisions.md`. Every other choice stays as the old code had it, under **Provisional**: confirm or overturn each before submission.

Each pipeline file becomes a step, in the old order. A file that several of them pull in becomes a helper, in `code/helpers/`.

**Check.** A full run ends `Run complete`. Claude reports each difference between an old and a new exhibit with both values, and what it knows about the cause. Two things may differ by design: a package's version, and the order of text in R. On Windows, with R or Python steps, [start each run yourself](work-with-r-steps.md#run-the-project-on-windows).

## Inputs still read from the old folder

With your yes, the project reads an input that the data root lacks where it lies in your old folder, through [an `old_` line in `code/pins.do`](../data/versions-and-pins.md), until the data curator delivers it. Claude's report lists each such input for the data curator. With your no, the steps that read it wait, and the other steps run.

Until the delivery, results are provisional, and Claude says so with every result. Claude treats the input as [restricted](../data/terms-of-use.md#sources-that-may-not-reach-an-outside-service) until you state its terms. When the data curator has delivered it, tell Claude: it reads the delivery instead, runs everything and compares again.

**What can go wrong.** On a machine without the old folder, such as a co-author's, no run starts. No replication package is made while an `old_` line is left.

## The paper and the slides

Claude copies the paper into `paper/draft/` and the slides into `paper/presentation/`, and points each line that reads a table or a figure at the new exhibit. Its report then names what stays open:

- **Data that the old project built for others** becomes a build, about half a day's work with the data curator.
- **The README.** Claude proposes its text; confirm it.
- **Rule gaps in the old code.** Ask for [a code review](review-code-and-paper.md) next.

## The old pipeline files go

An old pipeline file leaves `code/legacy/` once its step gives the old results, after a full run and a commit. Claude asks you once, with how many go and which stay. Git keeps every old file. To ask for it later:

```prompt
Remove the old pipeline files.
```
