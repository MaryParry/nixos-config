{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "phinger-cursors-gruvbox-material";
  version = "3328966123";

  src = fetchurl {
    url = "https://github.com/rehanzo/phinger-cursors-gruvbox-material/releases/download/${version}/phinger-cursors-variants.tar.bz2";
    sha256 = "sha256-qAEGY3B0tphEwYGfhkJ555yLgAu1nflCjqCOfZ8vjIE=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r ./phinger-cursors* $out/share/icons
    runHook postInstall
  '';

  meta = {
    description = "Phinger cursors gruvbox material";
    homepage = "https://github.com/rehanzo/phinger-cursors-gruvbox-material";
    platforms = lib.platforms.unix;
    license = lib.licenses.cc-by-sa-40;
  };
}
