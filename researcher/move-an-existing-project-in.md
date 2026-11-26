# Move an existing project in

Claude turns an old project's code into steps of a new repo, runs them, and compares the new exhibits with the old ones. It takes under an hour, and then a full run. You need [a fresh repo for the project](start-or-get-a-project.md), cloned, and the old folder's full path.

## Ask Claude to bring it in

**Ask Claude.** In the new project, with the path:

```prompt
Bring my old project in from this folder.
```

Claude first runs the new project once; if that run stops on the machine, it [checks the machine](../start/set-up-your-machine.md#let-claude-check-the-machine-and-run-everything) first. It changes nothing in the old folder and copies no data into the project. The moved code computes what it computed before, and a seed that the old code sets stays, under its D-number. Two things may still differ, and Claude names them: a package's version, and the order of text in R, since every R step here sorts text in one fixed order.

**Claude will ask you.** Everything at once, beside its plan of which old file becomes which step.

- Whether it matched the right shared files, and which folder holds the old tables and figures.
- Whether it may copy your tables made by hand and your Stata packages, and fetch the packages that your Stata lacks.
- Whether a colleague uses a dataset that this project makes.
- With R: whether the project's R version is installed and the network is on, and what to do where code depends on the order of text.
- For each scientific choice and each seed in the old code: keep it, or change it? And your name, once.

What you confirm or change goes under **Decided** in `decisions.md`, with your words. Every other choice stays as the old code had it, under **Provisional**, "kept from the old project", so the code runs: confirm or overturn each before submission. A licence stays under **Open**.

## Read the comparison

**Check.** A full run ends `Run complete`. Claude reports each difference between an old and a new exhibit with both values, and says what it knows about the cause.

With R steps, Claude also names each exhibit whose row or column order changed. It tests the packages [in a fresh copy](work-with-r-steps.md#after-a-change-to-the-packages) before it calls the project moved. On Windows, [you start each run yourself](work-with-r-steps.md#run-the-project-on-windows).

## Finish what stays open

- **An input that the data root lacks.** The data curator adds it. Until then, the steps that read it wait: they are in the project, but not in the list of steps, so the other steps run to `Run complete`. When it arrives, tell Claude: it puts them back into the list, runs everything and compares again.
- **Data that the old project built for others.** It becomes a build, about half a day's work with the data curator.
- **The README.** Claude proposes its text: the project's name, what it studies in one sentence and who works on it, and no run time. Give the names, and confirm the text.
- **Rule gaps in the old code.** Claude lists them. Ask for [a code review](review-code-and-paper.md) next.
