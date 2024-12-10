REM load create the project
quartus_sh -t create.tcl

REM generate the nessessary qsys files
REM cd ../src/HW/nios_system
REM call nios_systyem_hw.bat
REM cd ../../../HW

REM load all the files
quartus_sh -t load.tcl

REM load all the files
quartus_sh -t compile.tcl
pause
