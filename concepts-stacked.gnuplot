set terminal pdf
set output "concepts-stacked-percentages.pdf"
set title "Topic Distribution by Case"
set key outside
set xlabel "Case"
set ylabel "Relative Weight"
set xrange [180:425]
set style fill solid 1 border 0
set style data filledcurves x1
plot 'concept-all.csv' using 1:(1) t "trade", \
'' using 1:(($2+$3+$4+$5+$6+$7)/($2+$3+$4+$5+$6+$7+$8)) t "toleration", \
'' using 1:(($2+$3+$4+$5+$6)/($2+$3+$4+$5+$6+$7+$8)) t "sovereignty", \
'' using 1:(($2+$3+$4+$5)/($2+$3+$4+$5+$6+$7+$8)) t "rule of law", \
'' using 1:(($2+$3+$4)/($2+$3+$4+$5+$6+$7+$8)) t "orthodoxy", \
'' using 1:(($2+$3)/($2+$3+$4+$5+$6+$7+$8)) t "intolerance", \
'' using 1:($2/($2+$3+$4+$5+$6+$7+$8)) t "heterodoxy"

set output "concepts-stacked.pdf

set ylabel "Count per 10,000 Words"
plot 'concept-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8) t "trade", \
'' using 1:($2+$3+$4+$5+$6+$7) t "toleration", \
'' using 1:($2+$3+$4+$5+$6) t "sovereignty", \
'' using 1:($2+$3+$4+$5) t "rule of law", \
'' using 1:($2+$3+$4) t "orthodoxy", \
'' using 1:($2+$3) t "intolerance", \
'' using 1:2 t "heterodoxy"
