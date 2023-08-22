.PHONY: all clean visualize simulator

all: visualize

.DELETE_ON_ERROR:

ifndef PROJECT
$(error "Must set PROJECT variable" )
endif

VERILOG_SRC := $(CURDIR)/$(PROJECT).v

FPGA := 85k

# Available: 20, 314 and 316
CONSTRAINTS_VER := 316
CONFIG_FILE := $(CURDIR)/$(PROJECT).config

VERILATOR := verilator
VERILATOR_FLAGS := -O3 -MMD --trace -Wall --cc --build --exe
VERILATOR_OUTDIR  := $(CURDIR)/obj_dir
VERILATOR_APP := $(CURDIR)/$(PROJECT)_tb
VERILATOR_APP_SRC := $(VERILATOR_APP).cpp
VERILATOR_TRACE_FILE := $(CURDIR)/$(PROJECT).vcd

YOSYS := yosys
YOSYS_SRC := $(CURDIR)/$(PROJECT).ys
YOSYS_JSON := $(CURDIR)/$(PROJECT).json
YOSYS_SYNTH_FLAGS := -noccu2 -nomux -nodram

BITSTREAM_PACKER := ecppack
PLACER_ROUTER := nextpnr-ecp5
PROGRAMMER := fujprog

BITSTREAM := $(CURDIR)/$(PROJECT).bin

bitstream: $(BITSTREAM)

simulator: $(VERILATOR_APP)

visualize: $(VERILATOR_TRACE_FILE)
	gtkwave $<

clean:
	rm -rf $(VERILATOR_OUTDIR) $(VERILATOR_APP) $(VERILATOR_TRACE_FILE) \
		$(YOSYS_SRC) $(YOSYS_JSON) \
		$(CONFIG_FILE) \
		$(BITSTREAM)

$(VERILATOR_TRACE_FILE): $(VERILATOR_APP)
	$<

$(VERILATOR_APP): $(VERILATOR_APP_SRC) $(VERILOG_SRC)
	$(VERILATOR) $(VERILATOR_FLAGS) $^ -o $@

$(BITSTREAM): $(CONFIG_FILE)
	$(BITSTREAM_PACKER) $< $@

$(CONFIG_FILE): $(YOSYS_JSON)
	$(PLACER_ROUTER) \
		--$(FPGA) \
		--json $< \
		--lpf $(CURDIR)/../.constraints/ulx3s_v$(CONSTRAINTS_VER).lpf \
		--textcfg $(CONFIG_FILE)

.PHONY: $(YOSYS_SRC)
$(YOSYS_SRC):
	echo "read_verilog $(VERILOG_SRC)" > $@
	echo "synth_ecp5 $(YOSYS_SYNTH_FLAGS) -json $(YOSYS_JSON)" >> $@

$(YOSYS_JSON): $(YOSYS_SRC) $(VERILOG_SRC)
	$(YOSYS) $<

prog: $(BITSTREAM)
	$(PROGRAMMER) $<

prog-flash: $(BITSTREAM)
	$(PROGRAMMER) -j FLASH $<
