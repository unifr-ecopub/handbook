* Plays the curator: writes a released version of a toy dataset into the test data root.
* do toyversion.do <root> <dataset> <version> <file> <value>
args R ds v f val
foreach d in "`R'/processed" "`R'/processed/`ds'" "`R'/processed/`ds'/`v'" {
    capture mkdir "`d'"
}
clear
set obs 26
generate ctn = _n
generate value = _n * `val'
label variable value "A toy value"
save "`R'/processed/`ds'/`v'/`f'.dta", replace
tempname fh
file open `fh' using "`R'/processed/`ds'/`v'/manifest.txt", write text replace
file write `fh' "dataset `ds'" _n "version `v'" _n "released 2026-11-21" _n "commit none" _n "file `f'" _n
file close `fh'
clear
