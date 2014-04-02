set terminal pdf
set output sprintf("pair-%s-%s.pdf", worda, wordb)
unescape(x) = system("echo \"" . x ."\"| sed -e 's/_/ /'")
set title sprintf("Comparison of '%s' and '%s'", unescape(worda), unescape(wordb))
set key on
set xrange [1649:1700]
set mxtics 5
set yrange [0<*:1<*]
set xlabel "Year"
set ylabel "Count per 10,000 words"
plot sprintf("%s.csv", worda) linecolor rgbcolor "brown" title unescape(worda) with lines, \
     sprintf("%s.csv", wordb) linecolor rgbcolor "blue" title unescape(wordb) with lines

