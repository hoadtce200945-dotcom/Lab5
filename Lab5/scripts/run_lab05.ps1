# FAP201 - Lab05 Simulation Script for PowerShell
Remove-Item -Force -ErrorAction SilentlyContinue work-obj08.cf
if (!(Test-Path "waveform")) { New-Item -ItemType Directory -Path "waveform" }

ghdl -a --std=08 src/lfsr_timer.vhd
ghdl -a --std=08 src/demux_1_to_4.vhd
ghdl -a --std=08 src/lab05.vhd
ghdl -a --std=08 sim/lab05_tb.vhd

ghdl -e --std=08 lab05_tb
ghdl -r --std=08 lab05_tb --assert-level=error --wave=waveform/lab05.ghw

Write-Host "Simulation PASS - opening GTKWave..." -ForegroundColor Green
Start-Process gtkwave "waveform/lab05.ghw"
