set terminal pdf
set output "option-2.pdf"
set terminal pdf linewidth 1

set title "Comparison of Toleration and Trade by Year"

set style data boxes
set xrange [1649:1700]
set xlabel "Year"
set ylabel "Count per 10,000 Words"
set xtics nomirror
set ytics nomirror
set y2label "Number Cases"
set y2tics
#set logscale y

set boxwidth 1 absolute
set style fill transparent solid 0.5
plot 'concept-trade.csv' lc rgb "blue" t "trade" with lines, \
 'concept-toleration.csv' t "toleration" lc rgb "brown" with lines, \
'year-case-count.csv' t "cases" with boxes axis x1y2
#plot '../year-count.csv' with boxes
#set tics scale 0 font ",8"
#set xlabel "Immigration to U.S. by Decade"
#plot 'immigration.dat' using 21:xtic(1) lt 4
