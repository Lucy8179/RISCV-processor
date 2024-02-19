# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/86189/Desktop/cod_exp/exp6/Comprehensive_Experiment/Comprehensive_Experiment.cache/wt [current_project]
set_property parent.project_path C:/Users/86189/Desktop/cod_exp/exp6/Comprehensive_Experiment/Comprehensive_Experiment.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/86189/Desktop/cod_exp/exp6/Comprehensive_Experiment/Comprehensive_Experiment.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files C:/Users/86189/Desktop/cod_exp/exp6/Pipeline_coe/pipeline_test.coe
add_files C:/Users/86189/Desktop/cod_exp/exp6/Pipeline_coe/data.coe
add_files C:/Users/86189/Desktop/cod_exp/exp6/Pipeline_coe/control_test.coe
add_files C:/Users/86189/Desktop/cod_exp/exp6/Matrix_coe/matrix_data.coe
add_files C:/Users/86189/Desktop/cod_exp/exp6/Matrix_coe/matrix_text.coe
add_files C:/Users/86189/Desktop/cod_exp/exp6/load_use_coe/load_use.coe
add_files C:/Users/86189/Desktop/cod_exp/exp6/Pipeline_coe/inst_test.coe
read_verilog -library xil_defaultlib {
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/ADD.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/ALU.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/AND.v
  C:/Users/86189/Desktop/cod_exp/exp6/Branch_Prediction_source_code/BRANCH_PREDICTION.v
  C:/Users/86189/Desktop/cod_exp/exp6/Branch_Prediction_source_code/BTB.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Branch.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Branch_Default.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Branch_Predict_Analyze.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Branch_Predict_Update.v
  C:/Users/86189/Desktop/cod_exp/exp6/Branch_Prediction_source_code/COMPETITION_FSM.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/CPU.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/CTRL.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Check_Data_SEG_SEL.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Check_Data_SEL.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Check_Data_SEL_HZD.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Data_Mem.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Ded.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Encoder.v
  C:/Users/86189/Desktop/cod_exp/exp6/Branch_Prediction_source_code/GLOBAL_PREDICTION.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Hazard.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Hex2ASC.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Immediate.v
  C:/Users/86189/Desktop/cod_exp/exp6/Branch_Prediction_source_code/LOCAL_PREDICTION.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/MEM.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Memory_Map.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Mux1.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Mux2.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/PC.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/PC_SEL_GEN.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/PC_SEL_MUX.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/PDU.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/PDU_ctrl.v
  C:/Users/86189/Desktop/cod_exp/exp6/Branch_Prediction_source_code/PREDICT_COMPETITION.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/RF.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Receive.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Register.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/SEG_REG.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Segment.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Send.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Shift_reg.v
  C:/Users/86189/Desktop/cod_exp/exp6/Branch_Prediction_source_code/TWO_BITS_FSM.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Uout.v
  C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/Top.v
}
read_ip -quiet C:/Users/86189/Desktop/cod_exp/exp6/Comprehensive_Experiment/Comprehensive_Experiment.srcs/sources_1/ip/DPRAM/DPRAM.xci
set_property used_in_implementation false [get_files -all c:/Users/86189/Desktop/cod_exp/exp6/Comprehensive_Experiment/Comprehensive_Experiment.srcs/sources_1/ip/DPRAM/DPRAM_ooc.xdc]

read_ip -quiet C:/Users/86189/Desktop/cod_exp/exp6/Comprehensive_Experiment/Comprehensive_Experiment.srcs/sources_1/ip/ROM/ROM.xci
set_property used_in_implementation false [get_files -all c:/Users/86189/Desktop/cod_exp/exp6/Comprehensive_Experiment/Comprehensive_Experiment.srcs/sources_1/ip/ROM/ROM_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/constrains.xdc
set_property used_in_implementation false [get_files C:/Users/86189/Desktop/cod_exp/exp6/CPU_Pipeline_source_code/constrains.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top Top -part xc7a100tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef Top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file Top_utilization_synth.rpt -pb Top_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]