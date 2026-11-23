# Have your code and your paper reviewed

Claude reviews against every item of the project's `checklist.md`. A review reads: it runs nothing and changes nothing.

**Ask Claude.** In the project, for the code:

```prompt
Review my code.
```

For the paper, first ask "Run everything.", because only a full run in this session shows Claude that the exhibits are current. On Windows, with R steps, [you start that run yourself](work-with-r-steps.md#run-the-project-on-windows). Then:

```prompt
Review my paper.
```

```prompt
Do the numbers in my paper match the tables?
```

Claude opens each exhibit and checks every number typed in the text: its value, its units and its scale.

## Read the report

Findings come first, each with the file and line, the checklist item, and what to change. Then every item of `checklist.md` is marked **holds**, **finding**, or **not judged** with the reason.

**Only you do.** Say which findings Claude should fix.

## Before submission: what people do

Four checklist items need a person. No program enforces them, and Claude's review marks them **not judged**.

- A colleague other than the author reruns the project from a fresh clone and matches the main results.
- A person reads the PDF in full, and the checklist names who and when.
- An author records the licences in `decisions.md`, by their own hand.
- The data curator [assembles the replication package](../curator/assemble-a-replication-package.md) and tests it.
