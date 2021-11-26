#!/bin/bash -e

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

#  Description:
#  YOCTO_BRANCH=<Yocto Project version for build> choose from: hardknott, honister.
#  Default: honister. For GSRD 21.3: honister
YOCTO_BRANCH=honister
META_INTEL_FPGA_BRANCH=honister
META_INTEL_FPGA_REFDES_BRANCH=honister

#  Description:
#  If were to build a specific version of Linux Kernel, U-boot or ATF,
#  uncomment/define the following variables else leave them as commented lines to build latest release:
#  For Linux kernel:
#	LINUX_VER=<Linux kernel version for build> choose from: 5.10.60 (for GSRD 21.3 release)
#  	LINUX_SOCFPGA_BRANCH=socfpga-$LINUX_VER-lts  Uncomment this line and keep the default value unchanged.
#  For Uboot:
#  	UBOOT_VER=<Uboot version for build> choose from: v2021.07 (for GSRD 21.3 release).
#  For arm-trusted-firmware:
#      ATF_VER=<ATF version for build> choose from: 2.5.0 (for GSRD 21.3 release).
#
#LINUX_VER=5.10.60
#UBOOT_VER=v2021.07
#ATF_VER=v2.5.0

usage() {
cat <<EOF

####################################
#            USAGE NOTE            #
###################################
This script builds a Reference Linux distribution for Intel SoCFPGA.
This script was written to parse its MACHINE variables from the script file name.
Please make sure you ran the correct script that associated to the FPGA device name.

For Agilex: use agilex-build.sh
For Stratix10: use stratix10-build.sh
For Arria10: use arria10-build.sh
For Cyclone5: use cyclone5-build.sh

Example command to use:
$ ./agilex-build.sh

NOTE: This script uses Poky as the reference distribution of Yocto Project version ($YOCTO_BRANCH)

NOTE: There are a few GSRD variants supported. To build specific GSRD variant,
      use the following optional flag (-i) to select the variant desired.
      List of supported variant: gsrd, nand, pcie, pr, qspi, sgmii, tse
      Default variant: gsrd

Example: $ ./agilex-build.sh -i pcie

EOF
}

# Ensures that no other bitbake is running, otherwise sleep for a random time and try again
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

# Clean up the build workspace for subsequent build to happen smoothly
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
}

get_version_info() {
	echo -e "\n[INFO] Selected ingredient versions for this build"

	[ -d "$WORKSPACE/meta-intel-fpga" ] && pushd meta-intel-fpga > /dev/null

	if [ -z $LINUX_VER ]; then
		LINUX_BB="$(find * -name linux-socfpga-lts*.bb | sort -n | head -n1)"
		grep -Fw LINUX_VERSION\ \= $LINUX_BB
		LINUX_VER=$(grep -Fw LINUX_VERSION\ \= $LINUX_BB | cut -d'"' -f2)
	else
		echo "LINUX_VERSION = $LINUX_VER"
	fi
	LINUX_SOCFPGA_BRANCH=socfpga-$LINUX_VER-lts
	echo "LINUX_SOCFPGA_BRANCH = $LINUX_SOCFPGA_BRANCH"

	if [ -z $UBOOT_VER ]; then
		UBOOT_BB="$(find * -name u-boot-socfpga*.bb | sort -nr | head -n1)"
		grep -Fw UBOOT_VERSION\ \= $UBOOT_BB
		UBOOT_VER=$(grep -Fw UBOOT_VERSION\ \= $UBOOT_BB | cut -d'"' -f2 | cut -d'_' -f1)
		UBOOT_REL="_$(grep -Fw UBOOT_VERSION\ \= $UBOOT_BB | cut -d'"' -f2 | cut -d'_' -f2)"
	else
		if [ "$UBOOT_VER" == *"_RC"* ]; then
			UBOOT_VER=$(`cut -d'_' -f1` <<< "$UBOOT_VER")
			UBOOT_REL="_RC"
		fi
		echo "UBOOT_VERSION = $UBOOT_VER$UBOOT_REL"
	fi
	UBOOT_SOCFGPA_BRANCH=socfpga_$UBOOT_VER$UBOOT_REL
	echo "UBOOT_SOCFGPA_BRANCH = $UBOOT_SOCFGPA_BRANCH"

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

# Update existing meta layers or clone a new one if it does not exists
get_meta() {
	pushd $WORKSPACE > /dev/null
		# Update submodules
		git submodule update --remote -r
		get_version_info
	popd > /dev/null
}

yocto_build_setup() {
	pushd $WORKSPACE > /dev/null
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
		echo "IMAGE_TYPE:${MACHINE} = \"$IMAGE\"" >> conf/local.conf
		echo 'DISTRO_FEATURES:append = " systemd"' >> conf/local.conf
		echo 'VIRTUAL-RUNTIME_init_manager = "systemd"' >> conf/local.conf
		echo "require conf/machine/$MACHINE-gsrd.conf" >> conf/local.conf
		# Linux
		echo 'PREFERRED_PROVIDER_virtual/kernel = "linux-socfpga-lts"' >> conf/local.conf
		if [ ! -z $LINUX_VER ]; then
			echo "PREFERRED_VERSION_linux-socfpga-lts = \"`cut -d. -f1-2 <<< "$LINUX_VER"`%\"" >> conf/local.conf
		fi
		# U-boot
		echo 'PREFERRED_PROVIDER_virtual/bootloader = "u-boot-socfpga"' >> conf/local.conf
		echo "UBOOT_CONFIG:${MACHINE} = \"$UB_CONFIG\"" >> conf/local.conf
		if [ ! -z $UBOOT_VER ]; then
			echo "PREFERRED_VERSION_u-boot-socfpga = \"$UBOOT_VER%\"" >> conf/local.conf
		fi
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

echo "[INFO] MACHINE selected for the build: $MACHINE"

WORKSPACE=$(dirname "$(readlink -f "$0")")
echo "[INFO] Build location is $WORKSPACE"
if [ ! -d "$WORKSPACE" ]; then
	mkdir $WORKSPACE
fi

# Set default variant to gsrd for stratix10 and agilex
# Set default variant to build gsrd if "-i" argument is empty
if [[ "$MACHINE" == "agilex" || "$MACHINE" == "stratix10" ]]; then
		IMAGE="gsrd"
elif [ -z $IMAGE ]; then
		IMAGE="gsrd"
fi
echo "[INFO] Variant selected for the build: $IMAGE"

# Set default UB_CONFIG for each of the configurations
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

sanity_bitbake
environment_cleanup
get_meta
yocto_build_setup
build_linux_distro

exit 0
