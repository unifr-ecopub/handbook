* Records one test case: do record.do <results file> <id> "<description>" <expected rc> <got rc>
* A do-file, not a program, so that clear all in the code under test cannot drop it.
args out id desc want got
local ok = cond("`want'" == "`got'", "PASS", "FAIL")
tempname fh
file open `fh' using "`out'", write text append
file write `fh' "TEST `ok' `id' (want r(`want'), got r(`got')): `desc'" _n
file close `fh'
display as text "TEST `ok' `id' (want r(`want'), got r(`got')): `desc'"
