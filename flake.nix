{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Needed for macOS support
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv = {
      url = "github:cachix/devenv/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, devenv, ... }:
    let
      supportedSystems = [ "aarch64-darwin" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          devenv.overlays.default
          (import ./overlays/claude-code.nix)
        ];
      });
    in
    {
      homeConfigurations."sadjow" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgsFor."aarch64-darwin";

        modules = [
          ./home.nix
          # Make devenv available to home.nix
          { _module.args.devenv = devenv; }
        ];
      };

      # Optional: darwin configuration if you want to use nix-darwin too
      darwinConfigurations."sadjow-mac" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          # Your darwin configuration
          # Example: ./darwin-configuration.nix
        ];
      };
    };
}
