#!/usr/local/bin/fish

# recalculate all the word counts
cd usage-charts/
for w in (cat ../target-phrases.txt)
    echo "===== $w"
    ../phrase-usage.py "$w" ../case-year.csv ../stopped/* > $w.csv
    gnuplot -e "word=\"$w\"" ../usage-chart.gnuplot
end

