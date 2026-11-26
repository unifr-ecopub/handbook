# Work on a project with R steps

`master.do` runs R steps as it runs Stata steps.

**Untested on Windows.** So far, no R step was run on a Windows machine.

| Task | Who |
|---|---|
| Install R at the project's version | You |
| Find R on the machine, and restore the R packages | Claude |
| Start a run on Windows | You, in Stata's window |
| Try a step in RStudio | You |

## Add the first R step

**Ask Claude.** In the project:

```prompt
I want to write my first R step.
```

**Claude will ask you.** Before the first R step, two things. Does the machine have the R version that `code/templates/r-project/renv.lock` names, and is the network on? With your yes, Claude sets the project up for R. From then on, the project's own `renv.lock` names the version.

## Run the project on Windows

On Windows, Claude cannot start the run if the project has R or Python steps: not a full run, not a single step, not an explore file.

**Only you do.**

1. In Explorer, double-click `code/master.do`.
2. In Stata's do-file editor, click **Do**.
3. Tell Claude what Stata showed.

For a single step, Claude tells you what to type in Stata's window. Claude still restores the R packages itself.

## Try a step on its own in RStudio

**Only you do.** Open `project.Rproj` in RStudio and run the step line by line. Take results from a full run only.

## When master.do says R is not ready

[R steps](../reference/messages-project-run.md#r-steps) quotes each message.

- **R was not found, or is another version.** Claude looks on the machine for the right R. If it finds one, it asks whether it may write one line that names it into your Stata `profile.do`. On Windows, you then close Stata and start the run in a new Stata window. If the machine has no such R, only you install it.
- **The packages are missing,** as in a fresh clone. Claude restores them. The message says to type a command in R: leave that to Claude.
- **The project has no `renv.lock`, or it names no repository called RENV.** Claude sets up or repairs the project's R files.

**Untested on Windows.** The place of `profile.do` there, `C:/Users/<you>/profile.do`, follows Stata's documentation.

## Add an R package, or take the packages of another date

**Ask Claude.** In the project:

```prompt
Install the R package <name>.
```

```prompt
Use the packages of <date>.
```

Claude installs through `renv` and writes the change into `renv.lock`; no step installs a package. For another date, it changes only the address of the dated package snapshot, so an old project can keep its package versions. A package of an older date may not build on today's R: Claude names it and asks.

## After a change to the packages

After any change to `renv.lock`, Claude restores the packages once in a fresh copy of the project under `temp/`, and checks R there (and in a project with Python steps too, restores Python in the same copy). On Windows, it asks you to run that check in Stata's window. Only then does Claude say that the change works.

**Check.** Claude says what the check showed. The changed `renv.lock` is committed with the step that needs it.
