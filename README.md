# Nixops Versions Flake

## Overview

* This repo is intended to provide easy access to different versions of nixops packages we've used over the years as well as the latest and greatest, via nix flake.

### Nix Version Requirements

* A nix version which support flakes will be required for flake functionality.
* See [here](https://nixos.wiki/wiki/Flakes) for installation instructions.
* Nix versions which do not support flakes may still utilize these nixops packages via the flake compatibility shim -- see below.


### Quick Start

* Without needing to clone this repo, have fun with the following!
```
# Build yourself a shiny new nixops and use it from a nix shell!
nix shell github:input-output-hk/nixops-flake

# Get some info about nixops build attributes and options available:
nix run github:input-output-hk/nixops-flake

# Repl the nixops flake remotely, no need to clone!
nix run github:input-output-hk/nixops-flake#repl-remote
```


### Lorri, Direnv

* Git clone this repo and enter the top level repo directory.
* If [Direnv](https://direnv.net/) is installed, execute `direnv allow` in the repo top level directory and allow the project to build for the first time.
* If [Lorri](https://github.com/target/lorri) is installed, it will not be used as it is not yet fully compatible with flakes. [IssueRef](https://github.com/target/lorri/issues/460)


## Information Helpers

* The following flake application attributes can be run for nixops version information:
```
# For info from a remote repo not yet cloned:
nix run github:input-output-hk/nixops-flake
nix run github:input-output-hk/nixops-flake#info

# For info from a cloned repo in the root dir:
nix run
nix run .#info
```

* The following flake application attributes can be run for nixops version repo repl:
```
# For repl from a remote repo not yet cloned:
nix run github:input-output-hk/nixops-flake#repl-remote

# For repl from a cloned repo in the root dir:
nix run .#repl
nix repl repl.nix
```

* If you have an outdated cache of the flake, the following can be run to update the cache for the flake:
```
# To cache update a remote repo not yet cloned:
nix flake update github:input-output-hk/nixops/version

# To cache update a cloned repo in the root dir:
nix flake update
```

## Flake Attribute Update Approach

* Nixops2 unstable attributes will be available in the name form of: `nixops_2_0-YYYY-MM-unstable`.
* A nixops2 attribute for the current month will have its source pins updated as nixops and plugin repos are updated.
* Once a nixops2 attribute no longer represents the current month, its source pins will remain locked.
* Any pre-nixops2 attributes remain source pin locked.
* For brevity, only the two most recent nixops2 attributes are shown in this file.
* Full nixops attribute and source pin information is available in the [versions.md](https://github.com/input-output-hk/nixops/blob/versions/versions.md) file.


## Flake Attributes and Purity

### Available Nixops Versions

* Available nixops versions for `x86_64-linux` and `x64-64-darwin` (except where noted with `(!)`) are:
```
Flake Attribute Name              Binary Ver (*)         Comment
-----------------------------     ------------------     ---------------------------------------------------------------------
nixops_2_0-2021-01-unstable       @version@              Plugins: aws, gcp, packet, libvirtd(!), vbox, encrypted-links, contrib
nixops_2_0-2020-07-unstable       @version@              Plugins: aws, gcp, packet, libvirtd(!), vbox, encrypted-links, contrib
nixops_1_8-nixos-unstable         1.8pre0_abcdef         Plugins: aws, hetzner, packet, libvirtd, vbox
nixops_1_7-iohk-unstable          1.7pre0_abcdef         Plugins: aws, hetzner, packet, libvirtd, vbox
nixops_1_7-preplugin-unstable     1.7pre2764_932bf43     Monolithic
nixops_1_7-preplugin              1.7                    Monolithic
nixops_1_6_1-preplugin            1.6.1                  Monolithic

(!) = There is a build error of the `libvirtd` plugin on Darwin at the moment
(*) = To do: Fix up the builds to show proper version and commit rev from `nixops --version`
```


### Building Flake Attributes Purely

* Building purely will automatically add all plugins to the resulting binary.  The exception to this is:
  * The plugin libvirtd will be excluded on Darwin for `nixops_2_0` attributes due to a build error.
* Nixops versions can be built from the attribute names above, with:
```
# For attributes from a remote repo not yet cloned:
nix <build|shell> github:input-output-hk/nixops-flake#${ATTRIBUTE}

# For attributes from a cloned repo in the root dir:
nix <build|shell> .#${ATTRIBUTE}
```


### Building Flake Attributes Impurely

* In contrast to building purely, building impurely allows plugin selection by command line.
* The following nixops versions are available to build impurely:
```
Flake Attribute Name             Binary Ver (*)        Comment
-------------------------        --------------        -----------------------------------------------------------------------
nixops_2_0-2021-01-unstable      @version@             Plugins: aws, gcp, packet, libvirtd(!), vbox, contrib, encrypted-links
nixops_2_0-2020-07-unstable      @version@             Plugins: aws, gcp, packet, libvirtd(!), vbox, contrib, encrypted-links
nixops_1_8-nixos-unstable        1.8pre0_abcdef        Plugins: aws, hetzner, packet, libvirtd, vbox
nixops_1_7-iohk-unstable         1.7pre0_abcdef        Plugins: aws, hetzner, packet, libvirtd, vbox

(!) = There is a build error of the `libvirtd` plugin on Darwin at the moment
(*) = To do: Fix up the builds to show proper version and commit rev from `nixops --version`
```

* Nixops versions can be built impurely from the attribute names above, with specified plugins (at least one of `${PLUGIN}`):
```
# For attributes from a remote repo not yet cloned:
nix <build|shell> --impure --expr '(builtins.getFlake "github:input-output-hk/nixops-flake")'\
'.impure.${builtins.currentSystem}.${ATTRIBUTE} [ ${PLUGIN} ]'


# For attributes from a cloned repo in the root dir:
nix <build|shell> --impure --expr '(builtins.getFlake (toString ./.))'\
'.impure.${builtins.currentSystem}.${ATTRIBUTE} [ ${PLUGIN} ]'

# Where ${PLUGIN} is generally of the following plugin strings (with quotes), depending on attribute selected:
# "aws" "encrypted-links" "gcp" "hetzner" "packet" "virtd" "vbox"
```

* Nixops can be built impurely with no plugins.  In this case, a warning will be shown during the build.


## Flake Outputs and Legacy Packages

* These nixops packages are available for use in other flakes.
* Non-flake nix can also utilize these packages via the `legacyPackages` attributes:
```
# Build using non-flakes nix from the legacyPackages shim in a cloned repo root dir:
nix-build default.nix -A legacyPackages.${SYSTEM}.${ATTRIBUTE}
```
* Similarly, non-flake nix can also utilize these legacy package attributes in other non-flake nix code.


## Default Package Version

* Due to a Darwin build error in the libvirtd plugin, the default packages by system are slightly different:
  * `x86_64-linux`:  `nixops_2_0-2021-01-unstable`, all plugins
  * `x86_64-darwin`: `nixops_2_0-2021-01-unstable`, all plugins except libvirtd
* To build or enter a shell with the default nixops package, run:
```
# For the default nixops package from a remote repo not yet cloned:
nix <build|shell> github:input-output-hk/nixops-flake

# For the default nixops package from a cloned repo in the root dir:
nix build
nix shell .#
```


## Repo URLs For the Plugins Referenced Above

* Nixops: `nixops` [https://github.com/NixOS/nixops](https://github.com/NixOS/nixops)
* Plugin: `aws` [https://github.com/NixOS/nixops-aws](https://github.com/NixOS/nixops-aws)
* Plugin: `gcp` [https://github.com/nix-community/nixops-gce](https://github.com/nix-community/nixops-gce)
* Plugin: `packet` [https://github.com/input-output-hk/nixops-packet](https://github.com/input-output-hk/nixops-packet)
* Plugin: `libvirtd` [https://github.com/nix-community/nixops-libvirtd](https://github.com/nix-community/nixops-libvirtd)
* Plugin: `vbox` [https://github.com/nix-community/nixops-vbox](https://github.com/nix-community/nixops-vbox)
* Plugin: `links` [https://github.com/nix-community/nixops-encrypted-links](https://github.com/nix-community/nixops-encrypted-links)
* Plugin: `contrib` [https://github.com/nix-community/nixos-modules-contrib](https://github.com/nix-community/nixos-modules-contrib)


## Generating an Updated Poetry Nixops2 Patch File

* From the nixops2 PR nixpkgs commit make a nixpkgs git tracked directory for generating a new patch file.
* A script to set up a nixpkgs git tracked directory for patch generation is available by running:
```
./scripts/setup-patchdir.sh
```

* From the git tracked repo directory at `../nixpkgs-patch`, make the following modifications as needed:
```
* Run the update script for poetry at: pkgs/development/tools/poetry2nix/update
* Add a packet-python poetry override to: pkgs/development/tools/poetry2nix/poetry2nix/overrides.nix

    packet-python = super.packet-python.overridePythonAttrs (
      old: {
        buildInputs = old.buildInputs ++ [ self.pytest-runner ];
      }
    );

* If needed, adjust the pyproject.toml file for the new nixops version at: `pkgs/tools/package-management/nixops2/pyproject.toml`.
* If needed, adjust the default.nix file for the new nixops version at: `pkgs/tools/package-management/nixops2/default.nix`.
* Run the update script for nixops2 at: `pkgs/tools/package-management/nixops2/update`.
* Add all diffs from the command above: `git add ${CHANGED_FILES[@]}`.
* Generate a patch file: `git diff --cached > new_patch.diff`.
* Copy new patch file to the `patches/` directory in this repo.
* Use the new patch with nixops2 package generator in this repo: `pkgs/nixops_2-unstable.nix`.
```


## Development and Testing

* To set up a development and testing environment, do the following from the root directory of the repo.
* Generate a nixpkgs git tracked patch directory if not already done:
```
# The following command creates a `../nixpkgs-patch` dir relative to the repo root directory:
./scripts/setup-patchdir.sh
```

* Generate a set of local nixops and plugin repos for development and testing purposes:
```
# The following command creates a `../nixops-dev` dir relative to the repo root directory:
./scripts/setup-devdir.sh
```

* The `setup-devdir.sh` script command above will clone all nixops and plugin repos into the `../nixops-dev` directory.
* It will also print output similar to the following, where the absolute paths shown will be to the development and testing repos just cloned.
```
The following lines can now replace the corresponding repo pyproject.toml lines for local development:

nixops = {path = "/home/myUser/nixops-flake-wt/nixops-dev/nixops"}
nixops-aws = {path = "/home/myUser/nixops-flake-wt/nixops-dev/nixops-aws"}
nixops-encrypted-links = {path = "/home/myUser/nixops-flake-wt/nixops-dev/nixops-encrypted-links"}
nixops-gcp = {path = "/home/myUser/nixops-flake-wt/nixops-dev/nixops-gce"}
nixops-hetzner = {path = "/home/myUser/nixops-flake-wt/nixops-dev/nixops-hetzner"}
nixops-packet = {path = "/home/myUser/nixops-flake-wt/nixops-dev/nixops-packet"}
nixops-virtd = {path = "/home/myUser/nixops-flake-wt/nixops-dev/nixops-libvirtd"}
nixopsvbox = {path = "/home/myUser/nixops-flake-wt/nixops-dev/nixops-vbox"}

The directory "/home/myUser/nixops-flake-wt/nixops-dev" is now ready for local development and testing
```

* Use your similar `pyproject.toml` lines from the `setup-devdir.sh` script output to update the `pyproject.toml` file:
```
# Where desired, update the pyproject.toml file with local pointing repo references in the nixpkgs-patch directory
vim ../nixpkgs-patch/pkgs/tools/package-management/nixops2/pyproject.toml
```

* Update poetry to use the new paths and enter a shell with the updated version of nixops by running the following:
```
# If not already there, cd to the poetry2 directory in the nixpkgs-patch directory
cd ../nixpkgs-patch/pkgs/tools/package-management/nixops2/pyproject.toml

# Enter a nix shell to get poetry
nix-shell

# Update poetry to use the proper local development and testing repos
poetry install

# Enter a poetry shell for the development and testing version of nixops
poetry shell
```

* Now the local development and testing repos can be updated as needed
* Changes to local repo code will be effective immediately in the poetry shell nixops command
* If new changes to the pyproject.toml development and testing version are needed, such as dropping or adding a plugin, do the following:
```
# If already in a poetry shell, drop out of it
exit

# Update the pyproject.toml file as needed in the nixpkgs-patch dir
vim ./pyproject.toml

# Update poetry to use the newly edited pyproject.toml local repo references
poetry update

# Enter a poetry shell for the updated development and testing version of nixops
poetry shell
```


## Notes

* A `nix flake show` command will break due to an issue with IFD and flakes.
* This appears to be cosmetic and will be fixed when there is a suitable workaround.  [IssueRef](https://discourse.nixos.org/t/how-to-use-flakes-with-ifd/10300)
* Testing was done at nix version `nix (Nix) 2.4pre20201205_a5d85d0`.


## To Do

* Where not already done, embed the version and commit revision into the attributes so `nixops --version` command displays these.
