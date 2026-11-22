/*
  The tests of project-template. Run them on the curator's machine, with the clones of handbook
  and project-template side by side in one folder: in Stata, cd into handbook/tests and type
      do run_tests.do
  They make toy projects from ../../project-template in tests/_t/. Each project has its data
  root inside its own folder, <project>/data/, holding one raw delivery and two toy versions
  (made once in _t/data/ and copied in). master.do takes a folder named data inside the project
  folder for the data root, as in a replication package, so the machine's own data-root file is
  not read. The Stata cases are in s_tests.do and the R cases in r_tests.do; this file runs both,
  and a stop inside either that no case catches is itself a TEST FAIL line. Each case writes
  TEST PASS, TEST FAIL or TEST SKIP. Besides tests/_t/, the run writes two files in tests/:
  results.txt, which holds every case and ends with the summary line, and Stata's batch log,
  run_tests.log. Git ignores all three. The R cases run on a toy project with R steps: they need
  R at the version the template's renv.lock names and, for their one restore, the network; where
  that R is not found each writes TEST SKIP and the Stata cases are the same. The restore copies
  the packages into the toy project, never links into renv's cache, so that no link lies under
  _t/. Outside the two repos the run writes only what R and renv write on any machine: renv's
  package cache and its sandbox (where RENV_PATHS_ROOT points, else renv's own folders in the
  home folder), and the session folder in the system's temp folder that an R killed on purpose
  (H36) leaves behind. Nothing else.
  Two clones run at once and a machine without its data-root file are not tested here: one Stata
  cannot start two runs, nor give itself another home folder, so they stay with a shell script.
*/
version 18
* Lines up to 255 characters stay on one line in a log; logsays.do joins the parts of a longer one.
set linesize 255
local here = subinstr(c(pwd), "\", "/", .)
local tmpl = substr("`here'", 1, strrpos(substr("`here'", 1, strrpos("`here'", "/") - 1), "/")) + "project-template"
mata: st_local("ok", strofreal(fileexists(st_local("here") + "/record.do")))
if "`ok'" != "1" {
    display as error "Failed: Stata is not in the tests folder of handbook. Type cd with that folder, then do run_tests.do."
    exit 170
}
mata: st_local("ok", strofreal(fileexists(st_local("tmpl") + "/code/master.do")))
if "`ok'" != "1" {
    display as error "Failed: the folder project-template was not found beside handbook, at `tmpl'. The tests copy the template from there: clone project-template into the folder that holds handbook, then run the tests again."
    exit 601
}
global t_tests "`here'"
local out "`here'/results.txt"
capture erase "`out'"
local rec "`here'/record.do"
* The toy projects' runs and the cases set Stata's PERSONAL folder: it is put back after the cases,
* whether they end or stop.
local pers "`c(sysdir_personal)'"

* ---- The Stata cases, in s_tests.do -------------------------------------------------------------
* A stop inside it that no case catches is itself a failure, so the run still reaches the R cases
* and its summary.
quietly cd "`here'"
capture noisily do "`here'/s_tests.do" "`here'"
local rc = _rc
forvalues i = 1/67 {
    capture log close `=cond(`i' < 10, "h0", "h")'`i'
}
capture log close master
quietly cd "`here'"
if `rc' do "`rec'" "`out'" S "the Stata cases in s_tests.do ran to their end" 0 `rc'

* ---- R steps: the cases in r_tests.do -----------------------------------------------------------
* A stop inside it that no case catches is itself a failure, so the run still reaches its summary.
quietly cd "`here'"
capture noisily do "`here'/r_tests.do" "`here'"
local rc = _rc
forvalues i = 30/68 {
    capture log close h`i'
}
capture log close h68b
capture log close rversion
capture log close master
quietly cd "`here'"
if `rc' do "`rec'" "`out'" R "the R cases in r_tests.do ran to their end" 0 `rc'
sysdir set PERSONAL "`pers'"

* ---- Summary -------------------------------------------------------------------------------------
quietly cd "`here'"
mata: r = cat(st_local("out")); st_local("np", strofreal(sum(substr(r, 1, 9) :== "TEST PASS"))); st_local("nf", strofreal(sum(substr(r, 1, 9) :== "TEST FAIL"))); st_local("ns", strofreal(sum(substr(r, 1, 9) :== "TEST SKIP")))
local summary "template tests: `np' passed, `nf' failed, `ns' skipped (results.txt)"
tempname fh
file open `fh' using "`out'", write text append
file write `fh' "`summary'" _n
file close `fh'
display as text _n "`summary'"

