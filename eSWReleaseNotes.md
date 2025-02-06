# Intel FPGA HPS Embedded Software Release Notes


## Release Information

**Version:**  Release 24.3.1 PRO<br>
**Release Date:** January 31st, 2025<br>
**Devices Affected:**  Agilex™ 5, Agilex™ 7<br>
**Release Type:** Minor release/Binary release<br>
**Binary Release Path:**  https://releases.rocketboards.org/2025.01/<br>

**Note:** Although new features supported in this release were focus on Agilex™ 5 and Agilex™ 7 devices, indirectly  Stratix® 10 device was also affected after there is some shared code among them. Also, there were few fixed issues that affected the Stratix® 10, Cyclone® V and Arria® 10 devices.



The source code and tools repositories with the current release branches or versions are shown next.

| SW Component | Release Repository | Branch/Tag |
| :-- | :-- | :-- |
| Arm® Trusted Firmware | https://github.com/altera-opensource/arm-trusted-firmware | socfpga_v2.11.1/QPDS24.3.1_REL_GSRD_PR |
| U-Boot | https://github.com/altera-opensource/u-boot-socfpga | socfpga_v2024.07/QPDS24.3.1_REL_GSRD_PR |
| Linux kernel |  https://github.com/altera-opensource/linux-socfpga | socfpga-6.6.51-lts/QPDS24.3.1_REL_GSRD_PR |
| GHRD | https://github.com/altera-opensource/ghrd-socfpga | master/QPDS24.3.1_REL_GSRD_PR |
| GSRD | https://github.com/altera-opensource/gsrd-socfpga | styhead/QPDS24.3.1_REL_GSRD_PR |
| Reference Designs Sources | https://github.com/altera-opensource/meta-intel-fpga-refdes | styhead/QPDS24.3.1_REL_GSRD_PR |
| Reference Design Recipes | https://git.yoctoproject.org/git/meta-intel-fpga | styhead/QPDS24.3.1_REL_GSRD_PR |
| Yocto Project | https://git.openembedded.org/meta-openembedded | styhead |
| Reference Yocto Project | https://git.yoctoproject.org/git/poky.git/ | styhead |
| Zephyr | https://github.com/altera-opensource/zephyr-socfpga/ | socfpga_rel_24.3/QPDS24.3_REL_GSRD_PR |
| Baremetal | https://github.com/altera-fpga/baremetal-drivers | main / 24.3 |
| ARM® Debugger | 	https://www.intel.com/content/www/us/en/software-kit/816394/arm-development-studio-version-2023-1-for-intel-soc-fpga.html | ARM DS 2023.1|

