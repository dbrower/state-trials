set terminal pdf
set terminal pdf linewidth 1
unescape(x) = system("echo \"" . x ."\"| sed -e 's/_/ /'")
set output sprintf("triple-%s-%s-%s.pdf", worda, wordb, wordc)
set title sprintf("Comparison of '%s', '%s', and '%s'", unescape(worda), unescape(wordb), unescape(wordc))
set key on
set xrange [1649:1700]
set mxtics 5
set yrange [0<*:1<*]
set xlabel "Year"
set ylabel "Count per 10,000 words"
plot sprintf("%s.csv", worda) linecolor rgb "brown" title unescape(worda) with lines, \
     sprintf("%s.csv", wordb) linecolor rgb "blue" title unescape(wordb) with lines, \
     sprintf("%s.csv", wordc) linecolor rgb "dark-green" title unescape(wordc) with lines

