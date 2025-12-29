{ pkgs, ... }:

{
  # Determinate Nix manages its own daemon, avoid conflicts
  nix.enable = false;

  networking = {
    hostName = "codecraft";
    computerName = "codecraft";
    localHostName = "codecraft";
  };

  system.stateVersion = 5;
}