## Features Released
| Feature Description | Component Affected | Scope <br> Device/Board | HSD <br> (Internal Use) |
| :-- | :-- | :-- | :-- |
| Provide an example design(s) demonstrating simple TSN functionality including ptp4l, phc2sys, ethtool, tc, ip. | GSRD | Agilex™ 5 | 22014236672 |
| Improved latency in SMC call in ATF by yeld immediately and just send a mailbox message. The Linux or non-secure software would poll the response. **Commit IDs:**  d9182e80c1, 8bad787e85, ef74dadb1f, dfe710310d. | ATF | Agilex™5<br>Agilex™7<br>Stratix® 10 | 15011992914 |
| Improved latency in SMC call in ATF by yeld immediately and just send a mailbox message. The Linux or non-secure software would poll the response. **Commit IDs:** 4edadb87549c14751cac7d17bd9a0df1f5863e00, c3f82a01e1, 22425012fd, 49a6eb948d, 9d1d3cca77, d8c0390957, eebb852778, 1605f0a44b. | Linux | Agilex™5<br>Agilex™7 <br>Stratix® 10 |15011993515|
| Hypervisor support. Added a  separate modular add-on reference design that can builds seamlessly on top of the baseline of Agilex™ 5 E/D-Series GSRD, demonstrating Linux and Zephyr running side-by side in the HPS cluster. HPS has capability to boot hypervisor on main CPU core and launch Zephyr on secondary CPU core. Want to demonstrate separation of execution and memory. **Commit IDs:** f76229cbd8, 3835b20a77, 7e7d3a6c00. | GSRD | Agilex™ 5 | 18025905437<br>18027472935 |
| Migrated GSRD for Agilex™ 7 FPGA F-Series SI Transceiver-SoC Development Kit from Enpirion (DK-SI-AGF014EA) to Linear version (DK-SI-AGF014EB). | GSRD | Agilex™ 7 | 18036345149 |
| U-Boot: Provided ability to query the SDM configuration status and/or report errors seen by the SDM during FPGA configuration from HPS.  Allowing U-Boot to query the SDM on configuration status and error log would help users find underlying cause of failure faster e.g., finding the SDM had logged messages such as missing ref clock for transceivers, or mis-matched FPGA core rbf (Phase 2) with HPS first image (Phase 1).The ask applies to all SDM-based SoC devices. **Commit IDs:** 0d9cd85d1d. | U-Boot | Agilex™ 5 <br>  Agilex™ 7 <br> Stratix®10 | 18036484257|
| ATF: Provided ability to query the SDM configuration status and/or report errors seen by the SDM during FPGA configuration from HPS.  Allowing U-Boot to query the SDM on configuration status and error log would help users find underlying cause of failure faster .e.g., finding the SDM had logged messages such as missing ref clock for transceivers, or mis-matched FPGA core rbf (Phase 2) with HPS first image (Phase 1).The ask applies to all SDM-based SoC devices. **Commit IDs:** da54890a35. | ATF | Agilex™ 5 <br>  Agilex™ 7 <br> Stratix® 10 | 18036484257|



