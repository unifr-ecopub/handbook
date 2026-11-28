/*
  The Python cases: do py_tests.do <tests folder>, from run_tests.do, after the R cases. A toy
  project with one Python step, made from the template like the others, with the starter files of
  code/templates/py-project/ at its top and its data root in data/ inside it. Its packages are put
  into .venv/ once with  uv sync --frozen , which needs uv and, the first time, the network. Where
  uv is not found or the sync fails, each case writes TEST SKIP. On Windows Python does not run in
  Stata's batch mode: there too each case writes TEST SKIP.
*/
args here
local W "`here'/_t"
local R "`W'/data"
local out "`here'/results.txt"
local rec "`here'/record.do"
local tmpl = substr("`here'", 1, strrpos(substr("`here'", 1, strrpos("`here'", "/") - 1), "/")) + "project-template"
local pycases H86 H87 H100 H101 H103
local P "`W'/py"
local C "`P'/code"
quietly do "`here'/copytree.do" "`tmpl'" "`P'"
quietly do "`here'/copytree.do" "`R'" "`P'/data"
foreach f in pyproject.toml uv.lock .python-version {
    copy "`tmpl'/code/templates/py-project/`f'" "`P'/`f'", replace
}
local why ""
if c(os) == "Windows" local why "Python does not run in Stata's batch mode on Windows"
else {
    capture erase "`W'/uvsync.txt"
    shell cd "`P'" && uv sync --frozen > "`W'/uvsync.txt" 2>&1 && echo synced >> "`W'/uvsync.txt"
    mata: st_local("ok", strofreal(fileexists(st_local("W") + "/uvsync.txt") ? anyof(cat(st_local("W") + "/uvsync.txt"), "synced") : 0))
    if !`ok' local why "uv sync --frozen did not finish (see _t/uvsync.txt): check that uv is installed and that this machine reaches the network"
}
if "`why'" != "" {
    tempname fh
    foreach id of local pycases {
        file open `fh' using "`out'", write text append
        file write `fh' "TEST SKIP `id': `why'" _n
        file close `fh'
        display as text "TEST SKIP `id': `why'"
    }
    exit
}
quietly do "`here'/setpin.do" "`C'/pins.do" pin_toy v1
quietly do "`here'/setpin.do" "`C'/pins.do" raw_toy toy-raw/2026-01-01
* A step begins with the lines of code/templates/step.py up to the line that marks it as a template.
mata: t = cat(st_local("C") + "/templates/step.py"); m = selectindex(strpos(t, "raise SystemExit(" + char(34) + "templates/step.py is a template") :== 1); st_local("m", strofreal(rows(m) == 1 ? m[1] : 0))
if "`m'" == "0" {
    display as error "The line that marks code/templates/step.py as a template was not found: py_tests.do takes the lines above it."
    exit 459
}
mata: q = char(34); b = "import pandas as pd" \ ("d = chair_use(" + q + "toy/toy" + q + ")") \ ("w = pd.read_csv(P.raw_toy / " + q + "weights.csv" + q + ")")
mata: b = b \ ("chair_save(w[w[" + q + "ctn" + q + "] <= 20], P.temp / " + q + "phalf.dta" + q + ", key=[" + q + "ctn" + q + "])")
mata: b = b \ ("d = d.sort_values(" + q + "ctn" + q + ", ascending=False).reset_index(drop=True)")
mata: b = b \ ("m = chair_merge(d, P.temp / " + q + "phalf.dta" + q + ", type=" + q + "1:1" + q + ", on=[" + q + "ctn" + q + "], expect=[" + q + "both" + q + ", " + q + "left_only" + q + "], keep=[" + q + "both" + q + ", " + q + "left_only" + q + "], note=" + q + "Python list." + q + ")")
mata: b = b \ ("assert list(m[" + q + "ctn" + q + "]) == list(d[" + q + "ctn" + q + "])")
mata: b = b \ ("m3 = chair_merge(w[w[" + q + "ctn" + q + "] <= 20], d, type=" + q + "1:1" + q + ", on=[" + q + "ctn" + q + "], expect=[" + q + "both" + q + ", " + q + "right_only" + q + "], keep=" + q + "both" + q + ")")
mata: b = b \ ("assert str(m3[" + q + "weight" + q + "].dtype) == " + q + "int64" + q + ", m3[" + q + "weight" + q + "].dtype")
mata: b = b \ ("a = chair_append(P.temp / " + q + "phalf.dta" + q + ", P.temp / " + q + "phalf.dta" + q + ")") \ "assert len(a) == 40"
mata: b = b \ ("chair_save(m, P.temp / " + q + "pmerged.dta" + q + ", key=[" + q + "ctn" + q + "])")
* A whole number near 2^53 and a column named _chair_l keep their values; a categorical key of the
* using side keeps its values; a file name with a tab does not break the run's records; a reader
* of chunks is read.
mata: b = b \ ("big = pd.DataFrame({" + q + "ctn" + q + ": [1], " + q + "account" + q + ": [9007199254740993], " + q + "_chair_l" + q + ": [61]})")
mata: b = b \ ("mb = chair_merge(big, pd.DataFrame({" + q + "ctn" + q + ": [1, 2]}), type=" + q + "1:1" + q + ", on=" + q + "ctn" + q + ", expect=[" + q + "both" + q + ", " + q + "right_only" + q + "], keep=" + q + "both" + q + ")")
mata: b = b \ ("assert int(mb.at[0, " + q + "account" + q + "]) == 9007199254740993 and int(mb.at[0, " + q + "_chair_l" + q + "]) == 61, mb")
* Kept unmatched using rows leave the column missing there: it becomes Int64 and keeps the value.
mata: b = b \ ("mo = chair_merge(big, pd.DataFrame({" + q + "ctn" + q + ": [1, 2]}), type=" + q + "1:1" + q + ", on=" + q + "ctn" + q + ", expect=[" + q + "both" + q + ", " + q + "right_only" + q + "])")
mata: b = b \ ("assert str(mo[" + q + "account" + q + "].dtype) == " + q + "Int64" + q + " and int(mo.loc[mo[" + q + "ctn" + q + "] == 1, " + q + "account" + q + "].iloc[0]) == 9007199254740993, mo")
mata: b = b \ ("mc = chair_merge(pd.DataFrame({" + q + "k" + q + ": pd.Categorical([" + q + "a" + q + "])}), pd.DataFrame({" + q + "k" + q + ": pd.Categorical([" + q + "b" + q + "])}), type=" + q + "1:1" + q + ", on=" + q + "k" + q + ", expect=[" + q + "left_only" + q + ", " + q + "right_only" + q + "])")
mata: b = b \ ("assert sorted(str(v) for v in mc[" + q + "k" + q + "]) == [" + q + "a" + q + ", " + q + "b" + q + "], mc")
mata: b = b \ ("chair_save(mb, P.temp / " + q + "tab" + char(92) + "tfile.pkl" + q + ", key=" + q + "ctn" + q + ")")
mata: b = b \ ("with chair_use(" + q + "toy/toy" + q + ", chunksize=2) as chunks:") \ ("    assert len(next(iter(chunks))) == 2")
* An append of a file whose name holds a tab: the page is still written.
mata: b = b \ ("pd.DataFrame({" + q + "ctn" + q + ": [1]}).to_pickle(P.temp / " + q + "with" + char(92) + "ttab.pkl" + q + ")") \ ("chair_append(P.temp / " + q + "with" + char(92) + "ttab.pkl" + q + ", P.temp / " + q + "with" + char(92) + "ttab.pkl" + q + ")")
mata: s = t[1..m[1] - 1] \ b; f = st_local("C") + "/analysis/01_pyflow.py"; if (fileexists(f)) unlink(f); fh = fopen(f, "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
mata: s = t[1..m[1] - 1] \ ("import pandas as pd") \ ("chair_save(pd.DataFrame({" + q + "ctn" + q + ": [1, 1]}), P.temp / " + q + "explore" + q + " / " + q + "dup.dta" + q + ", key=[" + q + "ctn" + q + "])"); f = st_local("C") + "/explore/01_pydup.py"; if (fileexists(f)) unlink(f); fh = fopen(f, "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
mata: s = t[1..m[1] - 1] \ ("chair_merge(chair_use(" + q + "toy/toy" + q + "), P.temp / " + q + "phalf.dta" + q + ", type=" + q + "1:1" + q + ", on=[" + q + "ctn" + q + "], expect=[" + q + "both" + q + "])"); f = st_local("C") + "/explore/02_pybad.py"; if (fileexists(f)) unlink(f); fh = fopen(f, "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
mata: s = t[1..m[1] - 1] \ "import pandas as pd" \ ("chair_merge(pd.DataFrame({" + q + "side" + q + ": [1]}), pd.DataFrame({" + q + "side" + q + ": [2]}), type=" + q + "1:1" + q + ", on=" + q + "side" + q + ", expect=[" + q + "left_only" + q + ", " + q + "right_only" + q + "])"); f = st_local("C") + "/explore/03_pyside.py"; if (fileexists(f)) unlink(f); fh = fopen(f, "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
mata: s = t[1..m[1] - 1] \ "import pandas as pd" \ ("ap = chair_append(pd.DataFrame({" + q + "ctn" + q + ": [1], " + q + "account" + q + ": [9007199254740993]}), pd.DataFrame({" + q + "ctn" + q + ": [2]}))") \ ("assert str(ap[" + q + "account" + q + "].dtype) == " + q + "Int64" + q + " and int(ap.at[0, " + q + "account" + q + "]) == 9007199254740993, ap") \ ("print(" + q + "append: whole numbers kept" + q + ")"); f = st_local("C") + "/explore/04_pyappend.py"; if (fileexists(f)) unlink(f); fh = fopen(f, "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
mata: s = cat(st_local("C") + "/master.do"); s = subinstr(s, `"local steps """', "local steps analysis/01_pyflow.py"); unlink(st_local("C") + "/master.do"); fh = fopen(st_local("C") + "/master.do", "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)

* ---- A Python step on the data flow page ---------------------------------------------------------
* A left join keeps the master's row order, as pandas' does; the page shows the saves, the merges
* and the append in master and using words.
sleep 1100
quietly cd "`C'"
capture noisily do master.do
local rc = _rc
quietly cd "`here'"
mata: s = cat(st_local("C") + "/README.md"); st_local("ok", strofreal(sum(s :== "| phalf | [01\_pyflow](analysis/01_pyflow.py) | ctn | 20 |") == 1 & sum(s :== "| pmerged | [01\_pyflow](analysis/01_pyflow.py) | ctn | 26 |") == 1 & sum(s :== "| [01\_pyflow](analysis/01_pyflow.py) · 1:1 on ctn<br>master: toy/toy<br>using: phalf | 20 | 6 | 0 |") == 1 & sum(s :== "| [01\_pyflow](analysis/01_pyflow.py)<br>master: phalf<br>using: phalf | 20 | 20 |") == 1))
mata: q = st_local("P") + "/logs/qa/01_pyflow_merge1.csv"; st_local("ok", strofreal(strtoreal(st_local("ok")) & (fileexists(q) ? sum(strpos(cat(q), "master only") :> 0 :& strpos(cat(q), "Python list.") :> 0) == 6 : 0)))
mata: s = cat(st_local("C") + "/README.md"); st_local("ok", strofreal(strtoreal(st_local("ok")) & sum(s :== "| 1 file, name built at run time | [01\_pyflow](analysis/01_pyflow.py) | ctn | 1 |") == 1))
do "`rec'" "`out'" H86 "a Python step's chair_save and chair_merge and chair_append are rows of the data flow page and chair_merge keeps values and types and column names and a tab in a file name and a reader of chunks pass" 0 `=`rc' + 1000 * !`ok''
* chair_save refuses a key that repeats, and chair_merge an outcome expect does not allow.
local said2 1
foreach f in 01_pydup 02_pybad {
    sleep 1100
    quietly cd "`C'"
    log using "`W'/h87.log", text name(h87) replace
    capture noisily do master.do explore/`f'.py
    log close h87
    quietly cd "`here'"
    global t_want = cond("`f'" == "01_pydup", "chair_save: ctn does not identify a row of dup.dta: a value repeats or is missing", "chair_merge: 6 rows are left_only, which expect does not allow")
    global t_without ""
    quietly do "`here'/logsays.do" "`W'/h87.log"
    local s1 = `said'
    global t_want "Failed: explore/`f'.py"
    quietly do "`here'/logsays.do" "`W'/h87.log"
    local said2 = `said2' & `s1' & `said'
}
mata: st_local("nofile", strofreal(!fileexists(st_local("P") + "/temp/explore/dup.dta") & fileexists(st_local("P") + "/temp/explore/02_pybad_merge1.csv")))
do "`rec'" "`out'" H87 "in Python chair_save refuses a key that repeats and chair_merge lists the unmatched rows and then refuses an outcome expect does not allow" 1 `=`said2' & `nofile''
global t_want ""
* A key named side, the name of the list's own column, stays in the list.
sleep 1100
quietly cd "`C'"
capture noisily do master.do explore/03_pyside.py
local rc = _rc
quietly cd "`here'"
mata: q = st_local("P") + "/temp/explore/03_pyside_merge1.csv"; st_local("ok", strofreal(fileexists(q) ? rows(cat(q)) == 3 & cat(q)[1] == "side,_side,note" & substr(cat(q)[2], 1, 2) == "1," : 0))
do "`rec'" "`out'" H100 "a Python chair_merge on a key named side keeps the key in its list" 0 `=`rc' + 1000 * !`ok''
* The full run above appended a file whose name holds a tab, and still wrote its page.
mata: s = cat(st_local("C") + "/README.md"); st_local("ok", strofreal(sum(s :== "| [01\_pyflow](analysis/01_pyflow.py)<br>master: a file built at run time<br>using: a file built at run time | 1 | 1 |") == 1))
do "`rec'" "`out'" H101 "a Python chair_append of a file whose name holds a tab leaves the page whole" 1 `ok'
global t_want ""
* An append where one input lacks a whole-number column keeps its values: Int64, not a float.
sleep 1100
quietly cd "`C'"
log using "`W'/h103.log", text name(h103) replace
capture noisily do master.do explore/04_pyappend.py
local rc = _rc
log close h103
quietly cd "`here'"
global t_want "append: whole numbers kept"
global t_without ""
quietly do "`here'/logsays.do" "`W'/h103.log"
do "`rec'" "`out'" H103 "a Python chair_append keeps a whole number that another input lacks the column for" 0 `=`rc' + 1000 * !`said''
global t_want ""
