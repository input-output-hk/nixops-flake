{ self
, system
, pkgs
, nixopsCore
, coreVersion ? "1_7"
, validPlugins
, p ? validPlugins
, ...
}:
let
  inherit (builtins) all elem length;
  inherit (pkgs) lib;
  inherit (lib) assertMsg attrValues filterAttrs generators isList isString traceIf warn;
  inherit (generators) toPretty;

  p' = traceIf (length p == 0) ''
    WARNING
    trace: WARNING  -->  The plugins list is empty.  Is this what you intended?
    trace: WARNING  -->  The plugins parameter type is a list of strings: [ "$PLUGIN1" "$PLUGIN2" ]
    trace: WARNING  -->
    trace: WARNING  -->  Valid plugins for this attribute are shown in the following list:
    trace: WARNING  -->  ${toPretty {} validPlugins}
    trace: WARNING  -->
    trace: WARNING  -->  Proceeding to build with no plugins...
    trace: WARNING
  '' p;

  patchPlugin = { plugin, v ? "1_7" }: pkgs.applyPatches {
    src = self.inputs."nixops_${v}-plugin-${plugin}";
    name = "nixops_${v}-plugin-${plugin}-patched";
    patches = [ (../patches + "/nixops_${v}-plugin-${plugin}.diff") ];
  };

  nixops_1-plugin-core-patched = patchPlugin { plugin = nixopsCore; v = coreVersion; };
  nixops_1-plugin-aws-patched = patchPlugin { plugin = "aws"; };
  nixops_1-plugin-hetzner-patched = patchPlugin { plugin = "hetzner"; };
  nixops_1-plugin-libvirtd-patched = patchPlugin { plugin = "libvirtd"; };
  nixops_1-plugin-packet-patched = patchPlugin { plugin = "packet"; };
  nixops_1-plugin-vbox-patched = patchPlugin { plugin = "vbox"; };

  allPlugins = {
    aws = nixops_1-plugin-aws-patched;
    hetzner = nixops_1-plugin-hetzner-patched;
    packet = nixops_1-plugin-packet-patched;
    virtd = nixops_1-plugin-libvirtd-patched;
    vbox = nixops_1-plugin-vbox-patched;
  };

  filteredPlugins = attrValues (filterAttrs (n: v: builtins.elem n p') allPlugins);

in
  assert assertMsg (isList p) ''
    ERROR
    trace: ERROR  -->  The plugin parameter must be a list of strings: [ "$PLUGIN1" "$PLUGIN2" ]
    trace: ERROR  -->  It was supplied as: `${toPretty {} p}`
    trace: ERROR  -->
    trace: ERROR  -->  Valid plugins for this attribute are shown in the following list:
    trace: ERROR  -->  ${toPretty {} validPlugins}
    trace: ERROR
  '';
  assert all (plugin: assertMsg (isString plugin) ''
    ERROR
    trace: ERROR  -->  `${toString plugin}` must be a string; enclose it in quotes if needed
    trace: ERROR
  '') p;
  assert all (plugin: assertMsg (elem plugin validPlugins) ''
    ERROR
    trace: ERROR  -->  "${toString plugin}" must be one of ${toPretty {} validPlugins}
    trace: ERROR
  '') p;
(import (nixops_1-plugin-core-patched + "/release.nix") {
  inherit system;
  nixpkgs = self.inputs.nixpkgs-plugin-1.outPath;
  p = (p:
    let
      pluginSources = filteredPlugins;
      plugins = map (source: p.callPackage (source + "/release.nix") { })
        pluginSources;
    in [] ++ plugins);
}).build.${system}
