ifndef VIVADO_PATH
	VIVADO=vivado
else
	VIVADO=$(VIVADO_PATH)/vivado
endif

all: ./build/out.bit

./build/out.bit: buildFolder
	@echo "Building the Design..."
	$(VIVADO)  -mode batch -nolog -nojournal -source run.tcl
buildFolder:
	@echo "Creating the build folder..."
	mkdir -p build
	mkdir -p reports

clean:
	@echo "Cleaning the build folder..."
	rm -rf build
	rm -rf reports
	rm -rf .Xil
	rm -rf clockInfo.txt

# openFPGALoader funciona apenas na versão nightly, a versão estavel atual não suporta a vc709 ainda
load:
	@echo "Flashing the FPGA..."
	openFPGALoader -b zcu102 ./build/out.bit

run_all: ./build/out.bit load