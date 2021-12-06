#!/bin/bash -e

environment_setup() {
	arg0=$0
	filename="${arg0##*/}"
	target=${filename%-*}
	if [ -n "${target}" -a "${target}" != "${filename}" ]; then
		MACHINE=${target}
	fi
	if [ -z "${MACHINE}" ]; then
		echo "MACHINE must be set before sourcing this script"
		return
	fi
	export $MACHINE
	echo "[INFO] MACHINE selected for the build: $MACHINE"
	
	WORKSPACE=$(dirname "$(readlink -f "$0")")
	echo "[INFO] Build location is $WORKSPACE"
	if [ ! -d "$WORKSPACE" ]; then
		mkdir $WORKSPACE
	fi
	
	#------------------------------------------------------------------------------------------#
	# Set default Linux, U-Boot, and ATF variant
	#------------------------------------------------------------------------------------------#
	#  Description:
	#  If were to build a specific version of Linux Kernel, U-boot or ATF,
	#  uncomment/define the following variables else leave them as commented lines to build latest release:
	#  For Linux kernel:
	#		LINUX_VER=<Linux kernel version for build> choose from: 5.10.60 (for GSRD 21.3 release)
	#  		LINUX_SOCFPGA_BRANCH=socfpga-$LINUX_VER-lts  Uncomment this line and keep the default value unchanged.
	#  For Uboot:
	#  		UBOOT_VER=<Uboot version for build> choose from: v2021.07 (for GSRD 21.3 release).
	#  For arm-trusted-firmware:
	#      ATF_VER=<ATF version for build> choose from: 2.5.0 (for GSRD 21.3 release).
	#
	#LINUX_VER=5.10.60
	#UBOOT_VER=v2021.07
	#ATF_VER=v2.5.0

	#------------------------------------------------------------------------------------------#
	# Set default IMAGE variant 
	#------------------------------------------------------------------------------------------#
	# Set default variant to build gsrd if "-i" argument is empty
	#
	# 	Agilex variant: gsrd [ sgmii + pr + qspi ]
	# 	Stratix10 variant: gsrd [ sgmii + pcie + pr + qspi ]
	# 	Arria10 variant: gsrd, qspi, nand, pcie, pr, sgmii, tse
	# 	Cyclone5 variant: gsrd
	#
	#------------------------------------------------------------------------------------------#
	if [[ "$MACHINE" == "agilex" || "$MACHINE" == "stratix10" || "$MACHINE" == "cyclone5" || -z $IMAGE ]]; then
		IMAGE="gsrd"
	fi
	echo "[INFO] Variant selected for the build: $IMAGE"

	#------------------------------------------------------------------------------------------#
	# Set default UB_CONFIG for each of the configurations
	#------------------------------------------------------------------------------------------#
	# 					For Agilex and Stratix10:
	# U-Boot version ≥ v2021.07 : Uses same defconfig naming convention
	#		  Yocto							U-Boot
	#	$MACHINE-socdk-atf		-> socfpga_$MACHINE_defconfig
	#	$MACHINE-socdk-qspi-atf -> socfpga_$MACHINE_defconfig
	#
	# U-Boot version < v2021.07 : Uses diffrernt defconfig naming convention
	#		  Yocto							U-Boot
	#	$MACHINE-socdk-atf		-> socfpga_$MACHINE_atf_defconfig
	#	$MACHINE-socdk-qspi-atf	-> socfpga_$MACHINE_qspi_atf_defconfig
	#------------------------------------------------------------------------------------------#
	if [[ "$MACHINE" == "agilex" || "$MACHINE" == "stratix10" ]]; then
			UB_CONFIG="$MACHINE-socdk-atf"
	elif [[ "$MACHINE" == "arria10" || "$MACHINE" == "cyclone5" ]]; then
		if [[ "$IMAGE" == "nand" || "$IMAGE" == "qspi" ]]; then
			UB_CONFIG="$MACHINE-socdk-$IMAGE"
		else
			UB_CONFIG="$MACHINE-socdk"
		fi
	fi
	echo "[INFO] U-boot config selected for the build: $UB_CONFIG"
}

