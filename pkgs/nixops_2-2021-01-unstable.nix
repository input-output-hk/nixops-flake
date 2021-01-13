{ self
, system
, pkgs
, ...
}:
let
  inherit (pkgs.lib) attrValues filterAttrs;

  nixpkgs_2-plugin-patched = pkgs.applyPatches {
    src = self.inputs.nixpkgs-plugin-2;
    name = "nixpkgs_2-plugin-patched";
    patches = [ ../patches/nixpkgs-pr83548-2021-01.diff ];
  };

  nixops_2-nixpkgs = import nixpkgs_2-plugin-patched { inherit system; };

in nixops_2-nixpkgs.nixops2Unstable.withPlugins (ps: with ps; [
  nixops-aws
  nixops-packet
  nixops-gcp
  nixops-virtd
  nixops-encrypted-links
  nixopsvbox
])
