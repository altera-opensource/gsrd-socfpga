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
| Agilex FM61   |   gsrd [ sgmii + pr + qspi ]                 |
| Agilex FM86   |   gsrd                                       |
| Agilex FM87   |   gsrd                                       |
| Stratix10     |   gsrd [ sgmii + pr + qspi ]                 |
| Arria10       |   gsrd, qspi, nand, pcie, pr, sgmii, tse     |
| Cyclone5      |   gsrd                                       |
| Default       |   gsrd                                       |


## Default GSRD Setup

1. Clone the repository  
`$ git clone -b $POKY_VERSION https://gitlab.devtools.intel.com/psg-opensource/gsrd-socfpga.git`
2. Sync the submodules  
`$ cd gsrd-socfpga`  
`$ git submodule update --init --remote -r`
3. Source the script to export component version (Linux,U-Boot,ATF,Machine,Image)  

|  Target       |            Command                |
| ------------- | --------------------------------- |
| Agilex FM61   | $ . agilex_fm61-gsrd-build.sh     |
| Agilex FM86   | $ . agilex_fm86-gsrd-build.sh     |
| Agilex FM67   | $ . agilex_fm87-gsrd-build.sh     |
| Stratix10     | $ . stratix10-gsrd-build.sh       |
| Arria10       | $ . arria10-$Image-build.sh       |
| Cyclone V     | $ . cyclone5-gsrd-build.sh        |

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
| Agilex FM61   | $ . agilex_fm61-gsrd-build.sh     |
| Agilex FM86   | $ . agilex_fm86-gsrd-build.sh     |
| Agilex FM67   | $ . agilex_fm87-gsrd-build.sh     |
| Stratix10     | $ . stratix10-gsrd-build.sh       |
| Arria10       | $ . arria10-$Image-build.sh       |
| Cyclone V     | $ . cyclone5-gsrd-build.sh        |

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
| Agilex FM61   | $ . agilex_fm61-gsrd-build.sh     |
| Agilex FM86   | $ . agilex_fm86-gsrd-build.sh     |
| Agilex FM67   | $ . agilex_fm87-gsrd-build.sh     |
| Stratix10     | $ . stratix10-gsrd-build.sh       |
| Arria10       | $ . arria10-$Image-build.sh       |
| Cyclone V     | $ . cyclone5-gsrd-build.sh        |

4. Setup build environment  
`$ build_setup`
<pre>
5. OPTIONAL:  GHRD:  
              1. Add custom GHRD design in:  
                 $WORKSPACE/meta-intel-fpga-refdes/recipes-bsp/ghrd/files  
                 NOTE: Update/Replace the file with the same naming convention  
                       For Agilex FM61:-  
                                  agilex_fm61_gsrd_ghrd.core.rbf  
                                  agilex_fm61_nand_ghrd.core.rbf  
                                  agilex_fm61_pr_ghrd.core.rbf  
                                  agilex_fm61_pr_persona0.rbf  
                                  agilex_fm61_pr_persona1.rbf  
                       For Agilex FM86:-  
                                  agilex_fm86_gsrd_ghrd.core.rbf  
                       For Agilex FM87:-  
                                  agilex_fm87_gsrd_ghrd.core.rbf  
                       For Stratix10:-  
                                  stratix10_gsrd_ghrd.core.rbf  
                                  stratix10_nand_ghrd.core.rbf  
                                  stratix10_pr_persona0.rbf  
                                  stratix10_pr_persona1.rbf  
                       For Arria10:-  
                                  GSRD:-  
                                      arria10_gsrd_ghrd_10as066n2.core.rbf  
                                      arria10_gsrd_ghrd_10as066n2.periph.rbf  
                                      arria10_gsrd_hps.xml  
                                  NAND:-  
                                      arria10_nand_ghrd_10as066n2.core.rbf  
                                      arria10_nand_ghrd_10as066n2.periph.rbf  
                                      arria10_nand_hps.xml  
                                  PCIE:-  
                                      arria10_pcie_ghrd_10as066n2.core.rbf  
                                      arria10_pcie_ghrd_10as066n2.periph.rbf  
                                      arria10_pcie_hps.xml  
                                  PR:-  
                                      arria10_pr_ghrd_10as066n2.core.rbf  
                                      arria10_pr_ghrd_10as066n2.periph.rbf  
                                      arria10_pr_hps.xml  
                                      arria10_pr_persona0.rbf  
                                      arria10_pr_persona1.rbf  
                                  QSPI:-  
                                      arria10_qspi_ghrd_10as066n2.core.rbf  
                                      arria10_qspi_ghrd_10as066n2.periph.rbf  
                                      arria10_qspi_hps.xml  
                                  SGMII:-  
                                      arria10_sgmii_ghrd_10as066n2.core.rbf  
                                      arria10_sgmii_ghrd_10as066n2.periph.rbf  
                                      arria10_sgmii_hps.xml  
                                  TSE:-  
                                      arria10_tse_ghrd_10as066n2.core.rbf  
                                      arria10_tse_ghrd_10as066n2.periph.rbf  
                                      arria10_tse_hps.xml  
                       For Cyclone5:-  
                                  cyclone5_gsrd_soc_system.rbf  
              2. Update SRC_URL in the recipe:  
                 $WORKSPACE/meta-intel-fpga-refdes/recipes-bsp/ghrd/hw-ref-design.bb  
                 Note: Update the SRC_URL using the example below  
                       Include the required file with sha256sum  
                 Eg:-  
                       SRC_URI:agilex_fm61 ?= "\  
                                           file://agilex_fm61_gsrd_ghrd.core.rbf;sha256sum=xxxx \  
                                           file://agilex_fm61_nand_ghrd.core.rbf;sha256sum=xxxx \  
                                           file://agilex_fm61_pr_ghrd.core.rbf;sha256sum=xxxx \  
                                           file://agilex_fm61_pr_persona0.rbf;sha256sum=xxxx \  
                                           file://agilex_fm61_pr_persona1.rbf;sha256sum=xxxx \  
                                           "  
              U-BOOT:  
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
