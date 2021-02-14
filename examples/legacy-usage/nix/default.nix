{ sources ? import ./sources.nix }:
let
  pkgs = import sources.nixpkgs {};
  inherit (pkgs) lib makeWrapper;
  inherit (lib) makeBinPath;
  inherit (builtins) currentSystem;

  nixops-flake-repo = import sources.nixops-flake-repo;

  # Latest monthly attribute build
  nixops = nixops-flake-repo.legacyPackages.${currentSystem}.nixops_2_0-latest-unstable;

  # Impure build with customizable plugins
  # See the main README.md for a list of available plugins to use
  customPlugins = [ "aws" ];
  nixops-custom = let
    nixops-impure = nixops-flake-repo.outputs.impure.${currentSystem}.nixops_2_0-latest-unstable customPlugins;
    deps = with pkgs; [ nixops-impure ];
  in pkgs.runCommandLocal "nixops-custom" {
    inherit nixops-impure;
    nativeBuildInputs = [ makeWrapper ];
  } ''
    makeWrapper ${nixops-impure}/bin/nixops $out/bin/nixops-custom \
      --prefix PATH : ${makeBinPath deps}
  '';
in with {
  overlay = self: super: {
    inherit (import sources.niv { }) niv;
    inherit nixops;
    inherit nixops-custom;
  };
};
import sources.nixpkgs {
  overlays = [ overlay ];
  config = { };
}
