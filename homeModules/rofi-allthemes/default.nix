{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.qnix.rofi-allthemes;
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

    applets = {
      type = mkOption {
        type = types.str;
        default = "2";
        description = "Type of applet";
        example = "1-3";
      };
      style = mkOption {
        type = types.str;
        default = "1";
        description = "Style of applet";
        example = "1-3";
      };
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
        source = "${pkgs.qnix-pkgs.rofi-allthemes}/share/rofi";
        recursive = true;
      };
      "rofi/color-theme.rasi" = {
        text = ''
          @import "~/.config/rofi/colors/${cfg.colorScheme}.rasi"
        '';
      };
      "rofi/applets/shared/theme.bash".text = ''
        type="$HOME/.config/rofi/applets/type-${cfg.applets.type}"
        style='style-${cfg.applets.style}.rasi'
      '';
    };
  };
}
