UKM910-elf-as -ahls --gdwarf2 --gstabs+ source\%1.asm -o object_bin\%1.o
UKM910-elf-ld object_bin\%1.o -o elf\%1.elf

