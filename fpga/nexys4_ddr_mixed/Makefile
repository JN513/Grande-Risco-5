ifndef VIVADO_PATH
	VIVADO=vivado
else
	VIVADO=$(VIVADO_PATH)/vivado
endif

all: ./build/out.bit

./build/out.bit: ./build/out.edf vivado.tcl
	$(VIVADO) -mode batch -nolog -nojournal -source vivado.tcl

./build/out.edf: main.sv buildFolder yosys.tcl
	synlig -c yosys.tcl

buildFolder:
	mkdir -p build

clean:
	rm -rf build
	rm -rf .Xil
	rm -rf vivado*.log
	rm -rf vivado*.jou
	rm -rf slpp_all

load:
	openFPGALoader -b nexys_a7_100 ./build/out.bit

run_all: ./build/out.bit flash