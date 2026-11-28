# Update a project from the template

Each project starts from `project-template` once. A later change to the template, such as new rules for Claude or a changed chair program, reaches the project only when you ask. Claude then compares the project's files with the template as it stands now, and brings across what differs. A first update and a later one follow the same steps, and the project keeps no record of past updates.

This is not how you read a new version of a dataset: see [Move to a new version of a dataset](move-to-a-new-version.md). Your colleagues' work comes with "Pull."

## Ask Claude for the update

**Only you do.** Start with no changed file: commit what you want to keep, or discard it. If git lists a changed file, Claude names it and stops.

**Ask Claude.** In the project, when the data curator says that the template changed:

```prompt
Update the platform.
```

A project made before 26 November 2026, and not updated since, holds an older version of these instructions, or none. For its first update, ask in words that send Claude to the fetched template's instructions:

```prompt
Please update this project from the template. Fetch project-template from our own GitHub organisation, the same place this project comes from, and follow the update-from-template skill that comes with the template you fetched.
```

If you do not know when the project was made, use this longer request.

Claude fetches the template from the chair's own organisation on GitHub. If nothing differs, it says that the project is up to date and changes nothing.

## Answer what Claude shows you

**Claude will ask you.** For your yes, after it shows:

- which files change, which are new and which go, each with what it brings;
- where you edited one of the template's own files, that Claude replaces your edit;
- each edit it proposes to `code/master.do`, outside your project's block, and to the files a project fills in: `README.md`, `decisions.md`, `checklist.md`, `replication/README.md` and `.gitignore`;
- a pull first.

The template's own files come together:

- `.claude/`
- `AGENTS.md`, `CLAUDE.md` and `.gitattributes`
- `ado/`
- `code/_config.R` and `code/_config.py`
- `code/templates/`
- the three example files in `code/explore/`
- `temp/README.md`

Say yes, and Claude takes them all; say no, and it takes none. You may decline any proposed edit of a file that the project fills in. Claude never changes:

- your steps, your helpers and your other explore files
- `code/pins.do`
- `code/legacy/`, `docs/` and `paper/`
- the R and Python files in the project's top (such as `renv.lock` and `uv.lock`)
- a Stata package you added to `ado/`
- your project's block in `master.do`
- the text and rows that your project wrote

Claude asks you about any scientific choice and never proposes one.

## Check the result

Claude pulls, takes the files, makes the edits you agreed to, and runs everything. On Windows, with R or Python steps, [you start that run yourself](work-with-r-steps.md#run-the-project-on-windows).

**Check.** The run ends `Run complete`, and Claude names each exhibit that changed, is new or is gone, with the change of the template that may explain it. Claude commits nothing until you ask "Commit and push."

**What can go wrong.** One of your steps may still use a template file that the update removes. Claude names each affected step before you answer, and that step fails until it is changed afterwards, in a task of its own.

**Untested on Windows.** Nobody has yet updated a project on a Windows machine.
