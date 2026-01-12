{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # Create a unified module that works for both NixOS and Home Manager
      rofiAllThemesModule = import ./modules/programs/rofi-allthemes.nix;
    in
    {
      overlays.default = import ./overlays/default.nix;

      # NixOS modules
      nixosModules = {
        # Import individual modules
        rofi-allthemes = import ./nixosModules/rofi-allthemes/default.nix;
        # Add other individual modules here

        # Default module that imports everything
        default = {
          imports = [
            ./nixosModules/default.nix
            # This forwards configurations to home-manager if it's available
            (
              { config, lib, ... }:
              lib.mkIf (config ? home-manager.users) {
                home-manager.sharedModules = [ ./homeModules/default.nix ];
              }
            )
          ];
        };
      };

      # Home Manager modules
      homeManagerModules = {
        # Import individual modules
        rofi-allthemes = import ./homeModules/rofi-allthemes/default.nix;
        # Add other individual modules here

        # Default module that imports everything
        default = {
          imports = [ ./homeModules/default.nix ];
        };
      };

      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        {
          inherit (pkgs.qnix-pkgs) rofi-allthemes nixos-blur;
          default = pkgs.qnix-pkgs.rofi-allthemes;
        }
      );
    };
}
