
all: ./build/out.fs

./build/out.fs: ./build/out.config
	gowin_pack -d :GW2AR-LV18QN88C8/I7 -o ./build/out.fs out_pnr.json

./build/out.config: ./build/out.json
	nextpnr-himbaechel --json ./build/out.json --write ./build/out_pnr.json  \
		--device GW2A-18/I7 --vopt cst=pinout.cst --vopt family=GW2A-18

./build/out.json: main.sv pinout.cst buildFolder run.tcl
	yosys -c run.tcl

buildFolder:
	mkdir -p build

clean:
	rm -rf build
	rm -rf slpp_all

load:
	openFPGALoader -b tangnano20k ./build/out.fs

flash:
	openFPGALoader -b tangnano20k -f ./build/out.fs

run_all: ./build/out.bit flash
