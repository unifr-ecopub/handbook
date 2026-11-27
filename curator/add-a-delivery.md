# Add a raw delivery

Claude copies a provider's files into the data root when you ask, and records them in the data map.

## Ask Claude to copy it

**Ask Claude.** In `data-processing`:

```prompt
Copy the delivery of <source> in <folder> into raw/.
```

If you copied the files into `raw/<source>/<date>/` yourself, say instead:

```prompt
I added a delivery of <source>.
```

Claude then checks that folder.

**Claude will ask you.**

- First, whatever you did not say: the folder that holds the delivery, the source's name and the date it came. Claude proposes the name.
- For a new source, its terms of use, in a message of their own. Claude opens no file of the delivery until you answer.
- Then, in one message, what the files leave unclear, such as the sender and what one row is.

Claude copies every file untouched into `raw/<source>/<date>/`, and checks that the number of files and their sizes match. If that date folder is there already, it copies nothing and asks whether this is a second delivery of that date, which goes into `<date>-2`.

`<source>` is lower case, with hyphens between words, and at most 28 characters, or 27 if it begins with a digit. Claude renames a folder that breaks this only on your yes, and never a delivered file.

**What can go wrong.** Once the terms allow it, Claude reads the header and first rows of each text file, and those rows reach Anthropic's servers. `open` and `chair only` allow it. Terms that [bar outside services](../data/terms-of-use.md#sources-that-may-not-reach-an-outside-service), or that say not to open the files, keep the files closed, and so do terms that nobody has stated yet: say them in your request, or when Claude asks.

## The terms beside the files

Claude writes the terms as `raw/<source>/README.md` in the data root, `open` included, in your words or the provider's, and shows you its text. Where nobody knows them, the `README.md` says that they are not yet stated. If a `README.md` is there already, Claude shows it and changes it only as you say.

## Check the row, then commit and push

**Check.** Claude shows the source's row of `datamap.csv`, with every field filled, and names each build that reads the source. Then ask Claude to [commit and push](commit-and-push.md) `datamap.csv`. A raw source's row does not make a dataset: it is not among the code that `release.do` checks against a candidate, so a candidate that waits stays releasable.

A build keeps the delivery on its pin. Ask Claude to move the build to the new delivery: it changes that line and the build's `README.md`, and runs the whole build again. That candidate is released only once both files are committed and pushed as they were when the build ran.
