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

|    Target                  |              Image                           |
| -------------------------- | -------------------------------------------- |
| Agilex5 DEV KIT            |   gsrd                                       |


## Default GSRD Setup

1. Clone the repository  
`$ git clone -b $POKY_VERSION https://gitlab.devtools.intel.com/psg-opensource/gsrd-socfpga.git`
2. Sync the submodules  
`$ cd gsrd-socfpga`  
`$ git submodule update --init --remote -r`
3. Source the script to export component version (Linux,U-Boot,ATF,Machine,Image)  

|  Target                    |            Command                           |
| -------------------------- | -------------------------------------------- |
| Agilex5 DEV KIT            | $ . agilex5_devkit-gsrd-build.sh             |

4. Build default GSRD setup  
`$ build_default`  

## Default GSRD Setup with eSDK

1. Clone the repository  
`$ git clone -b $POKY_VERSION https://gitlab.devtools.intel.com/psg-opensource/gsrd-socfpga.git`
2. Sync the submodules  
`$ cd gsrd-socfpga`  
`$ git submodule update --init --remote -r`
3. Source the script to export component version (Linux,U-Boot,ATF,Machine,Image)  

|  Target                    |            Command                           |
| -------------------------- | -------------------------------------------- |
| Agilex5 DEV KIT            | $ . agilex5_devkit-gsrd-build.sh             |

4. Build default GSRD setup + eSDK  
`$ build_esdk`  

## Custom GSRD Setup

1. Clone the repository  
`$ git clone -b $POKY_VERSION https://gitlab.devtools.intel.com/psg-opensource/gsrd-socfpga.git`
2. Sync the submodules  
`$ cd gsrd-socfpga`  
`$ git submodule update --init --remote -r`
3. Source the script to export component version (Linux,U-Boot,ATF,Machine,Image)  

|  Target                    |            Command                           |
| -------------------------- | -------------------------------------------- |
| Agilex5 DEV KIT            | $ . agilex5_devkit-gsrd-build.sh             |

4. Setup build environment  
`$ build_setup`
<pre>
5. OPTIONAL:  GHRD:  
              1. Add custom GHRD design in:  
                 $WORKSPACE/meta-intel-fpga-refdes/recipes-bsp/ghrd/files  
                 NOTE: Update/Replace the file with the same naming convention  
                       For Agilex5 DEV KIT:-  
                                  agilex5_devkit_gsrd_ghrd.core.rbf
                                  agilex5_devkit_nand_ghrd.core.rbf
                                  agilex5_devkit_emmc_ghrd.core.rbf
                                  agilex5_devkit_aic0_ghrd.core.rbf
                                  agilex5_devkit_debug2_ghrd.core.rbf
              2. Update SRC_URL in the recipe:  
                 $WORKSPACE/meta-intel-fpga-refdes/recipes-bsp/ghrd/hw-ref-design.bb  
                 Note: Update the SRC_URL using the example below  
                       Include the required file with sha256sum  
                 Eg:-  
                       SRC_URI:agilex5_devkit ?= "\  
                                           file://agilex5_devkit_gsrd_ghrd.core.rbf;sha256sum=xxxx \  
                                           file://agilex5_devkit_nand_ghrd.core.rbf;sha256sum=xxxx \  
                                           file://agilex5_devkit_emmc_ghrd.core.rbf;sha256sum=xxxx \  
                                           file://agilex5_devkit_aic0_ghrd.core.rbf;sha256sum=xxxx \  
                                           file://agilex5_devkit_debug2_ghrd.core.rbf;sha256sum=xxxx \  
                                           "  
              U-BOOT:  
                 For Agilex 5 DEV KIT:-  
                     Edit uboot.txt, uboot_script.its in:  
                     $WORKSPACE/meta-intel-fpga-refdes/recipes-bsp/u-boot/files  
                     Edit fit_kernel_agilex5_devkit.its in:  
                     $WORKSPACE/meta-intel-fpga-refdes/recipes-kernel/linux/linux-socfpga-lts  
</pre>
6. Perform Yocto bitbake to generate binaries  
`$ bitbake_image`
7. Package binaries into build folder  
`$ package`  