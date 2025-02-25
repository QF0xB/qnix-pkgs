{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "rofi-allthemes";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "adi1090x";
    repo = "rofi";
    rev = "master";
    sha256 = "sha256-TVZ7oTdgZ6d9JaGGa6kVkK7FMjNeuhVTPNj2d7zRWzM="; # Replace with actual hash after first attempt
  };

  installPhase = ''
    mkdir -p $out/share/rofi/themes
    cp -r files/* $out/share/rofi/themes/
  '';

  meta = with lib; {
    description = "A large collection of Rofi themes";
    homepage = "https://github.com/adi1090x/rofi";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
