{
  inputs.flakelight.url = "github:nix-community/flakelight";

  outputs = {
    flakelight,
    nixpkgs,
    ...
  }:
    flakelight ./. {
      devShell.packages = pkgs: [
        pkgs.flutter
        pkgs.dart
      ];
    };
}
