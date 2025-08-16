{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initContent = ''
      . ${pkgs.asdf-vm}/share/asdf-vm/asdf.sh
    '';
  };

  programs.bash = {
    enable = false;
  };
}