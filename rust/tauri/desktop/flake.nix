{
  inputs.flakelight.url = "github:nix-community/flakelight";
  outputs = {flakelight, ...}:
    flakelight ./. {
      devShell = {
        packages = pkgs: [
          pkgs.pkg-config
          pkgs.wrapGAppsHook4
          pkgs.cargo
          pkgs.nodejs
          pkgs.librsvg
          pkgs.webkitgtk_4_1

          pkgs.cargo
          pkgs.rust-analyzer
          pkgs.rustc
          pkgs.clippy
          pkgs.rustfmt
        ];
        shellHook = pkgs: ''
          export XDG_DATA_DIRS="$GSETTINGS_SCHEMAS_PATH"
          export RUST_SRC_PATH="${pkgs.rustPlatform.rustLibSrc}";
        '';
      };
    };
}
