VERSION := 1.1.1

PROGRAM_NAME := project

CC := g++
# CC := g++-mp-5 # typical macports compiler name
# CC := g++-5 # typical homebrew compiler name 

ARCH := native # best auto-tuning
# ARCH := core2 # a reasonably safe default for most CPUs since 2007
# ARCH := corei7
# ARCH := corei7-avx # earlier i7 
# ARCH := core-avx-i # i7 ivy bridge or newer 
# ARCH := core-avx2 # i7 with Haswell or newer
# ARCH := nehalem
# ARCH := westmere
# ARCH := sandybridge # circa 2011
# ARCH := ivybridge   # circa 2012
# ARCH := haswell     # circa 2013
# ARCH := broadwell   # circa 2014
# ARCH := skylake     # circa 2015
# ARCH := bonnell
# ARCH := silvermont
# ARCH := skylake-avx512
# ARCH := nocona #64-bit pentium 4 or later 

CFLAGS := -march=$(ARCH) -Ofast -s -fomit-frame-pointer -mfpmath=both -fopenmp -m64 -std=c++11

BioFVM_OBJECTS := BioFVM_vector.o BioFVM_mesh.o BioFVM_microenvironment.o BioFVM_solvers.o BioFVM_matlab.o \
BioFVM_utilities.o BioFVM_basic_agent.o BioFVM_MultiCellDS.o BioFVM_agent_container.o 

PhysiCell_core_OBJECTS := PhysiCell_cell_container.o PhysiCell_cell.o PhysiCell_standard_models.o PhysiCell_digital_cell_line.o \
PhysiCell_custom.o PhysiCell_utilities.o 

PhysiCell_module_OBJECTS := PhysiCell_SVG.o PhysiCell_pathology.o PhysiCell_MultiCellDS.o

# put your custom objects here (they should be in the custom_modules directory)

PhysiCell_custom_module_OBJECTS :=  

pugixml_OBJECTS := pugixml.o

ALL_OBJECTS := $(BioFVM_OBJECTS) $(PhysiCell_core_OBJECTS) $(PhysiCell_module_OBJECTS) $(pugixml_OBJECTS) $(PhysiCell_custom_module_OBJECTS)

EXAMPLES := ./examples/PhysiCell_test_mechanics_1.cpp ./examples/PhysiCell_test_mechanics_2.cpp \
 ./examples/PhysiCell_test_DCIS.cpp ./examples/PhysiCell_test_HDS.cpp \
 ./examples/PhysiCell_test_cell_cycle.cpp ./examples/physicell_test_volume.cpp 

COMPILE_COMMAND := $(CC) $(CFLAGS) 

# template projects 

all: main.cpp $(ALL_OBJECTS)
	$(COMPILE_COMMAND) -o $(PROGRAM_NAME) $(ALL_OBJECTS) main.cpp 

template2D: ./template_projects/template2D.cpp
	cp ./template_projects/template2D.cpp main.cpp 
	cp Makefile ./template_projects/Makefile.backup

template3D: ./template_projects/template3D.cpp
	cp ./template_projects/template3D.cpp main.cpp 	
	cp Makefile ./template_projects/Makefile.backup
	
# examples 

physicell_test_mech1: $(ALL_OBJECTS) ./examples/PhysiCell_test_mechanics_1.cpp 
	$(COMPILE_COMMAND) -o test_mech1 $(ALL_OBJECTS) ./examples/PhysiCell_test_mechanics_1.cpp

physicell_test_mech2: $(ALL_OBJECTS) ./examples/PhysiCell_test_mechanics_2.cpp 
	$(COMPILE_COMMAND) -o test_mech2 $(ALL_OBJECTS) ./examples/PhysiCell_test_mechanics_2.cpp
	
physicell_test_DCIS: $(ALL_OBJECTS) ./examples/PhysiCell_test_DCIS.cpp 
	$(COMPILE_COMMAND) -o test_DCIS $(ALL_OBJECTS) ./examples/PhysiCell_test_DCIS.cpp

physicell_test_HDS: $(ALL_OBJECTS) ./examples/PhysiCell_test_HDS.cpp 
	$(COMPILE_COMMAND) -o test_HDS $(ALL_OBJECTS) ./examples/PhysiCell_test_HDS.cpp

physicell_test_cell_cycle: $(ALL_OBJECTS) ./examples/PhysiCell_test_cell_cycle.cpp 
	$(COMPILE_COMMAND) -o test_cycle $(ALL_OBJECTS) ./examples/PhysiCell_test_cell_cycle.cpp

physicell_test_volume: $(ALL_OBJECTS) ./examples/physicell_test_volume.cpp 
	$(COMPILE_COMMAND) -o test_volume $(ALL_OBJECTS) ./examples/physicell_test_volume.cpp
	
