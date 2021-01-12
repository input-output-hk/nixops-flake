# Nixops Versions Flake

## Overview

* This repo is intended to provide easy access to different versions of nixops packages we've used over the years as well as the latest and greatest, via nix flake.

### Nix Version Requirements

* A nix version which support flakes will be required for flake functionality.
* See [here](https://nixos.wiki/wiki/Flakes) for installation instructions.
* Nix versions which do not support flakes may still utilize these nixops packages via the flake compatibility shim -- see below.

### Lorri, Direnv

* Git clone this repo and enter the top level repo directory.
* If [Direnv](https://direnv.net/) is installed, execute `direnv allow` in the repo top level directory and allow the project to build for the first time.
* If [Lorri](https://github.com/target/lorri) is installed, it will not be used as it is not yet fully compatible with flakes. [IssueRef](https://github.com/target/lorri/issues/460)


## Information Helpers

* The following flake application attributes can be run for nixops version information:
```
# For info from a remote repo not yet cloned:
nix run github:input-output-hk/nixops/versions
nix run github:input-output-hk/nixops/versions#info

# For info from a cloned repo in the root dir:
nix run
nix run .#info
```

* The following flake application attributes can be run for nixops version repo repl:
```
# For repl from a remote repo not yet cloned:
nix run github:input-output-hk/nixops/versions#repl

# For repl from a cloned repo in the root dir:
nix run .#repl
nix repl repl.nix
```

## Flake Attributes and Purity

### Available Nixops Versions

* Available nixops versions are the following:
```
Flake Attribute Name             Version               Comment
-----------------------------    ------------------    ---------------------------------------------
nixops_1_6_1-preplugin           1.6.1                 Monolithic
nixops_1_7-preplugin             1.7                   Monolithic
nixops_1_7-preplugin-unstable    1.7pre2764_932bf43    Monolithic
nixops_1_7-iohk-unstable         1.7pre0_abcdef        Plugins: aws, hetzner, packet, libvirtd, vbox
nixops_1_8-nixos-unstable        1.8pre0_abcdef        Plugins: aws, hetzner, packet, libvirtd, vbox
```

### Building Flake Attributes Purely

* Building purely adds automatically adds all the plugins available by default to the resulting binary.
* Nixops versions can be built from the attribute names above, with:
```
# For attributes from a remote repo not yet cloned:
nix <build|shell> github:input-output-hk/nixops/versions#${ATTRIBUTE}

# For attributes from a cloned repo in the root dir:
nix <build|shell> .#${ATTRIBUTE}
```

### Building Flake Attributes Impurely

* In contrast to building purely, building impurely allows plugin selection by command line.
* The following nixops versions are available to build impurely:
```
Flake Attribute Name             Version               Comment
nixops_1_7-iohk-unstable         1.7pre0_abcdef        Plugins: aws, hetzner, packet, libvirtd, vbox
nixops_1_8-nixos-unstable        1.8pre0_abcdef        Plugins: aws, hetzner, packet, libvirtd, vbox
```

* Nixops versions can be built impurely from the attribute names above, with specified plugins (at least one of ${PLUGIN}):
```
# For attributes from a remote repo not yet cloned:
nix <build|shell> --impure --expr '(builtins.getFlake "github:input-output-hk/nixops/versions")' \
'.impure.${builtins.currentSystem}.${ATTRIBUTE} [ ${PLUGIN} ]'


# For attributes from a cloned repo in the root dir:
nix <build|shell> --impure --expr '(builtins.getFlake (toString ./.))' \
'.impure.${builtins.currentSystem}.${ATTRIBUTE} [ ${PLUGIN} ]'

# Where ${PLUGIN} is of (with quotes):
# "aws" "hetzner" "packet" "libvirtd" "vbox"
```

## Flake Outputs and Legacy Packages

* These nixops packages are available for use in other flakes.
* Non-flake nix can also utilize these packages via the `legacyPackages` attributes:
```
# Build using non-flakes nix from the legacyPackages shim in a cloned repo root dir:
nix-build default.nix -A legacyPackages.${SYSTEM}.${ATTRIBUTE}
```
* Similarly, non-flake nix can also utilize these legacy package attributes in other non-flake nix code.


## Notes
* A `nix flake show` command will break due to an issue with IFD and flakes.
* This appears to be cosmetic and will be fixed when there is a suitable workaround.  [IssueRef](https://discourse.nixos.org/t/how-to-use-flakes-with-ifd/10300)
