# Add a raw delivery

You copy a provider's files into the data root, and Claude records them in the data map.

## Copy the delivery into raw/

**Only you do.** Claude never writes under `raw/`.

1. In Explorer, make the folder `raw/<source>/<date>/` in the data root.
2. Copy the files into it as received.
3. In GitHub Desktop, pull `data-processing`.

`<source>` is lower case, with hyphens between words, and under 28 characters. `<date>` is written `yyyy-mm-dd`.

## Ask Claude to record it

**Ask Claude.** In `data-processing`:

```prompt
I added a delivery of <source>.
```

**Claude will ask you.** In one message, whatever the files leave unclear. That can be the sender, the terms of use, and what one row is.

**What can go wrong.** For a new source, Claude looks at the first rows of each text file, and asks for the terms afterwards. Those rows reach Anthropic's servers. Claude's instructions keep the files closed only if the source's `README.md` or its row in the data map already [bars outside services](../data/terms-of-use.md#sources-that-may-not-reach-an-outside-service).

## Save the terms beside the files

**Only you do.** If the terms are not `open`, Claude gives you the text of a `README.md` that repeats them.

1. Paste the text into Notepad.
2. Choose **File › Save as**, and pick `raw/<source>/` in the data root.
3. Name the file `README.md`, and set **Save as type** to **All Files**.

## Check the row, then commit and push

**Check.** Claude shows the source's row of `datamap.csv`, with every field filled, and names each build that reads the source. Then [commit and push](commit-and-push.md) `datamap.csv`.

A build keeps the delivery on its pin. Ask Claude to move the build to the new delivery: it changes that line and runs the whole build again.
