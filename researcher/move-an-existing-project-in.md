# Move an existing project in

Claude turns an old project's code into steps of a new repo, runs them, and compares the new exhibits with the old ones. You need [a fresh repo for the project](start-or-get-a-project.md), cloned, and the old folder's full path.

## Ask Claude to bring it in

**Ask Claude.** In the new project, with the path:

```prompt
Bring my old project in from this folder.
```

Claude changes nothing in the old folder and copies no data into the project. The moved code computes what it computed before, and a seed that the old code sets stays. There is one exception. Every R step here sorts text in one fixed order, so R code that depends on that order may differ.

**Claude will ask you.** Everything at once, beside its plan of which old file becomes which step.

- Whether it matched the right shared files, and which folder holds the old tables and figures.
- Whether it may copy your tables made by hand and your Stata packages.
- Whether a colleague uses a dataset that this project makes.
- With R: whether the project's R version is installed, and what to do where code depends on the order of text.
- For each scientific choice and each seed in the old code: keep it, or change it?

What you cannot answer stays Open in `decisions.md`.

## Read the comparison

**Check.** A full run ends `Run complete`. Claude reports each difference between an old and a new exhibit with both values, and says what it knows about the cause.

With R steps, Claude also names each exhibit whose row or column order changed. It tests the packages [in a fresh copy](work-with-r-steps.md#after-a-change-to-the-packages) before it calls the project moved. On Windows, [you start each run yourself](work-with-r-steps.md#run-the-project-on-windows).

## Finish what stays open

- **An input that the data root lacks.** The data curator adds it, and the steps that read it wait.
- **Data that the old project built for others.** It becomes a build, about half a day's work with the data curator.
- **The README.** Claude proposes its text: the project's name, what it studies in one sentence and who works on it. Give the names, and confirm the text.
- **Rule gaps in the old code.** Claude lists them. Ask for [a code review](review-code-and-paper.md) next.
