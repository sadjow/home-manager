{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      . ${pkgs.asdf-vm}/share/asdf-vm/asdf.sh
    '';
  };

  programs.bash = {
    enable = false;
  };
}