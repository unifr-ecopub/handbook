# Have your code and your paper reviewed

Claude reviews against every item of the project's `checklist.md`. A review reads: it runs nothing and changes nothing.

**Ask Claude.** In the project, for the code:

```prompt
Review my code.
```

For the paper, first ask "Run everything.", because only a full run in this session shows Claude that the exhibits are current. On Windows, with R or Python steps, [you start that run yourself](work-with-r-steps.md#run-the-project-on-windows). Then:

```prompt
Review my paper.
```

```prompt
Do the numbers in my paper match the tables?
```

Claude opens each exhibit and checks every number typed in the text: its value, its units and its scale.

## Read the report

Findings come first, each with the file and line, the checklist item, and what to change. Claude then marks every item of `checklist.md` as **holds**, **finding**, or **not judged** with the reason. If the results page marks the exhibits as provisional (inputs still read from an old folder), a paper review leads with that. A code review leaves `code/legacy/` out and says so.

**Only you do.** Say which findings Claude should fix.

## Before submission: what people do

Some checklist items need a person. No program enforces them, and Claude's review marks as **not judged** what the files cannot show:

- A colleague other than the author reruns the project from a fresh clone and matches the main results.
- Someone checks each statement about a cited paper against that paper.
- Someone reads the target journal's policy on AI tools, and the paper makes the statement it requires.
- A person reads the PDF in full, and the checklist names who and when.
- An author records the licences in `decisions.md`, by their own hand.
- The data curator [assembles the replication package](../curator/assemble-a-replication-package.md) and tests it. Ask the data curator when the paper is ready to submit: Claude in your project assembles no package.
