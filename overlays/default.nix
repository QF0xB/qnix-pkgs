final: prev: {
  # Create a qnix-pkgs namespace for all packages
  qnix-pkgs = {
    rofi-themes = final.callPackage ../pkgs/rofi-themes { };

    # Add more packages here as needed
    # example = final.callPackage ../pkgs/example { };
  };
}