## Fixed Issues
| Issue Fixed | Component Affected | Scope <br> Device/Board | HSD <br> (Internal Use) |
| :-- | :-- | :-- | :-- |
| Update GHRD for Agilex™ 5 Modular dev kit to use the official device MK- A5E065BB32AES1. **Commit IDs:** 4f170c94e5, f578fb674d, b60722a750. | GHRD | Agilex™ 5 | 15016519273 |
| Cache is not flushed when a cold reset is triggered from U-Boot using **reset** command or through SMC call to ATF.  **Commit IDs:** ccffa28b12. | ATF  | Agilex™ 7 | 14022144130 |
| Unable to boot up using ARM® DS using second boot core (A76). Workaround identified.  | ARM® DS | Agilex™ 5 | 15016006295<br>15015204245 |
| QIS and DA warnings are observed when ECC is enabled in Agilex™ 7 M-Series SOF. **Commit IDs:** f7fca206e9, 593900edff, 86312a166c | GHRD | Agilex™ 7 | 15016822102 |
| Get the broad device ID from JTAG ID. The JTAG ID is read from the boot scratch cold 4 register, and based on the sub device type info retrieved from JTAG ID, the appropriate code path is executed to correct the erratum on the silicon. **Commit IDs:** aa9348797c | U-Boot | Agilex™ 5 | 15016529058 |
| ATF FDT enhancement for future portability. **Commit IDs:** 69564808d9. | ATF | Agilex™ 5 | 15016396549 |
| NAND failed to initialize on U-boot 2024.04 (Agilex™ 5 Power- Optimized). The test unable to initialize NAND controller. **Commit IDs:** 59be0e78ca. | GSRD | Agilex™ 5 | 15016663458 |
| Add DMAs fields to SPI Master nodes in Agilex™ 7 reference device tree. **Commit IDs:** 31dccee15c, 3b24c8869e. | Linux | Agilex™ 7 | 18039818253 |
| Configure HPS Internal Oscillator as boot_clk source. Right now for non-secure boot, boot_clk is sourced from external oscillator (HPS_OSC_CLK) by default, it is required to Configure HPS Internal Oscillator as boot_clk source for non-secure boot. **Commit IDs:** 90fcd33585. | U-Boot | Agilex™ 5 | 15016500042 |
| SSGDMA: Defining callback information to be shared between netdriver and ssgdma driver. Netdriver and SSGDMA driver need to share certain information which are needed for cleanup information and further processing. This information  needs to be shared using the registered callback and its parameters. | Linux | Agilex™ 5 | 16025482961 |
| Query on how the DEVICE_PORTS_IRQ_STATUS IRQ bits are interpreted by the SSGDMA software. As per the channel allocation the order of registration is in the order of MM, H2D ST, D2H ST. While the device IRQ status is read in the reverse order  | Linux | Agilex™ 5 | 16025499228 |
| SSGDMA: SSGDMA driver need to call netdriver registered callback even on terminate all. Netdriver registers callback along with a structure. These structures are important to it for cleanup on transfer completions. In case interface is shutdown net driver is going to call the terminate all of dmaengine, ssgdma driver should call the callback for all the descriptors, for a respective channel so that net driver can free the used resources.  | Linux | Agilex™ 5 | 16025500389 |
| SSGDMA:Current SSGDMA driver have only one descriptor block, user should have the flexibility to configure the no of descriptor block. If not given by user it should have a default descriptor block. | Linux | Agilex™ 5 | 16025510775 |
| SSGDMA:D2H packets are not received after 1-2 initial startup packets. While the system is in loopback/Soc mode, HPS is sending packets, initial 1-2 packets are received, then reception stops. But we can observe from the Ethernet stat dump that the Ethernet HIP has sent and received the packets towards SSGDMA IP. | Linux | Agilex™ 5 | 16025872289 |
| SSGDMA: In SSGDMA driver the spin lock obtained is not released on certain condition. | Linux | Agilex™ 5 | 16025997698 |
| SSGDMA: watch dog error bit not cleared on error case. | Linux | Agilex™ 5 | 16025998365 |
| SSGDMA: Interrupt handling in SSGDMA driver to be in sync with the interrupt mechanism in RTL. | Linux | Agilex™ 5 | 16026031481 |
| SSGDMA: Understanding how circular data descriptor handled in corner case. | Linux | Agilex™ 5 | 16026078932 |
| NAND driver probe fail when SMMU is enabled. If SMMU is enabled, SMMU initialize all the peripherals that is using iommu property first and then only it initializes the DMA driver. NAND driver requires DMA channel, so if NAND driver gets probed first before DMA driver, it gets failed. **Commit IDs:** fc7e83f7779, 4f3a031fee. | Linux | Agilex™ 5 | 15016315059 |
| HW Monitor fails during first probe due to dependency on stratix10-svc. The first time it fails after requesting a SVC channel but since the SVC driver has not being initialized, it fails. The 2nd time is probed just after the SVC driver is initialized, which make sense since there is dependency on this. **Commit IDs:** 39c026e081 | Linux | Agilex™ 5<br> Agilex™ 7<br>Stratix® 10 | 15016809521 |
| 'Internal error: synchronous external abort' when running PR flow in Stratix® 10. **Commit IDs:** 4c792899c1 | Linux | Stratix® 10 | 16025442435 |
| Linux hangs while using FPGA-to-HPS free clock design. Workaround identified as 'clock freqency' field for f2s_free_clk node requires to be set in device tree.  | Linux | Agilex™ 5 | 16025571730 |
| Linux SPI is not initialized properly. The SPI device is not showing up on as a dev node upon Linux boot, therefore any read/write test to the EEPROM on Debug2 DC cannot be performed. **Commit IDs:** b771d376df | GSRD<br>meta-intel-fpga-refdes | Agilex™ 5 | 15015803992 |
| Enabled multilib support which enables arm32 compiled binaries to run on Agilex™ 5 Linux. **Commit IDs:** e2adf4f95d | GSRD<br>meta-intel-fpga-refdes | Agilex™ 5 | 15016662668 |
| Remove Agilex™ 7 pcie devkit from ghrd since is not fully tested (DK-DEV-AGF014E). **Commit IDs:** cc53536538 | GHRD | Agilex™ 7 | 15016584528 |
| Refactor DDR DBE Error recover. in the beginning of every u-boot power up, fsbl will directly send IOSSM mailbox cmd to IO96B to check the previous ECC interrupt status, to see if any un-correctable ECC error happened in the last run or not.  If any un-correctable ECC error reported before, U-Boot will trigger the watchdog reset immediately(with watchdog timer = 0)  and ddr_init_in_progress flag= 1(boot_scratch_por0 bit 0), so SDM will based on the dr_init_in_progress flag = 1 to do a fully DDR reconfig in the next boot up. **Commit IDs:** fc9a5c3829, 2576f9194e, 1a2a99825d | U-Boot | Agilex™ 5 | 15016811141 |
| GICv3 ITS MSIX Interrupt Failure. ITS unable to access physical memory larger than 32bits. MSI Controller GIC ITS is failing when configuring the ITS translation table descriptors base-address. The driver then fails and MSIX is not available for GHRD dev kit memory larger than 2GBytes. **Commit IDs:** 1de128905e, 88ade27b48. | Linux | Agilex™ 5 | 15016865391 |
| Observed ADMA error during Linux boot While running the stress test for 10,000 loops.  Sometimes it boots successfully with errors and other times the Linux boot fails due to ADMA errors. **Commit IDs:** b8f8efee6a. | Linux | Agilex™ 5 | 16025569613 |
| Linux fails with CDMA error during NAND boot. **Commit IDs:** 95b119faeae | U-Boot | Agilex™ 5 | 16025355060 |
| Adding dma-coherent properties for usb3.1 and usb2.0 node to align with other peripherals that support SMMU. **Commit IDs:** c1bb0f429f7, 27c2cfbe03). | U-Boot | Agilex™ 5 | 15016973702 |
| FGPA reconfig stress fail with smmu timeout: <br> [ 1512.278277] arm-smmu-v3 16000000.iommu: CMD_SYNC timeout at 0x000152ff [hwprod 0x00015300, hwcons 0x00014ec2]. **Commit IDs:** 22074dcf70, 76c67207ba. | ATF | Agilex™ 5 | 15016661952 |
| ghrd_timing.sdc should be removed from the repo, as top_level_sdc_template.sdc.terp regenerates ghrd_timing.sdc again for each build. **Commit IDs:** cc53536538. | GHRD | Agilex™ 5<br>Agilex™ 7<br>Stratix®10<br>Arria® 10<br>Cyclone® V | 15016951801 |
| ATF -> Linux direct boot flow missing core features (QSPI boot fails). Workaround for QSPI boot is supported changing QSPI clock from device tree to match ATF setting. | Linux | Agilex™ 7 | 14023675777  |
| Wrong OPN for Stratix® 10 H-Tile ghrd. | GHRD | Stratix® 10 | 15017053047 |
| Correct irq number for switch and button. Missmatch between GSRD dts and GHRD mismatch since 24.1. **Commit IDs:** cc53536538. | GHRD | Agilex™ 5 | 15016776737 |
| Create a SOF for Agilex™ 5 Power-optimized (A5ED013BB32AE4S) using GHRD releases/24.3.1 branch. **Commit IDs:** cc53536538 | GHRD | Agilex™ 5 | 15017041926 |
| ARM® Debugger issue on dangling data on Agilex™ 5 Devkits. Workaround provided by ARM®. Proper fix released on December 2024. | ARM® DS | Agilex™ 5 | 15015204245 |
| System hang when connecting to ARM® debugger when WDT is started. Workaround provided by ARM®. Proper fix released on December 2024. | ARM® DS | Agilex™ 5. | 15016155701 |
| After optimizing Agilex™ 7 build parameters in GHRD, all Makefile parameters are set to 0 by default. **Commit IDs:** cc53536538. | GHRD                           | Agilex™ 7 | 15017090354 |
| agilex5_soc_devkit_ghrd: fix debug_sof target. Fix the following issues: <br> * Update software/hps_debug/README.md to inform user about build.sh. <br> * Remove unnecessary SPL_DEBUG_GEN_HEX_DEPS, since some of the files in software/hps_debug are deleted.  **Commit IDs:** cc53536538 | GHRD | Agilex™ 5 | 15017105029 |
| U-Boot SPL fails to boot up using a 25MHz FPGA to HPS free clock. **Commit IDs:** cc53536538. | GHRD | Agilex™ 5 | 16025661525 |
| Cyclone® V build is failing, when not using the make all. | GHRD | Cyclone® V | 15017126716 |
| Remove a10_soc_devkit_ghrd_std for 24.3.1 release. **Commit IDs:** cc53536538 | GHRD | Arria® 10 | 15017098712 |
| NAND U-Boot boot with CDMA errors. NAND programming is failed on U-Boot. **Commit IDs:** 8a54beee59 | U-Boot | Agilex™ 5 | 16026119255  |
| Using customer reserved boot scratch register for Altera implementation and will impact SMP and Reset flow. Moved to use BS Cold6 to BS Cold 3. **Commit IDs:** 2d377eff73 | ATF | Agilex™ 5 | 15016770576 |
| Failing to trigger LED and response from interrupt switch in Agilex™ 7 I-Series dev kit. **Commit IDs:** cc53536538 | GHRD | Agilex™ 7 | 15016825669 |
| F2H bridge fails when phase 2 core.rbf is reconfigured.  If I reconfigure the core.rbf into the FPGA a second or more times, the F2H bridge does not function properly for me, my MSGDMA appears to lockup in the middle of its operation. **Commit IDs:** 76c67207ba, 22074dcf70 | ATF | Agilex™ 5 | 22019988055 |
| I3C Read/Write not enable in Uboot. Workaround identified updating command format. | U-Boot  | Agilex™ 5 | 15017051642  |
| I3C Read/Write not enable in Linux. Workaround identified.  | Linux | Agilex™ 5 | 16025990272 |
|  Failed to disable fpga bridge from U-Boot.<br> ERROR:   F2S bridge fpga handshake fpgahsack: Timeout. Message shouldn't be printed since bridge is enabled correctly. **Commit IDs:** 811674696d | ATF | Agilex™ 5 | 15017187240 |
| FGPA reconfig stress fail with handshake error. **Commit IDs:** d333ae629b. | ATF | Agilex™ 5 | 15017118837 |
| Correctable Error count didn't reflect the correct count for sbe with cram-seu. **Commit IDs:** 0cf70af8bb. | Linux | Agilex™ 5 | 15017110843 |
| RSU fails in U-BOOT in Agilex™ 5 24.2/24.3. Problem is related to cache flush in the smc_send_mailbox() function. **Commit IDs:** ec1389f80c8. | U-Boot | Agilex™ 5 | 14023661564 |
| Config1 TSN Ref App is failing on Modular Devkit when sending iperf3 command. **Commit IDs:** 09f6d1b19b. | GSRD<br>meta-intel-fpga-refdes | Agilex™ 5 | 15016982756 |
| With SiPv3, it  fails to fully execute FPGA overlay and eventually system hang/timeout. Interrupt design in SiPV3 is enabled, thus the V1 response is already captured by V3 framework before V1 able to execute the interrupt thus ended up V1 command does not service as expected. **Commit IDs:** ef74dadb1f1. | ATF | Agilex™ 5 | 15017218294 |
| Request to add devmem2 and core.rbf in sdcard image. **Commit IDs:** ecc1c20b1d | GSRD<br>meta-intel-fpga-refdes | Agilex™ 5 | 15016876378 |
| Yocto bitbake -c populate_sdk_ext fails for Agilex™ 5. Failed to compile Yocto ESDK due to llvm being generated by both llvm-native and clang-native. **Commit IDs:** fe73ac581a | GSRD<br>meta-intel-fpga-refdes| Agilex™ 5 | 15016897116 |
| TSN Config 2 requires new identifier in GHRD .qsf for u-boot. **Commit IDs:** cc53536538 | GHRD | Agilex™ 5 | 15017255211 |
| TSN Config 2 HPS Boot First Mode with prebuilt binaries fails to load FPGA configuration. **Commit IDs:** d12c079762 | GSRD<br>meta-intel-fpga-refdes | Agilex™ 5 | 16026336814 |
|  Multi domain CMLDS feature is not supported by ptp4l version 4.1. **Commit IDs:** 6a5b6566df | GSRD<br>meta-intel-fpga-refdes | Agilex™ 5 | 15016924883 |
| DomU is not able to boot up when doing USB passthrough. Fixed interrupt number in xen usb config file. | Linux | Agilex™ 7. | 15017182742 |
| During SPI test is observed a kernel panic on XEN boot up on Agilex™ 5 PDK DEBUG2 DC. **Commit IDs:** 7e7d3a6c00. | GSRD<br>meta-intel-fpga-refdes | Agilex™ 5 | 15017030889 |
| Syschk application shows inverted infromation for LED state. **Commit IDs:** 2510ae5e2e. | GSRD<br>meta-intel-fpga-refdes | Agilex™ 5 | 15017207499 |
| Unable to boot up to linux using sdimage. After request the FPGA configuration, it hangs for few minutes, after that is shows error msg which is error sending bitsream. **Commit IDs:** 92f2b9f2da0, dfe710310d | ATF | Agilex™ 5 | 15017245047 |
| FCS AES failure observed with ATF 2.11.1. **Commit IDs:** 0447da78ed| Linux | Agilex™5<br>Agilex™7 | 15017188058 |
| Unable to trigger LED using both Linux application and webpage in  Stratix® 10-H-Tile. **Commit IDs:** 3839795643 | GSRD<br>meta-intel-fpga-refdes  | Stratix®10 | 15016822238 |
| Unable to boot from SD Card using 23.1std. Fixed in GHRD build instructions. | GHRD | Cyclone® V | 16023469269 |
| Failure on all regtest for the ATF To Linux direct flow with ATF v2.11.1.  **Commit IDs:** 92f2b9f2da, dfe710310d. | ATF | Agilex™ 7 | 15017246958 |
| Unable to open '/dev/mtd0' [LOW] when running rsu_client in Linux in compatibility tests (Quartus® Pro 24.2, U-Boot 2024.07, ATF 2.11.1). Workaround identified and the test requires to change the size of SPTs and CPBs to 64 KBs hence the HPS software uses now this size. | Linux | Agilex™ 7 | 15017201028 |
| Response error (0x4) on FCS related test  in24.3.1 build. **Commit IDs:** fbf2b01a91. | ATF | Agilex™5<br/>Agilex™7 | 15017337830 |
| 24.1 ACDS test is failing during ECDSA Data Verify testing (linux/ci_linux_fcs_ecdsa_service_large_blob/agilex_atf) **Commit IDs:** 5a51126002 | Linux | Agilex™ 7 | 15015579133 |
| Linux RTC regtest failed due to ls: /dev/rtc0: No such file or directory. **Commit IDs:** 7f35bcee11. | Linux | Agilex™ 5 | 15016141215 |
| Agilex™ 5 does not boot up with Simics model 24.3.1. Fixing the issue by instead of binding the NAND device to mtd->dev->parent, register the device directly using mtd->dev. **Commit IDs:** 0dad0a0a47. | U-Boot | Agilex™ 5 | 15017189131 |

