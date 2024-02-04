# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="7"
EGIT_REPO_URI="git@gitlab.fydeos.xyz:misc/detachable_emulator.git"
EGIT_BRANCH="master"

inherit git-r3 linux-info linux-mod

DESCRIPTION="Detachable Device Emulator Kernel Driver"
HOMEPAGE="http://fydeos.com"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="kernel-4_14 kernel-5_4 kernel-5_10 kernel-4_19 kernel-surface-4_19 clang"

RDEPEND=""

DEPEND="${RDEPEND}"
MODULE_NAMES="fyde-vdtb(kernel/drivers/input)"

pkg_setup() {
	export KV_OUT_DIR=${ROOT}usr/src/linux
	# export KBUILD_OUTPUT=${ROOT}usr/src/linux
	#  linux-info_get_any_version
	use kernel-4_14 && export KERNEL_DIR="/mnt/host/source/src/third_party/kernel/v4.14"
	use kernel-5_4 && export KERNEL_DIR="/mnt/host/source/src/third_party/kernel/v5.4"
	use kernel-5_10 && export KERNEL_DIR="/mnt/host/source/src/third_party/kernel/v5.10"
	use kernel-4_19 && export KERNEL_DIR="/mnt/host/source/src/third_party/kernel/v4.19"
	use kernel-surface-4_19 && KERNEL_DIR="/mnt/host/source/src/third_party/kernel/v4.19-surface"

	local TEMP_KERNEL_DIR="${T}/kernel/$(basename ${KERNEL_DIR})"
	git clone -s "$KERNEL_DIR" "$TEMP_KERNEL_DIR" || die "Failed to clone kernel to temporary directory $TEMP_KERNEL_DIR"
	# if use kernel-4_19; then
	# upgrade chromeos-kernel-4_19 in r102, no need to checkout old revision
	# 	# for surface-pro3, 4, 5, 6. v14.1 release
	# 	git -C "$TEMP_KERNEL_DIR" checkout f85a69d601ba9f66b60eb13d377e1b193f2c08a7 || die "Unable to checkout"
	# if use kernel-5_10; then
		# for surface-pro7. v14.1 release
		# git -C "$TEMP_KERNEL_DIR" checkout bca20254cbdceec0704062c4117fbf415db42cf9 || die "Unable to checkout"
	# fi
	export KERNEL_DIR="${TEMP_KERNEL_DIR}"

	if [ -r $KV_OUT_DIR/source ]; then
		rm $KV_OUT_DIR/source
		ln -f -s $KERNEL_DIR $KV_OUT_DIR/source
	fi

	#  if [ ! -r ${ROOT}/lib/modules/${KV_FULL}/source ]; then
	#    ln -f -s $KERNEL_DIR ${ROOT}/lib/modules/${KV_FULL}/source
	#  fi
	#  ln -f -s $KERNEL_DIR ${ROOT}/usr/src/linux
	linux-mod_pkg_setup
	einfo "Edit $KV_OUT_DIR/Makefile"
	sed -i -e "s|^MAKEARGS := -C.*|MAKEARGS := -C ${KERNEL_DIR}|" $KV_OUT_DIR/Makefile
	sed -i -e "s|^include.*$|include ${KERNEL_DIR}/Makefile|" $KV_OUT_DIR/Makefile
	#BUILD_PARAMS="-C ${KERNEL_DIR} -I${KBUILD_OUTPUT} O=${KBUILD_OUTPUT} M=${S}"
	einfo "Edit $KERNEL_DIR/Makefile"
	sed -i -e "s|^HOST_LIBELF_LIBS = \$(shell pkg-config.*$|HOST_LIBELF_LIBS = \$(shell \"pkg-config libelf --libs 2>/dev/null \"\|\| echo -lelf)|" $KERNEL_DIR/Makefile
	if use clang; then
		export LLVM=llvm
	else
		cros_use_gcc
	fi
}

src_compile() {
	unset ARCH
	tc-export PKG_CONFIG
	if use clang; then
		export PATH=/usr/bin:$PATH
	fi
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
	exeinto /lib/udev
	doexe ${FILESDIR}/switch_tablet_mode.sh
	insinto /etc/init
	doins ${FILESDIR}/load-vdtb-module.conf
}
