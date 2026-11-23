# handbook

The guides to the chair's research platform, which GitHub renders as a public website, and the
tests of `project-template`. The data curator writes here, and is not a programmer: say what you do in
one plain sentence. `data-processing` and `project-template`
are the clones in the folder beside this repo.

- **The guides,** one task or topic per page: `start/` (machine setup, the first day, how the
  platform fits together), `researcher/`, `curator/` (the data curator's tasks), `assistant/`,
  `data/` (for anyone who reads the shared data), `claude/` (for anyone new to Claude),
  `reference/` (words, folders, messages, what never to do) and `faq.md`. `README.md` is the start
  page; it links each page by its title. A new page is also added to the list of pages in
  `.github/workflows/publish.yml`.
- **The guides are Claude-first.** Each task says, under these labels, bold with a full stop
  inside the bold: **Ask Claude.** (the request, and the folder the session is opened on),
  **Claude will ask you.**, **Only you do.**, **Check.**, and **What can go wrong.** where a limit
  of the design must be known. A label is used only where it carries something. The order is Ask
  Claude, Claude will ask you, Only you do, Check; **Only you do.** comes first where the person must
  act before any session can be opened, and after **Check.** where it acts on what the check
  shows. **Untested on Windows.** opens a paragraph of its own. A guide never
  repeats a procedure, never gives a by-hand version and never calls Claude optional; only a
  replication package runs without Claude. The opening paragraph of each guide says, in the same
  words: "Claude commits and pushes when you ask, and never on its own; it asks before
  `release.do`. Scientific choices are yours, and Claude writes them into `decisions.md`." (the
  data curator's guide: "yours, or the build author's", "the build's `decisions.md`"), and the
  data curator's guide adds, once, that in `data-processing` the commit and the push are still the
  data curator's, in GitHub Desktop. A task that a repo's rule or skill still leaves to the person
  says so under **Only you do.**, and no more.
- **The guides follow, and never own,** the skills, `CLAUDE.md` files, settings and messages of
  `data-processing` and `project-template`. Every sentence must be true of them as they stand: a
  request is one a skill's description or a `CLAUDE.md` answers, and a message is quoted only as
  the code prints it, in a fenced block marked `text`, with `<…>` for the parts that vary. A
  request the reader is meant to type is quoted in a fenced block marked `prompt`, wherever it
  stands; a request mentioned in passing in a sentence stays in quotes there. Where
  they disagree with a guide, change the guide, or tell the data curator what the other repo should
  change.
- **Public.** No data, no names of people, no email, no dataset or source of the chair, nothing
  of the chair's own: use placeholders (`<dataset>`, `<source>`, `<project>`, `<you>`). Plain
  words, short sentences, British spelling.
- **`tests/` are the template's tests.** They change only together with the template. To run
  them: `cd tests`, then `stata-se -b do run_tests.do` (on Windows `StataSE-64.exe /e do
  run_tests.do`). Batch mode reports success whatever happens: read `tests/results.txt`, which
  holds one line per case, beginning `TEST PASS`, `TEST FAIL` or `TEST SKIP`, and ends with the
  summary line `template tests: <n> passed, <n> failed, <n> skipped (results.txt)`; read also
  `tests/run_tests.log`, written by your run. The R cases need R at the minor version the
  template's `renv.lock` names and the network for their one restore; without them, and on
  Windows in batch mode, each writes `TEST SKIP` with the reason. Report the counts, quote any
  failure in full, and say why cases were skipped: on Windows the data curator runs the tests in
  Stata's window to run the R cases.
- The website is rendered only by the workflow on GitHub (`.github/workflows/`): install nothing
  and render nothing here. Its look is in `website/` (colours, fonts, a filter that turns the
  labels into cards, the code boxes, the Copy page button, and pele, which draws the diagrams),
  on the website only; a page never carries markup for the website.
- This repo holds no data, and no task here reads or writes the data root.
- **Git: commit and push when the data curator asks, never on your own.** A task still ends with the
  files changed and a one-line summary in plain words; the data curator then asks, or does not. When
  asked: show what `git status` lists, commit those files to `main` with the summary, push, and
  say that it is pushed and that the website follows a push by a few minutes. The commit's message
  is the one-line summary and nothing else: no co-author line and no mention of Claude is added to
  a commit. Before a push that changed `tests/` or follows a change to the template, run the tests
  as the bullet on `tests/` says, and push only when they pass.
- **Pull when asked, and before you commit.** Say in one sentence what the pull brought.
- **A rejected push** means someone pushed first: pull, say what came, and push again.
- **A conflict:** show, for each file, both versions in plain words and ask which to keep, or how
  to combine them. Change nothing until the data curator answers; then finish the merge and push.
- **Never** a force push, never a rewrite of commits already pushed, never a branch, never a
  commit of a file the data curator has not seen listed.
