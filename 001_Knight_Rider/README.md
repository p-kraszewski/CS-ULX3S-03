# A Knight-Rider effect for the ULX3S Board

Strongy based on [Blinky by DoctorWkt](https://github.com/DoctorWkt/ULX3S-Blinky). Too different to make a fork.

For tools and environment: see parent [README](../README.md).

## Targets

* `make` or `make visualize`: build simulator with `Verilator`, run it and start `gtkwave` with saved trace.
* `make simulator`: just build simulator, without running anything
* `make bitstream`: build the actual bitstream for FPGA
* `make program`: build bitstream and program it to FPGA SRAM (does not survive power cycle)
* `make program-flash`: build bitstream and program it to on-board FLASH (does survive power cycle)
* `make clean`: remove all generated files
