+libext+.v
+libext+.vh
+libext+.sv
+libext+.svh

+define+SIM
+define+SIM_VERBOSE_LOW
+notimingchecks
-sv

+define+UVM
+define+LOG_DEBUG=UVM_MEDIUM

+incdir+../../inc
+incdir+../../libs
+incdir+../../intf
+incdir+../../src
+incdir+../../master
+incdir+../../slave
+incdir+../../env
+incdir+../../example
+incdir+../../example/test
+incdir+../../example/sequences
+incdir+../../sva

-y  ../../src
-y  ../../master
-y  ../../slave

// ../../inc/dti_apb_inc_file.sv

tb_dti_apb_top.sv

+define+MODE1