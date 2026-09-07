let
  caches = {
    "https://cache.nixos.org" = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
    "https://cachix.cachix.org" = "cachix.cachix.org-1:KzcwKqacT4A3+Jn1fEL4GezqHSO3LKC79VpRj4QsdB8=";
    "https://devenv.cachix.org" = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    "https://nix-community.cachix.org" = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    "https://claude-code.cachix.org" = "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk=";
    "https://codex-cli.cachix.org" = "codex-cli.cachix.org-1:1Br3H1hHoRYG22n//cGKJOk3cQXgYobUel6O8DgSing=";
    "https://tunnel-client.cachix.org" = "tunnel-client.cachix.org-1:m5ve4z3WgkbTn0GwDRbBCG76dJBlTjv9TR93sO3AaqA=";
  };
in
{
  substituters = builtins.attrNames caches;
  trusted-public-keys = builtins.attrValues caches;
}
