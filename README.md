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

1. Update the submodules
`git submodule update -r --remote`
2. Run the target build script
For Agilex, run
`./agilex-build.sh`
For Stratix10, run
`./stratix10-build.sh`
For Arria10, run
`./arria10-build.sh`
For Cyclone V, run
`./cyclone5-build.sh`
