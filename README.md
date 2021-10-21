# Intel SoCFPGA Golden Software Reference Design

GSRD is an Embedded Linux Reference Distribution optimized for SoCFPGA.
It is based on Yocto Project Poky reference distribution.

## Meta Layers

* meta-intel-fpga - SoCFPGA BSP Core Layer
* meta-intel-fpga-refdes - SoCFPGA GSRD Customization Layer

Dependencies
* poky - Core Layer from Yocto Project
* meta-openembedded - Additional features (python, networking tools, etc) for GSRD

## Using The Script

1. Clone the repository
`$ git clone https://gitlab.devtools.intel.com/psg-opensource/gsrd-socfpga.git`
2. Sync the submodules
`$ cd gsrd-socfpga`
`$ git submodule update --init --remote -r`

|  Target   |        Command         |
| --------- | ---------------------- |
| Agilex    | $ ./agilex-build.sh    |
| Stratix10 | $ ./stratix10-build.sh |
| Arria10   | $ ./arria10-build.sh   |
| Cyclone V | $ ./cyclone5-build.sh  |

