{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initContent = ''
      . ${pkgs.asdf-vm}/share/asdf-vm/asdf.sh
    '';
    shellAliases = {
      # Flutter development aliases
      flutter = "fvm flutter";
      dart = "fvm dart";
      f = "fvm flutter";
      d = "fvm dart";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.bash = {
    enable = false;
  };
}