usage() {
cat <<EOF

#-----------------------------#
#          USAGE NOTE         #
#-----------------------------#
This script builds a Reference Linux distribution for Intel SoCFPGA.
This script was written to parse its MACHINE variables from the script file name.
Please make sure you ran the correct script that associated to the FPGA device name.

For Agilex: use agilex-build.sh
For Stratix10: use stratix10-build.sh
For Arria10: use arria10-build.sh
For Cyclone5: use cyclone5-build.sh

Example command to use:
$ ./agilex-build.sh

NOTE: This script uses Poky as the reference distribution of Yocto Project

NOTE: There are a few GSRD variants supported. To build specific GSRD variant,
      use the following optional flag (-i) to select the variant desired.
      List of supported variant: gsrd, nand, pcie, pr, qspi, sgmii, tse
      Default variant: gsrd

Example: $ ./agilex-build.sh -i pcie

EOF
}

#------------------------------------------------------------------------------------------#
# Ensures that no other bitbake is running, otherwise sleep for a random time and try again
#------------------------------------------------------------------------------------------#
sanity_bitbake() {
while true; do
	BITBAKE_PROCESS_RUNNING=`ps aux | grep bitbake | wc -l`
	if [ $BITBAKE_PROCESS_RUNNING -eq 1 ]; then
		break;
	else
		echo -e "\n[INFO] There is already an instance of bitbake process running in the background. Waiting.."
		sleep `expr $RANDOM % 30`
	fi
done
}

#------------------------------------------------------------------------------------------#
# Clean up the build workspace for subsequent build to happen smoothly
#------------------------------------------------------------------------------------------#
environment_cleanup() {
	if [ -d "$WORKSPACE" ]; then
		echo -e "\n[INFO] Cleanup the /tmp, /conf folders in the workspace for next build"
		pushd $WORKSPACE > /dev/null
			rm -rf $MACHINE-$IMAGE-rootfs/tmp/
			rm -rf $MACHINE-$IMAGE-rootfs/conf/

			if [ -d $MACHINE-$IMAGE-images ]; then
				echo "[INFO] Cleanup images folder in the workspace for next build"
				rm -rf $MACHINE-$IMAGE-images
			fi
		popd > /dev/null
	fi

	if [ ! -d $WORKSPACE/$MACHINE-$IMAGE-rootfs ]; then
		echo -e "\n[INFO] Create build workspace"
		mkdir -p $WORKSPACE/$MACHINE-$IMAGE-rootfs
	fi
	
	if [ ! -d $WORKSPACE/$MACHINE-$IMAGE-images ]; then
		echo -e "\n[INFO] Create image staging area"
		mkdir -p $WORKSPACE/$MACHINE-$IMAGE-images
	fi
	
	STAGING_FOLDER=$WORKSPACE/$MACHINE-$IMAGE-images
}

#------------------------------------------------------------------------------------------#
# Get build components version informations
#------------------------------------------------------------------------------------------#
get_version_info() {
	echo -e "\n[INFO] Selected ingredient versions for this build"

	[ -d "$WORKSPACE/meta-intel-fpga" ] && pushd meta-intel-fpga > /dev/null

	# LINUX
	if [ -z $LINUX_VER ]; then
		LINUX_BB="$(find * -name linux-socfpga-lts*.bb | sort -n | head -n1)"
		grep -Fw LINUX_VERSION\ \= $LINUX_BB
		LINUX_VER=$(grep -Fw LINUX_VERSION\ \= $LINUX_BB | cut -d'"' -f2)
	else
		echo "LINUX_VERSION = $LINUX_VER"
	fi
	LINUX_SOCFPGA_BRANCH=socfpga-$LINUX_VER-lts
	echo "LINUX_SOCFPGA_BRANCH = $LINUX_SOCFPGA_BRANCH"

	# U-BOOT
	if [ -z $UBOOT_VER ]; then
		UBOOT_BB="$(find * -name u-boot-socfpga*.bb | sort -nr | head -n1)"
		grep -Fw UBOOT_VERSION\ \= $UBOOT_BB
		UBOOT_VER=$(grep -Fw UBOOT_VERSION\ \= $UBOOT_BB | cut -d'"' -f2 | cut -d'_' -f1)
		if [ "$UBOOT_VER" == *"_RC"* ]; then
			UBOOT_REL="_$(grep -Fw UBOOT_VERSION\ \= $UBOOT_BB | cut -d'"' -f2 | cut -d'_' -f2)"
		fi
	else
		if [ "$UBOOT_VER" == *"_RC"* ]; then
			UBOOT_VER=$(`cut -d'_' -f1` <<< "$UBOOT_VER")
			UBOOT_REL="_$(grep -Fw UBOOT_VERSION\ \= $UBOOT_BB | cut -d'"' -f2 | cut -d'_' -f2)"
		fi
		echo "UBOOT_VERSION = $UBOOT_VER$UBOOT_REL"
	fi
	UBOOT_SOCFGPA_BRANCH=socfpga_$UBOOT_VER$UBOOT_REL
	echo "UBOOT_SOCFGPA_BRANCH = $UBOOT_SOCFGPA_BRANCH"

	# ATF
	if [ -z $ATF_VER ]; then
		ATF_BB="$(find * -name arm-trusted-firmware*.bb | sort -nr | head -n1)"
		grep -Fw ATF_VERSION\ \= $ATF_BB
		ATF_VER=$(grep -Fw ATF_VERSION\ \= $ATF_BB | cut -d'"' -f2)
	else
		echo "ATF_VERSION = $ATF_VER"
	fi
	ATF_BRANCH=socfpga_$ATF_VER
	echo "ATF_BRANCH = $ATF_BRANCH"

	[ -d "$WORKSPACE/meta-intel-fpga" ] && popd > /dev/null

	# Pause for 5 seconds for user to view the versions
	sleep 5
}

