vlib work
vcom ../../src/telemetre_us.vhd
vcom tb_telemetre_us.vhd
vsim tb_telemetre_us
add wave *
run 15 sec
stop