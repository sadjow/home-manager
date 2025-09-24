{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    profileExtra = ''
      # Ensure direnv is available in login shells (like VSCode/Cursor terminals)
      if command -v direnv >/dev/null 2>&1; then
        eval "$(direnv hook zsh)"
      fi
    '';
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
    enable = true;
    profileExtra = ''
      # Ensure direnv works for editors that might use bash
      if command -v direnv >/dev/null 2>&1; then
        eval "$(direnv hook bash)"
      fi
    '';
  };

  # Enable direnv bash integration
  programs.direnv.enableBashIntegration = true;
}