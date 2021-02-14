{ self, system, pkgs }:
let
  mkNixops_2-2021-02 = nixpkgs-src: patches: pkgs.callPackage ./pkgs/nixops_2-2021-02-unstable.nix {
    inherit self system pkgs nixpkgs-src patches;
    # Remove encrypted-links plugin until partial deployment errors are fixed
    # validPlugins = [ "aws" "encrypted-links" "wg-links" "gcp" "packet" "virtd" "vbox" ];
    validPlugins = [ "aws" "gcp" "packet" "virtd" "vbox" "wg-links" ];
  };

  mkNixops_2 = patches: pkgs.callPackage ./pkgs/nixops_2-unstable.nix {
    inherit self system pkgs patches;
    validPlugins = if pkgs.stdenv.isLinux then
      [ "aws" "encrypted-links" "gcp" "packet" "virtd" "vbox" ]
    else
      [ "aws" "encrypted-links" "gcp" "packet" "vbox" ];
  };

  mkNixops_1 = nixopsCore: coreVersion: pkgs.callPackage ./pkgs/nixops_1-unstable.nix {
    inherit self system pkgs nixopsCore coreVersion;
    validPlugins = [ "aws" "hetzner" "packet" "virtd" "vbox" ];
  };
in final: prev: {
  nixops_2_0-latest-unstable = mkNixops_2-2021-02 self.inputs.nixpkgs-plugin-2-2021-02 [ ./patches/nixpkgs-2021-02.diff ];
  nixops_2_0-2021-02-unstable = mkNixops_2-2021-02 self.inputs.nixpkgs-plugin-2-2021-02 [ ./patches/nixpkgs-2021-02.diff ];
  nixops_2_0-2021-01-unstable = mkNixops_2 [ ./patches/nixpkgs-pr83548-2021-01.diff ];
  nixops_2_0-2020-07-unstable = mkNixops_2 [ ./patches/nixpkgs-pr83548-2020-07.diff ];

  nixops_1_8-nixos-unstable = mkNixops_1 "core-nixos" "1_8";

  nixops_1_7-iohk-unstable = mkNixops_1 "core-iohk" "1_7";
  nixops_1_7-preplugin-unstable = self.inputs.nixpkgs-pin.legacyPackages.${system}.nixopsUnstable;
  nixops_1_7-preplugin = self.inputs.nixpkgs-pin.legacyPackages.${system}.nixops;

  nixops_1_6_1-preplugin = self.inputs.nixpkgs-pin.legacyPackages.${system}.nixops_1_6_1;
}
