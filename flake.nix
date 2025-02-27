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

      # Create a unified NixOS module that also sets up home-manager
      nixosModules.default =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          imports = [ rofiAllThemesModule ];

          # Forward the options to home-manager if it's available
          home-manager.users = lib.mkIf (config ? home-manager.users) (
            lib.mapAttrs (username: userConfig: {
              imports = [ rofiAllThemesModule ];
            }) config.home-manager.users
          );
        };

      # Also provide direct home-manager modules for completeness
      homeManagerModules.default = {
        imports = [ rofiAllThemesModule ];
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
          inherit (pkgs.qnix-pkgs) rofi-allthemes;
          default = pkgs.qnix-pkgs.rofi-allthemes;
        }
      );
    };
}
