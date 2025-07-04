#!/bin/bash 
reset

# Tools
# export MTI_HOME=/tools/mentor/questasim-2024.3
# export PATH=$MTI_HOME/linux_x86_64/:$PATH

# # License
# export LM_LICENSE_FILE=29000@dt90-linux
# export SALT_LICENSE_SERVER=29000@dt90-linux

# UVM
# UVMLIB=1800.2-2020.3.0
# export UVM_HOME="D:\DIGITAL_DESIGN\1800.2-2020.3.0"

# Generate uvm lib
# ccflags_dyn="-fPIC"
# ldflags_dyn="-shared"

export TEST_NAME="apb_uart_standard_test"
mkdir -p log
mkdir -p ucdb

# if [ ! -f uvm_dpi.so ]; then
  # echo "c++ -Wno-deprecated ${ccflags_dyn} ${ldflags_dyn} -DQUESTA  ${UVM_HOME}/src/dpi/uvm_dpi.cc"
  # c++ -Wno-deprecated ${ccflags_dyn} ${ldflags_dyn} -DQUESTA  ${UVM_HOME}/src/dpi/uvm_dpi.cc
# fi

# Run simulation
alias vlb='reset; rm -rf work; rm -rf log/vlogr.log log/vlogt.log; vlib work'

alias vlgr='vlog -64 -f filelist_com.f -f filelist_rtl.f +cover=bcefs -l ./log/vlogr.log'

# if [[ "${UVMLIB}" == "uvm-1.1" ]]; then
#   # echo "vlog -64 -f filelist_com.f -f filelist_vsim.f +incdir+${UVM_HOME}/src -f filelist_tb.f -l ./log/vlogt.log"
#   alias vlgt='vlog -64 -f filelist_com.f -f filelist_vsim.f +incdir+../libs/uvm-1.1d/src -f filelist_tb.f -l ./log/vlogt.log'
# else
  # echo "vlog -64 -f filelist_com.f -f filelist_vsim.f +incdir+${UVM_HOME}/src +define+UVM_NO_DEPRECATED -f filelist_tb.f -l ./log/vlogt.log"
  alias vlgt='vlog -64 -f filelist_com.f -f filelist_vsim.f +incdir+../libs/uvm-1.1d/src ../libs/uvm-1.1d/src/uvm_pkg.sv +define+UVM_NO_DEPRECATED -f filelist_tb.f -l ./log/vlogt.log'
# fi
alias vlg='vlgr;vlgt'

alias vsm='vsim -c apb_uart_top -wlf vsim.wlf -solvefaildebug -assertdebug -sva -coverage -voptargs=+acc -l ./log/vsim.log +UVM_VERBOSITY=UVM_MEDIUM +UVM_TESTNAME=${TEST_NAME} -sv_lib ../libs/uvm-1.1d/lib/uvm_dpiWin64.dll -do "coverage save -assert -directive -cvg -code bcefs -onexit ./ucdb/${TEST_NAME}.ucdb; add wave -r /apb_uart_top/*; run -all; quit";'


alias vsm_debug='vsim -c top_test -wlf vsim.wlf -solvefaildebug -assertdebug -sva -coverage -voptargs=+acc -l ./log/vsim.log +UVM_VERBOSITY=UVM_DEBUG +UVM_TESTNAME=tc_strb -sv_lib uvm_dpi -do "coverage save -assert -directive -cvg -code bcefs -onexit ./ucdb/tc_strb.ucdb; add wave -r /top_test/*; run -all; quit";'

alias check_error_model='grep -r -i "ERROR" ./log/vsim.log;'

alias vsms='vsim -c top -sdfmaxr top/dynamo=../../syn/netlist/dynamo.sdf -solvefaildebug -voptargs=+acc -l ./log/vsim.log +UVM_VERBOSITY=UVM_DEBUG -sv_lib ../libs/$UVMLIB/lib/uvm_dpi64 -do "add wave -r /top/*; run -all; quit"'
alias viw='vsim -view vsim.wlf -nowlflock -do "wave.do" &'
alias mer='vcover merge -64 coverage_total.ucdb  ./ucdb/*.ucdb'

#tc_standard
#tc_change_bit_num
#tc_change_stop_bit_num
#tc_strb
vlb
vlg
vsm