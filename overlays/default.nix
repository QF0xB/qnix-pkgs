final: prev: {
  # Create a qnix-pkgs namespace for all packages
  qnix-pkgs = {
    rofi-allthemes = final.callPackage ../pkgs/rofi-allthemes { };
    easyroam-setup = final.callPackage ../pkgs/easyroam-setup { };
    nixos-blur = final.callPackage ../pkgs/nixos-plymouth { };

    # Add more packages here as needed
    # example = final.callPackage ../pkgs/example { };
  };
}
