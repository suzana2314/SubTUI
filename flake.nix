{
  description = "A lightweight Subsonic TUI music player built in Go";

  inputs.nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          subtui = pkgs.callPackage ./nix/package.nix { inherit self; };
          default = self.packages.${system}.subtui;
        }
      );

      homeManagerModules = {
        subtui = ./nix/module.nix;
        default = self.homeManagerModules.subtui;
      };

      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            inputsFrom = [ self.packages.${system}.subtui ];
            nativeBuildInputs = with pkgs; [
              go
              gopls
              go-tools
            ];
          };
        }
      );
    };
}
