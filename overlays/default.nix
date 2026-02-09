final: prev: {
  # nvf's nix language module (pinned rev) uses pkgs.nixfmt-rfc-style; alias to nixfmt to avoid deprecation warning
  nixfmt-rfc-style = prev.nixfmt;

  # Fix superhtml: ZIG_GLOBAL_CACHE_DIR is unset in Nix build, so "ln -s ... $ZIG_GLOBAL_CACHE_DIR/p"
  # becomes "ln -s ... /p" and fails. Set it in preConfigure so the existing phase sees it.
  superhtml = prev.superhtml.overrideAttrs (old: {
    preConfigure = (old.preConfigure or "") + ''
      export ZIG_GLOBAL_CACHE_DIR="''${ZIG_GLOBAL_CACHE_DIR:-$NIX_BUILD_TOP/zig-cache}"
      mkdir -p "$ZIG_GLOBAL_CACHE_DIR"
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
