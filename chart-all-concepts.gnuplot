set terminal pdf
set output "concepts-all-by-year.pdf"
set title "Topic Distribution by Year"
set key outside
set xlabel "Year"
set xtics nomirror
set ylabel "Count per 10,000 Words"
set xrange [1649:1700]
set style fill solid 1 border 0
set style data lines
set style line 1 lt rgb "red" lw 3
set style line 2 lt rgb "bisque" lw 3
set style line 3 lt rgb "dark-yellow" lw 3
set style line 4 lt rgb "dark-green" lw 3
set style line 5 lt rgb "light-blue" lw 3
set style line 6 lt rgb "blue" lw 3
set style line 7 lt rgb "violet" lw 3
set style line 8 lt rgb "brown" lw 3
concepts = "heterodoxy intolerance orthodoxy rule-of-law sovereignty toleration trade"
plot for [i=1:words(concepts)] sprintf("concept-%s.csv", word(concepts,i)) using 1:2 t word(concepts,i) ls i

