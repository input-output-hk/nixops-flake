{ self, system, pkgs }:
let
  mkNixops_1 = nixopsCore: coreVersion: pkgs.callPackage ./pkgs/nixops_1-unstable.nix {
    inherit self system pkgs nixopsCore coreVersion;
    validPlugins = [ "aws" "hetzner" "packet" "virtd" "vbox" ];
  };

  mkNixops_2 = patches: pkgs.callPackage ./pkgs/nixops_2-unstable.nix {
    inherit self system pkgs patches;
    # Remove libvirtd plugin from Darwin until the compile error is fixed
    # The plugin "encrypted-links" is also removed due to a bug with the fix not yet merged:
    #   https://github.com/nix-community/nixops-encrypted-links/pull/1
    # and also a compatibility issue with at least packet plugin and possibly others.
    #   https://github.com/nix-community/nixops-encrypted-links/issues/2
    validPlugins = if pkgs.stdenv.isLinux then
      [ "aws" "gcp" "packet" "packet" "virtd" "vbox" ]
      # [ "aws" "encrypted-links" "gcp" "packet" "packet" "virtd" "vbox" ]
    else
      [ "aws" "gcp" "packet" "packet" "vbox" ];
      # [ "aws" "encrypted-links" "gcp" "packet" "packet" "vbox" ];
  };
in final: prev: {
  nixops_1_6_1-preplugin = self.inputs.nixpkgs-pin.legacyPackages.${system}.nixops_1_6_1;
  nixops_1_7-preplugin = self.inputs.nixpkgs-pin.legacyPackages.${system}.nixops;
  nixops_1_7-preplugin-unstable = self.inputs.nixpkgs-pin.legacyPackages.${system}.nixopsUnstable;

  nixops_1_7-iohk-unstable = mkNixops_1 "core-iohk" "1_7";
  nixops_1_8-nixos-unstable = mkNixops_1 "core-nixos" "1_8";

  nixops_2_0-2020-07-unstable = mkNixops_2 [ ./patches/nixpkgs-pr83548-2020-07.diff ];
  nixops_2_0-2021-01-unstable = mkNixops_2 [ ./patches/nixpkgs-pr83548-2021-01.diff ];
}
