vlib work
vcom ../../src/binary_to_sevseg_3dig.vhd
vcom tb_binary_to_sevseg_3dig.vhd
vsim tb_binary_to_sevseg_3dig
add wave *
run 15 sec
stop