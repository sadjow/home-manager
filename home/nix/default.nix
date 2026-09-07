{
  config,
  pkgs,
  devenv,
  ...
}: {
  nix.package = pkgs.nix;
  nix.settings = (import ./caches.nix) // {
    netrc-file = "${config.home.homeDirectory}/.config/nix/netrc";
    accept-flake-config = true;
    experimental-features = [ "nix-command" "flakes" ];
  };
}
