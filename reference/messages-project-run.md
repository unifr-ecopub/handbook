# Messages of a project run

The messages that a project run prints, and who acts after each. `<…>` marks a part that varies. Claude reads the log for you: ask "Did my run finish?"

On a new machine, you first meet [the data root was not found](#before-anything-runs-the-machine-checks). Where a line says to ask Claude for a run, [you start it yourself](../researcher/work-with-r-steps.md#run-the-project-on-windows) on Windows with R steps.

## How a run ends

```mermaid
flowchart TD
  L["The last line of the run"] --> A{"Which line?"}
  A -->|"Run complete"| B["A full run finished. Results count."]
  A -->|"Step complete"| C["One step finished. Results do not count yet."]
  A -->|"Failed:"| D["The sentence says what stopped. Ask Claude why."]
  A -->|"none of these"| E["The run did not finish."]
```

```text
Run complete. Exhibits and the results page: <folder>
Step complete: <step>
Failed: <step> (r(<code>))
```

After the third line, ask Claude ["The run failed: why?"](../researcher/find-why-a-run-failed.md)

## Before anything runs: the machine checks

A run that stops here deleted nothing and wrote no dated log.

```text
Failed: Stata is not in this project's code folder, so nothing was run: double-click master.do in the project's code folder in Explorer and click Do, or cd into that folder and type  do master.do  (not File > Open).
```

**You:** close Stata and ask Claude to run.

```text
Failed: the data root was not found: the file <file> is missing or empty. Write one line into that file, the full path of the data root on this machine (chair-research-data on Dropbox), as in C:/Users/<you>/Dropbox/chair-research-data (r(601))
```

**You:** tell Claude "It says the data root was not found." and give it the path. Claude writes the file.

```text
Failed: R is not ready for this project, for the reason just above. If no R was found: install R at the version renv.lock names, or, where it is installed in a folder of your own, put the line  global RSCRIPT_PATH <path to Rscript, in double quotes>  into your Stata profile.do (r(601))
```

**Claude:** finds R and restores the packages. See [When master.do says R is not ready](../researcher/work-with-r-steps.md#when-masterdo-says-r-is-not-ready).

## The pins

```text
Failed: pins.do pins raw/<delivery>, which is not in the data root, <folder>. Check the line in pins.do; if it is right, let Dropbox finish syncing (r(601))
```

**You:** check the delivery's name with the data curator, or wait for Dropbox.

## Loading a dataset

`chair_use` prints these, with slightly other words in an R step.

```text
chair_use: <dataset>/<file> v<N>
```

The file was loaded at this version.

```text
chair_use: pins.do pins no version of <dataset>. Add the line  global pin_<dataset> "v<N>"  to code/pins.do.
```

**You:** say which version the project should read.

```text
chair_use: <dataset> v<N>, which pins.do names, has no manifest in the data root (<folder>).
  Check the version on its line in code/pins.do. If it is right: Let Dropbox finish syncing and run again: it delivers large files late.
chair_use: <dataset> v<N> holds no file <file>.dta here (<folder>). Check the name; if it is right: Let Dropbox finish syncing and run again: it delivers large files late.
```

**You:** check the version or the name in [the data map](../data/data-map.md), then wait for Dropbox.

## During the steps

```text
Failed: the file <file> cannot be erased: close it where it is open, as in Excel, and run again (r(<code>))
```

**You:** close the file, then ask for the run again.

```text
This step needs this project's settings, which master.do sets: from this project's code folder type  do master.do <folder>/<this file>  (after that, its lines also run on their own in the same Stata).
```

A step was started on its own. **You:** ask Claude to run it.

A step can stop with Stata's own message that a command is unknown:

```text
command <name> is unrecognized
```

**You:** tell Claude, which names the package and asks whether to [put it into `ado/`](../researcher/add-a-stata-package.md).

A step can also stop with Stata's own message `grmap not yet activated`, and the advice to type `grmap, activate`. Never type it: in Stata's window it writes to a folder that no run reads. **You:** tell Claude, which activates the command inside the project, with your yes.

## R steps

```text
This project needs R <version> (renv.lock); this is R <version>. Install R <version>; where it is not the R that Stata finds, put the line  global RSCRIPT_PATH "<path to its Rscript>"  into your Stata profile.do.
This clone's R packages are not installed yet: once, in R, in the project folder, type  renv::restore()  and run again.
```

**Claude:** looks for the right R, and restores the packages. You type nothing in R. **You:** install R only if the machine lacks that version.

```text
This project has R steps and no renv.lock: copy what is in code/templates/r-project/ into the project folder; then, once, in R, in the project folder, type  renv::restore()  and run again.
```

**You:** tell Claude what the run says, and it [sets the project up for R](../researcher/work-with-r-steps.md#add-the-first-r-step). You type nothing in R.

```text
renv.lock names no repository called RENV, from which renv installs itself, so a fresh clone on another machine cannot install renv or restore the packages, though this machine runs: put the RENV entry back among the Repositories of renv.lock as code/templates/r-project/renv.lock has it, and run again.
```

**You:** ask Claude to put the entry back.

```text
This R runs on its own, outside master.do: exhibits are overwritten. Results for the paper come from a full run of master.do.
```

You ran a step in RStudio. Report no result from it.
