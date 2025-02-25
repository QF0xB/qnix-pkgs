# qnix-pkgs

A collection of custom Nix packages and configurations.

## Available Packages

- `rofi-themes`: A collection of themes for rofi from adi1090x/rofi

## Usage

### As a flake input

Add this repository as an input to your flake:
```
{
  inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  qnix-pkgs.url = "github:yourusername/qnix-pkgs";
};

outputs = { self, nixpkgs, qnix-pkgs, ... }:
{
  # Example for NixOS configuration
  nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
  # Apply the overlay
  { nixpkgs.overlays = [ qnix-pkgs.overlays.default ]; }
      # Your configuration
      ./configuration.nix
    ];
  };
};
```

### Using packages

Once you've added the overlay, you can use the packages like any other package:
```nix
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    rofi-wayland
    qnix-pkgs.rofi-themes
  ];
}
```


### Using themes

To use the themes with rofi, you can configure rofi to look for themes in the package:
```nix
{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    extraConfig = {
      theme = "${pkgs.qnix-pkgs.rofi-themes}/share/rofi/themes/colorful/style_7.rasi";
    };
  };
}
```
## Adding New Packages

To add a new package:

1. Create a new directory under `pkgs/` for your package
2. Add a `default.nix` file with the package definition
3. Add the package to the overlay in `overlays/default.nix` under the `qnix-pkgs` namespace

