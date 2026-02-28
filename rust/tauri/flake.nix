{
  inputs.flakelight.url = "github:nix-community/flakelight";
  outputs = {flakelight, ...}:
    flakelight ./. {
      devShell = {
        packages = pkgs: [
          pkgs.pkg-config
          pkgs.wrapGAppsHook4
          pkgs.cargo
          pkgs.cargo-tauri
          pkgs.nodejs
          pkgs.librsvg
          pkgs.webkitgtk_4_1
        ];
        shellHook = ''
          export XDG_DATA_DIRS="$GSETTINGS_SCHEMAS_PATH"
        '';
      };
    };
}
