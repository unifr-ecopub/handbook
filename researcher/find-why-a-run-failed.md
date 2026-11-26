# Find out why a run failed or a number looks wrong

When a run ends `Failed:`, or an exhibit is not what you expect, Claude finds the cause before it changes any code.

## Ask Claude for the cause

**Ask Claude.** In the project:

```prompt
The run failed: why?
```

```prompt
This number looks wrong.
```

Claude reads the run's log, makes the fault appear again through `master.do`, and looks at the data with explore files, counts first. Before its first explore file, and before it reads more of a log than its command, the line that says how it ended and Stata's error, it reads the `README.md` and terms of each source that the step reads. It reports the cause: the file, the line, and what happens there. On Windows, with R steps, [you start each run yourself](work-with-r-steps.md#run-the-project-on-windows).

**Claude will ask you.** The value you expected, if neither the log nor git shows it.

**What can go wrong.** An explore file can print rows of the data into the session. A source is restricted if its terms bar outside services, or its `README.md` says not to open its files; "chair only" alone is not. For [a restricted source](../data/terms-of-use.md#sources-that-may-not-reach-an-outside-service), Claude's instructions allow only counts, and of a log only the line that says how it ended, Stata's error and counts. Where the cause needs the records, Claude says so and stops. These are instructions, not a lock.

## Decide what Claude proposes

Claude proposes the smallest change at the cause, and waits for your word.

- **A fault in the code.** Say yes, and Claude changes it.
- **A scientific choice,** such as which rows to keep. Claude lists the options and adds an Open question to [`decisions.md`](record-a-scientific-choice.md).
- **A fault in a raw delivery.** A cleaning step corrects it, under a D-number.
- **A fault in a version.** Only the data curator can correct it, in a new version.
- **A command that Stata does not know** (`command <name> is unrecognized`). The project lacks a package: see [Add a Stata package to a project](add-a-stata-package.md).
- **A fault of the machine,** when the run stops before any step, as on the data root or R. Claude checks the machine as in [Set up your machine](../start/set-up-your-machine.md#let-claude-check-the-machine-and-run-everything).

## Check the fix

A full run that fails during a step has cleared `temp/` and `paper/results/`: do not commit that state; the next full run makes the exhibits again. A run that stops on a check before the steps (Stata's version, the guard, `ado/`, the data root, `pins.do`, old-folder checks, software checks, or the step or explore name) clears nothing in `temp/` or `paper/results/`. Where a stop happens before `master.do` opens a dated log in `logs/` (any check before the step name), Claude reads the `Failed:` line in Stata's batch log in `code/` (`master.log`, or the step's `.log`), or asks what Stata displayed in its window.

**Check.** The step ends `Step complete`. A full run then ends `Run complete`, and Claude names each exhibit that changed.

The sentence after `Failed:` often says what to do: see [Messages of a project run](../reference/messages-project-run.md). Never type a command that [Stata's own message](../reference/messages-project-run.md#during-the-steps) proposes.
