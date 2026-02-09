final: prev: {
  # Fix superhtml: ZIG_GLOBAL_CACHE_DIR is unset in Nix build, so "ln -s ... $ZIG_GLOBAL_CACHE_DIR/p"
  # becomes "ln -s ... /p" and fails. Set it and create the dir before the symlink.
  superhtml = prev.superhtml.overrideAttrs (old: {
    postConfigure = ''
      export ZIG_GLOBAL_CACHE_DIR="''${ZIG_GLOBAL_CACHE_DIR:-$NIX_BUILD_TOP/zig-cache}"
      mkdir -p "$ZIG_GLOBAL_CACHE_DIR"
      ${old.postConfigure}
    '';
  });

  # Create a qnix-pkgs namespace for all packages
  qnix-pkgs = {
    rofi-allthemes = final.callPackage ../pkgs/rofi-allthemes { };
    easyroam-setup = final.callPackage ../pkgs/easyroam-setup { };
    nixos-blur = final.callPackage ../pkgs/nixos-plymouth { };

    # Add more packages here as needed
    # example = final.callPackage ../pkgs/example { };
  };
}
