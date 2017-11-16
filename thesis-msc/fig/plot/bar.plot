set terminal postscript eps enhanced color font 'Helvetica,10'
set output "bar.eps"

set title "Sample Bar Chart"

set boxwidth 0.4
set style fill solid
set key off

set xlabel "Insert X label"
set ylabel "Insert Y label"

plot "bar.dat" using 1:3:xtic(2) with boxes
