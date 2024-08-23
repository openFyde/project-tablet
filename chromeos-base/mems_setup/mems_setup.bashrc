cros_pre_src_prepare_tablet_patches() {
  if [ ${PV} == '9999' ]; then
    return
  fi
  eapply ${TABLET_BASHRC_FILESDIR}/add_fydetab_support.patch
	eapply ${TABLET_BASHRC_FILESDIR}/add_cros_compat_accel_support.patch
}
