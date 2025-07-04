onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Master /tb_dti_apb_top/apb_intf/master_intf/PCLK
add wave -noupdate -expand -group Master /tb_dti_apb_top/apb_intf/master_intf/PRESETn
add wave -noupdate -expand -group Master /tb_dti_apb_top/apb_intf/master_intf/PADDR
add wave -noupdate -expand -group Master /tb_dti_apb_top/apb_intf/master_intf/PRDATA
add wave -noupdate -expand -group Master /tb_dti_apb_top/apb_intf/master_intf/PWDATA
add wave -noupdate -expand -group Master /tb_dti_apb_top/apb_intf/master_intf/PSTRB
add wave -noupdate -expand -group Master /tb_dti_apb_top/apb_intf/master_intf/PSEL
add wave -noupdate -expand -group Master /tb_dti_apb_top/apb_intf/master_intf/PENABLE
add wave -noupdate -expand -group Master /tb_dti_apb_top/apb_intf/master_intf/PWRITE
add wave -noupdate -expand -group Master /tb_dti_apb_top/apb_intf/master_intf/PREADY
add wave -noupdate -expand -group Master /tb_dti_apb_top/apb_intf/master_intf/PSLVERR
add wave -noupdate -expand -group Slave /tb_dti_apb_top/apb_intf/slave_intf/PCLK
add wave -noupdate -expand -group Slave /tb_dti_apb_top/apb_intf/slave_intf/PRESETn
add wave -noupdate -expand -group Slave /tb_dti_apb_top/apb_intf/slave_intf/PADDR
add wave -noupdate -expand -group Slave /tb_dti_apb_top/apb_intf/slave_intf/PRDATA
add wave -noupdate -expand -group Slave /tb_dti_apb_top/apb_intf/slave_intf/PWDATA
add wave -noupdate -expand -group Slave /tb_dti_apb_top/apb_intf/slave_intf/PSTRB
add wave -noupdate -expand -group Slave /tb_dti_apb_top/apb_intf/slave_intf/PSEL
add wave -noupdate -expand -group Slave /tb_dti_apb_top/apb_intf/slave_intf/PENABLE
add wave -noupdate -expand -group Slave /tb_dti_apb_top/apb_intf/slave_intf/PWRITE
add wave -noupdate -expand -group Slave /tb_dti_apb_top/apb_intf/slave_intf/PREADY
add wave -noupdate -expand -group Slave /tb_dti_apb_top/apb_intf/slave_intf/PSLVERR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {22690 ns}
