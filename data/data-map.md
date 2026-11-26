# The data map

The data map says what each source and each dataset of the chair is.

It is the file `datamap.csv` at the top of `data-processing`. Members of the chair's organisation open it on github.com, which shows it as a table with a search box. It has one row for each raw source and one for each processed file.

A dataset's build has a `README.md` of its own, `builds/<dataset>/README.md` in the same repo. It says what the build reads, and what changed in each version.

## The map as pages

You can also read the map as pages, in the folder `docs/` of `data-processing`. Members of the chair's organisation open them on github.com, which draws their diagrams. There are four kinds of page:

- The index, `docs/README.md`, lists every processed dataset and every raw source.
- A dataset's page gives its description, unit, declared key and terms. It names what the dataset is built from and what is built from it. Where it has either, a small diagram shows them. The page links to the build's `README.md` and `decisions.md`.
- A source's page gives the same details and names the datasets built from it.
- The lineage page, `docs/lineage.md`, shows what is built from what, with one diagram for each group of connected datasets. One line names the sources that nothing is built from.

Nobody edits these pages: GitHub rebuilds them from the map after each push that changes it. To change a page, change the map. The pages hold no data, and a key shown there is the key the map declares.

## The columns

| Column | For a raw source | For a processed file |
|---|---|---|
| `name` | Its folder name in `raw/` | `<dataset>/<file>` |
| `kind` | `raw` | `processed` |
| `description` | What one row is | The same |
| `origin` | Who sent it | `build <dataset>` |
| `received` | The dates of its deliveries | A pointer to the build's `README.md` |
| `unit` | The unit of observation | The same |
| `key` | The columns that identify a row | The same |
| [`terms`](terms-of-use.md) | The terms of use | The same |
| `built_from` | `none` | The sources, datasets and `intermediate/` folders behind it |

`unknown` means that nobody knows. `none` means that the field does not apply. A release refuses a processed file whose `key` or `terms` is blank or `unknown`, and a file whose key does not identify each row.

No row describes a table made by hand. The processed file made with it names the table's folder under `built_from`.

Each project's `code/pins.do` shows which versions and deliveries the project reads.
