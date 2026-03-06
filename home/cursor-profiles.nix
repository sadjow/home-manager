{ config, lib, pkgs, ... }:

let
  repoPath = "${config.home.homeDirectory}/opensource/cursor-profiles";
  repoLink = "${config.home.homeDirectory}/cursor-profiles";
in
{
  home.file."cursor-profiles".source = config.lib.file.mkOutOfStoreSymlink repoPath;

  home.activation.cursorProfilesSetup = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    setup_script="${repoLink}/setup-cursor-profiles.sh"

    if [ ! -x "$setup_script" ] && [ -x "${repoPath}/setup-cursor-profiles.sh" ]; then
      setup_script="${repoPath}/setup-cursor-profiles.sh"
    fi

    if [ ! -x "$setup_script" ]; then
      echo "Skipping cursor-profiles setup: setup-cursor-profiles.sh not found or not executable"
      exit 0
    fi

    "${pkgs.bash}/bin/bash" "$setup_script"
  '';
}
