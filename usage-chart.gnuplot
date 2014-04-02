set terminal pdf
set output sprintf("%s.pdf", word)
unescape(x) = system("echo \"" . x . "\"| sed -e 's/_/ /'")
set title sprintf("Usage of '%s'", unescape(word))
set key off
set xrange [1649:1700]
set mxtics 5
set yrange [0<*:1<*]
set xlabel "Year"
set ylabel "Count per 10,000 words"
plot sprintf("%s.csv", word) linecolor rgb "blue" with lines
