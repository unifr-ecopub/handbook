# Find out why a run failed or a number looks wrong

When a run ends `Failed:`, or an exhibit is not what you expect, Claude finds the cause before it changes any code.

## Ask Claude for the cause

**Ask Claude.** In the project:

```text
The run failed: why?
```

```text
This number looks wrong.
```

Claude reads the run's log, makes the fault appear again through `master.do`, and looks at the data with explore files. It reports the cause: the file, the line, and what happens there. On Windows, with R steps, [you start each run yourself](work-with-r-steps.md#run-the-project-on-windows).

**Claude will ask you.** The value you expected, if neither the log nor git shows it.

**What can go wrong.** An explore file can print rows of the data into the session, also for [a source that bars outside services](../data/terms-of-use.md#sources-that-may-not-reach-an-outside-service).

## Decide what Claude proposes

Claude proposes the smallest change at the cause, and waits for your word.

- **A fault in the code.** Say yes, and Claude changes it.
- **A scientific choice,** such as which rows to keep. Claude lists the options and adds an Open question to [`decisions.md`](record-a-scientific-choice.md).
- **A fault in a raw delivery.** A cleaning step corrects it, under a D-number.
- **A fault in a version.** Only the curator can correct it, in a new version.

## Check the fix

A failed run has deleted exhibits. Do not commit that state: the next full run makes them again.

**Check.** The step ends `Step complete`. A full run then ends `Run complete`, and Claude names each exhibit that changed.

The sentence after `Failed:` often says what to do: see [Messages of a project run](../reference/messages-project-run.md). Never type a command that [Stata's own message](../reference/messages-project-run.md#during-the-steps) proposes.
