transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/egeen/Desktop/School/EE\ 371/Labs/Lab\ 1 {C:/Users/egeen/Desktop/School/EE 371/Labs/Lab 1/carSensor.sv}
vlog -sv -work work +incdir+C:/Users/egeen/Desktop/School/EE\ 371/Labs/Lab\ 1 {C:/Users/egeen/Desktop/School/EE 371/Labs/Lab 1/carCount.sv}
vlog -sv -work work +incdir+C:/Users/egeen/Desktop/School/EE\ 371/Labs/Lab\ 1 {C:/Users/egeen/Desktop/School/EE 371/Labs/Lab 1/seg7.sv}
vlog -sv -work work +incdir+C:/Users/egeen/Desktop/School/EE\ 371/Labs/Lab\ 1 {C:/Users/egeen/Desktop/School/EE 371/Labs/Lab 1/DE1_SoC.sv}

