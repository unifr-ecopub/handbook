* Reads what a run printed in a log of its own: do logsays.do <log>
* Sets the caller's local said to 1 when a printed line (not an echoed command), with the parts a
* log breaks at 255 characters joined again, holds the text of the global t_want and not that of
* t_without, where it is set; nsaid is the number of such lines.
args log
mata: s = cat(st_local("log")); j = J(0, 1, ""); for (i = 1; i <= rows(s); i++) { if (substr(s[i], 1, 2) == "> " & rows(j) > 0) j[rows(j)] = j[rows(j)] + substr(s[i], 3, .); else j = j \ s[i]; }
mata: o = select(j, !ustrregexm(j, "^(\. | *[0-9]+\. )")); h = select(o, strpos(o, st_global("t_want")) :> 0); if (st_global("t_without") != "" & rows(h) > 0) h = select(h, strpos(h, st_global("t_without")) :== 0); st_local("n", strofreal(rows(h)))
local said = `n' > 0
c_local nsaid `n'
c_local said `said'