#------------------------------------------------------------------------------------------#
# Update existing meta layers or clone a new one if it does not exists
#------------------------------------------------------------------------------------------#
get_meta() {
	pushd $WORKSPACE > /dev/null
		# Update submodules
		git submodule update --init --remote -r
		get_version_info
	popd > /dev/null
}

yocto_build_setup() {
	pushd $WORKSPACE > /dev/null
		
		# Setup Poky build environment
		echo -e "\n[INFO] Source poky/oe-init-build-env to initialize poky build environment"
		source poky/oe-init-build-env $WORKSPACE/$MACHINE-$IMAGE-rootfs/

		# Settings for bblayers.conf
		echo -e "\n[INFO] Update bblayers.conf"
		bitbake-layers add-layer ../meta-intel-fpga
		bitbake-layers add-layer ../meta-intel-fpga-refdes
		bitbake-layers add-layer ../meta-openembedded/meta-oe
		bitbake-layers add-layer ../meta-openembedded/meta-python
		bitbake-layers add-layer ../meta-openembedded/meta-networking

		# Show layers for checking purposes
		echo -e "\n"
		bitbake-layers show-layers
		sleep 5
		echo -e "\n"

		# Settings for local.conf
		echo -e "\n[INFO] Update local.conf"
		sed -i /MACHINE/d conf/local.conf
		sed -i /UBOOT_CONFIG/d conf/local.conf
		sed -i /IMAGE\_TYPE/d conf/local.conf
		sed -i /SRC\_URI\_/d conf/local.conf

		echo "MACHINE = \"$MACHINE\"" >> conf/local.conf
		echo "DL_DIR = \"$WORKSPACE/downloads\"" >> conf/local.conf
		echo "SSTATE_DIR ?= \"$WORKSPACE/state_cache\"" >> conf/local.conf
		echo "IMAGE_TYPE:${MACHINE} = \"$IMAGE\"" >> conf/local.conf
		echo 'DISTRO_FEATURES:append = " systemd"' >> conf/local.conf
		echo 'VIRTUAL-RUNTIME_init_manager = "systemd"' >> conf/local.conf
		echo "require conf/machine/$MACHINE-gsrd.conf" >> conf/local.conf
		# Linux
		echo 'PREFERRED_PROVIDER_virtual/kernel = "linux-socfpga-lts"' >> conf/local.conf
		echo "PREFERRED_VERSION_linux-socfpga-lts = \"$LINUX_VER%\"" >> conf/local.conf
		# U-boot
		echo 'PREFERRED_PROVIDER_virtual/bootloader = "u-boot-socfpga"' >> conf/local.conf
		echo "UBOOT_CONFIG:${MACHINE} = \"$UB_CONFIG\"" >> conf/local.conf
		echo "PREFERRED_VERSION_u-boot-socfpga = \"$UBOOT_VER%\"" >> conf/local.conf
		# ATF
		if [ ! -z $ATF_VER ]; then
			echo "PREFERRED_VERSION_arm-trusted-firmware = \"`cut -d. -f1-2 <<< "$ATF_VER"`\"" >> conf/local.conf
		fi
	popd > /dev/null
}

