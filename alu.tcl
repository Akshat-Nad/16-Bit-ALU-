set_db init_netlist_files /home/nielit/aarushi/counter_design_database_45nm/physical_design/alunetlist.v
set_db init_lef_files {../lef/gsclib045_tech.lef ../lef/gsclib045_macro.lef}
set_db init_power_nets VDD
set_db init_ground_nets VSS
set_db init_mmmc_files  alu.view
read_mmmc alu.view
read_physical -lef {../lef/gsclib045_tech.lef ../lef/gsclib045_macro.lef}
read_netlist /home/nielit/aarushi/counter_design_database_45nm/physical_design/alunetlist.v -top alu64
init_design


connect_global_net VDD -type pg_pin -pin_base_name VDD -inst_base_name *
connect_global_net VSS -type pg_pin -pin_base_name VSS -inst_base_name *

#Create Floorplan
create_floorplan -core_margins_by die -site CoreSite -core_density_size 1 0.4 2.5 2.5 2.5 2.5

#Pin Assignment
write_io_file -template alu.io
read_io_file alu.io

#Power Planning
set_db add_rings_skip_shared_inner_ring none ; set_db add_rings_avoid_short 1 ; set_db add_rings_ignore_rows 0 ; set_db add_rings_extend_over_row 0

#Add Rings
add_rings -type core_rings -jog_distance 0.6 -threshold 0.6 -nets {VDD VSS} -follow core -layer {bottom Metal11 top Metal11 right Metal10 left Metal10} -width 0.7 -spacing .4 -offset 0.6

#Add Stripes
add_stripes -block_ring_top_layer_limit Metal11 -max_same_layer_jog_length 0.44 -pad_core_ring_bottom_layer_limit Metal9 -set_to_set_distance 5 -pad_core_ring_top_layer_limit Metal11 -spacing 0.4 -merge_stripes_value 0.6 -layer Metal10 -block_ring_bottom_layer_limit Metal9 -width 0.3 -nets {VDD VSS} 

