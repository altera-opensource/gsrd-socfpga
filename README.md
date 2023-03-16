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
#### [Default GSRD Setup](#default-gsrd-setup-1)  
#### [Default GSRD Setup with eSDK](#default-gsrd-setup-with-esdk-1)  
#### [Custom GSRD Setup](#custom-gsrd-setup-1)  

## Supported Image Variant:  

|    Target     |              Image                           |
| ------------- | -------------------------------------------- |
| Agilex5       |   gsrd                                       |

## Default GSRD Setup

1. Clone the repository  
`$ git clone -b $POKY_VERSION https://gitlab.devtools.intel.com/psg-opensource/gsrd-socfpga.git`
2. Sync the submodules  
`$ cd gsrd-socfpga`  
`$ git submodule update --init --remote -r`
3. Source the script to export component version (Linux,U-Boot,ATF,Machine,Image)  

|  Target       |            Command                |
| ------------- | --------------------------------- |
| Agilex5       | $ . agilex5-gsrd-build.sh         |

4. Build default GSRD setup  
`$ build_default`  

## Default GSRD Setup with eSDK

1. Clone the repository  
`$ git clone -b $POKY_VERSION https://gitlab.devtools.intel.com/psg-opensource/gsrd-socfpga.git`
2. Sync the submodules  
`$ cd gsrd-socfpga`  
`$ git submodule update --init --remote -r`
3. Source the script to export component version (Linux,U-Boot,ATF,Machine,Image)  

|  Target       |            Command                |
| ------------- | --------------------------------- |
| Agilex5       | $ . agilex5-gsrd-build.sh         |

4. Build default GSRD setup + eSDK  
`$ build_esdk`  

## Custom GSRD Setup

1. Clone the repository  
`$ git clone -b $POKY_VERSION https://gitlab.devtools.intel.com/psg-opensource/gsrd-socfpga.git`
2. Sync the submodules  
`$ cd gsrd-socfpga`  
`$ git submodule update --init --remote -r`
3. Source the script to export component version (Linux,U-Boot,ATF,Machine,Image)  

|  Target       |            Command                |
| ------------- | --------------------------------- |
| Agilex5       | $ . agilex5-gsrd-build.sh         |


4. Setup build environment  
`$ build_setup`
<pre>
5. OPTIONAL:  
              U-BOOT:  
                 For Agilex5:-  
                     Edit agilex5_uboot.txt, agilex5_uboot_script.its in:  
                     $WORKSPACE/meta-intel-fpga-refdes/recipes-bsp/u-boot/files  
                     Edit fit_kernel_agilex5.its in:  
                     $WORKSPACE/meta-intel-fpga-refdes/recipes-kernel/linux/linux-socfpga  
                 For Agilex and Stratix10:-  
                     Edit uboot.txt, uboot_script.its in:  
                     $WORKSPACE/meta-intel-fpga-refdes/recipes-bsp/u-boot/files  
                     Edit fit_kernel_(agilex*/stratix10).its in:  
                     $WORKSPACE/meta-intel-fpga-refdes/recipes-kernel/linux/linux-socfpga-lts  
                 For Cyclone5:-  
                     Edit cyclone5_u-boot.txt in:  
                     $WORKSPACE/meta-intel-fpga-refdes/recipes-bsp/u-boot/files  
</pre>
6. Perform Yocto bitbake to generate binaries  
`$ bitbake_image`
7. Package binaries into build folder  
`$ package`  
