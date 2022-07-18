# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="5"

DESCRIPTION="A script to switch tablet mode based on Detachable Device Emulator Kernel Driver"
HOMEPAGE="http://fydeos.com"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND=""

DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	# the detachable_emulator driver was compiled into kernel
	# project-surface:
	#	sys-kernel/chromeos-kernel-5_10/files/019-docker-mode-driver.patch
	#	sys-kernel/chromeos-kernel-4_19/files/019-docker-mode-driver.patch
	# and `CONFIG_USB_KBD_DOCKER_EMULATOR` in kconfig file of every overlay
	# surface-pro3, 4, 5, 6, 7 and surface-go3
	exeinto /lib/udev
	doexe ${FILESDIR}/switch_tablet_mode.sh
}
