ifndef QUARTUS_PATH
	QUARTUS_PATH=""
endif

all:
	$(QUARTUS_PATH)quartus_sh --flow compile De1SoC_Grande_Risco5

load:
	$(QUARTUS_PATH)quartus_pgm -m jtag -c "DE-SoC " -o "p;build/De1SoC_Grande_Risco5.sof@2"

create_project:
	$(QUARTUS_PATH)quartus_sh -t create_project.tcl

clean:
	rm -rf build/*

run_all: all load