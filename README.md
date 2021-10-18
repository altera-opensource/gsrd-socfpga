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


|  Target   |        Command         |
| --------- | ---------------------- |
| Agilex    | $ ./agilex-build.sh    |
| Stratix10 | $ ./stratix10-build.sh |
| Arria10   | $ ./arria10-build.sh   |
| Cyclone V | $ ./cyclone5-build.sh  |

