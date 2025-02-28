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

    # Do NOT copy config.rasi
    rm files/config.rasi

    # Copy files from the source to the destination
    cp -r files/* $out/share/rofi/

    # Create a global colors.rasi file that imports the selected color scheme
    echo '@import "colors/${colorScheme}.rasi"' > $out/share/rofi/colors-theme.rasi 

    runHook postInstall
  '';

  postInstall = ''
    # Find all colors.rasi files and replace the import line with the exact string
    find $out -type f -name "colors.rasi" -exec sed -i 's|@import "~/.config/rofi/colors/.*"|@import "~/.config/rofi/color-theme.rasi"|g' {} \;
  '';

  meta = with lib; {
    description = "A huge collection of Rofi based custom Applets, Launchers & Powermenus";
    homepage = "https://github.com/adi1090x/rofi";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
