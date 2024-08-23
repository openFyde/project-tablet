tablet_stack_bashrc() {
  local cfg cfgd
  cfgd="/mnt/host/source/src/overlays/project-tablet/${CATEGORY}/${PN}"
  for cfg in ${PN} ${P} ${PF} ; do
    cfg="${cfgd}/${cfg}.bashrc"
    [[ -f ${cfg} ]] && . "${cfg}"
  done

  export TABLET_BASHRC_FILESDIR="${cfgd}/files"
}

tablet_stack_bashrc
