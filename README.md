# ULX3S resources

## HARDWARE

All sources are written for and tested with `ULX3S v3.1.8` (as sold on [Mouser](https://www.mouser.pl/ProductDetail/Radiona/CS-ULX3S-03?qs=hWgE7mdIu5SAh1Tg%2FLbSUg%3D%3D) as `CS-ULX3S-03` in April 2023).

## OS
Software platform used was `Manjaro Linux` on `x86_64` device.

## Software for bitstream generation

Package versions are as of `2023-08-21`

* Native
    * `extra/yosys` 0.25-1
    * `extra/prjtrellis` 1.3-2
    * `extra/prjtrellis-db` r262.f7f8375-3
* AUR
    * `AUR/nextpnr-git` 0.6.r43.g053dfc98-1
    * `AUR/fujprog` 4.8-1
    * `AUR/vhd2vl-git` 2.5-1 -- `PKGSOURCE` is outdated, you need to edit `source=(...)` line and change `git://` to `git+https://` before building the package. Without the change it timeouts on `git` access.
    * `AUR/istyle-verilog-formatter-git` v1.23.r13.ge368dee-1

**Note** - pure AUR setup worked for me too, in place of *native* packages:

* AUR
    * `AUR/nextpnr-ecp5-nightly` 1:20230821_nextpnr_0.6_43_g053dfc98-1
    * `AUR/yosys-nightly` 1:20230821_yosys_0.32_52_g6405bbab1-2
    * `AUR/prjtrellis-nightly` 1:20230821_1.4_17_g53beef4-1

## Software for simulation

* Native
    * `extra/verilator` 5.014-1
    * `extra/gtkwave` 3.3.116-1
* AUR
    * `AUR/verilator-git`  r5486.0e4da3b0b-1
    * `aur/gtkwave-gtk3` 3.3.117-1


## `udev` rules file `90-radiona.rules`

Pick one:

### Enabled only for members of `plugdev` group

```udev
# udev rules file for Radiona ULX3S
#
ACTION!="add|change", GOTO="radiona_rules_end"
SUBSYSTEM!="tty", GOTO="radiona_rules_end"
# 0403:6015
ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="0660", GROUP="plugdev"

LABEL="radiona_rules_end"
```

### Enabled for everybody

```udev
# udev rules file for Radiona ULX3S
#
ACTION!="add|change", GOTO="radiona_rules_end"
SUBSYSTEM!="tty", GOTO="radiona_rules_end"
# 0403:6015
ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="0666"

LABEL="radiona_rules_end"
```
