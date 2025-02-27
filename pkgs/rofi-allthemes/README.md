## Rofi All Themes

This package provides the adi1090x rofi themes collection with configurable color schemes.

### Usage with Home Manager

```
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    qnix-pkgs.url = "github:Stormfox2/qnix-pkgs";
  };

  outputs = { self, nixpkgs, home-manager, qnix-pkgs, ... }: {
    homeConfigurations."username" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        qnix-pkgs.homeManagerModules.default
        {
          programs.qnix.rofi-allthemes = {
            enable = true;
            colorScheme = "nord"; # Available: onedark, nord, dracula, etc.
          };
        }
      ];
    };
  };
}
```

### Usage with NixOS

```
{
  imports = [
    inputs.qnix-pkgs.nixosModules.default
  ];

  programs.qnix.rofi-allthemes = {
    enable = true;
    colorScheme = "dracula"; # Choose your preferred color scheme
  };
}
```

### Available Color Schemes

- onedark
- nord
- dracula
- catppuccin
- gruvbox
- monokai
- solarized
- tokyo-night