# Create Power Rails with Special Route
route_special -connect core_pin -layer_change_range { Metal1(1) Metal11(11) } -block_pin_target nearest_target -core_pin_target first_after_row_end -allow_jogging 1 -crossover_via_layer_range { Metal1(1) Metal11(11) } -nets { VDD VSS } -allow_layer_change 1 -target_via_layer_range { Metal1(1) Metal11(11) }
# Read the Scan DEF
set_db reorder_scan_comp_logic true
# Run Placement Optimization
place_opt_design
# Save the Database
write_db placeOpt 
# Create a Clock Tree Spec and run CTS
create_clock_tree_spec
ccopt_design 
# Save the database
write_db postCTSopt
# Run Detail Routing
set_db route_design_with_timing_driven 1
set_db route_design_with_si_driven 1
set_db design_top_routing_layer Metal11
set_db design_bottom_routing_layer Metal1
set_db route_design_detail_end_iteration 0
set_db route_design_with_timing_driven true
set_db route_design_with_si_driven true
route_design -global_detail
reset_parasitics
extract_rc
write_parasitics -spef_file alu.spef
set_db check_drc_disable_rules {}
set_db check_drc_ndr_spacing auto
set_db check_drc_check_only default
set_db check_drc_inside_via_def true
set_db check_drc_exclude_pg_net false
set_db check_drc_ignore_trial_route false
set_db check_drc_ignore_cell_blockage false
set_db check_drc_use_min_spacing_on_block_obs auto
set_db check_drc_report alu64.drc.rpt
set_db check_drc_limit 1000
check_drc
set_db check_drc_area {0 0 0 0}
delete_drc_markers
check_connectivity -type all -geometry_connect -error 1000 -warning 50
delete_drc_markers
set_power_output_dir -reset
set_power_output_dir ./run_new
set_default_switching_activity -reset
set_default_switching_activity -input_activity 0.2 -period 10.0
read_activity_file -reset
set_power -reset
set_dynamic_power_simulation -reset
report_power -rail_analysis_format VS -out_file ./run_new/alu64.rpt
#@ source power.tcl
#@ Begin verbose source (pre): source power.tcl
connect_global_net VDD -type pg_pin -pin VDD -inst *
connect_global_net VSS -type pg_pin -pin VSS -inst *
connect_global_net VDD -type tie_hi 
connect_global_net VSS -type tie_lo 
connect_global_net VDD -type tie_hi -pin VDD -inst *
connect_global_net VSS -type tie_lo -pin VSS -inst *
#@ End verbose source: power.tcl
set_power_output_dir -reset
set_power_output_dir ./run_new
set_default_switching_activity -reset
set_default_switching_activity -input_activity 0.2 -period 10.0
read_activity_file -reset
set_power -reset
set_dynamic_power_simulation -reset
report_power -rail_analysis_format VS -out_file ./run_new/alu64.rpt
set_rail_analysis_config -method era_static -power_switch_eco false -write_movies false -write_voltage_waveforms false -accuracy xd -analysis_view wc -process_techgen_em_rules false -enable_rlrp_analysis false -extraction_tech_file ../QRC_Tech/gpdk045.tch -voltage_source_search_distance 50 -ignore_shorts false -enable_mfg_effects false -report_via_current_direction false
set_rail_analysis_config -method era_static -power_switch_eco false -write_movies false -write_voltage_waveforms false -accuracy xd -analysis_view wc -process_techgen_em_rules false -enable_rlrp_analysis false -extraction_tech_file ../QRC_Tech/gpdk045.tch -voltage_source_search_distance 50 -ignore_shorts false -enable_mfg_effects false -report_via_current_direction false
write_power_pads -net VDD -voltage_source_file alu64.pp
set_pg_nets -net VDD -voltage 0.9 -threshold 0.8set_layer_preference violation -is_visible 11
set_power_data -reset
set_power_data -format current -scale 1 run_new/static_VDD.ptiavg
set_power_pads -reset
set_power_pads -net VDD -format xy
set_package -reset
set_package -spice_model_file {} -mapping_file {}
set_net_group -reset
set_advanced_rail_options -reset
report_rail -type net -results_directory ./run_new VDD
set_pg_nets -net VDD -voltage 0.9 -threshold 0.81
set_power_data -reset
set_power_data -format current -scale 1 run_new/static_VDD.ptiavg
set_power_pads -reset
set_power_pads -net VDD -format xy
set_package -reset
set_package -spice_model_file {} -mapping_file {}
set_net_group -reset
set_advanced_rail_options -reset
set_pg_nets -net VDD -voltage 0.9 -threshold 0.81
set_power_data -reset
set_power_data -format current -scale 1 run_new/static_VDD.ptiavg
set_power_pads -reset
set_power_pads -net VDD -format xy
set_package -reset
set_package -spice_model_file {} -mapping_file {}
set_net_group -reset
set_advanced_rail_options -reset
write_power_pads -net VDD -voltage_source_file alu64.pp
set_pg_nets -net VDD -voltage 0.9 -threshold 0.81
set_power_data -reset
set_power_data -format current -scale 1 run_new/static_VDD.ptiavg
set_power_pads -reset
set_power_pads -net VDD -format xy -file alu64.pp
set_package -reset
set_package -spice_model_file {} -mapping_file {}
set_net_group -reset
set_advanced_rail_options -reset
get_distributed_hosts -mode
get_distributed_hosts -mode
get_distributed_hosts -timeOut
get_distributed_hosts -mode
get_distributed_hosts -mode
get_distributed_hosts -mode
get_distributed_hosts -timeOut
get_distributed_hosts -mode
get_distributed_hosts -mode
eval_legacy {isLogCommand eval_legacy}
set_pg_nets -net VDD -voltage 0.9 -threshold 0.81
set_power_data -reset
set_power_data -format current -scale 1 run_new/static_VDD.ptiavg
set_power_pads -reset
set_power_pads -net VDD -format xy -file alu64.pp
set_package -reset
set_package -spice_model_file {} -mapping_file {}
set_net_group -reset
set_advanced_rail_options -reset
get_distributed_hosts -mode
get_distributed_hosts -mode
get_distributed_hosts -timeOut
get_distributed_hosts -mode
get_distributed_hosts -mode
get_distributed_hosts -mode
get_distributed_hosts -timeOut
get_distributed_hosts -mode
get_distributed_hosts -mode
eval_legacy {isLogCommand eval_legacy}
add_fillers -base_cells FILL8 FILL64 FILL4 FILL32 FILL2 FILL16 FILL1 -prefix FILLER
write_stream alu_64_bit -lib_name DesignLib -unit 2000 -mode all
