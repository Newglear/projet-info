webtalk_init -webtalk_dir /home/imbergam/Documents/4IR/projet-info/processeur/processeur.sim/sim_1/behav/xsim/xsim.dir/regs_Test_behav/webtalk/
webtalk_register_client -client project
webtalk_add_data -client project -key date_generated -value "Fri May 12 18:16:30 2023" -context "software_version_and_target_device"
webtalk_add_data -client project -key product_version -value "XSIM v2018.2 (64-bit)" -context "software_version_and_target_device"
webtalk_add_data -client project -key build_version -value "2258646" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_platform -value "LIN64" -context "software_version_and_target_device"
webtalk_add_data -client project -key registration_id -value "" -context "software_version_and_target_device"
webtalk_add_data -client project -key tool_flow -value "xsim_vivado" -context "software_version_and_target_device"
webtalk_add_data -client project -key beta -value "FALSE" -context "software_version_and_target_device"
webtalk_add_data -client project -key route_design -value "FALSE" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_family -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_device -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_package -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_speed -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key random_id -value "a65fa7ab4f79551f9441df78abb087e3" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_id -value "97d1890935644ec9914f99937f7ed1d0" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_iteration -value "38" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_name -value "Ubuntu" -context "user_environment"
webtalk_add_data -client project -key os_release -value "Ubuntu 20.04.6 LTS" -context "user_environment"
webtalk_add_data -client project -key cpu_name -value "Intel(R) Core(TM) i5-4590 CPU @ 3.30GHz" -context "user_environment"
webtalk_add_data -client project -key cpu_speed -value "900.000 MHz" -context "user_environment"
webtalk_add_data -client project -key total_processors -value "1" -context "user_environment"
webtalk_add_data -client project -key system_ram -value "8.000 GB" -context "user_environment"
webtalk_register_client -client xsim
webtalk_add_data -client xsim -key Command -value "xsim" -context "xsim\\command_line_options"
webtalk_add_data -client xsim -key trace_waveform -value "true" -context "xsim\\usage"
webtalk_add_data -client xsim -key runtime -value "1 us" -context "xsim\\usage"
webtalk_add_data -client xsim -key iteration -value "1" -context "xsim\\usage"
webtalk_add_data -client xsim -key Simulation_Time -value "0.02_sec" -context "xsim\\usage"
webtalk_add_data -client xsim -key Simulation_Memory -value "114396_KB" -context "xsim\\usage"
webtalk_transmit -clientid 460734265 -regid "" -xml /home/imbergam/Documents/4IR/projet-info/processeur/processeur.sim/sim_1/behav/xsim/xsim.dir/regs_Test_behav/webtalk/usage_statistics_ext_xsim.xml -html /home/imbergam/Documents/4IR/projet-info/processeur/processeur.sim/sim_1/behav/xsim/xsim.dir/regs_Test_behav/webtalk/usage_statistics_ext_xsim.html -wdm /home/imbergam/Documents/4IR/projet-info/processeur/processeur.sim/sim_1/behav/xsim/xsim.dir/regs_Test_behav/webtalk/usage_statistics_ext_xsim.wdm -intro "<H3>XSIM Usage Report</H3><BR>"
webtalk_terminate
