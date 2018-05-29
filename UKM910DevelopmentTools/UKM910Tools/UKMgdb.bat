set CDU=%CD:\=/%
start "UKM910 Simulator" /min "UKM910.x" "--load=elf\%1.elf"
..\emacs-22.3\bin\runemacs.exe --execute="(gdb \"../UKM910Tools/UKM910-elf-gdb --annotate=3 -x ../UKM910Tools/gdbstartupmin \\\"%CDU%/elf/%1.elf\\\"\")"
