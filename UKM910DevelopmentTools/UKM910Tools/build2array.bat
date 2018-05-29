UKM910-elf-as source/%1.asm -o object_bin/%1.o
UKM910-elf-ld --oformat binary object_bin/%1.o -o bin/%1.bin
bin2array bin/%1.bin array/%1.array
