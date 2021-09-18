{ self
, system
, pkgs
, patches ? []
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

  nixpkgs_2-plugin-patched = pkgs.applyPatches {
    inherit patches;
    src = self.inputs.nixpkgs-plugin-2;
    name = "nixpkgs_2-plugin-patched";
  };

  nixops_2-nixpkgs = import nixpkgs_2-plugin-patched { inherit system; };

in nixops_2-nixpkgs.nixops2Unstable.withPlugins (ps: with ps; let
  allPlugins = {
    aws = nixops-aws;
    encrypted-links = nixops-encrypted-links;
    gcp = nixops-gcp;
    packet = nixops-packet;
    virtd = nixops-virtd;
    vbox = nixopsvbox;
    vultr = nixops-vultr
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
filteredPlugins)
