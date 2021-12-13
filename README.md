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
`$ git clone -b $Poky_Version https://gitlab.devtools.intel.com/psg-opensource/gsrd-socfpga.git`
2. Sync the submodules  
`$ cd gsrd-socfpga`  
`$ git submodule update --init --remote -r`
3. Source the script to export component version (Linux,U-Boot,ATF,Machine,Image)  

|  Target   |            Command            |
| --------- | ----------------------------- |
| Agilex    | $ . agilex-gsrd-build.sh      |
| Stratix10 | $ . stratix10-gsrd-build.sh   |
| Arria10   | $ . arria10-$Image-build.sh   |
| Cyclone V | $ . cyclone5-gsrd-build.sh    |

4. Setup build environment and staging folder  
`$ build_setup`
5. Update git submodules (meta layers)  
`$ update_meta`
6. Setup Yocto build configuration  
`$ yocto_setup`
<pre>
7. OPTIONAL:  Update/Replace custom GHRD design in:  
              $WORKSPACE/meta-intel-fpga-refdes/recipes-bsp/ghrd/files  
              NOTE: Update/Replace the file with the same naming convention  
   OPTIONAL:  For Agilex and Stratix10:-  
                  Edit uboot.txt, uboot_script.its in:  
                  $WORKSPACE/meta-intel-fpga-refdes/recipes-bsp/u-boot/files  
                  Edit fit_kernel_(agilex/stratix10).its in:  
                  $WORKSPACE/meta-intel-fpga-refdes/recipes-kernel/linux/linux-socfpga-lts  
              For Cyclone5:-  
                  Edit cyclone5_u-boot.txt in:  
                  $WORKSPACE/meta-intel-fpga-refdes/recipes-bsp/u-boot/files  
</pre>
8. Perform Yocto bitbake to generate binaries  
`$ bitbake_image`
9. Package binaries into build folder  
`$ package`  

## Using The Script (Default GSRD Setup)

1. Clone the repository  
`$ git clone -b $Poky_Version https://gitlab.devtools.intel.com/psg-opensource/gsrd-socfpga.git`
2. Sync the submodules  
`$ cd gsrd-socfpga`  
`$ git submodule update --init --remote -r`
3. Source the script to export component version (Linux,U-Boot,ATF,Machine,Image)  

|  Target   |            Command            |
| --------- | ----------------------------- |
| Agilex    | $ . agilex-gsrd-build.sh      |
| Stratix10 | $ . stratix10-gsrd-build.sh   |
| Arria10   | $ . arria10-$Image-build.sh   |
| Cyclone V | $ . cyclone5-gsrd-build.sh    |

4. Build default GSRD setup  
`$ build_default`  

## Supported Image Variant:  

|    Target    |              Image                           |
| ------------ | -------------------------------------------- |
|  Agilex      |   gsrd [ sgmii + pr + qspi ]                 |
|  Stratix10   |   gsrd [ sgmii + pcie + pr + qspi ]          |
|  Arria10     |   gsrd, qspi, nand, pcie, pr, sgmii, tse     |
|  Cyclone5    |   gsrd                                       |
|  Default     |   gsrd                                       |