{
  # NOTE: THIS DEPENDS ON NIX-LD, SINCE ELECTROBUN PUTS DYNAMICALLY LINKED EXECUTABLES IN YOUR HOME DIR
  inputs = {
    flakelight.url = "github:nix-community/flakelight";
    nixpkgs.url = "github:NixOS/nixpkgs/25.11";
  };
  outputs = {flakelight, ...}:
    flakelight ./. {
      devShell = pkgs: {
        packages = [
          pkgs.bun
          pkgs.webkitgtk_4_1
          pkgs.gtk3
          pkgs.glib
          pkgs.cairo
          pkgs.gdk-pixbuf
          pkgs.libsoup_3
          pkgs.libayatana-appindicator
          pkgs.stdenv.cc.cc.lib
        ];
        shellHook = ''
          export LD_LIBRARY_PATH=${
            pkgs.lib.makeLibraryPath [
              pkgs.webkitgtk_4_1
              pkgs.gtk3
              pkgs.glib
              pkgs.cairo
              pkgs.gdk-pixbuf
              pkgs.libsoup_3
              pkgs.libayatana-appindicator
              pkgs.stdenv.cc.cc.lib
            ]
          }:$LD_LIBRARY_PATH
          export GIO_MODULE_DIR="${pkgs.glib-networking}/lib/gio/modules/"
        '';
      };
    };
}
