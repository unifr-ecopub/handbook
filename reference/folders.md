# Folders

The layout of a project, of `data-processing` and of a replication package. [The data root](../data/data-root.md) has its own page.

## A project

```plaintext
<project>/
├── README.md
├── AGENTS.md              the rules for Claude
├── CLAUDE.md              loads AGENTS.md and names the skills
├── .claude/               the skills, the Stata and R conventions, the settings
├── checklist.md           the items of a review
├── decisions.md           the scientific choices
├── code/
│   ├── master.do          runs everything
│   ├── pins.do            the versions and deliveries to read
│   ├── dataprep/          steps that save working files
│   ├── analysis/          steps that write exhibits
│   ├── explore/           explore files
│   └── templates/
├── ado/                   Stata packages and the chair's programs
├── paper/
│   ├── draft/             the manuscript
│   └── results/           exhibits and the results page
├── replication/           the README of a future package
├── temp/                  working files
└── logs/                  a dated log per run
```

Git holds everything but `temp/` and `logs/`. Only code writes `paper/results/` and `temp/`, and a full run empties `temp/` first.

## data-processing

```plaintext
data-processing/
├── datamap.csv            the data map
├── docs/                  the data map as pages, rebuilt by GitHub
├── builds/<dataset>/      one build
│   ├── README.md          what it reads, and one line per version
│   ├── decisions.md       the build author's choices
│   ├── checklist.md       the list for a look at a candidate
│   └── code/, temp/, logs/
├── code/
│   ├── build.do           what every build runs
│   └── release.do         releases a candidate
├── ado/                   the chair's programs
└── tests/
```

The repo holds no data. Nobody edits `docs/`: it shows [the data map as pages](../data/data-map.md#the-map-as-pages).

## A replication package

```plaintext
<project>-replication/
├── README.md              the journal's README, filled in
├── code/, paper/, ado/    the project, as committed
├── builds/<dataset>/      the code that made each version
└── data/
    ├── raw/               the deliveries that may be shared
    ├── intermediate/      decisions and tables made by hand
    └── processed/         the versions that may be shared
```

In a package, the data root is the folder `data/`. A replicator sets no path.

A package holds no `CLAUDE.md`, no `AGENTS.md` and no `.claude/`: Claude [leaves them out](../curator/assemble-a-replication-package.md#read-the-report). A project's `.gitattributes` also leaves them out of any archive of its repo, such as GitHub's **Download ZIP**; a clone keeps them.
