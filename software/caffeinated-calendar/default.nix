{ pkgs, ... }:

let
  pname = "caffeinated-calendar";
  version = "1.3.7";

  src = pkgs.fetchurl {
    url = "https://downloads.caffeinatedsoftworks.com/calendar/${version}/${pname}-${version}-x86_64.AppImage";
    hash = "sha256-+dKiPs34WtghmdT2w47Bi5BRXYrP3ZNYbCOajIV3+EA=";
  };

  appimageContents = pkgs.appimageTools.extract {
    inherit pname version src;
  };

  package = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -Dm444 \
        ${appimageContents}/caffeinated-calendar.desktop \
        $out/share/applications/caffeinated-calendar.desktop
      install -Dm444 \
        ${appimageContents}/usr/share/icons/hicolor/256x256/apps/caffeinated-calendar.png \
        $out/share/icons/hicolor/256x256/apps/caffeinated-calendar.png
    '';

    meta = {
      description = "Cross-platform calendar with CalDAV sync and event filtering";
      homepage = "https://caffeinatedcalendar.com/";
      license = pkgs.lib.licenses.unfree;
      mainProgram = "caffeinated-calendar";
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  home.packages = [ package ];
}
