# Update a project from the template

A project is made from `project-template` once. A later change to the template, such as new rules for Claude or a changed chair program, reaches the project only when you ask. Claude then compares the project's files with the template as it stands now, and brings across what differs. A first update and a later one go the same way, and no record of an update is kept.

This is not how you read a new version of a dataset: see [Move to a new version of a dataset](move-to-a-new-version.md). Your colleagues' work comes with "Pull.".

## Ask Claude for the update

**Only you do.** Start with no changed file: commit what you want to keep, or discard it. If git lists a changed file, Claude names it and stops.

**Ask Claude.** In the project, when the data curator says that the template changed:

```prompt
Update the platform.
```

A project made before 26 November 2026, and not updated since, holds an older version of these instructions, or none. Its first update is asked for in words that send Claude to the instructions of the template it fetches:

```prompt
Please update this project from the template. Fetch project-template from our own GitHub organisation, the same place this project comes from, and follow the update-from-template skill that comes with the template you fetched.
```

If you do not know when the project was made, use this longer request.

Claude fetches the template from the chair's own organisation on GitHub. If nothing differs, it says that the project is up to date and changes nothing.

## Answer what Claude shows you

**Claude will ask you.** For your yes, after it shows:

- which files change, which are new and which go, each with what it brings;
- where you edited one of the template's own files, that your edit is replaced;
- each edit it proposes to `code/master.do`, outside your project's block, and to the files a project fills in: `README.md`, `decisions.md`, `checklist.md`, `replication/README.md` and `.gitignore`;
- a pull first.

The template's own files come together: they are `.claude/`, `AGENTS.md`, `CLAUDE.md`, `.gitattributes`, `ado/`, `code/_config.R`, `code/_config.py`, `code/templates/`, the three example files in `code/explore/` and `temp/README.md`. Say yes, and Claude takes them all; say no, and it takes none. You may decline any proposed edit of a file that the project fills in. Claude never changes your steps, your other explore files, `code/pins.do`, `code/legacy/`, `docs/`, `paper/`, the R and Python files in the project's top (such as `renv.lock` and `uv.lock`), a Stata package you added to `ado/`, your project's block in `master.do`, or the text and rows that your project wrote. A scientific choice it asks you, and never proposes.

## Check the result

Claude pulls, takes the files, makes the edits you agreed to, and runs everything. On Windows, with R or Python steps, [you start that run yourself](work-with-r-steps.md#run-the-project-on-windows).

**Check.** The run ends `Run complete`, and Claude names each exhibit that changed, is new or is gone, with the change of the template that may explain it. Nothing is committed until you ask "Commit and push.".

**What can go wrong.** A file of the template that goes may still be used by one of your steps. Claude names each such step before you answer, and that step fails until it is changed, afterwards, as a task of its own.

**Untested on Windows.** Nobody has yet updated a project on a Windows machine.
