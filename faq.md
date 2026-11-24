# Questions people ask

One line per question, with a link to the page that covers it.

## Getting started

- **What do I install?** [Four programs](start/set-up-your-machine.md#install-the-programs-and-sign-in), and Dropbox.
- **Who gives me access?** [The data curator](start/set-up-your-machine.md#before-you-start-what-the-data-curator-arranges).
- **What is the trust question?** Claude Code asks it once per clone, and [you accept](start/set-up-your-machine.md#open-your-first-session-and-answer-the-trust-question).

## Every day

- **What do I do each day?** [Pull, work on a step, run everything, commit and push](researcher/daily-routine.md).
- **How do I know that a run finished?** [Its last line](reference/messages-project-run.md#how-a-run-ends) is `Run complete`.
- **Why can Claude not start my run?** On Windows, a project with R steps [runs in Stata's window](researcher/work-with-r-steps.md#run-the-project-on-windows).

## When something breaks

- **A run failed. What now?** Ask Claude for [the cause](researcher/find-why-a-run-failed.md).
- **My push was rejected, or there is a conflict.** [Someone pushed first](researcher/fix-a-rejected-push-or-a-conflict.md).
- **My tables are gone after a failed run.** [A full run makes them again](researcher/find-why-a-run-failed.md#check-the-fix).

## The data

- **What is this dataset?** Its row in [the data map](data/data-map.md) says.
- **Which version does my project read?** [The one on its line](data/versions-and-pins.md#which-version-a-run-read) in `code/pins.do`.
- **How do I get the new version?** Ask Claude to [move](researcher/move-to-a-new-version.md).

## Claude

- **Does Claude commit on its own?** No, [only when you ask](claude/working-with-claude.md#what-claude-never-does).
- **Who decides a scientific choice?** [You do](researcher/record-a-scientific-choice.md).
- **Does my data go to Anthropic?** [What Claude reads](data/terms-of-use.md#sources-that-may-not-reach-an-outside-service) does.
- **Can Claude be wrong?** Yes. See [How you keep control](claude/working-with-claude.md#how-you-keep-control).

## For the data curator

- **Who commits in `data-processing`?** [You do](curator/commit-and-push.md), in GitHub Desktop.
- **How do I undo a release?** You cannot. You [withdraw the version](curator/withdraw-a-version.md).
- **How do I welcome a new researcher?** In [three steps](curator/manage-repos-and-people.md#welcome-a-new-researcher).
