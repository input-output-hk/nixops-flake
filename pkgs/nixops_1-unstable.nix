{ self
, system
, pkgs
, nixopsCore
, coreVersion ? "1_7"
, p ? [ "aws" "packet" "hetzner" "libvirtd" "vbox" ]
, ...
}:
let
  inherit (pkgs.lib) attrValues filterAttrs;

  patchPlugin = { plugin, v ? "1_7" }: pkgs.applyPatches {
    src = self.inputs."nixops_${v}-plugin-${plugin}";
    name = "nixops_${v}-plugin-${plugin}-patched";
    patches = [ (../patches + "/nixops_${v}-plugin-${plugin}.diff") ];
  };

  nixops_1-plugin-core-patched = patchPlugin { plugin = nixopsCore; v = coreVersion; };
  nixops_1-plugin-aws-patched = patchPlugin { plugin = "aws"; };
  nixops_1-plugin-packet-patched = patchPlugin { plugin = "packet"; };
  nixops_1-plugin-hetzner-patched = patchPlugin { plugin = "hetzner"; };
  nixops_1-plugin-libvirtd-patched = patchPlugin { plugin = "libvirtd"; };
  nixops_1-plugin-vbox-patched = patchPlugin { plugin = "vbox"; };

  allPlugins = {
    aws = nixops_1-plugin-aws-patched;
    packet = nixops_1-plugin-packet-patched;
    libvirtd = nixops_1-plugin-libvirtd-patched;
    hetzner = nixops_1-plugin-hetzner-patched;
    vbox = nixops_1-plugin-vbox-patched;
  };

  filteredPlugins = attrValues (filterAttrs (n: v: builtins.elem n p) allPlugins);

in (import (nixops_1-plugin-core-patched + "/release.nix") {
  inherit system;
  nixpkgs = self.inputs.nixpkgs-plugin-1.outPath;
  p = (p:
    let
      pluginSources = filteredPlugins;
      plugins = map (source: p.callPackage (source + "/release.nix") { })
        pluginSources;
    in [] ++ plugins);
}).build.${system}
