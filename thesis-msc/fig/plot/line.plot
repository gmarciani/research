set terminal postscript eps enhanced color font 'Helvetica,10'
set output "line.eps"

set title "Sample Line Chart"
set xlabel "Insert X label"
set ylabel "Insert Y label"

set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 7 ps 1.5   # --- blue
set style line 2 lc rgb '#dd181f' lt 1 lw 2 pt 5 ps 1.5   # --- red

plot "line.dat" index 0 with linespoints ls 1, "" index 1 with linespoints ls 2
