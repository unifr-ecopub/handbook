# Your first day: from pull to push

In this tutorial we add one step to a practice project, run it, and push it to GitHub. Nothing in it touches real work.

We need a machine that is [set up](set-up-your-machine.md), and one session on our clone of the practice project.

## 1. Pull

A pull brings in what other people pushed. We say:

```prompt
Pull.
```

Nobody else works on a practice project, so Claude answers that the pull brought nothing.

## 2. Ask for a step and state a choice

A step is one file of code. An exhibit is what a step writes for the paper: a table, a figure or a number. Our step saves one number, and that number is a scientific choice.

```prompt
Write a step that saves one number as an exhibit: the smallest population a municipality needs to be in our sample. I choose 2,000.
```

Claude asks whose name to write beside the decision, and we give ours. Claude then says that our choice is `D1` in `decisions.md`, and that the step is a new file in `code/analysis/`.

## 3. Run one step

```prompt
Run only the step that saves the threshold.
```

Claude may first propose a full run. We answer that one step is enough for now. The run ends with this line:

```text
Step complete: <step>
```

## 4. Run everything and read how it ended

A full run runs every step from empty working files. Results count only after one. A project with R steps [runs differently on Windows](../researcher/work-with-r-steps.md#run-the-project-on-windows).

```prompt
Run everything.
```

```prompt
Did my run finish?
```

Claude reads the log and tells us its last line:

```text
Run complete. Exhibits and the results page: <folder>
```

The results page, `paper/results/README.md`, now lists our number and the step that made it.

## 5. Commit and push

A commit records the changed files with a summary. A push sends the commit to GitHub.

```prompt
Commit and push.
```

Claude pulls, lists the changed files in plain words, and commits them to `main`. Before its first push from this machine, it warns us that GitHub will ask for a sign-in, and waits. We sign in with our GitHub Desktop account. Claude then says that it is pushed.

**Untested on Windows.** If git or the sign-in fails, [GitHub Desktop's buttons](../researcher/fix-a-rejected-push-or-a-conflict.md#if-claude-cannot-use-git-on-your-machine) stand in.

On github.com, the practice project now shows our commit. Read [the daily routine](../researcher/daily-routine.md) next, and the rules in [What never to do](../reference/never-do.md).
