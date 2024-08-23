cros_pre_src_prepare_tablet_patches() {
  if [ ${PV} == '9999' ]; then
    return
  fi
  eapply ${TABLET_BASHRC_FILESDIR}/fix_location.patch
}
