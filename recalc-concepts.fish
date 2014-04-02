#!/usr/local/bin/fish

# recalculate all the word counts
cd usage-charts/
for w in ../concept-*.txt
    set -l concept (echo $w | sed -e 's/.*concept-//g;s/\.txt//g')
    echo "===== $concept"
    ../phrase-usage.py @$w ../case-year.csv ../stopped/* > concept-$concept.csv
    gnuplot -e "concept=\"$concept\"" ../chart-concept.gnuplot
end

