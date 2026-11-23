# Look over a candidate

A candidate is a build's finished files, which wait in the data root for a release. A look is a habit between people: no release waits for it, and nothing records it.

## Find the candidate

In the data root, open `intermediate/<dataset>/`. The file `staged.txt` names the candidate's files, the commit of the code that made them, and the date. The code is in `data-processing`, in `builds/<dataset>/`.

## Go through the build's checklist

The build's `checklist.md` is your list.

- The commit in `staged.txt` is on github.com, and the delivery is the one in the build's `code/pins.do`.
- The check values in the log match the build's `README.md`.
- You read the lists in `logs/qa/`: the rows that a step dropped or could not match.
- Each variable has a label, and the key in the data map identifies a row.
- Each judgement call cites a D-number in the build's `decisions.md`.

Tell the data curator what you found.

**What can go wrong.** Each full run on the data curator's machine replaces the candidate, and your look does not cover the new one. Compare the date in `staged.txt` with the day you looked.
