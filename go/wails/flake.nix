{
  inputs.flakelight.url = "github:nix-community/flakelight";
  outputs = {flakelight, ...}:
    flakelight ./. {
      devShell = {
        packages = pkgs: [pkgs.wails pkgs.go pkgs.nodejs];
      };
    };
}
