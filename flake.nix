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

    # Fast, Declarative, Reproducible, and Composable Developer Environments
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, devenv, ... }:
    let
      # System types to support
      supportedSystems = [ "x86_64-darwin" "aarch64-darwin" ];

      # Helper function to generate an attrset for each supported system
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Import nixpkgs with overlays for each supported system
      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        # Configure your nixpkgs instance
        config = {
          allowUnfree = true;
        };
        # Add devenv overlay
        overlays = [
          devenv.overlays.default
        ];
      });
    in
    {
      # Home manager configuration
      homeConfigurations."sadjow" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgsFor."x86_64-darwin"; # Intel Mac
        # When switch to M4: Change to "aarch64-darwin"

        # Specify home configuration modules
        modules = [
          ./home.nix
          # Make devenv available to home.nix
          { _module.args.devenv = devenv; }
        ];
      };

      # Optional: darwin configuration if you want to use nix-darwin too
      darwinConfigurations."sadjow-mac" = darwin.lib.darwinSystem {
        system = "x86_64-darwin"; # Intel Mac
        # When you switch to M4: Change to "aarch64-darwin"
        modules = [
          # Your darwin configuration
          # Example: ./darwin-configuration.nix
        ];
      };
    };
}
