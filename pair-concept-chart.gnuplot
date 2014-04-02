set terminal pdf
set output sprintf("pair-concept-%s-%s.pdf", concepta, conceptb)
unescape(x) = system("echo \"" . x . "\"| sed -e 's/_/ /'")
set title sprintf("Comparison of '%s' and '%s'", unescape(concepta), unescape(conceptb))
set key on
set xrange [1649:1700]
set mxtics 5
set yrange [0<*:1<*]
set xlabel "Year"
set ylabel "Count per 10,000 words"
plot sprintf("concept-%s.csv", concepta) linecolor rgbcolor "brown" title unescape(concepta) with lines, \
     sprintf("concept-%s.csv", conceptb) linecolor rgbcolor "blue" title unescape(conceptb) with lines

