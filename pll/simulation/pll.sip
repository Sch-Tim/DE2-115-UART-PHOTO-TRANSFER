set_global_assignment -entity "pll" -library "lib_pll" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "pll" -library "lib_pll" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "pll" -library "lib_pll" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_pll" -name SPD_FILE [file join $::quartus(sip_path) "../pll.spd"]
set_global_assignment -library "lib_pll" -name MISC_FILE [file join $::quartus(sip_path) "../../pll.qsys"]

set_global_assignment -library "lib_pll" -name MISC_FILE [file join $::quartus(sip_path) "pll.vhd"]
set_global_assignment -library "lib_pll" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_controller.v"]
set_global_assignment -library "lib_pll" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_synchronizer.v"]
set_global_assignment -library "lib_pll" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_controller.sdc"]
set_global_assignment -library "lib_pll" -name MISC_FILE [file join $::quartus(sip_path) "submodules/pll_altpll_2.vho"]
set_global_assignment -library "lib_pll" -name MISC_FILE [file join $::quartus(sip_path) "submodules/pll_altpll_1.vho"]
set_global_assignment -library "lib_pll" -name MISC_FILE [file join $::quartus(sip_path) "submodules/pll_altpll_0.vho"]
