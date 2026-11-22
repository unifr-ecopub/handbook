/*
  The R cases: do r_tests.do <tests folder>, from run_tests.do, after the Stata cases.
  They use a toy project with a Stata step and R steps, made from the template like the others,
  with the starter files of code/templates/r-project/ at its top and its data root in data/
  inside it. Its folder, _t/r toy, has a space in its name, as a researcher's path often has, so
  that a path with a space is tested whatever folder holds the clones. Where no R at the minor
  version its renv.lock names is found, the way master.do finds R (rscript: the global
  RSCRIPT_PATH, else its default places), each case writes one line TEST SKIP and none runs.
  Otherwise the project's renv library is restored once, from Stata (H30), which needs the
  network; renv's cache on the machine makes it quick after the first time.
  rscript returns 0 for an R that stopped with a message in another language than English, or
  quit: so the cases read what the design claims, the Failed: line, the sentence, no done-file
  and nothing cleared, and not the return code that rscript gives in English.
*/
args here
local W "`here'/_t"
local R "`W'/data"
local out "`here'/results.txt"
local rec "`here'/record.do"
local tmpl = substr("`here'", 1, strrpos(substr("`here'", 1, strrpos("`here'", "/") - 1), "/")) + "project-template"
local rcases H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H57 H58 H59 H64 H65 H66 H67 H68
local P "`W'/r toy"
local C "`P'/code"
quietly do "`here'/copytree.do" "`tmpl'" "`P'"
quietly do "`here'/copytree.do" "`R'" "`P'/data"
foreach f in .Rprofile project.Rproj renv.lock renv/.gitignore renv/activate.R renv/settings.json {
    capture mkdir "`P'/renv"
    copy "`tmpl'/code/templates/r-project/`f'" "`P'/`f'", replace
}

