/*
  The Stata cases: do s_tests.do <tests folder>, from run_tests.do, before the R cases. They make
  the test data root, _t/data/ (one raw delivery and two toy versions, which r_tests.do uses
  too), and toy projects from ../../project-template in _t/.
*/
args here
local tmpl = substr("`here'", 1, strrpos(substr("`here'", 1, strrpos("`here'", "/") - 1), "/")) + "project-template"
local out "`here'/results.txt"
local rec "`here'/record.do"
local W "`here'/_t"
* A suite stopped during H52, H53 or H64 leaves a folder that cannot be written: it is made
* writable first.
quietly do "`here'/rmtree.do" "`W'" writable
local R "`W'/data"
foreach d in "`W'" "`R'" "`R'/raw" "`R'/raw/toy-raw" "`R'/raw/toy-raw/2026-01-01" {
    mkdir "`d'"
}
quietly do "`here'/toyversion.do" "`R'" toy v1 toy 10
quietly do "`here'/toyversion.do" "`R'" toy v2 toy 20
* The raw delivery: a weight per canton, which the toy project reads through its raw pin.
clear
set obs 26
generate ctn = _n
generate weight = 27 - ctn
export delimited using "`R'/raw/toy-raw/2026-01-01/weights.csv"
clear
* A project made from the template, as "Use this template" does: nothing is edited, and it runs.
local F "`W'/fresh"
quietly do "`here'/copytree.do" "`tmpl'" "`F'"
quietly do "`here'/copytree.do" "`R'" "`F'/data"
* The template ships a results page, so the case reads the run's own lines: the page was written
* and the run completed, and the run left its dated log in logs/. A line that holds the project's
* path can be longer than the 255 characters of a log line: logsays.do joins its parts.
sleep 1100
quietly cd "`F'/code"
log using "`W'/h17.log", text name(h17)
capture noisily do master.do
local rc = _rc
log close h17
quietly cd "`here'"
global t_want "Results page written: `F'/paper/results/README.md"
global t_without ""
quietly do "`here'/logsays.do" "`W'/h17.log"
local page = `nsaid' == 1
global t_want "Run complete. Exhibits and the results page: `F'/paper/results"
quietly do "`here'/logsays.do" "`W'/h17.log"
mata: st_local("page", strofreal(strtoreal(st_local("page")) & strtoreal(st_local("nsaid")) == 1 & rows(dir(st_local("F") + "/logs", "files", "master_*.smcl")) == 1))
do "`rec'" "`out'" H17 "a project made from the template runs with no edit before its first run and writes its results page" 0 `=`rc' + 1000 * !`page''
* A table written with esttab, as the rules ask, from the package the template ships in ado/: the
* run ends Run complete and the results page lists the table with its script.
local E "`W'/esttab"
quietly do "`here'/copytree.do" "`tmpl'" "`E'"
quietly do "`here'/copytree.do" "`R'" "`E'/data"
mata: s = cat(st_local("E") + "/code/master.do"); s = subinstr(s, `"local steps """', "local steps analysis/01_reg.do"); unlink(st_local("E") + "/code/master.do"); fh = fopen(st_local("E") + "/code/master.do", "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
quietly do "`here'/step.do" "`E'" analysis/01_reg.do esttab
sleep 1100
quietly cd "`E'/code"
log using "`W'/h27.log", text name(h27)
capture noisily do master.do
local rc = _rc
log close h27
quietly cd "`here'"
global t_want "Run complete. Exhibits and the results page: `E'/paper/results"
quietly do "`here'/logsays.do" "`W'/h27.log"
mata: st_local("page", strofreal(strtoreal(st_local("nsaid")) == 1 & fileexists(st_local("E") + "/paper/results/tables/01_reg.tex")))
if `page' mata: b = char(96); st_local("page", strofreal(sum(cat(st_local("E") + "/paper/results/README.md") :== "| [01_reg.tex](tables/01_reg.tex) | [" + b + "code/analysis/01_reg.do" + b + "](../../code/analysis/01_reg.do) |") == 1))
do "`rec'" "`out'" H27 "a step that writes its table with esttab and no replace ends Run complete and the table is on the results page" 0 `=`rc' + 1000 * !`page''
* The same with steps: the researcher's only edit is the step list.
local P "`W'/toy"
quietly do "`here'/copytree.do" "`tmpl'" "`P'"
quietly do "`here'/copytree.do" "`R'" "`P'/data"
mata: s = cat(st_local("P") + "/code/master.do"); s = subinstr(s, `"local steps """', "local steps dataprep/01_load.do analysis/01_fig.do analysis/02_tab.do"); unlink(st_local("P") + "/code/master.do"); fh = fopen(st_local("P") + "/code/master.do", "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
quietly do "`here'/step.do" "`P'" dataprep/01_load.do load
quietly do "`here'/step.do" "`P'" analysis/01_fig.do fig
quietly do "`here'/step.do" "`P'" analysis/02_tab.do tab
quietly do "`here'/step.do" "`P'" explore/01_look.do explore
local C "`P'/code"

* ---- Pin and run a fresh clone ----------------------------------------------------------------
* A pin is one line of pins.do, edited by hand: setpin.do plays the edit. The template's own
* pins.do pins nothing; after the edit it holds the two lines, each a version or a delivery and
* no checksum (H02 runs on them).
mata: s = cat(st_local("tmpl") + "/code/pins.do"); st_local("none", strofreal(sum(ustrregexm(s, "^\s*global ")) == 0))
capture noisily do "`here'/setpin.do" "`C'/pins.do" pin_toy v1
local rc = _rc
capture noisily do "`here'/setpin.do" "`C'/pins.do" raw_toy toy-raw/2026-01-01
local rc = `rc' + _rc
mata: s = cat(st_local("C") + "/pins.do"); st_local("pinned", strofreal(sum(s :== `"global pin_toy "v1""') == 1 & sum(s :== `"global raw_toy "toy-raw/2026-01-01""') == 1 & sum(ustrregexm(s, "^global ")) == 2))
do "`rec'" "`out'" H01 "the template's pins.do pins nothing and a pin added by hand is one line of it: a version and no checksum" 0 `=`rc' + (`pinned' != 1) + 1000 * !`none''
sleep 1100
quietly cd "`C'"
capture noisily do master.do
local rc = _rc
quietly cd "`here'"
* The table holds the sum of value * weight: value from toy v1 (10 * ctn) and weight from the raw
* delivery (27 - ctn), 32760 when both were read.
local both 0
mata: st_local("both", strofreal(fileexists(st_local("P") + "/paper/results/tables/02_tab.tex")))
if `both' mata: s = cat(st_local("P") + "/paper/results/tables/02_tab.tex"); st_local("both", strofreal(rows(s) == 1 & ustrregexm(s[1], "^total +32760$")))
do "`rec'" "`out'" H02 "a fresh clone runs end to end on a raw pin and a toy version in the data root inside its folder" 0 `=`rc' + 1000 * !`both''
* That run's dated log, the one in logs/, names each pin and its value, once each.
local pinlog : dir "`P'/logs" files "master_*.smcl"
local said 0
if `: word count `pinlog'' == 1 {
    local pinlog : word 1 of `pinlog'
    quietly translate "`P'/logs/`pinlog'" "`W'/h29.txt", translator(smcl2log)
    mata: s = cat(st_local("W") + "/h29.txt"); st_local("said", strofreal(sum(s :== "pins.do: pin_toy " + char(34) + "v1" + char(34)) == 1 & sum(s :== "pins.do: raw_toy " + char(34) + "toy-raw/2026-01-01" + char(34)) == 1))
}
do "`rec'" "`out'" H29 "a finished run's dated log names each pin of pins.do and its value" 1 `said'
* Each figure as its picture with the script two lines below; each table and number as a link
* beside its script; the run made three exhibits, and the page lists those three and no other.
mata: s = cat(st_local("P") + "/paper/results/README.md"); b = char(96); fi = select(1::rows(s), s :== "![01_fig](figures/01_fig.png)"); mi = select(1::rows(s), s :== "Made by [" + b + "code/analysis/01_fig.do" + b + "](../../code/analysis/01_fig.do)"); ti = select(1::rows(s), s :== "| [02_tab.tex](tables/02_tab.tex) | [" + b + "code/analysis/02_tab.do" + b + "](../../code/analysis/02_tab.do) |"); ni = select(1::rows(s), s :== "| [02_tab_total.txt](numbers/02_tab_total.txt) | [" + b + "code/analysis/02_tab.do" + b + "](../../code/analysis/02_tab.do) |"); n = sum(substr(s, 1, 2) :== "![") + sum(substr(s, 1, 3) :== "| ["); st_local("page", strofreal(rows(fi) == 1 & rows(mi) == 1 & rows(ti) == 1 & rows(ni) == 1 & n == 3 ? mi[1] == fi[1] + 2 : 0))
do "`rec'" "`out'" H03 "the results page lists every exhibit with its script and no other" 1 `page'

* ---- The guard, the cleared settings, the stop line -------------------------------------------
* The project's own master.do, started from another folder: it prints one sentence and stops
* before the settings of the run above are cleared. The case reads the line the run printed in a
* log of its own, not the echoed command.
* The settings are every global named p_*, pin_* or raw_*, and data: all must be as they were.
mkdir "`W'/elsewhere"
local gs : all globals "p_*"
local gs `gs' `: all globals "pin_*"' `: all globals "raw_*"' data
local gs : list sort gs
local was ""
foreach g of local gs {
    local was `"`was'|`g'=${`g'}"'
}
local full = strpos(`"`was'|"', "|p_code=`C'|") & strpos(`"`was'|"', "|data=`P'/data|") & strpos(`"`was'"', "|pin_toy=v") & strpos(`"`was'"', "|raw_toy=toy-raw/")
quietly cd "`W'/elsewhere"
log using "`W'/h04.log", text name(h04)
capture noisily do "`C'/master.do"
local rc = _rc
log close h04
quietly cd "`here'"
local want "Failed: Stata is not in this project's code folder, so nothing was run: double-click master.do in the project's code folder in Explorer and click Do, or cd into that folder and type  do master.do  (not File > Open)."
mata: s = cat(st_local("W") + "/h04.log"); f = select(s, substr(s, 1, 7) :== "Failed:"); st_local("said", strofreal(rows(f) == 1 ? f[1] == st_local("want") : 0))
local now ""
foreach g of local gs {
    local now `"`now'|`g'=${`g'}"'
}
local kept = `full' & `"`now'"' == `"`was'"'
do "`rec'" "`out'" H04 "master.do started in another folder stops with its one sentence and keeps every setting of the earlier run" 170 `=`rc' + 1000 * (!`said' | !`kept')'
* The guard asks for both files: a folder that holds pins.do and no master.do stops it too.
mkdir "`W'/pinsonly"
copy "`C'/pins.do" "`W'/pinsonly/pins.do"
quietly cd "`W'/pinsonly"
log using "`W'/h26.log", text name(h26)
capture noisily do "`C'/master.do"
local rc = _rc
log close h26
quietly cd "`here'"
mata: s = cat(st_local("W") + "/h26.log"); f = select(s, substr(s, 1, 7) :== "Failed:"); st_local("said", strofreal(rows(f) == 1 ? f[1] == st_local("want") : 0))
local now ""
foreach g of local gs {
    local now `"`now'|`g'=${`g'}"'
}
local kept = `full' & `"`now'"' == `"`was'"'
do "`rec'" "`out'" H26 "master.do started in a folder with pins.do and no master.do stops with the guard's sentence and keeps the settings" 170 `=`rc' + 1000 * (!`said' | !`kept')'
* A fresh Stata has no settings. The stopped start above leaves the settings of the earlier run
* in place, so this case clears them itself, standing for a fresh Stata.
* The case reads the step's own sentence, the one its stop lines print, in a log of its own.
local stepsays "This step needs this project's settings, which master.do sets: from this project's code folder type  do master.do <folder>/<this file>  (after that, its lines also run on their own in the same Stata)."
macro drop p_* pin_* raw_* data
quietly cd "`C'"
log using "`W'/h05.log", text name(h05)
capture noisily do analysis/01_fig.do
local rc = _rc
log close h05
quietly cd "`here'"
mata: s = cat(st_local("W") + "/h05.log"); st_local("said", strofreal(sum(s :== st_local("stepsays")) == 1))
do "`rec'" "`out'" H05 "a step run where no settings are set stops with its one sentence" 198 `=`rc' + 1000 * !`said''
* After a run the settings stay: a step's lines run again in the same Stata.
sleep 1100
quietly cd "`C'"
capture noisily do master.do
local rc = _rc
quietly cd "`here'"
quietly cd "`C'"
capture noisily do dataprep/01_load.do
local rc2 = _rc
quietly cd "`here'"
do "`rec'" "`out'" H18 "after a run a step's lines run again in the same Stata" 0 `=`rc' + `rc2''
* Another project's run leaves its own settings: this project's step stops.
local O "`W'/other"
quietly do "`here'/copytree.do" "`P'" "`O'"
sleep 1100
quietly cd "`O'/code"
capture noisily do master.do
local rc = _rc
quietly cd "`here'"
quietly cd "`C'"
log using "`W'/h06.log", text name(h06)
capture noisily do dataprep/01_load.do
local rc = _rc
log close h06
quietly cd "`here'"
mata: s = cat(st_local("W") + "/h06.log"); st_local("said", strofreal(sum(s :== st_local("stepsays")) == 1))
do "`rec'" "`out'" H06 "a step run in a session left by another project stops with its one sentence" 198 `=`rc' + 1000 * !`said''
* A run clears the pins another project's run left: in the session the other project's run left,
* this project's pins.do, without its line for toy, stops the loader with its sentence. The case
* reads that sentence, and no line of the loader that loaded a version.
copy "`C'/pins.do" "`W'/pins.keep", replace
mata: s = cat(st_local("C") + "/pins.do"); s = select(s, !ustrregexm(s, "^global pin_toy ")); unlink(st_local("C") + "/pins.do"); fh = fopen(st_local("C") + "/pins.do", "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
sleep 1100
quietly cd "`C'"
log using "`W'/h56.log", text name(h56)
capture noisily do master.do explore/01_look.do
local rc = _rc
log close h56
quietly cd "`here'"
copy "`W'/pins.keep" "`C'/pins.do", replace
global t_want "chair_use: pins.do pins no version of toy."
global t_without ""
quietly do "`here'/logsays.do" "`W'/h56.log"
local ok = `said'
global t_want "chair_use: toy/toy v"
quietly do "`here'/logsays.do" "`W'/h56.log"
do "`rec'" "`out'" H56 "a run clears the pins another project's run left: a dataset this project's pins.do does not pin stops the loader with its sentence" 459 `=`rc' + 1000 * (!`ok' | `said')'

* ---- Moving to a new version is one edited line; an explore file runs with the paths and pins ---
quietly do "`here'/setpin.do" "`C'/pins.do" pin_toy v2
sleep 1100
quietly cd "`C'"
capture noisily do master.do dataprep/01_load.do
local rc = _rc
quietly cd "`here'"
local v2 0
capture noisily {
    use "`P'/temp/toy.dta", clear
    local v2 = value[1] == 20
    clear
}
do "`rec'" "`out'" H07 "moving to v2 is one edited line of pins.do: the next run loads v2" 1 `=`rc' == 0 & `v2''
* After pins.do is edited, lines of a step run again in the same Stata read the new pin:
* outside a run chair_use reads pins.do afresh.
quietly do "`here'/setpin.do" "`C'/pins.do" pin_toy v1
quietly cd "`C'"
capture noisily do dataprep/01_load.do
local rc = _rc
quietly cd "`here'"
local v1 0
capture noisily {
    use "`P'/temp/toy.dta", clear
    local v1 = value[1] == 10
    clear
}
do "`rec'" "`out'" H19 "after pins.do is edited a step's lines run again in the same Stata load the version it now names" 1 `=`rc' == 0 & `v1''
* A dataset pinned on two lines: Stata would take the last and R the first. The run stops
* before anything is cleared.
* Marker files in temp/, temp/explore/ and the three results folders show that nothing was
* cleared; the case reads the stop in a log of its own and checks that it names the pin and both lines.
quietly do "`here'/markers.do" "`P'" plant
mata: fh = fopen(st_local("C") + "/pins.do", "a"); fput(fh, "global pin_toy " + char(34) + "v2" + char(34)); fclose(fh)
mata: s = cat(st_local("C") + "/pins.do"); i = select(1::rows(s), ustrregexm(s, "^global pin_toy ")); st_local("lines", rows(i) == 2 ? strofreal(i[1]) + " and " + strofreal(i[2]) : "")
sleep 1100
quietly cd "`C'"
log using "`W'/h20.log", text name(h20)
capture noisily do master.do
local rc = _rc
log close h20
quietly cd "`here'"
mata: s = cat(st_local("W") + "/h20.log"); f = select(s, substr(s, 1, 7) :== "Failed:"); st_local("said", strofreal(rows(f) == 1 & st_local("lines") != "" ? strpos(f[1], "Failed: pins.do sets pin_toy twice, on lines " + st_local("lines") + ". ") == 1 : 0))
quietly do "`here'/markers.do" "`P'" check
quietly do "`here'/markers.do" "`P'" plant
quietly do "`here'/setpin.do" "`C'/pins.do" pin_toy v2
do "`rec'" "`out'" H20 "a dataset pinned on two lines of pins.do stops the run before anything is cleared" 198 `=`rc' + 1000 * (!`said' | !`kept')'
* The same for a raw delivery pinned on two lines.
mata: fh = fopen(st_local("C") + "/pins.do", "a"); fput(fh, "global raw_toy " + char(34) + "toy-raw/2026-01-01" + char(34)); fclose(fh)
mata: s = cat(st_local("C") + "/pins.do"); i = select(1::rows(s), ustrregexm(s, "^global raw_toy ")); st_local("lines", rows(i) == 2 ? strofreal(i[1]) + " and " + strofreal(i[2]) : "")
sleep 1100
quietly cd "`C'"
log using "`W'/h21.log", text name(h21)
capture noisily do master.do
local rc = _rc
log close h21
quietly cd "`here'"
mata: s = cat(st_local("W") + "/h21.log"); f = select(s, substr(s, 1, 7) :== "Failed:"); st_local("said", strofreal(rows(f) == 1 & st_local("lines") != "" ? strpos(f[1], "Failed: pins.do sets raw_toy twice, on lines " + st_local("lines") + ". ") == 1 : 0))
quietly do "`here'/markers.do" "`P'" check
quietly do "`here'/setpin.do" "`C'/pins.do" raw_toy toy-raw/2026-01-01
do "`rec'" "`out'" H21 "a raw delivery pinned on two lines of pins.do stops the run before anything is cleared" 198 `=`rc' + 1000 * (!`said' | !`kept')'
* A line of pins.do that Stata cannot run stops the run with its sentence, before the dated log
* is opened and before anything is cleared: no new log in logs/, and the markers are still there.
quietly do "`here'/markers.do" "`P'" plant
mata: st_local("nlogs", strofreal(rows(dir(st_local("P") + "/logs", "files", "master_*.smcl"))))
mata: fh = fopen(st_local("C") + "/pins.do", "a"); fput(fh, "globl pin_bad " + char(34) + "v1" + char(34)); fclose(fh)
sleep 1100
quietly cd "`C'"
log using "`W'/h28.log", text name(h28)
capture noisily do master.do
local rc = _rc
log close h28
quietly cd "`here'"
mata: s = cat(st_local("W") + "/h28.log"); f = select(s, substr(s, 1, 7) :== "Failed:"); st_local("said", strofreal(rows(f) == 1 ? f[1] == "Failed: pins.do (r(199))" : 0)); st_local("nolog", strofreal(rows(dir(st_local("P") + "/logs", "files", "master_*.smcl")) == strtoreal(st_local("nlogs"))))
quietly do "`here'/markers.do" "`P'" check
mata: s = cat(st_local("C") + "/pins.do"); s = select(s, substr(s, 1, 6) :!= "globl "); unlink(st_local("C") + "/pins.do"); fh = fopen(st_local("C") + "/pins.do", "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
do "`rec'" "`out'" H28 "a line of pins.do that Stata cannot run stops the run with its sentence before the dated log is opened and before anything is cleared" 198 `=`rc' + 1000 * (!`said' | !`kept' | !`nolog')'
* A raw pin whose delivery is not in the data root stops the run with its sentence, before
* the dated log is opened and before anything is cleared.
quietly do "`here'/markers.do" "`P'" plant
mata: st_local("nlogs", strofreal(rows(dir(st_local("P") + "/logs", "files", "master_*.smcl"))))
quietly do "`here'/setpin.do" "`C'/pins.do" raw_toy toy-raw/2099-01-01
sleep 1100
quietly cd "`C'"
log using "`W'/h25.log", text name(h25)
capture noisily do master.do
local rc = _rc
log close h25
quietly cd "`here'"
* The project's data root is the folder data inside it, as in a replication package, so the
* sentence is the package's: it names the delivery and the folder and points to the package's
* README, and says nothing of Dropbox or of changing pins.do. A log breaks a line at 255
* characters and goes on in lines that begin "> ": the case joins them. The sentence for a data
* root on Dropbox needs a home folder of its own and is not reached here.
mata: s = cat(st_local("W") + "/h25.log") \ ""; i = select(1::rows(s), substr(s, 1, 7) :== "Failed:"); k = rows(i) == 1 ? i[1] : rows(s); m = k + 1; while (m <= rows(s) && substr(s[m], 1, 2) == "> ") m++; t = rows(i) == 1 ? s[k] : ""; for (j = k + 1; j < m; j++) t = t + substr(s[j], 3, .)
mata: e = "Failed: the raw delivery raw/toy-raw/2099-01-01 is not in this package's data/ folder, " + st_local("P") + "/data. The package's README.md, under " + char(34) + "Inputs the package omits" + char(34) + ", says how to obtain it and where to put it (r(601))"; st_local("said", strofreal(t == e & !strpos(t, "Dropbox")))
mata: st_local("nolog", strofreal(rows(dir(st_local("P") + "/logs", "files", "master_*.smcl")) == strtoreal(st_local("nlogs"))))
quietly do "`here'/markers.do" "`P'" check
quietly do "`here'/setpin.do" "`C'/pins.do" raw_toy toy-raw/2026-01-01
do "`rec'" "`out'" H25 "a raw pin whose delivery is not in a package's data folder stops the run with the sentence that points to the package README and not to Dropbox before the dated log is opened and before anything is cleared" 601 `=`rc' + 1000 * (!`said' | !`kept' | !`nolog')'
* The case reads the explore file's own line, with the data root, and the version chair_use read,
* which pins.do names; markers show that the run cleared nothing.
mata: s = cat(st_local("C") + "/pins.do"); s = select(s, ustrregexm(s, "^global pin_toy ")); st_local("pin", rows(s) == 1 ? subinstr(substr(s[1], 16, .), char(34), "") : "")
quietly do "`here'/markers.do" "`P'" plant
sleep 1100
quietly cd "`C'"
log using "`W'/h08.log", text name(h08)
capture noisily do master.do explore/01_look.do
local rc = _rc
log close h08
quietly cd "`here'"
global t_want "explore: 26 rows; data root `P'/data"
quietly do "`here'/logsays.do" "`W'/h08.log"
local ok = `nsaid' == 1
global t_want "chair_use: toy/toy `pin'"
quietly do "`here'/logsays.do" "`W'/h08.log"
local said = `ok' & `nsaid' == 1 & "`pin'" != ""
quietly do "`here'/markers.do" "`P'" check
do "`rec'" "`out'" H08 "an explore file runs with the project's paths and pins and clears nothing" 0 `=`rc' + 1000 * (!`said' | !`kept')'
* The ado-path is narrowed: a program found only in PERSONAL or in OLDPLACE (an old PLUS folder)
* before the run is not found inside the run. The explore file ends r(199) when neither is found.
foreach d in personal oldplace {
    mkdir "`W'/`d'"
    mata: fh = fopen(st_local("W") + "/`d'/zz`d'.ado", "w"); fput(fh, "program define zz`d'"); fput(fh, "    display " + char(34) + "zz`d' ran" + char(34)); fput(fh, "end"); fclose(fh)
}
local pers "`c(sysdir_personal)'"
local oldp "`c(sysdir_oldplace)'"
sysdir set PERSONAL "`W'/personal/"
sysdir set OLDPLACE "`W'/oldplace/"
adopath + PERSONAL
adopath + OLDPLACE
capture which zzpersonal
local before = _rc
capture which zzoldplace
local before = `before' + _rc
mata: fh = fopen(st_local("C") + "/explore/02_path.do", "w"); fput(fh, "capture zzpersonal"); fput(fh, "local a = _rc"); fput(fh, "capture zzoldplace"); fput(fh, "exit = min(" + char(96) + "a" + char(39) + ", _rc)"); fclose(fh)
sleep 1100
quietly cd "`C'"
capture noisily do master.do explore/02_path.do
local rc = _rc
quietly cd "`here'"
sysdir set PERSONAL "`pers'"
sysdir set OLDPLACE "`oldp'"
do "`rec'" "`out'" H22 "a program only in PERSONAL or OLDPLACE is not found inside a run" 199 `=`rc' + 1000 * (`before' != 0)'
* set varabbrev off: an abbreviated variable name stops the explore file (r(111)).
mata: fh = fopen(st_local("C") + "/explore/03_abbrev.do", "w"); fput(fh, "clear"); fput(fh, "set obs 1"); fput(fh, "generate value = 1"); fput(fh, "summarize val"); fclose(fh)
sleep 1100
quietly cd "`C'"
capture noisily do master.do explore/03_abbrev.do
local rc = _rc
quietly cd "`here'"
do "`rec'" "`out'" H23 "an abbreviated variable name stops a run" 111 `rc'
* The fixed seed: the first draw inside a run is the same in two runs started from other seeds,
* and is the first draw after the seed that master.do sets.
mata: fh = fopen(st_local("C") + "/explore/04_draw.do", "w"); fput(fh, "file open draw using " + char(34) + char(36) + "{p_temp}/explore/draw.txt" + char(34) + ", write text replace"); fput(fh, "file write draw %21x (runiform()) _n"); fput(fh, "file close draw"); fclose(fh)
local d ""
foreach seed in 999 1 {
    set seed `seed'
    sleep 1100
    quietly cd "`C'"
    capture noisily do master.do explore/04_draw.do
    local rc`seed' = _rc
    quietly cd "`here'"
    capture confirm file "`P'/temp/explore/draw.txt"
    if _rc local d "`d' none"
    else mata: st_local("d", st_local("d") + " " + strtrim(cat(st_local("P") + "/temp/explore/draw.txt")[1]))
    capture erase "`P'/temp/explore/draw.txt"
}
mata: s = cat(st_local("C") + "/master.do"); s = select(s, ustrregexm(s, "^set seed [0-9]+$")); st_local("seed", rows(s) == 1 ? substr(s[1], 10, .) : "")
local same 0
if "`seed'" != "" {
    set seed `seed'
    local ref = strtrim(string(runiform(), "%21x"))
    local same = "`d'" == " `ref' `ref'"
}
do "`rec'" "`out'" H24 "the first draw inside a run is the draw of the seed master.do sets in two runs" 0 `=`rc999' + `rc1' + 1000 * !`same''

* ---- Exhibits: no replace, a cleared folder -----------------------------------------------------
* The step writes 01_fig.png and 01_fig_b.png. Before its first run, files named after it lie in
* the three results folders, and 02_keep.png of another step: the run erases the first and keeps
* the second, and the step's own two exhibits do not stop its second run.
quietly do "`here'/step.do" "`P'" analysis/01_fig.do figmore
foreach f in tables/01_fig_old.tex figures/01_fig_old.png numbers/01_fig_old.txt figures/02_keep.png {
    mata: fh = fopen(st_local("P") + "/paper/results/`f'", "w"); fput(fh, "x"); fclose(fh)
}
sleep 1100
quietly cd "`C'"
capture noisily do master.do analysis/01_fig.do
local rc1 = _rc
local bad 0
foreach f in tables/01_fig_old.tex figures/01_fig_old.png numbers/01_fig_old.txt {
    capture confirm file "`P'/paper/results/`f'"
    if !_rc local bad 1
}
capture confirm file "`P'/paper/results/figures/02_keep.png"
if _rc local bad 1
capture erase "`P'/paper/results/figures/02_keep.png"
sleep 1100
capture noisily do master.do analysis/01_fig.do
local rc2 = _rc
quietly cd "`here'"
do "`rec'" "`out'" H09 "a single step erases the exhibits named after it and no other and runs twice in a row" 0 `=`rc1' + `rc2' + 1000 * `bad''
quietly do "`here'/step.do" "`P'" analysis/01_fig.do fig2
sleep 1100
quietly cd "`C'"
capture noisily do master.do analysis/01_fig.do
local rc = _rc
quietly cd "`here'"
do "`rec'" "`out'" H10 "a second export to one file inside a step stops the run" 602 `rc'
quietly do "`here'/step.do" "`P'" analysis/01_fig.do figrep
sleep 1100
quietly cd "`C'"
capture noisily do master.do analysis/01_fig.do
local rc = _rc
quietly cd "`here'"
do "`rec'" "`out'" H11 "limit: the same two exports with replace pass (review-code looks for replace)" 0 `rc'
quietly do "`here'/step.do" "`P'" analysis/01_fig.do fig
quietly do "`here'/step.do" "`P'" analysis/02_tab.do fig
mata: s = cat(st_local("C") + "/analysis/02_tab.do"); s = subinstr(s, "02_tab.png", "01_fig.png"); unlink(st_local("C") + "/analysis/02_tab.do"); fh = fopen(st_local("C") + "/analysis/02_tab.do", "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
sleep 1100
quietly cd "`C'"
capture noisily do master.do
local rc = _rc
quietly cd "`here'"
do "`rec'" "`out'" H12 "two steps writing one exhibit stop a full run" 602 `rc'
quietly do "`here'/step.do" "`P'" analysis/02_tab.do misnamed
sleep 1100
quietly cd "`C'"
capture noisily do master.do analysis/02_tab.do
sleep 1100
capture noisily do master.do analysis/02_tab.do
local rc = _rc
quietly cd "`here'"
do "`rec'" "`out'" H13 "an exhibit not named after its step stops that step's second run" 602 `rc'
quietly do "`here'/step.do" "`P'" analysis/02_tab.do tab

* ---- A full run starts clean: files of an earlier run in temp/, temp/explore/ and the three
* results folders are gone before the first step runs (the first step checks, and fails the run
* otherwise); the README of temp/ stays, and so do a named earlier log and a file in logs/qa/.
foreach f in temp/stray.dta temp/explore/stray.txt paper/results/tables/stray.tex paper/results/figures/stray.png paper/results/numbers/stray.txt {
    mata: fh = fopen(st_local("P") + "/`f'", "w"); fput(fh, "x"); fclose(fh)
}
mata: fh = fopen(st_local("P") + "/logs/qa/01_load_unmatched.csv", "w"); fput(fh, "a list of unmatched rows"); fclose(fh)
local old : dir "`P'/logs" files "master_*.smcl"
local old : word 1 of `old'
quietly do "`here'/step.do" "`P'" dataprep/01_load.do loadcheck
sleep 1100
quietly cd "`C'"
capture noisily do master.do
local rc = _rc
quietly cd "`here'"
quietly do "`here'/step.do" "`P'" dataprep/01_load.do load
local bad 0
foreach f in temp/stray.dta temp/explore/stray.txt paper/results/tables/stray.tex paper/results/figures/stray.png paper/results/numbers/stray.txt {
    capture confirm file "`P'/`f'"
    if !_rc local bad 1
}
capture confirm file "`P'/temp/README.md"
if _rc local bad 1
capture confirm file "`P'/logs/`old'"
if _rc | "`old'" == "" local bad 1
capture confirm file "`P'/logs/qa/01_load_unmatched.csv"
if _rc local bad 1
do "`rec'" "`out'" H16 "a full run empties temp and temp/explore and the results folders before the first step and keeps the README of temp and an earlier log and a file in logs/qa" 0 `=`rc' + 1000 * `bad''

* ---- A missing package stops the run with one sentence, before anything is cleared ------------
* The case reads the one sentence, which names the missing file. Markers in temp/, temp/explore/
* and the three results folders, with the exhibits and working files, show nothing was cleared.
mata: st_local("before", strofreal(rows(dir(st_local("P") + "/paper/results/figures", "files", "*.png")) + rows(dir(st_local("P") + "/temp", "files", "*.dta"))))
quietly do "`here'/markers.do" "`P'" plant
copy "`P'/ado/c/chair_results.ado" "`W'/chair_results.keep", replace
erase "`P'/ado/c/chair_results.ado"
sleep 1100
quietly cd "`C'"
log using "`W'/h14.log", text name(h14)
capture noisily do master.do
local rc = _rc
log close h14
quietly cd "`here'"
mata: st_local("after", strofreal(rows(dir(st_local("P") + "/paper/results/figures", "files", "*.png")) + rows(dir(st_local("P") + "/temp", "files", "*.dta"))))
quietly do "`here'/markers.do" "`P'" check
copy "`W'/chair_results.keep" "`P'/ado/c/chair_results.ado", replace
mata: s = cat(st_local("W") + "/h14.log"); f = select(s, substr(s, 1, 7) :== "Failed:"); st_local("said", strofreal(rows(f) == 1 ? strpos(f[1], "Failed: ado/c/chair_results.ado is missing from this project. ") == 1 : 0))
do "`rec'" "`out'" H14 "a package missing from ado stops the run with one sentence that names it" 601 `=`rc' + 1000 * !`said''
do "`rec'" "`out'" H15 "that stop comes before anything is cleared: the exhibits and working files and the markers are still there" 1 `=`before' > 0 & `before' == `after' & `kept''

* ---- A file that cannot be erased, a results page that cannot be written ------------------------
* A table open in Excel cannot be erased on Windows; here a folder made read-only stands for it,
* with chmod, which Windows lacks. The run ends with its Failed: sentence, which names the file,
* and closes its dated log, so a later chair_use in the same session reads pins.do afresh: pins.do
* is edited after the run, and chair_use loads the version it now names. A runner that erases a
* file in a folder made read-only all the same (as an administrator can) cannot play the cases: a
* file in such a folder is tried first.
local why ""
if c(os) == "Windows" local why "a file that cannot be erased is made with chmod, which Windows lacks"
else {
    mkdir "`W'/readonly"
    mata: fh = fopen(st_local("W") + "/readonly/sacrificial.txt", "w"); fput(fh, "x"); fclose(fh)
    shell chmod a-w "`W'/readonly"
    capture erase "`W'/readonly/sacrificial.txt"
    local gone = !_rc
    shell chmod u+w "`W'/readonly"
    capture erase "`W'/readonly/sacrificial.txt"
    rmdir "`W'/readonly"
    if `gone' local why "this runner erases a file in a folder made read-only, as an administrator can"
}
if "`why'" != "" {
    tempname fh
    foreach id in H52 H53 {
        file open `fh' using "`out'", write text append
        file write `fh' "TEST SKIP `id': `why'" _n
        file close `fh'
    }
}
else {
    * A full run: temp/explore/ holds one file, and cannot be written.
    local x "`P'/temp/explore"
    local fs : dir "`x'" files "*", respectcase
    foreach f of local fs {
        erase "`x'/`f'"
    }
    mata: fh = fopen(st_local("x") + "/locked.txt", "w"); fput(fh, "x"); fclose(fh)
    quietly do "`here'/setpin.do" "`C'/pins.do" pin_toy v2
    shell chmod a-w "`x'"
    sleep 1100
    quietly cd "`C'"
    log using "`W'/h52.log", text name(h52)
    capture noisily do master.do
    local rc = _rc
    log close h52
    quietly cd "`here'"
    shell chmod u+w "`x'"
    capture quietly log query master
    local open = !_rc
    capture log close master
    global t_want "Failed: the file `x'/locked.txt cannot be erased: close it where it is open, as in Excel, and run again (r(`rc'))"
    quietly do "`here'/logsays.do" "`W'/h52.log"
    local ok = `said'
    quietly do "`here'/setpin.do" "`C'/pins.do" pin_toy v1
    local v 0
    capture noisily {
        chair_use toy/toy, clear
        local v = value[1] == 10
        clear
    }
    capture erase "`x'/locked.txt"
    do "`rec'" "`out'" H52 "a file that cannot be erased when a full run starts ends the run with Failed and its name and closes the dated log so chair_use then reads pins.do afresh" 0 `=(`rc' == 0) + 1000 * (!`ok' | `open' | !`v')'
    * A single step: the one exhibit named after it lies in a folder that cannot be written.
    local x "`P'/paper/results/figures"
    local fs : dir "`x'" files "01_fig*", respectcase
    foreach f of local fs {
        erase "`x'/`f'"
    }
    mata: fh = fopen(st_local("x") + "/01_fig.png", "w"); fput(fh, "x"); fclose(fh)
    shell chmod a-w "`x'"
    sleep 1100
    quietly cd "`C'"
    log using "`W'/h53.log", text name(h53)
    capture noisily do master.do analysis/01_fig.do
    local rc = _rc
    log close h53
    quietly cd "`here'"
    shell chmod u+w "`x'"
    capture quietly log query master
    local open = !_rc
    capture log close master
    global t_want "Failed: the file `x'/01_fig.png cannot be erased: close it where it is open, as in Excel, and run again (r(`rc'))"
    quietly do "`here'/logsays.do" "`W'/h53.log"
    local ok = `said'
    quietly do "`here'/setpin.do" "`C'/pins.do" pin_toy v2
    local v 0
    capture noisily {
        chair_use toy/toy, clear
        local v = value[1] == 20
        clear
    }
    do "`rec'" "`out'" H53 "an exhibit that cannot be erased when a single step starts ends the run with Failed and its name and closes the dated log so chair_use then reads pins.do afresh" 0 `=(`rc' == 0) + 1000 * (!`ok' | `open' | !`v')'
}
* The results page cannot be written: a folder stands where the page goes (this needs no chmod).
local pg "`P'/paper/results/README.md"
capture erase "`pg'"
mkdir "`pg'"
quietly do "`here'/setpin.do" "`C'/pins.do" pin_toy v2
sleep 1100
quietly cd "`C'"
log using "`W'/h54.log", text name(h54)
capture noisily do master.do
local rc = _rc
log close h54
quietly cd "`here'"
rmdir "`pg'"
capture quietly log query master
local open = !_rc
capture log close master
global t_want "Failed: the results page `pg' cannot be written: close it where it is open, and run again (r(`rc'))"
quietly do "`here'/logsays.do" "`W'/h54.log"
local ok = `said'
quietly do "`here'/setpin.do" "`C'/pins.do" pin_toy v1
local v 0
capture noisily {
    chair_use toy/toy, clear
    local v = value[1] == 10
    clear
}
do "`rec'" "`out'" H54 "a results page that cannot be written ends the run with Failed and closes the dated log so chair_use then reads pins.do afresh" 0 `=(`rc' == 0) + 1000 * (!`ok' | `open' | !`v')'

* ---- The tests' own clean-up never deletes through a link ----------------------------------------
* rmtree.do removes a link itself, one that points nowhere too: the folder and the file it points
* to stay. Handed a folder that is itself a link, it stops before it changes or removes anything:
* the folder it points to, made read-only, stays read-only and keeps its file. Making a link needs
* rights on Windows that the tests do not have.
if c(os) == "Windows" {
    tempname fh
    file open `fh' using "`out'", write text append
    file write `fh' "TEST SKIP H55: a link is made with ln, which Windows lacks" _n
    file close `fh'
}
else {
    foreach d in "`W'/neighbour" "`W'/linktree" "`W'/linktree/a" {
        mkdir "`d'"
    }
    foreach f in neighbour/keep.txt linktree/a/own.txt {
        mata: fh = fopen(st_local("W") + "/`f'", "w"); fput(fh, "keep"); fclose(fh)
    }
    shell ln -s "`W'/neighbour" "`W'/linktree/a/dirlink"
    shell ln -s "`W'/neighbour/keep.txt" "`W'/linktree/a/filelink"
    shell ln -s "`W'/nowhere" "`W'/linktree/a/deadlink"
    shell ln -s "`W'/neighbour" "`W'/rootlink"
    shell chmod a-w "`W'/neighbour"
    mata: st_local("made", strofreal(direxists(st_local("W") + "/linktree/a/dirlink") & fileexists(st_local("W") + "/linktree/a/filelink") & direxists(st_local("W") + "/rootlink")))
    capture noisily do "`here'/rmtree.do" "`W'/rootlink" writable
    local rcroot = _rc
    shell ls -ld "`W'/neighbour" > "`W'/h55mode.txt"
    shell chmod u+w "`W'/neighbour"
    mata: st_local("ro", strofreal(substr(cat(st_local("W") + "/h55mode.txt")[1], 1, 4) == "dr-x"))
    capture noisily do "`here'/rmtree.do" "`W'/linktree"
    local rc = _rc
    mata: st_local("ok", strofreal(!direxists(st_local("W") + "/linktree") & direxists(st_local("W") + "/neighbour") & (fileexists(st_local("W") + "/neighbour/keep.txt") ? cat(st_local("W") + "/neighbour/keep.txt") == "keep" : 0)))
    do "`rec'" "`out'" H55 "rmtree.do refuses a folder that is itself a link before any chmod or delete and removes a link or a link to nowhere under the tree and leaves what it points to" 0 `=`rc' + (`rcroot' != 693) + 1000 * (!`made' | !`ok' | !`ro')'
}

* ---- A Stata step reads a hand-made table from intermediate/<project>/ ----------------------------
* The table is a factor of 3 for every canton, in the data root's intermediate/toy/; the step names
* it through p_intermediate and writes the sum, 78.
foreach d in "`P'/data/intermediate" "`P'/data/intermediate/toy" {
    capture mkdir "`d'"
}
clear
set obs 26
generate ctn = _n
generate factor = 3
export delimited using "`P'/data/intermediate/toy/factor.csv", replace
clear
mata: s = cat(st_local("C") + "/master.do"); s = subinstr(s, "local steps dataprep/01_load.do analysis/01_fig.do analysis/02_tab.do", "local steps dataprep/01_load.do analysis/01_fig.do analysis/02_tab.do analysis/03_hand.do"); unlink(st_local("C") + "/master.do"); fh = fopen(st_local("C") + "/master.do", "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
quietly do "`here'/step.do" "`P'" analysis/03_hand.do hand
sleep 1100
quietly cd "`C'"
capture noisily do master.do analysis/03_hand.do
local rc = _rc
quietly cd "`here'"
local ok 0
mata: st_local("ok", strofreal(fileexists(st_local("P") + "/paper/results/tables/03_hand.tex")))
if `ok' mata: s = cat(st_local("P") + "/paper/results/tables/03_hand.tex"); st_local("ok", strofreal(rows(s) == 1 & ustrregexm(s[1], "^total +78$")))
do "`rec'" "`out'" H60 "a Stata step reads a hand-made table from intermediate/<project>/ through p_intermediate" 0 `=`rc' + 1000 * !`ok''
global t_want ""

* ---- Stata's PERSONAL folder is the project's ado/ during a run ----------------------------------
* A command of Stata's own may keep a file in PERSONAL: grmap looks for its activation file there
* (findfile, path(PERSONAL)), whether or not PERSONAL is on the ado-path. The machine's own PERSONAL
* is played by a folder in _t/ that holds the activation file, so the machine's real one is never
* written; it is put back when the cases end.
local pers "`c(sysdir_personal)'"
mkdir "`W'/machine-personal"
mata: fh = fopen(st_local("W") + "/machine-personal/grmap__activated.ado", "w"); fclose(fh)
* Inside a run, Stata's PERSONAL folder is the project's ado/: an explore file writes it down.
sysdir set PERSONAL "`W'/machine-personal/"
mata: fh = fopen(st_local("C") + "/explore/05_personal.do", "w"); fput(fh, "mata: f = st_global(" + char(34) + "p_temp" + char(34) + ") + " + char(34) + "/explore/personal.txt" + char(34) + "; unlink(f); fh = fopen(f, " + char(34) + "w" + char(34) + "); fput(fh, c(" + char(34) + "sysdir_personal" + char(34) + ")); fclose(fh)"); fclose(fh)
sleep 1100
quietly cd "`C'"
capture noisily do master.do explore/05_personal.do
local rc = _rc
quietly cd "`here'"
local ok 0
mata: st_local("ok", strofreal(fileexists(st_local("P") + "/temp/explore/personal.txt")))
if `ok' mata: s = subinstr(cat(st_local("P") + "/temp/explore/personal.txt"), "\", "/"); st_local("ok", strofreal(rows(s) == 1 & ustrregexra(s[1], "/+$", "") == st_local("P") + "/ado"))
do "`rec'" "`out'" H61 "inside a run Stata's PERSONAL folder is the project's ado/ and not the machine's own" 0 `=`rc' + 1000 * !`ok''
* A step that draws a map with grmap, with the activation file only in the machine's own PERSONAL
* folder: it stops with Stata's message that grmap is not yet activated, as on a colleague's machine.
mata: s = cat(st_local("C") + "/master.do"); s = subinstr(s, "local steps dataprep/01_load.do analysis/01_fig.do analysis/02_tab.do analysis/03_hand.do", "local steps dataprep/01_load.do analysis/01_fig.do analysis/02_tab.do analysis/03_hand.do analysis/04_map.do"); unlink(st_local("C") + "/master.do"); fh = fopen(st_local("C") + "/master.do", "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
quietly do "`here'/step.do" "`P'" analysis/04_map.do map
sysdir set PERSONAL "`W'/machine-personal/"
sleep 1100
quietly cd "`C'"
log using "`W'/h62.log", text name(h62)
capture noisily do master.do analysis/04_map.do
local rc = _rc
log close h62
quietly cd "`here'"
global t_want "grmap not yet activated"
global t_without ""
quietly do "`here'/logsays.do" "`W'/h62.log"
local said = `nsaid' == 1
global t_want "Failed: analysis/04_map.do (r(199))"
quietly do "`here'/logsays.do" "`W'/h62.log"
local said = `said' & `nsaid' == 1
do "`rec'" "`out'" H62 "a step that calls grmap stops with Stata's not yet activated message when the activation file is only in the machine's own PERSONAL folder" 199 `=`rc' + 1000 * !`said''
* The activation, run once through master.do in an explore file, writes its file into the
* project's ado/; the same step then runs and draws its map.
mata: fh = fopen(st_local("C") + "/explore/06_activate.do", "w"); fput(fh, "grmap, activate"); fclose(fh)
sysdir set PERSONAL "`W'/machine-personal/"
sleep 1100
quietly cd "`C'"
capture noisily do master.do explore/06_activate.do
local rc = _rc
sysdir set PERSONAL "`W'/machine-personal/"
sleep 1100
capture noisily do master.do analysis/04_map.do
local rc = `rc' + _rc
quietly cd "`here'"
mata: st_local("ok", strofreal(fileexists(st_local("P") + "/ado/grmap__activated.ado") & fileexists(st_local("P") + "/paper/results/figures/04_map.png")))
do "`rec'" "`out'" H63 "grmap activated through master.do in an explore file writes its file into the project's ado/ and the step that calls grmap then runs" 0 `=`rc' + 1000 * !`ok''
sysdir set PERSONAL "`pers'"
global t_want ""

* ---- The data flow page, code/README.md ------------------------------------------------------------
* A project of its own, so that the cases above keep their steps. Its steps save with chair_save,
* merge with chair_merge and append with chair_append; the page names files and counts.
local F "`W'/flow"
local FC "`F'/code"
quietly do "`here'/copytree.do" "`tmpl'" "`F'"
quietly do "`here'/copytree.do" "`R'" "`F'/data"
quietly do "`here'/setpin.do" "`FC'/pins.do" pin_toy v1
quietly do "`here'/setpin.do" "`FC'/pins.do" raw_toy toy-raw/2026-01-01
* The project's block also holds a setting of its own named p_step, which a run must leave alone.
mata: s = cat(st_local("FC") + "/master.do"); s = subinstr(s, `"local steps """', "global p_step " + char(34) + "my setting" + char(34) + char(10) + "local steps dataprep/01_build.do dataprep/02_counts.do dataprep/03_names.do dataprep/04_overwrite.do dataprep/05_side.do analysis/01_more.do analysis/02_order.do"); unlink(st_local("FC") + "/master.do"); fh = fopen(st_local("FC") + "/master.do", "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
mata: fh = fopen(st_local("FC") + "/helpers/readw.do", "w"); fput(fh, "import delimited using " + char(34) + char(36) + "{p_raw}/" + char(36) + "{raw_toy}/weights.csv" + char(34) + ", clear"); fclose(fh)
quietly do "`here'/step.do" "`F'" dataprep/01_build.do flowbuild
quietly do "`here'/step.do" "`F'" dataprep/02_counts.do counts
quietly do "`here'/step.do" "`F'" dataprep/03_names.do names
quietly do "`here'/step.do" "`F'" dataprep/04_overwrite.do overwrite
quietly do "`here'/step.do" "`F'" dataprep/05_side.do sidekey
quietly do "`here'/step.do" "`F'" analysis/01_more.do flowmore
quietly do "`here'/step.do" "`F'" analysis/02_order.do order
local pg "`FC'/README.md"
sleep 1100
quietly cd "`FC'"
log using "`W'/h69.log", text name(h69)
capture noisily do master.do
local rc = _rc
log close h69
quietly cd "`here'"
global t_want "Data flow page written: `pg'"
global t_without ""
quietly do "`here'/logsays.do" "`W'/h69.log"
local ok = `said'
capture erase "`W'/h69page.md"
capture copy "`pg'" "`W'/h69page.md"
sleep 1100
quietly cd "`FC'"
capture noisily do master.do
local rc = `rc' + _rc
quietly cd "`here'"
mata: a = cat(st_local("W") + "/h69page.md"); st_local("ok", strofreal(strtoreal(st_local("ok")) & rows(a) > 10 & a[1] == "<!-- Generated by code/master.do. Do not edit by hand. -->"))
* Byte for byte: the two files read whole.
local ok = `ok' & fileread("`W'/h69page.md") == fileread("`pg'")
do "`rec'" "`out'" H69 "a full run writes the data flow page code/README.md and an unchanged rerun writes it byte for byte" 0 `=`rc' + 1000 * !`ok''
* The pages' rows, each once.
mata: s = cat(st_local("pg")); st_local("rows", strofreal(sum(s :== "| weights | [01\_build](dataprep/01_build.do) | ctn | 26 |") == 1 & sum(s :== "| half | [01\_build](dataprep/01_build.do) | ctn | 20 |") == 1 & sum(s :== "| toy | [01\_build](dataprep/01_build.do) | ctn | 26 |") == 1))
do "`rec'" "`out'" H70 "the data flow page lists each working file chair_save saved with its step and key and rows" 1 `rows'
mata: s = cat(st_local("pg")); st_local("two", strofreal(sum(s :== "| [01\_build](dataprep/01_build.do) · 1:1 on ctn<br>master: toy/toy<br>using: half | 20 | 6 | 0 |") == 1 & sum(s :== "| [01\_build](dataprep/01_build.do) · 1:1 on ctn<br>master: in memory<br>using: half | 20 | 6 | 0 |") == 1))
mata: q = st_local("F") + "/logs/qa/01_build_merge"; st_local("lists", strofreal(fileexists(q + "1.csv") & fileexists(q + "2.csv") ? (sum(strpos(cat(q + "1.csv"), "First list.") :> 0) == 6) & (sum(strpos(cat(q + "2.csv"), "Second list.") :> 0) == 6) & (sum(strpos(cat(q + "1.csv"), "master only") :> 0) == 6) : 0))
do "`rec'" "`out'" H71 "two chair_merge against one file in one step are two rows in master and using words and keep two lists in logs/qa with their notes" 1 `=`two' & `lists''
mata: s = cat(st_local("pg")); st_local("tmp", strofreal(sum(s :== "| [01\_more](analysis/01_more.do) · 1:1 on ctn<br>master: toy<br>using: toy/toy° | 26 | 0 | 0 |") == 1 & sum(s :== "| [01\_more](analysis/01_more.do) · 1:1 on ctn<br>master: in memory<br>using: _built_° | 26 | 0 | 0 |") == 1))
do "`rec'" "`out'" H72 "a temporary file is named by the stamp chair_use put on its data or else by name()" 1 `tmp'
mata: s = cat(st_local("pg")); st_local("loop", strofreal(sum(s :== "| [01\_more](analysis/01_more.do) ×3 · 1:1 on ctn<br>master: in memory<br>using: toy/toy° | 78 | 0 | 0 |") == 1))
do "`rec'" "`out'" H73 "three chair_merge in a loop are one row with the counts summed" 1 `loop'
mata: s = cat(st_local("pg")); st_local("app", strofreal(sum(s :== "| [01\_more](analysis/01_more.do)<br>master: bygrp\_0<br>using: a file built at run time, a file built at run time | 8 | 9 + 9 |") == 1 & sum(s :== "| Append | Master rows | Using rows |") == 1))
do "`rec'" "`out'" H74 "a chair_append is a row of the page with the rows of each side" 1 `app'
* bygrp_0 is written out in the step's code; bygrp_1 and bygrp_2 (a loop), one_1 (alone) and
* mid_1_x (the value inside the name) are built from data: one row, and none of their names.
mata: s = cat(st_local("pg")); st_local("vals", strofreal(sum(s :== "| bygrp\_0 | [01\_more](analysis/01_more.do) | ctn | 8 |") == 1 & sum(s :== "| 4 files, names built at run time | [01\_more](analysis/01_more.do) | ctn | 70 |") == 1 & !any(ustrregexm(s, "bygrp(\\)?_[12]|one(\\)?_|mid(\\)?_"))))
do "`rec'" "`out'" H75 "working files whose names the code builds from data are one row with a count and summed rows and none of their names is on the page" 1 `vals'
mata: s = cat(st_local("pg")); st_local("whole", strofreal(sum(s :== "| joined | [01\_more](analysis/01_more.do) | ctn | 26 |") == 1))
do "`rec'" "`out'" H76 "a step with clear all does not stop the page from recording what follows" 1 `whole'
mata: s = cat(st_local("F") + "/paper/results/README.md"); a = selectindex(strpos(s, "02_order_a.txt](numbers") :> 0); b = selectindex(strpos(s, "02_order_b.txt](numbers") :> 0); st_local("sorted", strofreal(rows(a) == 1 & rows(b) == 1 ? a[1] < b[1] : 0))
do "`rec'" "`out'" H77 "the results page lists a step's exhibits sorted by name whatever order they were written in" 1 `sorted'
* Counts: a file saved twice counts by its last save; a file saved with save is not recorded and
* never joins a recorded one; a merge with update counts results 3, 4 and 5 as matched.
mata: s = cat(st_local("pg")); st_local("cnt", strofreal(sum(s :== "| batch\_1 | [02\_counts](dataprep/02_counts.do) | ctn | 1 |") == 1 & sum(s :== "| batch\_2 | [02\_counts](dataprep/02_counts.do) | ctn | 1 |") == 1 & sum(s :== "| batch\_3 | – | not recorded | – |") == 1 & sum(s :== "| [02\_counts](dataprep/02_counts.do) · 1:1 on ctn<br>master: uleft<br>using: uright | 2 | 0 | 0 |") == 1))
do "`rec'" "`out'" H88 "a file saved twice counts by its last save and one saved with save stays apart and a merge with update counts every matched row" 1 `cnt'
* A solid arrow comes only from what the saved data descend from: fromtoy was saved after toy.dta
* was loaded over the merged data.
mata: s = cat(st_local("pg")); st_local("lin", strofreal(anyof(s, "    w_temp_toy --> w_temp_fromtoy") & !anyof(s, "    w_temp_uright --> w_temp_fromtoy") & !anyof(s, "    w_temp_uleft --> w_temp_fromtoy")))
do "`rec'" "`out'" H89 "a solid arrow of the picture comes only from the lineage of the data saved" 1 `lin'
* A raw delivery read in a helper the step pulls in is named; the project's own setting p_step
* reached the step unchanged, or it would have stopped.
mata: s = cat(st_local("pg")); st_local("hlp", strofreal(sum(s :== "| toy-raw | raw\* | 2026-01-01 | [01\_build](dataprep/01_build.do), [02\_counts](dataprep/02_counts.do), [03\_names](dataprep/03_names.do) |") == 1))
do "`rec'" "`out'" H90 "a raw delivery read in a helper is named for the step and a project setting named p_step is left alone" 1 `hlp'
* chair_merge and chair_append of a temporary file with no rows run as merge and append do, and
* chair_save keeps a dollar sign in a name as save does.
quietly do "`here'/step.do" "`F'" explore/03_edge.do edge
sleep 1100
quietly cd "`FC'"
capture noisily do master.do explore/03_edge.do
local rc = _rc
quietly cd "`here'"
mata: st_local("ok", strofreal(fileexists(st_local("F") + "/temp/explore/edge_ok.dta")))
do "`rec'" "`out'" H91 "chair_merge and chair_append take a temporary file with no rows and chair_save keeps a dollar sign in a name" 0 `=`rc' + 1000 * !`ok''
* A page that cannot be written ends the run with Failed, and the old page stays whole.
if c(os) != "Windows" {
    capture erase "`W'/h92page.md"
    copy "`pg'" "`W'/h92page.md"
    shell chmod a-w "`pg'"
    sleep 1100
    quietly cd "`FC'"
    log using "`W'/h92.log", text name(h92)
    capture noisily do master.do
    local rc = _rc
    log close h92
    quietly cd "`here'"
    shell chmod u+w "`pg'"
    global t_want "Failed: the data flow page `FC'/README.md cannot be written: close it where it is open, and run again (r(`rc'))"
    global t_without ""
    quietly do "`here'/logsays.do" "`W'/h92.log"
    local ok = `said' & `rc' != 0 & fileread("`W'/h92page.md") == fileread("`pg'")
    do "`rec'" "`out'" H92 "a data flow page that cannot be written ends the run with Failed and leaves the old page whole" 1 `ok'
}
else {
    tempname fh
    file open `fh' using "`out'", write text append
    file write `fh' "TEST SKIP H92: a file is made read-only with chmod, which Windows lacks" _n
    file close `fh'
}
* A file named from a value is not shown because the code writes out a longer name that begins
* the same: only a name written out whole counts.
mata: s = cat(st_local("pg")); st_local("ok", strofreal(sum(s :== "| review\_record\_26-other | [03\_names](dataprep/03_names.do) | ctn | 26 |") == 1 & sum(s :== "| 1 file, name built at run time | [03\_names](dataprep/03_names.do) | ctn | 26 |") == 1 & !any(strpos(s, "review\_record\_26 ") :| strpos(s, "review_record_26" + char(34)))))
do "`rec'" "`out'" H93 "a file named from a value stays off the page when the code writes out a longer name that begins the same" 1 `ok'
* A file chair_save wrote and save then replaced is not recorded: the page checks its size.
mata: s = cat(st_local("pg")); st_local("ok", strofreal(sum(s :== "| example | – | not recorded | – |") == 1 & !any(strpos(s, "| example | [04"))))
do "`rec'" "`out'" H94 "a working file that save replaced after chair_save wrote it is marked not recorded" 1 `ok'
* A merge on a key named _side, the name the list used for its own column, runs and lists both rows.
mata: q = st_local("F") + "/logs/qa/05_side_merge1.csv"; st_local("ok", strofreal(fileexists(q) ? rows(cat(q)) == 3 & cat(q)[1] == "_side,__side,_note" : 0))
do "`rec'" "`out'" H95 "chair_merge on a key named _side runs and its list keeps the key" 1 `ok'
* What a step's code names but the run did not record says no more than that: the column is Step,
* and the footnote says the name comes from the code (here a raw delivery inside if 0).
mata: s = cat(st_local("pg")); st_local("ok", strofreal(sum(s :== "| Source | Kind | Version | Step |") == 1 & sum(strpos(s, "\* named in the code, not recorded by the run") :> 0) == 1 & !any(strpos(s, "Read by"))))
do "`rec'" "`out'" H97 "the sources table heads its steps Step and its footnote says a name found in the code is not a recorded read" 1 `ok'
* One step run alone marks the page, which shows the last full run.
sleep 1100
quietly cd "`FC'"
capture noisily do master.do analysis/02_order.do
local rc = _rc
quietly cd "`here'"
mata: s = cat(st_local("pg")); st_local("mark", strofreal(sum(s :== "**Not current:** " + char(96) + "analysis/02_order.do" + char(96) + " ran alone since.") == 1))
do "`rec'" "`out'" H78 "a run of one step marks the data flow page not current" 0 `=`rc' + 1000 * !`mark''
* A single step that cannot mark the page stops before it runs, with Failed, and the page stays.
if c(os) != "Windows" {
    capture erase "`W'/h96page.md"
    copy "`pg'" "`W'/h96page.md"
    shell chmod a-w "`pg'"
    sleep 1100
    quietly cd "`FC'"
    log using "`W'/h96.log", text name(h96)
    capture noisily do master.do analysis/01_more.do
    local rc = _rc
    log close h96
    quietly cd "`here'"
    shell chmod u+w "`pg'"
    global t_want "Failed: the data flow page `FC'/README.md cannot be written: close it where it is open, and run again (r(`rc'))"
    global t_without ""
    quietly do "`here'/logsays.do" "`W'/h96.log"
    local ok = `said' & `rc' != 0 & fileread("`W'/h96page.md") == fileread("`pg'")
    global t_want "Step complete"
    quietly do "`here'/logsays.do" "`W'/h96.log"
    do "`rec'" "`out'" H96 "a single step that cannot mark the data flow page stops with Failed before it runs and leaves the page whole" 1 `=`ok' & !`said''
}
else {
    tempname fh
    file open `fh' using "`out'", write text append
    file write `fh' "TEST SKIP H96: a file is made read-only with chmod, which Windows lacks" _n
    file close `fh'
}
* A full run that stops at a step marks it too; that step's chair_save refused a key that repeats.
mata: s = cat(st_local("FC") + "/master.do"); s = subinstr(s, "local steps dataprep/01_build.do dataprep/02_counts.do dataprep/03_names.do dataprep/04_overwrite.do dataprep/05_side.do analysis/01_more.do analysis/02_order.do", "local steps dataprep/01_build.do dataprep/02_counts.do dataprep/03_names.do dataprep/04_overwrite.do dataprep/05_side.do analysis/01_more.do analysis/02_order.do analysis/03_dup.do"); unlink(st_local("FC") + "/master.do"); fh = fopen(st_local("FC") + "/master.do", "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
quietly do "`here'/step.do" "`F'" analysis/03_dup.do dupkey
sleep 1100
quietly cd "`FC'"
log using "`W'/h79.log", text name(h79)
capture noisily do master.do
local rc = _rc
log close h79
quietly cd "`here'"
mata: s = cat(st_local("pg")); st_local("mark", strofreal(sum(s :== "**Not current:** full run stopped at " + char(96) + "analysis/03_dup.do" + char(96) + ".") == 1))
do "`rec'" "`out'" H79 "a full run that stops at a step marks the data flow page not current" 459 `=`rc' + 1000 * !`mark''
global t_want "chair_save: ctn does not identify a row of dup.dta: a value repeats or is missing"
quietly do "`here'/logsays.do" "`W'/h79.log"
local dup = `said'
global t_want "Failed: analysis/03_dup.do (r(459))"
quietly do "`here'/logsays.do" "`W'/h79.log"
local dup = `dup' & `said'
mata: st_local("nofile", strofreal(!fileexists(st_local("F") + "/temp/dup.dta")))
quietly do "`here'/step.do" "`F'" explore/01_nokey.do nokey
sleep 1100
quietly cd "`FC'"
log using "`W'/h80.log", text name(h80)
capture noisily do master.do explore/01_nokey.do
local rc2 = _rc
log close h80
quietly cd "`here'"
global t_want "chair_save: ctn does not identify a row of dup.dta: a value repeats or is missing"
quietly do "`here'/logsays.do" "`W'/h80.log"
do "`rec'" "`out'" H80 "chair_save refuses a key that repeats or is missing and saves nothing" 459 `=cond(`rc2' == 459, `rc', `rc2') + 1000 * (!`dup' | !`said' | !`nofile')'
* chair_merge stops on an outcome expect() does not allow: here six rows of the master only.
quietly do "`here'/step.do" "`F'" explore/02_badmerge.do badmerge
sleep 1100
quietly cd "`FC'"
log using "`W'/h81.log", text name(h81)
capture noisily do master.do explore/02_badmerge.do
local rc = _rc
log close h81
quietly cd "`here'"
global t_want "chair_merge: 6 rows are master, which expect(match) does not allow"
quietly do "`here'/logsays.do" "`W'/h81.log"
mata: st_local("list", strofreal(fileexists(st_local("F") + "/temp/explore/02_badmerge_merge1.csv")))
do "`rec'" "`out'" H81 "chair_merge lists the unmatched rows and then refuses an outcome its expect() does not allow" 9 `=`rc' + 1000 * (!`said' | !`list')'
* A code/README.md the run did not write stays as it is, through a full run and a single step.
mata: s = cat(st_local("FC") + "/master.do"); s = subinstr(s, " analysis/03_dup.do", ""); unlink(st_local("FC") + "/master.do"); fh = fopen(st_local("FC") + "/master.do", "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
erase "`pg'"
mata: fh = fopen(st_local("pg"), "w"); fput(fh, "# Notes on the code"); fput(fh, ""); fput(fh, "Written by hand."); fclose(fh)
sleep 1100
quietly cd "`FC'"
log using "`W'/h82.log", text name(h82)
capture noisily do master.do
local rc = _rc
sleep 1100
capture noisily do master.do analysis/02_order.do
local rc = `rc' + _rc
log close h82
quietly cd "`here'"
global t_want "Data flow page not written: code/README.md is hand-written."
quietly do "`here'/logsays.do" "`W'/h82.log"
mata: s = cat(st_local("pg")); st_local("kept", strofreal(rows(s) == 3 ? s[1] == "# Notes on the code" & s[3] == "Written by hand." : 0))
do "`rec'" "`out'" H82 "a hand-written code/README.md is left as it is by a full run and by a single step" 0 `=`rc' + 1000 * (!`kept' | `nsaid' != 1)'
global t_want ""
