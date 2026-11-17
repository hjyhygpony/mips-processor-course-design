onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /mips_tb/rst
add wave -noupdate -radix hexadecimal /mips_tb/clk
add wave -noupdate -radix hexadecimal /mips_tb/mips_1/wdsel
add wave -noupdate -radix hexadecimal /mips_tb/mips_1/command
add wave -noupdate /mips_tb/mips_1/gprsel
add wave -noupdate /mips_tb/mips_1/gprwr
add wave -noupdate /mips_tb/mips_1/alu_21071003/overflow
add wave -noupdate -radix hexadecimal /mips_tb/mips_1/gpr_21071003/reg_files
add wave -noupdate -radix hexadecimal /mips_tb/mips_1/pc_21071003/pcout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {598 ns} 0}
configure wave -namecolwidth 252
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {221 ns}
