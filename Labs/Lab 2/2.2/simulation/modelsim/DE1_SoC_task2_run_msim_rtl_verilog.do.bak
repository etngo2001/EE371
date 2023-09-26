transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/egeen/Desktop/School/EE\ 371/Labs/Lab\ 2/2.2 {C:/Users/egeen/Desktop/School/EE 371/Labs/Lab 2/2.2/ram32x4.v}
vlog -sv -work work +incdir+C:/Users/egeen/Desktop/School/EE\ 371/Labs/Lab\ 2/2.2 {C:/Users/egeen/Desktop/School/EE 371/Labs/Lab 2/2.2/counter.sv}
vlog -sv -work work +incdir+C:/Users/egeen/Desktop/School/EE\ 371/Labs/Lab\ 2/2.2 {C:/Users/egeen/Desktop/School/EE 371/Labs/Lab 2/2.2/seg7.sv}
vlog -sv -work work +incdir+C:/Users/egeen/Desktop/School/EE\ 371/Labs/Lab\ 2/2.2 {C:/Users/egeen/Desktop/School/EE 371/Labs/Lab 2/2.2/DE1_SoC_task2.sv}