* ---- Is R at the version renv.lock names on this machine? ---------------------------------------
mata: s = cat(st_local("P") + "/renv.lock"); s = select(s, ustrregexm(s, `"^ *"Version": *"[0-9]+[.][0-9]+"')); st_local("minor", rows(s) ? (ustrregexm(s[1], "([0-9]+[.][0-9]+)") ? ustrregexs(1) : "") : "")
capture erase "`W'/rversion.R"
mata: fh = fopen(st_local("W") + "/rversion.R", "w"); fput(fh, "writeLines(c(paste(R.version[[" + char(34) + "major" + char(34) + "]], R.version[[" + char(34) + "minor" + char(34) + "]], sep = " + char(34) + "." + char(34) + ")), commandArgs(TRUE)[1])"); fclose(fh)
capture erase "`W'/rversion.txt"
adopath ++ "`P'/ado/r"
log using "`W'/rversion.log", text name(rversion) replace
capture noisily rscript using "`W'/rversion.R", args("`W'/rversion.txt")
local rc = _rc
log close rversion
local have ""
capture mata: st_local("have", strtrim(cat(st_local("W") + "/rversion.txt")[1]))
mata: st_local("hminor", ustrregexm(st_local("have"), "^([0-9]+[.][0-9]+)") ? ustrregexs(1) : "")
* The R cases are skipped only where rscript says it found no R (or, on Windows, that it does not
* run in Stata's batch mode), or where R answered with another minor version. Any other failure of
* that call is one TEST FAIL line with what rscript printed, and no case is skipped.
if `rc' | "`minor'" == "" | "`hminor'" != "`minor'" {
    local why ""
    global t_without ""
    foreach t in "R executable not found" "No default R executable found" "does not work in batch mode" {
        global t_want "`t'"
        quietly do "`here'/logsays.do" "`W'/rversion.log"
        if `said' local why = cond("`t'" == "does not work in batch mode", "rscript does not run R in Stata's batch mode on Windows", "R `minor' was not found on this machine")
    }
    if !`rc' & "`minor'" != "" & "`hminor'" != "" local why "R `minor' was not found on this machine: this is R `have'"
    if "`why'" == "" {
        mata: s = cat(st_local("W") + "/rversion.log"); s = select(s, s :!= "" :& !ustrregexm(s, "^(\. | *[0-9]+\. |> |      name:|       log:|  log type:| opened on:| closed on:|Running R script:|Args:|[-_]+$)")); m = ""; for (i = 1; i <= rows(s); i++) m = m + " " + strtrim(s[i])
        mata: l = "TEST FAIL R (want r(0), got r(" + st_local("rc") + ")): rscript did not give R's version so no R case ran:" + m; fh = fopen(st_local("out"), "a"); fput(fh, l); fclose(fh); printf("%s\n", l)
        exit
    }
    tempname fh
    foreach id of local rcases {
        file open `fh' using "`out'", write text append
        file write `fh' "TEST SKIP `id': `why'" _n
        file close `fh'
        display as text "TEST SKIP `id': `why'"
    }
    exit
}

* ---- The toy project with R steps -----------------------------------------------------------------
* Steps: a Stata step that saves temp/toy.dta, then an R step that writes a table from the pinned
* toy version, the raw delivery, a hand-made table in intermediate/rtoy/ and that working file.
mata: s = cat(st_local("C") + "/master.do"); s = subinstr(s, `"local steps """', "local steps dataprep/01_load.do analysis/01_rtab.R"); unlink(st_local("C") + "/master.do"); fh = fopen(st_local("C") + "/master.do", "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
quietly do "`here'/step.do" "`P'" dataprep/01_load.do load
quietly do "`here'/rstep.do" "`P'" analysis/01_rtab.R tab
quietly do "`here'/rstep.do" "`P'" explore/01_look.R explore
quietly do "`here'/setpin.do" "`C'/pins.do" pin_toy v1
quietly do "`here'/setpin.do" "`C'/pins.do" raw_toy toy-raw/2026-01-01
* The hand-made table: a factor of 2 for every canton.
foreach d in "`P'/data/intermediate" "`P'/data/intermediate/rtoy" {
    mkdir "`d'"
}
clear
set obs 26
generate ctn = _n
generate factor = 2
export delimited using "`P'/data/intermediate/rtoy/factor.csv"
clear
* A clone of the same project whose R library is never restored (H48, H49).
local N "`W'/rnone"
quietly do "`here'/copytree.do" "`P'" "`N'"

* ---- The restore, once, from Stata ---------------------------------------------------------------
* R starts in the project folder, as a researcher's first renv::restore() does, so .Rprofile names
* the CRAN snapshot. The library holds copies, not links into renv's cache, so that no link lies
* under _t/.
capture erase "`W'/restore.R"
mata: fh = fopen(st_local("W") + "/restore.R", "w"); q = char(34)
mata: fput(fh, "options(renv.config.cache.symlinks = FALSE)"); fput(fh, "renv::restore(prompt = FALSE)")
mata: fput(fh, "lib <- list.files(renv::paths[[" + q + "library" + q + "]](), full.names = TRUE)"); fput(fh, "links <- lib[nzchar(Sys.readlink(lib))]")
mata: fput(fh, "if (length(links)) { file.remove(links); stop(" + q + "the library held links into renv's cache: removed" + q + ") }"); fput(fh, "writeLines(" + q + "restored" + q + ", commandArgs(TRUE)[1])"); fclose(fh)
capture erase "`W'/restored.txt"
quietly cd "`P'"
capture noisily rscript using "`W'/restore.R", args("`W'/restored.txt")
local rc = _rc
quietly cd "`here'"
capture confirm file "`W'/restored.txt"
local rc = cond(`rc', `rc', _rc)
do "`rec'" "`out'" H30 "the R library of the toy project is restored from Stata with renv::restore()" 0 `rc'
* Where it did not finish, every later R case writes TEST SKIP, as where no R is found.
if `rc' {
    local why "renv::restore() did not finish: check that this machine reaches the network (renv itself and the packages come from the CRAN snapshot that renv.lock names), then run the tests again"
    tempname fh
    foreach id of local rcases {
        if "`id'" == "H30" continue
        file open `fh' using "`out'", write text append
        file write `fh' "TEST SKIP `id': `why'" _n
        file close `fh'
        display as text "TEST SKIP `id': `why'"
    }
    exit
}

* ---- A full run of a project with Stata and R steps ------------------------------------------------
* The R step is listed by its own name and runs; the table holds value (toy v1, 10 * ctn) times
* weight (raw, 27 - ctn) times factor (2), 65520; the results page names the R script.
sleep 1100
quietly cd "`C'"
log using "`W'/h31.log", text name(h31)
capture noisily do master.do
local rc = _rc
log close h31
quietly cd "`here'"
global t_want "R step complete: analysis/01_rtab.R"
global t_without ""
quietly do "`here'/logsays.do" "`W'/h31.log"
local ok = `said'
mata: b = char(96); s = fileexists(st_local("P") + "/paper/results/tables/01_rtab.tex") ? cat(st_local("P") + "/paper/results/tables/01_rtab.tex") : J(0, 1, ""); st_local("ok", strofreal(strtoreal(st_local("ok")) & rows(s) == 3 ? s[1] == "total 65520" : 0))
mata: s = cat(st_local("P") + "/paper/results/README.md"); st_local("ok", strofreal(strtoreal(st_local("ok")) & sum(s :== "| [01_rtab.tex](tables/01_rtab.tex) | [" + b + "code/analysis/01_rtab.R" + b + "](../../code/analysis/01_rtab.R) |") == 1))
do "`rec'" "`out'" H31 "a full run of a project with Stata and R steps runs the R step listed by its own name and the results page names the R script" 0 `=`rc' + 1000 * !`ok''

* ---- A single R step twice in a row ----------------------------------------------------------------
local rcs 0
forvalues i = 1/2 {
    sleep 1100
    quietly cd "`C'"
    capture noisily do master.do analysis/01_rtab.R
    local rcs = `rcs' + _rc
    quietly cd "`here'"
}
do "`rec'" "`out'" H32 "a single R step runs twice in a row" 0 `rcs'

* ---- The same script run on its own ----------------------------------------------------------------
* R started on the script in the project folder, as RStudio does with project.Rproj: the table is
* the one master.do made, byte for byte (draw included), written over a stale copy without a stop.
local tab "`P'/paper/results/tables/01_rtab.tex"
mata: t_made = fileexists(st_local("tab")) ? cat(st_local("tab")) : J(0, 1, ""); if (fileexists(st_local("tab"))) unlink(st_local("tab")); fh = fopen(st_local("tab"), "w"); fput(fh, "stale"); fclose(fh)
quietly cd "`P'"
log using "`W'/h33.log", text name(h33)
capture noisily rscript using "`C'/analysis/01_rtab.R"
local rc = _rc
log close h33
quietly cd "`here'"
global t_want "This R runs on its own, outside master.do: exhibits are overwritten."
quietly do "`here'/logsays.do" "`W'/h33.log"
mata: st_local("same", strofreal(rows(t_made) == 3 & fileexists(st_local("tab")) ? cat(st_local("tab")) == t_made : 0))
do "`rec'" "`out'" H33 "the R step run on its own gives the same table byte for byte and overwrites it without stopping" 0 `=`rc' + 1000 * (!`said' | !`same')'
* A fresh clone has no logs/, which git ignores: an R step run on its own writes its unmatched rows
* under logs/qa/, as the rules for R steps tell it to.
quietly do "`here'/rmtree.do" "`P'/logs"
quietly do "`here'/rstep.do" "`P'" analysis/02_qa.R qa
quietly cd "`P'"
capture noisily rscript using "`C'/analysis/02_qa.R"
local rc = _rc
quietly cd "`here'"
mata: st_local("ok", strofreal(fileexists(st_local("P") + "/logs/qa/02_qa_unmatched.csv")))
do "`rec'" "`out'" H66 "an R step run on its own in a clone with no logs folder writes a file under logs/qa" 0 `=`rc' + 1000 * !`ok''
* The table's second line is a list of letters sorted by R, in an order that C and a language's
* order give differently. The step run on its own from an R session that first sets a language's
* order (one this machine has), as an R started by hand may: the table is the one master.do made.
capture erase "`W'/collate.R"
mata: fh = fopen(st_local("W") + "/collate.R", "w"); q = char(34)
mata: fput(fh, "for (l in c(" + q + "en_US.UTF-8" + q + ", " + q + "fr_CH.UTF-8" + q + ", " + q + "de_CH.UTF-8" + q + ", " + q + "English_United States.utf8" + q + ")) if (nzchar(suppressWarnings(Sys.setlocale(" + q + "LC_COLLATE" + q + ", l)))) break")
mata: fput(fh, "if (Sys.getlocale(" + q + "LC_COLLATE" + q + ") %in% c(" + q + "C" + q + ", " + q + "POSIX" + q + ")) stop(" + q + "no language's order of strings was found on this machine" + q + ")")
mata: fput(fh, "source(file.path(" + q + "code" + q + ", " + q + "analysis" + q + ", " + q + "01_rtab.R" + q + "))"); fclose(fh)
capture erase "`tab'"
quietly cd "`P'"
capture noisily rscript using "`W'/collate.R"
local rc = _rc
quietly cd "`here'"
mata: st_local("same", strofreal(rows(t_made) == 3 & fileexists(st_local("tab")) ? cat(st_local("tab")) == t_made : 0))
do "`rec'" "`out'" H67 "the R step run on its own from an R session that sorts strings in a language's order gives the table master.do made byte for byte" 0 `=`rc' + 1000 * !`same''

* ---- An R step that fails, quits or is killed after an earlier success ------------------------------
* Each kind writes the table first, then stops: master.do must still say Failed: <step>, with the
* return code it ends with, and leave no done-file.
local done "`P'/temp/r_step.done"
local n 34
foreach kind in stop quit kill {
    quietly do "`here'/rstep.do" "`P'" analysis/01_rtab.R tab
    sleep 1100
    quietly cd "`C'"
    capture noisily do master.do analysis/01_rtab.R
    local rc0 = _rc
    quietly cd "`here'"
    quietly do "`here'/rstep.do" "`P'" analysis/01_rtab.R `kind'
    sleep 1100
    quietly cd "`C'"
    log using "`W'/h`n'.log", text name(h`n')
    capture noisily do master.do analysis/01_rtab.R
    local rc = _rc
    log close h`n'
    quietly cd "`here'"
    mata: s = cat(st_local("W") + "/h`n'.log"); f = select(s, substr(s, 1, 7) :== "Failed:"); st_local("said", strofreal(rows(f) == 1 ? f[1] == "Failed: analysis/01_rtab.R (r(" + st_local("rc") + "))" : 0))
    capture confirm file "`tab'"
    local made = !_rc
    capture confirm file "`done'"
    local got_`kind' = (`rc' == 0) + 1000 * (`rc0' != 0 | !`said' | !`made' | !_rc)
    local n = `n' + 1
}
do "`rec'" "`out'" H34 "an R step that stops with an error stops the run with Failed and its name and no done-file after the same step succeeded" 0 `got_stop'
do "`rec'" "`out'" H35 "an R step that quits with status 0 after writing its table stops the run with Failed and its name and no done-file after the same step succeeded" 0 `got_quit'
do "`rec'" "`out'" H36 "an R step whose R is killed after writing its table stops the run with Failed and its name and no done-file after the same step succeeded" 0 `got_kill'

* ---- A second write to one exhibit through new_file() ---------------------------------------------
quietly do "`here'/rstep.do" "`P'" analysis/01_rtab.R twice
sleep 1100
quietly cd "`C'"
log using "`W'/h37.log", text name(h37)
capture noisily do master.do analysis/01_rtab.R
local rc = _rc
log close h37
quietly cd "`here'"
quietly do "`here'/rstep.do" "`P'" analysis/01_rtab.R tab
global t_want "refusing to overwrite 01_rtab.tex: an exhibit is written once per run"
quietly do "`here'/logsays.do" "`W'/h37.log"
mata: s = cat(st_local("W") + "/h37.log"); f = select(s, substr(s, 1, 7) :== "Failed:"); st_local("said", strofreal(strtoreal(st_local("said")) & rows(f) == 1 ? f[1] == "Failed: analysis/01_rtab.R (r(" + st_local("rc") + "))" : 0))
capture confirm file "`done'"
do "`rec'" "`out'" H37 "a second write to one exhibit through new_file() stops the run with Failed and its name and its sentence and no done-file" 0 `=(`rc' == 0) + 1000 * (!`said' | !_rc)'

* ---- An explore file in R --------------------------------------------------------------------------
quietly do "`here'/markers.do" "`P'" plant
sleep 1100
quietly cd "`C'"
log using "`W'/h38.log", text name(h38)
capture noisily do master.do explore/01_look.R
local rc = _rc
log close h38
quietly cd "`here'"
global t_want "explore: 26 rows; data root `P'/data"
quietly do "`here'/logsays.do" "`W'/h38.log"
local ok = `said'
global t_want "chair_use: toy/toy v1"
quietly do "`here'/logsays.do" "`W'/h38.log"
quietly do "`here'/markers.do" "`P'" check
do "`rec'" "`out'" H38 "an explore file in R runs with the project's paths and pins and clears nothing" 0 `=`rc' + 1000 * (!`ok' | !`said' | !`kept')'
* One R session, as RStudio keeps one open, sources the explore file, the pin is moved by editing
* its line, and the session sources the file again: the second load is the version pins.do now
* names.
copy "`C'/pins.do" "`W'/pins.keep", replace
capture erase "`W'/session.R"
mata: fh = fopen(st_local("W") + "/session.R", "w"); q = char(34); look = "source(file.path(" + q + "code" + q + ", " + q + "explore" + q + ", " + q + "01_look.R" + q + "))"
mata: fput(fh, "p <- file.path(" + q + "code" + q + ", " + q + "pins.do" + q + ")"); fput(fh, "a <- capture.output(" + look + ")")
mata: fput(fh, "writeLines(sub(" + q + "^global pin_toy .*" + q + ", 'global pin_toy " + q + "v2" + q + "', readLines(p)), p)"); fput(fh, "b <- capture.output(" + look + ")")
mata: fput(fh, "writeLines(c(grep(" + q + "^chair_use:" + q + ", a, value = TRUE), grep(" + q + "^chair_use:" + q + ", b, value = TRUE)), commandArgs(TRUE)[1])"); fclose(fh)
capture erase "`W'/session.txt"
quietly cd "`P'"
capture noisily rscript using "`W'/session.R", args("`W'/session.txt")
quietly cd "`here'"
copy "`W'/pins.keep" "`C'/pins.do", replace
mata: s = fileexists(st_local("W") + "/session.txt") ? cat(st_local("W") + "/session.txt") : J(0, 1, ""); st_local("ok", strofreal(rows(s) == 2 ? s[1] == "chair_use: toy/toy v1" & s[2] == "chair_use: toy/toy v2" : 0))
do "`rec'" "`out'" H57 "an R step sourced twice in one R session loads the second time the version pins.do then names" 1 `ok'

* ---- What an R step reads ----------------------------------------------------------------------------
* The pinned version through chair_use(), the raw delivery through P$raw_toy and the hand-made
* table from intermediate/rtoy/: the table's total needs all three.
sleep 1100
quietly cd "`C'"
log using "`W'/h39.log", text name(h39)
capture noisily do master.do analysis/01_rtab.R
local rc = _rc
log close h39
quietly cd "`here'"
global t_want "chair_use: toy/toy v1"
quietly do "`here'/logsays.do" "`W'/h39.log"
mata: s = fileexists(st_local("tab")) ? cat(st_local("tab")) : J(0, 1, ""); st_local("ok", strofreal(rows(s) == 3 ? s[1] == "total 65520" : 0))
do "`rec'" "`out'" H39 "an R step reads the pinned version and the raw delivery through its pin and a hand-made table from intermediate" 0 `=`rc' + 1000 * (!`said' | !`ok')'
* A withdrawn version loads, with its warning.
mata: fh = fopen(st_local("P") + "/data/processed/toy/v1/WITHDRAWN", "w"); fput(fh, "Withdrawn for a test."); fclose(fh)
sleep 1100
quietly cd "`C'"
log using "`W'/h40.log", text name(h40)
capture noisily do master.do analysis/01_rtab.R
local rc = _rc
log close h40
quietly cd "`here'"
erase "`P'/data/processed/toy/v1/WITHDRAWN"
global t_want "chair_use: warning: toy v1 is withdrawn. It still loads; the curator wrote: Withdrawn for a test."
quietly do "`here'/logsays.do" "`W'/h40.log"
do "`rec'" "`out'" H40 "an R step loads a withdrawn version with its warning" 0 `=`rc' + 1000 * !`said''
* A version without a manifest stops the step. The project's data root is data/ inside it, as in
* a replication package, so the sentence points to the package's README and not to Dropbox.
quietly do "`here'/toyversion.do" "`P'/data" toy v3 toy 30
erase "`P'/data/processed/toy/v3/manifest.txt"
quietly do "`here'/setpin.do" "`C'/pins.do" pin_toy v3
sleep 1100
quietly cd "`C'"
log using "`W'/h41.log", text name(h41)
capture noisily do master.do analysis/01_rtab.R
local rc = _rc
log close h41
quietly cd "`here'"
quietly do "`here'/setpin.do" "`C'/pins.do" pin_toy v1
global t_want "chair_use: toy v3, which pins.do names, "
quietly do "`here'/logsays.do" "`W'/h41.log"
mata: s = cat(st_local("W") + "/h41.log"); f = select(s, substr(s, 1, 7) :== "Failed:"); st_local("said", strofreal(strtoreal(st_local("said")) & rows(f) == 1 ? f[1] == "Failed: analysis/01_rtab.R (r(" + st_local("rc") + "))" : 0))
capture confirm file "`done'"
do "`rec'" "`out'" H41 "an R step stops on a version without a manifest with Failed and its name and no done-file" 0 `=(`rc' == 0) + 1000 * (!`said' | !_rc)'
global t_want `"chair_use: toy v3, which pins.do names, is not in this package's data/ folder: `P'/data/processed/toy/v3 has no manifest. The package's README.md says what to do: a version it marks rebuild is rebuilt first, as its "Instructions to replicators" say; an input the package omits is obtained as "Inputs the package omits" says."'
global t_without "Dropbox"
quietly do "`here'/logsays.do" "`W'/h41.log"
global t_without ""
do "`rec'" "`out'" H42 "in a package that stop says the version is not in its data folder and points to its README and not to Dropbox" 1 `said'

* ---- The pins, read by Stata and by R ---------------------------------------------------------------
* A pin line that ends with a comment: the full run's Stata step and R step each load toy v1.
mata: s = cat(st_local("C") + "/pins.do"); s = select(s, !ustrregexm(s, "^global pin_toy ")) \ ("global pin_toy " + char(34) + "v1" + char(34) + " // a note"); unlink(st_local("C") + "/pins.do"); fh = fopen(st_local("C") + "/pins.do", "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
sleep 1100
quietly cd "`C'"
log using "`W'/h43.log", text name(h43)
capture noisily do master.do
local rc = _rc
log close h43
quietly cd "`here'"
global t_want "chair_use: toy/toy v1"
quietly do "`here'/logsays.do" "`W'/h43.log"
do "`rec'" "`out'" H43 "a pin line that ends with a comment is read by the Stata step and by the R step of one run" 0 `=`rc' + 1000 * (`nsaid' != 2)'
* The same with a comment written /* */.
mata: s = cat(st_local("C") + "/pins.do"); s = select(s, !ustrregexm(s, "^global pin_toy ")) \ ("global pin_toy " + char(34) + "v1" + char(34) + " /* a note */"); unlink(st_local("C") + "/pins.do"); fh = fopen(st_local("C") + "/pins.do", "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
sleep 1100
quietly cd "`C'"
log using "`W'/h59.log", text name(h59)
capture noisily do master.do
local rc = _rc
log close h59
quietly cd "`here'"
global t_want "chair_use: toy/toy v1"
quietly do "`here'/logsays.do" "`W'/h59.log"
do "`rec'" "`out'" H59 "a pin line that ends with a /* */ comment is read by the Stata step and by the R step of one run" 0 `=`rc' + 1000 * (`nsaid' != 2)'
* A dataset pinned on two lines stops the R step run on its own, naming the lines.
quietly do "`here'/setpin.do" "`C'/pins.do" pin_toy v1
mata: fh = fopen(st_local("C") + "/pins.do", "a"); fput(fh, "global pin_toy " + char(34) + "v2" + char(34)); fclose(fh)
mata: s = cat(st_local("C") + "/pins.do"); i = select(1::rows(s), ustrregexm(s, "^global pin_toy ")); st_local("lines", rows(i) == 2 ? strofreal(i[1]) + " and " + strofreal(i[2]) : "")
* The step on its own writes its table at its end: a stop leaves none.
capture erase "`tab'"
quietly cd "`P'"
log using "`W'/h44.log", text name(h44)
capture noisily rscript using "`C'/analysis/01_rtab.R"
log close h44
quietly cd "`here'"
global t_want "pins.do sets pin_toy twice, on lines `lines'. A dataset or a raw delivery is pinned on one line"
quietly do "`here'/logsays.do" "`W'/h44.log"
capture confirm file "`tab'"
do "`rec'" "`out'" H44 "a dataset pinned on two lines stops the R step run on its own with its sentence that names the lines" 0 `=1000 * (!`said' | "`lines'" == "" | !_rc)'
* The same for a raw delivery pinned on two lines.
quietly do "`here'/setpin.do" "`C'/pins.do" pin_toy v1
mata: fh = fopen(st_local("C") + "/pins.do", "a"); fput(fh, "global raw_toy " + char(34) + "toy-raw/2026-01-01" + char(34)); fclose(fh)
mata: s = cat(st_local("C") + "/pins.do"); i = select(1::rows(s), ustrregexm(s, "^global raw_toy ")); st_local("lines", rows(i) == 2 ? strofreal(i[1]) + " and " + strofreal(i[2]) : "")
capture erase "`tab'"
quietly cd "`P'"
log using "`W'/h58.log", text name(h58)
capture noisily rscript using "`C'/analysis/01_rtab.R"
log close h58
quietly cd "`here'"
quietly do "`here'/setpin.do" "`C'/pins.do" raw_toy toy-raw/2026-01-01
global t_want "pins.do sets raw_toy twice, on lines `lines'. A dataset or a raw delivery is pinned on one line"
quietly do "`here'/logsays.do" "`W'/h58.log"
capture confirm file "`tab'"
do "`rec'" "`out'" H58 "a raw delivery pinned on two lines stops the R step run on its own with its sentence that names the lines" 0 `=1000 * (!`said' | "`lines'" == "" | !_rc)'
* A pin line without its double quotes, which Stata reads, stops the R step with its sentence.
quietly do "`here'/setpin.do" "`C'/pins.do" pin_toy v1
mata: s = cat(st_local("C") + "/pins.do"); i = selectindex(ustrregexm(s, "^global pin_toy ")); s[i] = J(rows(i), 1, "global pin_toy v1"); st_local("line", rows(i) == 1 ? strofreal(i[1]) : ""); unlink(st_local("C") + "/pins.do"); fh = fopen(st_local("C") + "/pins.do", "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
capture erase "`tab'"
quietly cd "`P'"
log using "`W'/h45.log", text name(h45)
capture noisily rscript using "`C'/analysis/01_rtab.R"
log close h45
quietly cd "`here'"
quietly do "`here'/setpin.do" "`C'/pins.do" pin_toy v1
global t_want "pins.do, line `line', is not a pin that can be read: global pin_toy v1 . Write it as"
quietly do "`here'/logsays.do" "`W'/h45.log"
capture confirm file "`tab'"
do "`rec'" "`out'" H45 "a pin line without its double quotes stops the R step with its sentence" 0 `=1000 * (!`said' | "`line'" == "" | !_rc)'

* ---- R not ready: one sentence before any folder is emptied -----------------------------------------
* Each is a full run; markers in temp/, temp/explore/ and the three results folders must stay.
* R not found: RSCRIPT_PATH names a file that does not exist.
local rpath `"${RSCRIPT_PATH}"'
local notready "Failed: R is not ready for this project, for the reason just above. "
quietly do "`here'/markers.do" "`P'" plant
global RSCRIPT_PATH "`W'/nowhere/Rscript"
sleep 1100
quietly cd "`C'"
log using "`W'/h46.log", text name(h46)
capture noisily do master.do
local rc = _rc
log close h46
quietly cd "`here'"
global RSCRIPT_PATH `"`rpath'"'
global t_want "R executable not found"
quietly do "`here'/logsays.do" "`W'/h46.log"
local ok = `said'
global t_want "`notready'"
quietly do "`here'/logsays.do" "`W'/h46.log"
quietly do "`here'/markers.do" "`P'" check
capture confirm file "`P'/temp/r_check.done"
do "`rec'" "`out'" H46 "R not found stops the run with its sentence before anything is cleared" 601 `=`rc' + 1000 * (!`ok' | !`said' | !`kept' | !_rc)'
* Another R minor version than renv.lock names (the toy project's lock, edited): the running R's
* major number with another minor number, so that only the minor number differs.
mata: v = tokens(st_local("have"), "."); st_local("other", rows(v) == 1 & cols(v) >= 3 ? v[1] + "." + strofreal(strtoreal(v[3]) > 0 ? strtoreal(v[3]) - 1 : strtoreal(v[3]) + 1) + ".0" : "0.0.0")
copy "`P'/renv.lock" "`W'/renv.lock.keep", replace
mata: s = cat(st_local("P") + "/renv.lock"); i = selectindex(ustrregexm(s, `"^ *"Version": *"[0-9.]+""')); s[i[1]] = ustrregexra(s[i[1]], "[0-9.]+", st_local("other")); unlink(st_local("P") + "/renv.lock"); fh = fopen(st_local("P") + "/renv.lock", "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
quietly do "`here'/markers.do" "`P'" plant
sleep 1100
quietly cd "`C'"
log using "`W'/h47.log", text name(h47)
capture noisily do master.do
local rc = _rc
log close h47
quietly cd "`here'"
copy "`W'/renv.lock.keep" "`P'/renv.lock", replace
global t_want "This project needs R `other' (renv.lock); this is R `have'. Install R `other'"
quietly do "`here'/logsays.do" "`W'/h47.log"
local ok = `said'
global t_want "`notready'"
quietly do "`here'/logsays.do" "`W'/h47.log"
quietly do "`here'/markers.do" "`P'" check
capture confirm file "`P'/temp/r_check.done"
do "`rec'" "`out'" H47 "another R minor version than renv.lock names stops the run with its sentence before anything is cleared" 601 `=`rc' + 1000 * (!`ok' | !`said' | !`kept' | !_rc)'
* The toy project's own renv.lock with its RENV repository removed, as a snapshot taken with one
* repository writes it: the library is restored and every package is there, so only that check
* can stop it. A full run stops with the sentence before anything is cleared, and the R step run
* on its own stops with it and writes no table.
copy "`P'/renv.lock" "`W'/renv.lock.keep68", replace
mata: s = cat(st_local("P") + "/renv.lock"); i = selectindex(ustrregexm(s, `"^ *"Name": *"RENV""')); st_local("cut", strofreal(rows(i) == 1 & cols(i) == 1)); if (rows(i) == 1 & cols(i) == 1) { s[i - 2] = subinstr(s[i - 2], "},", "}"); s = s[1..i - 2] \ s[i + 3..rows(s)]; }; unlink(st_local("P") + "/renv.lock"); fh = fopen(st_local("P") + "/renv.lock", "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
mata: s = cat(st_local("P") + "/renv.lock"); st_local("left", strofreal(sum(ustrregexm(s, "RENV"))))
quietly do "`here'/markers.do" "`P'" plant
sleep 1100
quietly cd "`C'"
log using "`W'/h68.log", text name(h68)
capture noisily do master.do
local rc = _rc
log close h68
quietly cd "`here'"
local sentence "renv.lock names no repository called RENV, from which renv installs itself, so a fresh clone on another machine cannot install renv or restore the packages, though this machine runs: put the RENV entry back among the Repositories of renv.lock as code/templates/r-project/renv.lock has it"
global t_want "`sentence'"
quietly do "`here'/logsays.do" "`W'/h68.log"
local ok = `said'
global t_want "`notready'"
quietly do "`here'/logsays.do" "`W'/h68.log"
local said1 = `said'
quietly do "`here'/markers.do" "`P'" check
capture confirm file "`P'/temp/r_check.done"
local done = !_rc
capture erase "`tab'"
quietly cd "`P'"
log using "`W'/h68b.log", text name(h68b)
capture noisily rscript using "`C'/analysis/01_rtab.R"
log close h68b
quietly cd "`here'"
copy "`W'/renv.lock.keep68" "`P'/renv.lock", replace
global t_want "`sentence'"
quietly do "`here'/logsays.do" "`W'/h68b.log"
capture confirm file "`tab'"
do "`rec'" "`out'" H68 "a renv.lock without its RENV repository stops the run with its sentence before anything is cleared and stops the R step run on its own" 601 `=`rc' + 1000 * (!`cut' | `left' | !`ok' | !`said1' | !`kept' | `done' | !`said' | !_rc)'
* An R that quits with status 0 during the check (the toy project's renv/activate.R, which
* _config.R sources, replaced by a quit), with the done-file of an earlier check left in temp/:
* the run stops with the sentence before anything is cleared.
copy "`P'/renv/activate.R" "`W'/activate.R.keep", replace
mata: f = st_local("P") + "/renv/activate.R"; unlink(f); fh = fopen(f, "w"); fput(fh, "quit(save = " + char(34) + "no" + char(34) + ", status = 0)"); fclose(fh)
quietly do "`here'/markers.do" "`P'" plant
mata: fh = fopen(st_local("P") + "/temp/r_check.done", "w"); fput(fh, "ready"); fclose(fh)
sleep 1100
quietly cd "`C'"
log using "`W'/h51.log", text name(h51)
capture noisily do master.do
local rc = _rc
log close h51
quietly cd "`here'"
copy "`W'/activate.R.keep" "`P'/renv/activate.R", replace
global t_want "`notready'"
quietly do "`here'/logsays.do" "`W'/h51.log"
quietly do "`here'/markers.do" "`P'" check
capture confirm file "`P'/temp/r_check.done"
local left = !_rc
capture erase "`P'/temp/r_check.done"
do "`rec'" "`out'" H51 "an R that quits with status 0 during the check stops the run with the sentence before anything is cleared" 601 `=`rc' + 1000 * (!`said' | !`kept' | `left')'
* The same R, with the done-file of an earlier check left in a temp/ made read-only, so that it
* cannot be erased: the run stops with the sentence that names the file, before R is called and
* before anything is cleared. The folder is made read-only with chmod, which Windows lacks; a
* runner that erases a file in a read-only folder all the same cannot play the case either.
local why ""
if c(os) == "Windows" local why "a file that cannot be erased is made with chmod, which Windows lacks"
else {
    mata: fh = fopen(st_local("P") + "/temp/sacrificial.txt", "w"); fput(fh, "x"); fclose(fh)
    shell chmod a-w "`P'/temp"
    capture erase "`P'/temp/sacrificial.txt"
    local gone = !_rc
    shell chmod u+w "`P'/temp"
    capture erase "`P'/temp/sacrificial.txt"
    if `gone' local why "this runner erases a file in a folder made read-only, as an administrator can"
}
if "`why'" != "" {
    tempname fh
    file open `fh' using "`out'", write text append
    file write `fh' "TEST SKIP H64: `why'" _n
    file close `fh'
}
else {
    mata: f = st_local("P") + "/renv/activate.R"; unlink(f); fh = fopen(f, "w"); fput(fh, "quit(save = " + char(34) + "no" + char(34) + ", status = 0)"); fclose(fh)
    quietly do "`here'/markers.do" "`P'" plant
    mata: fh = fopen(st_local("P") + "/temp/r_check.done", "w"); fput(fh, "ready"); fclose(fh)
    shell chmod a-w "`P'/temp"
    sleep 1100
    quietly cd "`C'"
    log using "`W'/h64.log", text name(h64)
    capture noisily do master.do
    local rc = _rc
    log close h64
    quietly cd "`here'"
    shell chmod u+w "`P'/temp"
    copy "`W'/activate.R.keep" "`P'/renv/activate.R", replace
    global t_want "Failed: the file `P'/temp/r_check.done, left by an earlier check of R, cannot be deleted, so R was not checked: delete that file, and run again (r(601))"
    quietly do "`here'/logsays.do" "`W'/h64.log"
    quietly do "`here'/markers.do" "`P'" check
    capture erase "`P'/temp/r_check.done"
    do "`rec'" "`out'" H64 "a done-file of an earlier check that cannot be erased stops the run with the sentence that names it before anything is cleared" 601 `=`rc' + 1000 * (!`said' | !`kept')'
}
* renv's activation switched off (RENV_CONFIG_AUTOLOADER_ENABLED=false, set on the first line of
* the clone's renv/activate.R), an empty project library, and a lock that names one package, which
* R's own installation holds (and names the RENV repository, so that only the library is wanting):
* the run stops with the sentence before anything is cleared.
local I "`W'/rinactive"
quietly do "`here'/copytree.do" "`N'" "`I'"
mkdir "`I'/renv/library"
mata: f = st_local("I") + "/renv/activate.R"; s = ("Sys.setenv(RENV_CONFIG_AUTOLOADER_ENABLED = " + char(34) + "false" + char(34) + ")") \ cat(f); unlink(f); fh = fopen(f, "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
mata: f = st_local("I") + "/renv.lock"; q = char(34); s = "{" \ ("  " + q + "R" + q + ": {" + q + "Version" + q + ": " + q + st_local("have") + q + ", " + q + "Repositories" + q + ": [{" + q + "Name" + q + ": " + q + "RENV" + q + ", " + q + "URL" + q + ": " + q + "https://packagemanager.posit.co/cran/2026-11-16" + q + "}]},") \ ("  " + q + "Packages" + q + ": {" + q + "MASS" + q + ": {" + q + "Package" + q + ": " + q + "MASS" + q + ",") \ ("    " + q + "Version" + q + ": " + q + "7.3-65" + q + "}}") \ "}"; unlink(f); fh = fopen(f, "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
quietly do "`here'/markers.do" "`I'" plant
sleep 1100
quietly cd "`I'/code"
log using "`W'/h65.log", text name(h65)
capture noisily do master.do
local rc = _rc
log close h65
quietly cd "`here'"
global t_want "This clone's R packages are not installed yet, or R does not use them (its library is "
quietly do "`here'/logsays.do" "`W'/h65.log"
local ok = `said'
global t_want "`notready'"
quietly do "`here'/logsays.do" "`W'/h65.log"
quietly do "`here'/markers.do" "`I'" check
capture confirm file "`I'/temp/r_check.done"
do "`rec'" "`out'" H65 "R with renv's activation switched off and an empty project library stops the run with its sentence before anything is cleared" 601 `=`rc' + 1000 * (!`ok' | !`said' | !`kept' | !_rc)'
* A clone whose R library is not restored, then the same clone without renv.lock.
local n 48
foreach case in library lock {
    if "`case'" == "lock" erase "`N'/renv.lock"
    quietly do "`here'/markers.do" "`N'" plant
    sleep 1100
    quietly cd "`N'/code"
    log using "`W'/h`n'.log", text name(h`n')
    capture noisily do master.do
    local rc = _rc
    log close h`n'
    quietly cd "`here'"
    global t_want = cond("`case'" == "library", "This clone's R packages are not installed yet: once, in R, in the project folder, type  renv::restore()  and run again.", "This project has R steps and no renv.lock: copy what is in code/templates/r-project/ into the project folder")
    quietly do "`here'/logsays.do" "`W'/h`n'.log"
    local ok = `said'
    global t_want "`notready'"
    quietly do "`here'/logsays.do" "`W'/h`n'.log"
    quietly do "`here'/markers.do" "`N'" check
    capture confirm file "`N'/temp/r_check.done"
    local got_`case' = `rc' + 1000 * (!`ok' | !`said' | !`kept' | !_rc)
    local n = `n' + 1
}
do "`rec'" "`out'" H48 "an R library that is not restored stops the run with its sentence before anything is cleared" 601 `got_library'
do "`rec'" "`out'" H49 "a project with R steps and no renv.lock stops the run with its sentence before anything is cleared" 601 `got_lock'

* ---- A dataset whose name begins with a digit -------------------------------------------------------
* Stata's chair_use reads pin__1toy (strtoname() puts _ before a digit); pinned once, on that line,
* an explore file in Stata and one in R load the same version, v2.
quietly do "`here'/toyversion.do" "`P'/data" 1toy v1 toy 10
quietly do "`here'/toyversion.do" "`P'/data" 1toy v2 toy 20
mata: fh = fopen(st_local("C") + "/pins.do", "a"); fput(fh, "global pin__1toy " + char(34) + "v2" + char(34)); fclose(fh)
mata: fh = fopen(st_local("C") + "/explore/02_digit.do", "w"); fput(fh, "chair_use 1toy/toy, clear"); fput(fh, "display as text " + char(34) + "digit: " + char(34) + " _N " + char(34) + " rows" + char(34)); fclose(fh)
quietly do "`here'/rstep.do" "`P'" explore/02_digit.R digit
local rcs 0
local both 1
foreach f in 02_digit.do 02_digit.R {
    sleep 1100
    quietly cd "`C'"
    log using "`W'/h50.log", text name(h50) replace
    capture noisily do master.do explore/`f'
    local rcs = `rcs' + _rc
    log close h50
    quietly cd "`here'"
    global t_want "chair_use: 1toy/toy v2"
    quietly do "`here'/logsays.do" "`W'/h50.log"
    local both = `both' & `said'
}
mata: s = cat(st_local("C") + "/pins.do"); s = select(s, !ustrregexm(s, "^global pin__1toy ")); unlink(st_local("C") + "/pins.do"); fh = fopen(st_local("C") + "/pins.do", "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
do "`rec'" "`out'" H50 "a dataset whose name begins with a digit pinned once loads the same version in Stata and in R" 0 `=`rcs' + 1000 * !`both''
global t_want ""
