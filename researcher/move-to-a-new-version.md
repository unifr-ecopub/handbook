# Move to a new version of a dataset

A project keeps the version named on its [pin](../data/versions-and-pins.md#a-pin) until you ask for another. You need not move.

The data curator tells the chair after each release. The build's `README.md` in `data-processing` says in one line what changed in each version.

**Ask Claude.** In the project:

```prompt
Use the new version of <dataset>.
```

Claude changes the dataset's line in `code/pins.do`, and no other, runs everything, and says which results changed. On Windows, with R or Python steps, [you start that run yourself](work-with-r-steps.md#run-the-project-on-windows).

**Check.** Claude quotes this line from the log:

```text
chair_use: <dataset>/<file> v<N>
```

If the version does not load, [Loading a dataset](../reference/messages-project-run.md#loading-a-dataset) quotes each message. A version marked as wrong still loads, with no warning. Its line in the build's `README.md` says why and which version to use instead, and the data curator tells the chair.
