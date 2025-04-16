{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

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
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }:
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