## Known Issues

| Issue | Component Affected | Scope <br> Device/Board | HSD <br> (Internal Use) |
| :-- | :-- | :-- | :-- |
| Linux SD Card driver relies on U-Boot SD Card initialization. This makes Linux can't used the SD Card if U-Boot didn't do an prior SD Card controller initialziation. | Linux | Agilex™7<br>Stratix® 10 | 14021514563 |
| EMMC fail on HS400 mode test on u-boot with return value -110. | Linux | Agilex™ 5 | 16025784408 |
| Link down and up consistently fails for the api call dmaengine_prep_slave_single (descriptor allocation is failing).  | Linux | Agilex™ 5 | 16026230660 |
| SSGDMA: Communication stalls after fast ping on overlay_4 image + ssgdma latest image. It's necessary to  Understand how responder descriptor are updated and if is there a possibility of descriptor skip. | Linux | Agilex™ 5 | 16026243142 |
| Unable to perform crypto test using fcs_client with large blob AES. | Linux | Agilex™ 7 | 15017351283 |


## Golden System Reference Design Documentation

Examples Reference designs for the Agilex™ 5, Agilex™ 7 and Stratix® 10 are located at the  [Altera FPGA Developer Site](https://altera-fpga.github.io/rel-24.3.1/).
For Arria® 10 and Cyclone® V devices, these reference designs are located at [RocketBoards](https://www.rocketboards.org/foswiki/Main/GettingStarted).

The GSRD (Golden System Reference Design) are documented in the following pages:

**Agilex™ 5**

* [Agilex™ 5 E-Series Premium Devkit GSRD](https://altera-fpga.github.io/rel-24.3.1/embedded-designs/agilex-5/e-series/premium/gsrd/ug-gsrd-agx5e-premium/)
* [Agilex™ 5 E-Series Modular Devkit GSRD](https://altera-fpga.github.io/rel-24.3.1/embedded-designs/agilex-5/e-series/modular/gsrd/ug-gsrd-agx5e-modular/)
* [Agilex™ 5 E-Series Premium Development Kit Zephyr GSRD User Guide](https://altera-fpga.github.io/rel-24.3.1/embedded-designs/agilex-5/e-series/premium/gsrd_zephyr/ug-zgsrd-agx5e-premium/)
* [Agilex™ 5 Intel Simics Virtual Platform Example User Guide - Linux GSRD](https://altera-fpga.github.io/rel-24.3.1/embedded-designs/agilex-5/common/virtual-platforms/linux-gsrd/ug-linux-gsrd-agilex5-virtual-platforms/)
* [Agilex™ 5 Intel Simics Virtual Platform Example User Guide - Zephyr GSRD](https://altera-fpga.github.io/rel-24.3.1/embedded-designs/agilex-5/common/virtual-platforms/zephyr-gsrd/ug-zephyr-gsrd-agilex5-virtual-platforms/)



**Agilex™ 7**

* [Agilex™ 7 F-Series SoC Development Kit GSRD User Guide (P-Tiles & E-Tiles)](https://altera-fpga.github.io/rel-24.3.1/embedded-designs/agilex-7/f-series/soc/gsrd/ug-gsrd-agx7f-soc/)
* [Agilex™ 7 I-Series FPGA Development Kit GSRD User Guide](https://altera-fpga.github.io/rel-24.3.1/embedded-designs/agilex-7/i-series/soc/gsrd/ug-gsrd-agx7i-soc/)
* [Agilex™ 7 M-Series HBM2e Development Kit GSRD User Guide](https://altera-fpga.github.io/rel-24.3.1/embedded-designs/agilex-7/m-series/hbm2e/ug-gsrd-agx7m-hbm2e/)
* [Agilex™ 7 F-Series FPGA Development Kit GSRD User Guide (2x F-Tile)](https://altera-fpga.github.io/rel-24.3.1/embedded-designs/agilex-7/f-series/fpga/gsrd/ug-gsrd-agx7f-fpga)



**Stratix® 10**

* [Stratix® 10 SX (H-Tile) SoC Development Kit GSRD User Guide](https://altera-fpga.github.io/rel-24.3.1/embedded-designs/stratix-10/sx/soc/gsrd/ug-gsrd-s10sx-soc/)

**Cyclone® V**
* [Cyclone® V SoC GSRD](https://www.rocketboards.org/foswiki/Documentation/CycloneVSoCGSRD)

**Arria® 10**

* [Arria® 10 SoC GSRD](https://www.rocketboards.org/foswiki/Documentation/Arria10SoCGSRD)



## Release Strategy

The HPS Embedded software releases for Intel FPGA devices are aligned with Quartus® releases and are scheduled as follows:

* **Quartus® Standard (STD):** 1 release per year. This is a binary release.
* **Quartus® Pro (PRO):** 4 releases per year, one each quarter. Some of these are **Major** release which affects most of the devices while **Minor** releases are released as needed and affect few devices.  

Embedded software releases can also be classified as **Source code** or **Binary** releases. A **Source code** release involve releasing only the source code in the software repositories.  A **Binary** release consists of a source code release + pre-built binaries that could be loaded directly into the development kits.

Note: To review the Release Notes prior 24.3.1 release please refer to teh following link: https://www.rocketboards.org/foswiki/Documentation/IntelFPGAHPSEmbeddedSoftwareRelease.
