transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus/subtractor_32bit.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus/mux2to1_32bit.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus/mux2to1_1bit.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus/full_adder_1bit.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus/adder_32bit.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus/alu.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus/sign_extender.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus/control_unit.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus/alu_control.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus/register_file.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus/mux2to1_5bit.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus/mips_single_cycle_datapath.v}

vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/singleCycleProsQuartus/testbench.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
