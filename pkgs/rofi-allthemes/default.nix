{
  lib,
  stdenv,
  pkgs,
  colorScheme ? "solarized", # Default color scheme
}:

let
  sources = import ./_sources/generated.nix {
    inherit (pkgs)
      fetchurl
      fetchgit
      fetchFromGitHub
      dockerTools
      ;
  };
in
stdenv.mkDerivation {
  pname = "rofi-allthemes";
  version = sources.rofi-allthemes.version;

  src = sources.rofi-allthemes.src;

  installPhase = ''
    # Create the destination directory
    mkdir -p $out/share/rofi

    # Copy files from the source to the destination
    cp -r files/* $out/share/rofi/
  '';

  meta = with lib; {
    description = "A huge collection of Rofi based custom Applets, Launchers & Powermenus";
    homepage = "https://github.com/adi1090x/rofi";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
