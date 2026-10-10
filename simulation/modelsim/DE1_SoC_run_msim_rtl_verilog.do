transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Ibrahim\ Rasyid/Downloads/CSE371\ Lab1 {C:/Users/Ibrahim Rasyid/Downloads/CSE371 Lab1/seg7.sv}

