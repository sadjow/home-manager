{
  description = "Home Manager configuration";

  nixConfig = {
    extra-substituters = [
      "https://cachix.cachix.org"
      "https://devenv.cachix.org"
      "https://nix-community.cachix.org"
      "https://claude-code.cachix.org"
      "https://codex-cli.cachix.org"
      "https://gemini-cli-nix.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cachix.cachix.org-1:KzcwKqacT4A3+Jn1fEL4GezqHSO3LKC79VpRj4QsdB8="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
      "codex-cli.cachix.org-1:1Br3H1hHoRYG22n//cGKJOk3cQXgYobUel6O8DgSing="
      "gemini-cli-nix.cachix.org-1:DzAIhrYktyRtR1OO0KjyYEKR5hjwsdZU2NwHlEBCcvI="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Home manager - using master branch to match nixpkgs-unstable
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Needed for macOS support
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv = {
      url = "github:cachix/devenv";
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    codex-cli = {
      url = "github:sadjow/codex-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gemini-cli = {
      url = "path:/Users/sadjow/opensource/gemini-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, darwin, devenv, claude-code, codex-cli, gemini-cli, ... }:
    let
      supportedSystems = [ "aarch64-darwin" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          claude-code.overlays.default
          codex-cli.overlays.default
          gemini-cli.overlays.default
        ];
      });
    in
    {
      homeConfigurations."sadjow" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgsFor."aarch64-darwin";

        modules = [
          ./home.nix
          { _module.args.devenv = devenv; }
        ];
      };

      darwinConfigurations."codecraft" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin-configuration.nix
        ];
      };
    };
}
