set terminal pdf
set output "length-by-case.pdf"
set title "Number of Words By Case (Sopwords Removed)"
set key off
set xlabel "Case"
set ylabel "Word Count"
set xrange [*:*]
set style fill solid 1 border 0
binwidth = 2000
#set boxwidth binwidth/2
bin_left(x,width) = width*floor(x/width)
bin_right(x,width) = width*floor(x/width)+width/2
set boxwidth 1 absolute
#set boxwidth binwidth
plot 'concept-all.csv' using 1:8 with boxes lc rgb "brown"
#plot 'concept-all.csv' using (bin_left($9, binwidth)):(1) smooth freq with boxes title "stopwords present" lc rgb "goldenrod"
#plot 'concept-all.csv' using (bin_left($8, binwidth)):(1) smooth freq with boxes title "stopwords removed" lc rgb "brown", \
