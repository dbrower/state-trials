#
#          Stacked Plot Demo
#
# Set top and bottom margins to 0 so that there is no space between plots.
# Fix left and right margins to make sure that the alignment is perfect.
# Turn off xtics for all plots except the bottom one.
# In order to leave room for axis and tic labels underneath, we ask for
# a 4-plot layout but only use the top 3 slots.
#
#set tmargin 0
#set bmargin 0
set lmargin 9
set rmargin 2
#unset xtics

set terminal pdf
set output ",,zzz.pdf"
set terminal pdf linewidth 1

set multiplot layout 2,1 title "Comparison of Toleration and Trade by Year"

#set key autotitle column nobox samplen 1 noenhanced
set style data boxes
set xrange [1649:1700]
#set xlabel "Year"
unset xlabel
unset xtics
set ylabel "Count per 10,000 Words"
set ytics nomirror
#set y2label "Number Cases"
#set y2tics
#set logscale y

set boxwidth 1 absolute
set style fill solid 0.5
set bmargin 0
plot 'concept-trade.csv' lc rgb "blue" t "trade" with lines, \
 'concept-toleration.csv' t "toleration" lc rgb "brown" with lines
set xrange [1649:1700]
set tmargin 0
unset bmargin
set xlabel "Year"
set xtics nomirror
set ytics nomirror
plot 'year-case-count.csv' with boxes
#plot '../year-count.csv' with boxes
#set tics scale 0 font ",8"
#set xlabel "Immigration to U.S. by Decade"
#plot 'immigration.dat' using 21:xtic(1) lt 4

unset multiplot
