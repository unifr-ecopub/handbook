# Start a new project, or get one onto your machine

## Start a new project

**Only you do.** Give the data curator the project's bare name and nothing more. The names `data`, `data-processing`, `handbook` and `project-template` are taken. The data curator [makes the repo from the template](../curator/manage-repos-and-people.md#create-a-project-repo-from-the-template).

## Get a project of the chair onto your machine

**Ask Claude.** In a project that you already have:

```text
Get me the project <name>.
```

Claude clones the project and tells you where the clone is. You clone only [the first repo on a machine](../start/set-up-your-machine.md#clone-your-first-repo) yourself.

**Claude will ask you.** Once, the folder where you keep your projects. It refuses a folder inside Dropbox, OneDrive or another project.

**Untested on Windows.** Claude clones with Git for Windows. If git is missing, Claude says so, and you install it.

## Open the new clone and run everything

1. Open a new session on the new clone's top folder.
2. Claude Code asks whether you trust this folder. Accept. Unless you accept, Claude Code ignores the repo's permission rules.
3. Ask "Run everything." On Windows, with R steps, [you start the run yourself](work-with-r-steps.md#run-the-project-on-windows).

**Check.** The run ends `Run complete`, and no file of the repo changed. If exhibits changed, your run differs from the committed results, and Claude names them before any commit.