examples: $(ALL_OBJECTS) $(EXAMPLES)
	$(COMPILE_COMMAND) -o ./examples/test_mech1 ./examples/PhysiCell_test_mechanics_1.cpp $(ALL_OBJECTS)
	$(COMPILE_COMMAND) -o ./examples/test_mech2 ./examples/PhysiCell_test_mechanics_2.cpp $(ALL_OBJECTS)
	$(COMPILE_COMMAND) -o ./examples/test_DCIS ./examples/PhysiCell_test_DCIS.cpp $(ALL_OBJECTS)
	$(COMPILE_COMMAND) -o ./examples/test_HDS ./examples/PhysiCell_test_HDS.cpp $(ALL_OBJECTS)
	$(COMPILE_COMMAND) -o ./examples/test_cycle ./examples/PhysiCell_test_cell_cycle.cpp $(ALL_OBJECTS)
	$(COMPILE_COMMAND) -o ./examples/test_volume ./examples/physicell_test_volume.cpp $(ALL_OBJECTS)

# PhysiCell core components	
	
PhysiCell_digital_cell_line.o: ./core/PhysiCell_digital_cell_line.cpp
	$(COMPILE_COMMAND) -c ./core/PhysiCell_digital_cell_line.cpp

PhysiCell_cell.o: ./core/PhysiCell_cell.cpp
	$(COMPILE_COMMAND) -c ./core/PhysiCell_cell.cpp 

PhysiCell_cell_container.o: ./core/PhysiCell_cell_container.cpp
	$(COMPILE_COMMAND) -c ./core/PhysiCell_cell_container.cpp 
	
PhysiCell_standard_models.o: ./core/PhysiCell_standard_models.cpp
	$(COMPILE_COMMAND) -c ./core/PhysiCell_standard_models.cpp 
	
PhysiCell_utilities.o: ./core/PhysiCell_utilities.cpp
	$(COMPILE_COMMAND) -c ./core/PhysiCell_utilities.cpp 
	
PhysiCell_custom.o: ./custom_modules/PhysiCell_custom.cpp
	$(COMPILE_COMMAND) -c ./custom_modules/PhysiCell_custom.cpp 	
	
# BioFVM core components (needed by PhysiCell)	
	
BioFVM_vector.o: ./BioFVM/BioFVM_vector.cpp
	$(COMPILE_COMMAND) -c ./BioFVM/BioFVM_vector.cpp 

BioFVM_agent_container.o: ./BioFVM/BioFVM_agent_container.cpp
	$(COMPILE_COMMAND) -c ./BioFVM/BioFVM_agent_container.cpp 
	
BioFVM_mesh.o: ./BioFVM/BioFVM_mesh.cpp
	$(COMPILE_COMMAND) -c ./BioFVM/BioFVM_mesh.cpp 

BioFVM_microenvironment.o: ./BioFVM/BioFVM_microenvironment.cpp
	$(COMPILE_COMMAND) -c ./BioFVM/BioFVM_microenvironment.cpp 

BioFVM_solvers.o: ./BioFVM/BioFVM_solvers.cpp
	$(COMPILE_COMMAND) -c ./BioFVM/BioFVM_solvers.cpp 

BioFVM_utilities.o: ./BioFVM/BioFVM_utilities.cpp
	$(COMPILE_COMMAND) -c ./BioFVM/BioFVM_utilities.cpp 
	
BioFVM_basic_agent.o: ./BioFVM/BioFVM_basic_agent.cpp
	$(COMPILE_COMMAND) -c ./BioFVM/BioFVM_basic_agent.cpp 
	
BioFVM_matlab.o: ./BioFVM/BioFVM_matlab.cpp
	$(COMPILE_COMMAND) -c ./BioFVM/BioFVM_matlab.cpp

BioFVM_MultiCellDS.o: ./BioFVM/BioFVM_MultiCellDS.cpp
	$(COMPILE_COMMAND) -c ./BioFVM/BioFVM_MultiCellDS.cpp
	
pugixml.o: ./BioFVM/pugixml.cpp
	$(COMPILE_COMMAND) -c ./BioFVM/pugixml.cpp
	
# standard PhysiCell modules

PhysiCell_SVG.o: ./modules/PhysiCell_SVG.cpp
	$(COMPILE_COMMAND) -c ./modules/PhysiCell_SVG.cpp

PhysiCell_pathology.o: ./modules/PhysiCell_pathology.cpp
	$(COMPILE_COMMAND) -c ./modules/PhysiCell_pathology.cpp

PhysiCell_MultiCellDS.o: ./modules/PhysiCell_MultiCellDS.cpp
	$(COMPILE_COMMAND) -c ./modules/PhysiCell_MultiCellDS.cpp
	
# user-defined PhysiCell modules

# cleanup and archiving 
	
clean:
	rm -f *.o
	rm -f $(PROGRAM_NAME)*
	
zip:
	zip latest.zip */*.cpp */*.h Makefile* *.cpp *.h */*.hpp config/* documentation/* matlab/* README.txt
	cp latest.zip $$(date +%b_%d_%Y_%H%M).zip
	cp latest.zip VERSION_$(VERSION).zip 
	mv *.zip archives/
	
tar:
	tar --ignore-failed-read -czf latest.tar */*.cpp */*.h Makefile* *.cpp */*.hpp config/* documentation/* matlab/* README.txt
	cp latest.tar $$(date +%b_%d_%Y_%H%M).tar
	cp latest.tar VERSION_$(VERSION).tar
	mv *.tar archives/

unzip: 
	cp ./archives/latest.zip . 
	unzip latest.zip 
	
untar: 
	cp ./archives/latest.tar .
	tar -xzf latest.tar
