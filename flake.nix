{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Keep GitHub CLI current without forcing all Home Manager packages to update.
    nixpkgs-gh.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Keep Ollama current without forcing all Home Manager packages to update.
    nixpkgs-ollama.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

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
      url = "github:cachix/devenv/latest";
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    codex-cli = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Keep OpenCode current without forcing all Home Manager packages to update.
    nixpkgs-opencode.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Keep Pi current without forcing all Home Manager packages to update.
    nixpkgs-pi.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    aith = {
      url = "github:sadjow/aith";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-gh, nixpkgs-ollama, nixpkgs-opencode, nixpkgs-pi, home-manager, darwin, devenv, claude-code, codex-cli, aith, ... }:
    let
      supportedSystems = [ "aarch64-darwin" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          (import ./overlays/github-copilot-cli.nix)
          claude-code.overlays.default
          codex-cli.overlays.default
        ];
      });
    in
    {
      checks = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          agent-skills = pkgs.runCommand "agent-skills-check" {
            nativeBuildInputs = [
              pkgs.bash
              pkgs.coreutils
              pkgs.findutils
              pkgs.gnugrep
              pkgs.gnused
            ];
          } ''
            cp -R ${self} source
            chmod -R u+w source
            cd source
            bash scripts/check-agent-skills
            touch "$out"
          '';
        });

      homeConfigurations."sadjow" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgsFor."aarch64-darwin";

        modules = [
          ./home.nix
          { _module.args.devenv = devenv; }
          { _module.args.aith = aith; }
          { _module.args.ghPackage = nixpkgs-gh.legacyPackages."aarch64-darwin".gh; }
          { _module.args.ollamaPackage = nixpkgs-ollama.legacyPackages."aarch64-darwin".ollama; }
          { _module.args.opencodePackage = nixpkgs-opencode.legacyPackages."aarch64-darwin".opencode; }
          { _module.args.piPackage = nixpkgs-pi.legacyPackages."aarch64-darwin".pi-coding-agent; }
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
