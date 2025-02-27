{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.rofi-allthemes;
in
{
  options.programs.qnix.rofi-allthemes = {
    enable = mkEnableOption "Enable adi1090x rofi themes";

    colorScheme = mkOption {
      type = types.str;
      default = "solarized";
      description = "Color scheme to use for rofi themes";
      example = "nord";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.qnix-pkgs.rofi-allthemes.override {
        colorScheme = cfg.colorScheme;
      })
    ];

    xdg.configFile = {
      "rofi" = {
        source = "${pkgs.qnix-pkgs.rofi-allthemes.override { colorScheme = cfg.colorScheme; }}/share/rofi";
        recursive = true;
      };
    };
  };
}