build_linux_distro() {
	pushd $WORKSPACE/$MACHINE-$IMAGE-rootfs > /dev/null
		echo -e "\n[INFO] Clean up previous kernel build if any"
		bitbake virtual/kernel -c cleanall
		echo -e "\n[INFO] Clean up previous u-boot build if any"
		bitbake u-boot-socfpga -c cleanall
		echo -e "\n[INFO] Clean up previous ghrd build if any"
		bitbake hw-ref-design -c cleanall

		echo -e "\n[INFO] Start bitbake process for target config.."
		bitbake console-image-minimal gsrd-console-image 2>&1
		if [ "$MACHINE" == "arria10" ]; then
			bitbake xvfb-console-image 2>&1
		fi
	popd > /dev/null
}

packaging() {
	echo -e "\n[INFO] Copy the build output and store in $STAGING_FOLDER"
	pushd $WORKSPACE/$MACHINE-$IMAGE-rootfs/tmp/deploy/images/$MACHINE/ > /dev/null

		cp -vrL *-$MACHINE.tar.gz $STAGING_FOLDER/	|| echo "[INFO] No tar.gz found."
		cp -vrL *-$MACHINE.jffs2 $STAGING_FOLDER/	|| echo "[INFO] No jffs2 found."
		cp -vrL *-$MACHINE.wic $STAGING_FOLDER/		|| echo "[INFO] No wic found."
		cp -vrL *-$MACHINE.ubifs $STAGING_FOLDER/	|| echo "[INFO] No ubifs found."
		
		# Generate sdimage.tar.gz
		pushd $STAGING_FOLDER
			tar cvzf sdimage.tar.gz gsrd-console-image-$MACHINE.wic
			md5sum sdimage.tar.gz > sdimage.tar.gz.md5sum
			xz --best console-image-minimal-$MACHINE.wic
			if [ "$MACHINE" == "arria10" ]; then
				xz --best xvfb-console-image-$MACHINE.wic
			fi
		popd

		cp -vrL zImage $STAGING_FOLDER/			|| echo "[INFO] No zImage found."
		cp -vrL Image $STAGING_FOLDER/			|| echo "[INFO] No Image found."

		if [ "$MACHINE" == "arria10" ]; then
			cp -vrL *.itb $STAGING_FOLDER/		|| echo "[INFO] No .itb file found."
		else
			cp -vrL kernel.* $STAGING_FOLDER/	|| echo "[INFO] No .itb file found."
		fi

		cp -vrL *.dtb $STAGING_FOLDER/	|| echo "[INFO] No dtb found."
		if [[ "$MACHINE" == "arria10" && "$IMAGE" == "nand" ]]; then
			cp -vrL socfpga_arria10_socdk_nand.dtb $STAGING_FOLDER/		|| echo "[INFO] No dtb found."
		elif [[ "$MACHINE" == "arria10" && "$IMAGE" == "qspi" ]]; then
			cp -vrL socfpga_arria10_socdk_qspi.dtb $STAGING_FOLDER/		|| echo "[INFO] No dtb found."
		fi
	popd > /dev/null

	if [[ "$MACHINE" == "agilex" || "$MACHINE" == "stratix10" ]]; then
		mkdir -p $STAGING_FOLDER/u-boot-$MACHINE-socdk-$IMAGE-atf
		ub_cp_destination=$STAGING_FOLDER/u-boot-$MACHINE-socdk-$IMAGE-atf
	elif [[ "$MACHINE" == "arria10" || "$MACHINE" == "cyclone5" ]]; then
		mkdir -p $STAGING_FOLDER/u-boot-$MACHINE-socdk-$IMAGE
		ub_cp_destination=$STAGING_FOLDER/u-boot-$MACHINE-socdk-$IMAGE
	fi
	
	if [[ "$MACHINE" == "agilex" || "$MACHINE" == "stratix10" ]] ; then
		pushd $WORKSPACE/$MACHINE-$IMAGE-rootfs/tmp/work/$MACHINE-poky-*/u-boot-socfpga/1_v20*/build/socfpga_${MACHINE}_defconfig/
	elif [[ "$MACHINE" == "arria10" || "$MACHINE" == "cyclone5" ]] ; then
		if [[ "$IMAGE" == "nand" || "$IMAGE" == "qspi" ]] ; then
			pushd $WORKSPACE/$MACHINE-$IMAGE-rootfs/tmp/work/$MACHINE-poky-*/u-boot-socfpga/1_v20*/build/socfpga_${MACHINE}_${IMAGE}_defconfig/
		else
			pushd $WORKSPACE/$MACHINE-$IMAGE-rootfs/tmp/work/$MACHINE-poky-*/u-boot-socfpga/1_v20*/build/socfpga_${MACHINE}_defconfig/
		fi
	fi
		cp -vL u-boot $ub_cp_destination
		cp -vL u-boot-dtb.bin $ub_cp_destination
		cp -vL u-boot-dtb.img $ub_cp_destination
		cp -vL u-boot.dtb $ub_cp_destination
		cp -vL u-boot.img $ub_cp_destination
		cp -vL u-boot.map $ub_cp_destination
		cp -vL spl/u-boot-spl $ub_cp_destination
		cp -vL spl/u-boot-spl-dtb.bin $ub_cp_destination
		cp -vL spl/u-boot-spl.dtb $ub_cp_destination
		cp -vL spl/u-boot-spl.map $ub_cp_destination

		if [[ "$MACHINE" == "agilex" || "$MACHINE" == "stratix10" ]]; then
			cp -vL spl/u-boot-spl-dtb.hex $ub_cp_destination
			cp -vL u-boot.itb $ub_cp_destination
		elif [[ "$MACHINE" == "cyclone5" || "$MACHINE" == "arria10" ]]; then
			cp -vL spl/u-boot-spl.sfp $ub_cp_destination
			cp -vL spl/u-boot-splx4.sfp $ub_cp_destination
		fi

		if [ "$MACHINE" == "cyclone5" ]; then
			cp -vL u-boot-with-spl.sfp $ub_cp_destination
		fi
	popd > /dev/null

	pushd $ub_cp_destination > /dev/null
		chmod 644 u-boot-dtb.img
		chmod 644 u-boot.img
		chmod 744 u-boot.itb || echo "[INFO] File u-boot.itb not found for this build configuration."
	popd > /dev/null

	# Copy u-boot script to u-boot staging folder
	pushd $WORKSPACE/$MACHINE-$IMAGE-rootfs/tmp/deploy/images/$MACHINE/ > /dev/null
		if [[ "$MACHINE" == "agilex" || "$MACHINE" == "stratix10" ]]; then
			cp -vL u-boot.txt $ub_cp_destination
			cp -vL boot.scr.uimg $ub_cp_destination
		elif [[ "$MACHINE" == "arria10" && "$IMAGE" == "pr" ]]; then
			cp -vL u-boot.txt $ub_cp_destination
			cp -vL boot.scr $ub_cp_destination
		elif [ "$MACHINE" == "cyclone5" ]; then
			cp -vL u-boot.txt $ub_cp_destination
			cp -vL u-boot.scr $ub_cp_destination
		fi
	popd > /dev/null

	pushd $WORKSPACE/$MACHINE-$IMAGE-rootfs/tmp/deploy/images/$MACHINE > /dev/null
		if [[ "$MACHINE" == "arria10" || "$MACHINE" == "cyclone5" ]]; then
			cp -vL extlinux.conf $STAGING_FOLDER
		fi
		cp -vrL ${MACHINE}_${IMAGE}_ghrd/ $STAGING_FOLDER/.
	popd > /dev/null
}

while [ "$1" != "" ]; do
	case $1 in
		-i | --image )
			shift
			IMAGE=$1
			;;
		-h | --help )
			usage
			exit 1
			;;
		* )
			usage
			exit 1
			;;
	esac
	shift
done
	
environment_setup
sanity_bitbake
environment_cleanup
get_meta
yocto_build_setup
build_linux_distro
packaging

exit 0
