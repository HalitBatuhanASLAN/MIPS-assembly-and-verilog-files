transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus/add32.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus/imm_extender.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus/shifter.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus/alu_control.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus/alu.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus/pc_reg.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus/reg_file.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus/imem.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus/dmem.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus/control_unit.v}
vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus/mips_cpu.v}

vlog -vlog01compat -work work +incdir+C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus {C:/Users/halit/Desktop/thirdYear/firstTerm/comptOrg/hwSolutionsANDpracitces/SingleCycleAdvancedQuartus/mips_cpu_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  mips_cpu_tb

add wave *
view structure
view signals
run -all
