vlib work
vcom ../../src/servomoteur.vhd
vcom tb_servomoteur.vhd
vsim tb_servomoteur
add wave *
run 15 sec
stop