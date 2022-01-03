# Compile and Link Variable
CC := gcc
CC_FLAGS := -Wall -m64 -gdwarf-2 -c
ASM := yasm
ASM_FLAGS := -f elf64 -gdwarf2
LINKER := gcc
LINKER_FLAGS := -Wall -m64 -gdwarf-2 -no-pie 


# Executable name
BIN_NAME := my-program
BIN := ./$(BIN_NAME)

run:	build
	@echo "Running program!"
	./my-program

build: $(BIN)
.PHONY: build

#
$(BIN): triangle.o compute_area.o get_sides.o show_results.o heron.o
	g++ -g -Wall -Wextra -Werror -std=c++17 -no-pie triangle.o compute_area.o get_sides.o show_results.o heron.o -o my-program
	@echo "Done"

show_results.o: show_results.cpp
	g++ -g -Wall -Wextra -Werror -std=c++17 -c -o show_results.o show_results.cpp
	
compute_area.o: compute_area.asm
	$(ASM) $(ASM_FLAGS) compute_area.asm -o compute_area.o

get_sides.o: get_sides.c
	$(CC) $(CC_FLAGS) get_sides.c -o get_sides.o	

triangle.o: triangle.asm
	$(ASM) $(ASM_FLAGS) triangle.asm -o triangle.o

heron.o: heron.cpp
	g++ -g -Wall -Wextra -Werror -std=c++17 -c -o heron.o heron.cpp

# ca make targets as many as want

clean: 
	-rm *.o
	-rm $(BIN)














