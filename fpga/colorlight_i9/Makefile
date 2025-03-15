
all: ./build/out.bit

./build/out.bit: ./build/out.config
	ecppack --compress --input ./build/out.config  --bit ./build/out.bit

./build/out.config: ./build/out.json
	nextpnr-ecp5 --json ./build/out.json --write ./build/out_pnr.json --45k \
		--lpf pinout.lpf --textcfg ./build/out.config --package CABGA381 \
		--speed 6 --lpf-allow-unconstrained

./build/out.json: main.sv pinout.lpf buildFolder run.tcl
	synlig -c run.tcl

buildFolder:
	mkdir -p build

clean:
	rm -rf build
	rm -rf slpp_all

load:
	openFPGALoader -b colorlight-i9 ./build/out.bit

flash:
	openFPGALoader -b colorlight-i9 -f ./build/out.bit

run_all: ./build/out.bit flash