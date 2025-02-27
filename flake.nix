{
  description = "qnix-pkgs - Custom package collection";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported systems
      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        }
      );
    in
    {
      # Packages available through the overlay
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          inherit (pkgs.qnix-pkgs) rofi-allthemes;
          # Add more packages here as needed

          # Define a default value
          default = pkgs.qnix-pkgs.rofi-allthemes;
        }
      );

      # Overlay providing all packages
      overlays.default = final: prev: import ./overlays/default.nix final prev;

      nixosModules = {
        rofi-allthemes = import ./modules/rofi-allthemes/nixosModule.nix;
        default = {
          imports = [ self.nixosModules.rofi-allthemes ];
        };
      };

      homeManagerModules = {
        rofi-allthemes = import ./modules/rofi-allthemes/homeModule.nix;
        default = {
          imports = [ self.homeManagerModules.rofi-allthemes ];
        };
      };

      # Development shell for working on these packages
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              git
              rofi-wayland
            ];
          };
        }
      );
    };
}
