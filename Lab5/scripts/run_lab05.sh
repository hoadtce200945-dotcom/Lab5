#!/usr/bin/env bash 
set -euo pipefail 
 
rm -f work-obj08.cf 
mkdir -p waveform 
 
ghdl -a --std=08 src/lfsr_timer.vhd 
ghdl -a --std=08 src/demux_1_to_4.vhd 
ghdl -a --std=08 src/lab05.vhd 
ghdl -a --std=08 sim/lab05_tb.vhd 
ghdl -e --std=08 lab05_tb 
ghdl -r --std=08 lab05_tb --assert-level=error --wave=waveform/lab05.ghw 
 
echo "Simulation PASS - opening GTKWave" 
gtkwave waveform/lab05.ghw 
