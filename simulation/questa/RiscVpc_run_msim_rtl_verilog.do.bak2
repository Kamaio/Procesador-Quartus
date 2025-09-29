transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Juan\ Felipe\ Ocampo\ G/AppData/Local/quartus/Procesador {C:/Users/Juan Felipe Ocampo G/AppData/Local/quartus/Procesador/top_level.v}
vlog -vlog01compat -work work +incdir+C:/Users/Juan\ Felipe\ Ocampo\ G/AppData/Local/quartus/Procesador {C:/Users/Juan Felipe Ocampo G/AppData/Local/quartus/Procesador/pc.v}
vlog -sv -work work +incdir+C:/Users/Juan\ Felipe\ Ocampo\ G/AppData/Local/quartus/Procesador {C:/Users/Juan Felipe Ocampo G/AppData/Local/quartus/Procesador/hex7seg.sv}
vlog -sv -work work +incdir+C:/Users/Juan\ Felipe\ Ocampo\ G/AppData/Local/quartus/Procesador {C:/Users/Juan Felipe Ocampo G/AppData/Local/quartus/Procesador/sumador.sv}

vlog -sv -work work +incdir+C:/Users/Juan\ Felipe\ Ocampo\ G/AppData/Local/quartus/Procesador {C:/Users/Juan Felipe Ocampo G/AppData/Local/quartus/Procesador/tb_top_level.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_top_level

add wave *
view structure
view signals
run -all
