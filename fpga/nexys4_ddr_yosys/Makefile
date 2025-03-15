
all: ./build/out.bit

./build/out.bit: ./build/out.frames
	xc7frames2bit --part_file /usr/share/xray/database/artix7/xc7a100tcsg324-1/part.yaml \
	--part_name xc7a100tcsg324-1 --frm_file ./build/out.frames --output_file ./build/out.bit

./build/out.frames: ./build/out.fasm
	fasm2frames --part xc7a100tcsg324-1 --db-root /usr/share/xray/database/artix7 ./build/out.fasm > ./build/out.frames

./build/out.fasm: ./build/out.json pinout.xdc
	nextpnr-xilinx --chipdb /usr/share/nextpnr/xilinx-chipdb/xc7a100tcsg324-1.bin --xdc pinout.xdc \
	--json ./build/out.json --write ./build/out_pnr.json --fasm ./build/out.fasm

./build/out.json: main.sv buildFolder run.tcl
	synlig -c run.tcl

buildFolder:
	mkdir -p build

clean:
	rm -rf build
	rm -rf slpp_all

load:
	openFPGALoader -b nexys_a7_100 ./build/out.bit

run_all: ./build/out.bit flash