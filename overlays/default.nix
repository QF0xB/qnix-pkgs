final: prev: {
  # Create a qnix-pkgs namespace for all packages
  qnix-pkgs = {
    rofi-allthemes = final.callPackage ../pkgs/rofi-allthemes { };

    # Add more packages here as needed
    # example = final.callPackage ../pkgs/example { };
  };
}
