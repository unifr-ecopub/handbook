# Start a new project, or get one onto your machine

## Start a new project

**Ask Claude.** In a project that you already have, if your GitHub account can create repositories in the chair's organisation:

```prompt
Start a new project <project>.
```

Claude creates a private repo from `project-template` with `gh` and clones it into your projects folder; without `gh` or a sign-in, you make it on github.com with **Use this template** on `project-template`, and Claude clones it once it is there.

**Only you do.** If your account cannot create repositories in the organisation, give the data curator the project's bare name and nothing more. The names `data`, `data-processing`, `handbook` and `project-template` are taken. The data curator [makes the repo from the template](../curator/manage-repos-and-people.md#create-a-project-repo-from-the-template).

Never make a project from a ZIP or `git archive`: a folder without `AGENTS.md` and `.claude/` is not a working project.

## If you created an empty repo on GitHub

**Ask Claude.** In a project that you already have, if a new repo was created without **Use this template**:

```prompt
My new repo is empty.
```

**Claude will ask you.** For your yes before it puts the template's files into the repo (over any `README.md` or `.gitignore` that GitHub wrote). If the repo already holds an old project's files, Claude puts no template file among them: with your yes it renames the folder, starts a new project beside it, and you [move the old project in](move-an-existing-project-in.md).

## Get a project of the chair onto your machine

**Ask Claude.** In a project that you already have:

```prompt
Get me the project <project>.
```

Claude clones the project and tells you where the clone is. You clone only [the first repo on a machine](../start/set-up-your-machine.md#clone-your-first-repo) yourself.

**Claude will ask you.** Once, the folder where you keep your projects. It refuses a folder inside Dropbox, OneDrive or another project. If a folder of that name is already there, it says so and clones nothing.

**Untested on Windows.** Claude clones with Git for Windows. If git is missing, Claude says so, and you install it.

## Open the new clone and run everything

1. Open a new session on the new clone's top folder.
2. Claude Code asks whether you trust this folder. Accept. Unless you accept, Claude Code ignores the repo's permission rules.
3. Ask:

   ```prompt
   Run everything.
   ```

   On Windows, with R or Python steps, [you start the run yourself](work-with-r-steps.md#run-the-project-on-windows).

**Check.** The run ends `Run complete`, and no file in your clone changed. If exhibits changed, your run differs from the committed results, and Claude names them before any commit.
