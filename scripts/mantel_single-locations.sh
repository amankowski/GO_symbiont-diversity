#!/bin/bash

mkdir ./analyses/phylogenetic_correlation/host/single_locations
mkdir ./analyses/phylogenetic_correlation/mito/single_locations

cd ./analyses/phylogenetic_correlation/

grep Oilvae ../../data/metadata.csv|grep -v Italy|awk -F";" '{print $1}' > ./Oilv_not-Italy_libs
grep Oalgarvensis ../../data/metadata.csv|grep -v Italy|awk -F";" '{print $1}' > ./Oalg_not-Italy_libs
grep Ileukodermatus ../../data/metadata.csv|grep -v Belize|awk -F";" '{print $1}' > ./Ileu_not-Belize_libs

cd ./host/single_locations

for f in $(ls ../|grep Oilvae|grep -v mantel_out); do grep -v -f ../../Oilv_not-Italy_libs ../${f} > ./${f}; done
for f in $(ls ../|grep Oalgarvensis|grep -v mantel_out); do grep -v -f ../../Oalg_not-Italy_libs ../${f} > ./${f}; done
for f in $(ls ../|grep Ileukodermatus|grep -v mantel_out); do grep -v -f ../../Ileu_not-Belize_libs ../${f} > ./${f}; done

for f in $(ls); do ../../../../scripts/mantel_host-vs-symbiont.R --symbiont ${f##*_} --input ./${f} --output ./${f}_mantel_out; done

for f in *mantel_out; do paste <(echo -e "host\n${f%%_*}") <(cat $f) > tmp && mv tmp ${f}; done

(head -n 1 Ileukodermatus_Alpha10_mantel_out &&  for f in *mantel_out; do tail -n +2 ${f}; done) > mantel_combined

cd ../../mito/single_locations

for f in $(ls ../|grep Oilvae|grep -v mantel_out); do grep -v -f ../../Oilv_not-Italy_libs ../${f} > ./${f}; done
for f in $(ls ../|grep Oalgarvensis|grep -v mantel_out); do grep -v -f ../../Oalg_not-Italy_libs ../${f} > ./${f}; done
for f in $(ls ../|grep Ileukodermatus|grep -v mantel_out); do grep -v -f ../../Ileu_not-Belize_libs ../${f} > ./${f}; done

for f in $(ls); do ../../../../scripts/mantel_host-vs-symbiont.R --symbiont ${f##*_} --input ./${f} --output ./${f}_mantel_out; done

for f in *mantel_out; do paste <(echo -e "host\n${f%%_*}") <(cat $f) > tmp && mv tmp ${f}; done

(head -n 1 Ileukodermatus_Alpha10_mantel_out &&  for f in *mantel_out; do tail -n +2 ${f}; done) > mantel_combined