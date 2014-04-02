#!/usr/local/bin/fish

# recalculate all the paired/triple graphs
cd usage-charts/
for ws in (cat ../target-pairs.txt )
    set -l a (echo $ws | cut -d '|' -f 1)
    set -l b (echo $ws | cut -d '|' -f 2)
    set -l c (echo $ws | cut -d '|' -f 3)
    if [ -z $c ]
        gnuplot -e "worda=\"$a\";wordb=\"$b\"" ../pair-chart.gnuplot
    else
        gnuplot -e "worda=\"$a\";wordb=\"$b\";wordc=\"$c\"" ../triple-chart.gnuplot
    end
end
