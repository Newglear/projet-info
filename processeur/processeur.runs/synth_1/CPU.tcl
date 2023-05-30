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
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/g_robert/tmp_PSI/projet-info/processeur/processeur.cache/wt [current_project]
set_property parent.project_path /home/g_robert/tmp_PSI/projet-info/processeur/processeur.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property board_part digilentinc.com:basys3:part0:1.1 [current_project]
set_property ip_output_repo /home/g_robert/tmp_PSI/projet-info/processeur/processeur.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  /home/g_robert/tmp_PSI/projet-info/processeur/processeur.srcs/sources_1/new/ALU.vhd
  /home/g_robert/tmp_PSI/projet-info/processeur/processeur.srcs/sources_1/new/registers.vhd
  /home/g_robert/tmp_PSI/projet-info/processeur/processeur.srcs/sources_1/new/data_bench.vhd
  /home/g_robert/tmp_PSI/projet-info/processeur/processeur.srcs/sources_1/new/code_bench.vhd
  /home/g_robert/tmp_PSI/projet-info/processeur/processeur.srcs/sources_1/new/sync.vhd
  /home/g_robert/tmp_PSI/projet-info/processeur/processeur.srcs/sources_1/new/CPU.vhd
  /home/g_robert/tmp_PSI/projet-info/processeur/processeur.srcs/sources_1/new/compteur_8bits.vhd
  /home/g_robert/tmp_PSI/projet-info/processeur/processeur.srcs/sources_1/new/LC.vhd
  /home/g_robert/tmp_PSI/projet-info/processeur/processeur.srcs/sources_1/new/MUX_DI.vhd
  /home/g_robert/tmp_PSI/projet-info/processeur/processeur.srcs/sources_1/new/LC_ALU.vhd
  /home/g_robert/tmp_PSI/projet-info/processeur/processeur.srcs/sources_1/new/MUX_EX.vhd
  /home/g_robert/tmp_PSI/projet-info/processeur/processeur.srcs/sources_1/new/LC_Mem.vhd
  /home/g_robert/tmp_PSI/projet-info/processeur/processeur.srcs/sources_1/new/MUX_MEM.vhd
  /home/g_robert/tmp_PSI/projet-info/processeur/processeur.srcs/sources_1/new/MUX_RE.vhd
  /home/g_robert/tmp_PSI/projet-info/processeur/processeur.srcs/sources_1/new/PRE_PROCESS.vhd
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top CPU -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef CPU.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file CPU_utilization_synth.rpt -pb CPU_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
