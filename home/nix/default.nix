{
  config,
  pkgs,
  devenv,
  ...
}: {
  nix.package = pkgs.nix;
  nix.settings =
    let
      caches = {
        "cache.nixos.org" = "6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
        "cachix.cachix.org" = "KzcwKqacT4A3+Jn1fEL4GezqHSO3LKC79VpRj4QsdB8=";
        "devenv.cachix.org" = "w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
        "nix-community.cachix.org" = "mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
        "claude-code.cachix.org" = "m0kqRMQrW+sjthbPBDu0YvPRlEISbmmMk4dJRc1xf5E=";
      };
    in
    {
      netrc-file = "${config.home.homeDirectory}/.config/nix/netrc";
      substituters = builtins.map (domain: "https://${domain}") (builtins.attrNames caches);
      trusted-public-keys = builtins.attrValues (builtins.mapAttrs (domain: key: "${domain}-1:${key}") caches);
    };
}
