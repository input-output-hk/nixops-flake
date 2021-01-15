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
nix shell github:input-output-hk/nixops/versions

# Get some info about nixops build attributes and options available:
nix run github:input-output-hk/nixops/versions

# Repl the nixops flake remotely, no need to clone!
nix run github:input-output-hk/nixops/versions#repl-remote
```


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
nix run github:input-output-hk/nixops/versions#repl-remote

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


## Flake Attributes and Purity

### Available Nixops Versions

* Available nixops versions for `x86_64-linux` and `x64-64-darwin` (except where noted with `(!)`) are:
```
Flake Attribute Name              Binary Ver (*)         Comment
-----------------------------     ------------------     ---------------------------------------------------------------------
nixops_1_6_1-preplugin            1.6.1                  Monolithic
nixops_1_7-preplugin              1.7                    Monolithic
nixops_1_7-preplugin-unstable     1.7pre2764_932bf43     Monolithic
nixops_1_7-iohk-unstable          1.7pre0_abcdef         Plugins: aws, hetzner, packet, libvirtd, vbox
nixops_1_8-nixos-unstable         1.8pre0_abcdef         Plugins: aws, hetzner, packet, libvirtd, vbox
nixops_2_0-2020-07-unstable       @version@              Plugins: aws, gcp, packet, libvirtd(!), vbox, encrypted-links, contrib
nixops_2_0-2021-01-unstable       @version@              Plugins: aws, gcp, packet, libvirtd(!), vbox, encrypted-links, contrib

(!) = There is a build error of the `libvirtd` plugin on Darwin at the moment
(*) = To do: Fix up the builds to show proper version and commit rev from `nixops --version`
```


### Building Flake Attributes Purely

* Building purely automatically will add all plugins to the resulting binary.  Two exceptions to this are:
  * The plugin libvirtd will be excluded on Darwin for `nixops_2_0` attributes due to a build error
  * The plugin encrypted-links will be excluded on `nixops_2_0` attributes due to a bug and a packet plugin conflict
    * Bug [IssueRef](https://github.com/nix-community/nixops-encrypted-links/pull/1)
    * Packet plugin conflict [IssueRef](https://github.com/nix-community/nixops-encrypted-links/issues/2)
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
Flake Attribute Name             Binary Ver (*)        Comment
-------------------------        --------------        -----------------------------------------------------------------------
nixops_1_7-iohk-unstable         1.7pre0_abcdef        Plugins: aws, hetzner, packet, libvirtd, vbox
nixops_1_8-nixos-unstable        1.8pre0_abcdef        Plugins: aws, hetzner, packet, libvirtd, vbox
nixops_2_0-2020-07-unstable      @version@             Plugins: aws, gcp, packet, libvirtd(!), vbox, contrib, encrypted-links(1)
nixops_2_0-2021-01-unstable      @version@             Plugins: aws, gcp, packet, libvirtd(!), vbox, contrib, encrypted-links(1)

(!) = There is a build error of the `libvirtd` plugin on Darwin at the moment
(*) = To do: Fix up the builds to show proper version and commit rev from `nixops --version`
(1) = Currently incompatible with packet
```

* Nixops versions can be built impurely from the attribute names above, with specified plugins (at least one of `${PLUGIN}`):
```
# For attributes from a remote repo not yet cloned:
nix <build|shell> --impure --expr '(builtins.getFlake "github:input-output-hk/nixops/versions")'\
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
nix <build|shell> github:input-output-hk/nixops/versions

# For the default nixops package from a cloned repo in the root dir:
nix build
nix shell .#
```


## Nixops Version Commit Information

### nixops_2_0-2021-01-unstable (@version@)

* Pure builds are compiled with all mentioned plugins (except for libvirtd on Darwin)
* Impure builds may be used to selectively choose plugins
* Plugins available are aws, gcp, packet, libvirtd(!), vbox, nixos-modules-contrib ("contrib below"), encrypted-links ("links" below):
```
Component      Tag         Commit Date     Commit Revision                             Repo
-----------    --------    -----------     ----------------------------------------    ------------------------------------------------
nixops         > 1.7       2020-12-26      ed2868fbc0b5924fcd4a60a8bd32a14fa196381b    github:NixOS/nixops
aws            > v1.0.0    2020-11-27      ce9e0ae63981c5c727a688eec5c314e38694eba2    github:NixOS/nixops-aws
gcp                        2020-12-26      4ac78a5a7f30170e58d4f376e46ab84736fbc046    github:nix-community/nixops-gce
packet         > v0.0.4    2020-09-12      cdeba70d6c2c878ad462e119e1accb935e974ac8    github:input-output-hk/nixops-packet
libvirtd(!)    > v1.0.0    2020-07-13      af6cf5b2ced57b7b6d36b5df7dd27a14e0a5cfb6    github:nix-community/nixops-libvirtd
vbox           > v1.0.0    2020-07-17      2729672865ebe2aa973c062a3fbddda8c1359da0    github:nix-community/nixops-vbox
links(1)                   2020-07-13      045d25facbf52dcd63b005392ecd59005fb1d20a    github:nix-community/nixops-encrypted-links
contrib(*)                 2020-07-10      6e4d21f47f0c40023a56a9861886bde146476198    github:nix-community/nixos-modules-contrib

(!) = There is a build error of the `libvirtd` plugin on Darwin at the moment
(*) = The nixos-modules-contrib plugin is not optional -- it is always included
(1) = Currently incompatible with packet
```


### nixops_2_0-2020-07-unstable (@version@)

* Pure builds are compiled with all mentioned plugins
* Impure builds may be used to selectively choose plugins
* Plugins available are aws, gcp, packet, libvirtd (!), vbox, nixos-modules-contrib ("contrib below"), encrypted-links ("links" below):
```
Component      Tag         Commit Date     Commit Revision                             Repo
-----------    --------    -----------     ----------------------------------------    ------------------------------------------------
nixops         > 1.7       2020-07-15      0330ead36be75c0b0f80cf84c227f13380daf414    github:NixOS/nixops
aws            > v1.0.0    2020-07-16      36a200f1baec9c97590cf1c2ad2ad02fd88504cf    github:NixOS/nixops-aws
gcp                        2020-07-10      f761368c248711085542efec604971651ca14033    github:nix-community/nixops-gce
packet         > v0.0.4    2020-09-12      cdeba70d6c2c878ad462e119e1accb935e974ac8    github:input-output-hk/nixops-packet
libvirtd(!)    > v1.0.0    2020-07-13      af6cf5b2ced57b7b6d36b5df7dd27a14e0a5cfb6    github:nix-community/nixops-libvirtd
vbox           > v1.0.0    2020-07-10      562760e68cbe7f82eaf25c78563c967706dc161a    github:nix-community/nixops-vbox
links(1)                   2020-07-13      045d25facbf52dcd63b005392ecd59005fb1d20a    github:nix-community/nixops-encrypted-links
contrib(*)                 2020-07-10      6e4d21f47f0c40023a56a9861886bde146476198    github:nix-community/nixos-modules-contrib

(!) = Note that there is a build error of the `libvirtd` plugin on Darwin at the moment
(*) = The nixos-modules-contrib plugin is not optional -- it is always included
(1) = Currently incompatible with packet
```


### nixops_1_8-nixos-unstable (1.8pre0_abcdef)

* Pure builds are compiled with all mentioned plugins
* Impure builds may be used to selectively choose plugins
* Plugins available are aws, hetzner, packet, libvirtd, vbox:
```
Component      Tag         Commit Date     Commit Revision                             Repo
-----------    --------    -----------     ----------------------------------------    ------------------------------------------------
nixops         > 1.7       2019-11-19      360342437d236060c9951b7fdfdea49bdeb46b6b    github:NixOS/nixops
aws            v1.0.0      2019-08-27      5a267e66de4b239f640bbbf43bb41bd72f2cbee3    github:NixOS/nixops-aws
hetzner        v1.0.1      2019-10-28      6245ca44f3682e45d6d82cee7d873f76b51ff693    github:NixOS/nixops-hetzner
packet         > v0.0.4    2020-02-15      08992f6f69dbe1d7f98783d43bb2be758f8d6676    github:input-output-hk/nixops-packet
libvirtd       v1.0.0      2019-10-21      1c29f6c716dad9ad58aa863ebc9575422459bf95    github:nix-community/nixops-libvirtd
vbox           > v1.0.0    2019-10-28      bff6054ce9e7f5f9aa830617577f1a511a461063    github:nix-community/nixops-vbox
```


### nixops_1_7-iohk-unstable (1.7pre0_abcdef)

* Pure builds are compiled with all mentioned plugins
* Impure builds may be used to selectively choose plugins
* Plugins available are aws, hetzner, packet, libvirtd, vbox:
```
Component      Tag         Commit Date     Commit Revision                                 Repo
-----------    --------    -----------     ----------------------------------------    ------------------------------------------------
nixops                     2020-06-05      2a94052d3d69953d098b917b392f2e134b499791    github:input-output-hk/nixops/nixops-core-pr-int
aws            v1.0.0      2019-08-27      5a267e66de4b239f640bbbf43bb41bd72f2cbee3    github:NixOS/nixops-aws
hetzner        v1.0.1      2019-10-28      6245ca44f3682e45d6d82cee7d873f76b51ff693    github:NixOS/nixops-hetzner
packet         > v0.0.4    2020-02-15      08992f6f69dbe1d7f98783d43bb2be758f8d6676    github:input-output-hk/nixops-packet
libvirtd       v1.0.0      2019-10-21      1c29f6c716dad9ad58aa863ebc9575422459bf95    github:nix-community/nixops-libvirtd
vbox           > v1.0.0    2019-10-28      bff6054ce9e7f5f9aa830617577f1a511a461063    github:nix-community/nixops-vbox
```


### nixops_1_7-preplugin-unstable (1.7pre2764_932bf43)

```
Component      Tag         Commit Date     Commit Revision                             Repo
-----------    --------    -----------     ----------------------------------------    ------------------------------------------------
nixops         1.7         2019-04-17      932bf43f0eb857edcf55742f239f459451ab47e5    github:NixOS/nixops
```


### nixops_1_7-preplugin (1.7)

```
Component      Tag         Commit Date     Commit Revision                             Repo
-----------    --------    -----------     ----------------------------------------    ------------------------------------------------
nixops         1.7         2019-06-27      b2856a5c079742b456aad64b7fcca36cf2b03011    github:NixOS/nixops/release-1.7
```


### nixops_1_6_1-preplugin (1.6.1)

```
Component      Tag         Commit Date     Commit Revision                             Repo
-----------    --------    -----------     ----------------------------------------    ------------------------------------------------
nixops         1.6.1       2018-09-14      3d5e816e622b7863daa76732902fd20dba72a0b8    github:NixOS/nixops
```


## Repo URLs For the Plugins Referenced Above

* Nixops: `nixops` [https://github.com/NixOS/nixops](https://github.com/NixOS/nixops)
* Plugin `aws` [https://github.com/NixOS/nixops-aws](https://github.com/NixOS/nixops-aws)
* Plugin `gcp` [https://github.com/nix-community/nixops-gce](https://github.com/nix-community/nixops-gce)
* Plugin `packet` [https://github.com/input-output-hk/nixops-packet](https://github.com/input-output-hk/nixops-packet)
* Plugin `libvirtd` [https://github.com/nix-community/nixops-libvirtd](https://github.com/nix-community/nixops-libvirtd)
* Plugin `vbox` [https://github.com/nix-community/nixops-vbox](https://github.com/nix-community/nixops-vbox)
* Plugin `links` [https://github.com/nix-community/nixops-encrypted-links](https://github.com/nix-community/nixops-encrypted-links)
* Plugin `contrib` [https://github.com/nix-community/nixos-modules-contrib](https://github.com/nix-community/nixos-modules-contrib)


## Notes

* A `nix flake show` command will break due to an issue with IFD and flakes.
* This appears to be cosmetic and will be fixed when there is a suitable workaround.  [IssueRef](https://discourse.nixos.org/t/how-to-use-flakes-with-ifd/10300)
* Testing was done at nix version `nix (Nix) 2.4pre20201205_a5d85d0`


## To Do

* Where not already done, embed the version and commit revision into the attributes so `nixops --version` command displays these


## Reminders

### Generating an Updated Poetry Nixops2 Patch File

* From the nixops2 PR nixpkgs commit, git init to begin tracking changes for a patch and then make the following modifications:
```
* Run the update script for poetry at: pkgs/development/tools/poetry2nix/update
* Add a packet-python poetry override to: pkgs/development/tools/poetry2nix/poetry2nix/overrides.nix

    packet-python = super.packet-python.overridePythonAttrs (
      old: {
        buildInputs = old.buildInputs ++ [ self.pytest-runner ];
      }
    );

* If needed, adjust the pyproject.toml file for the new nixops version at: pkgs/tools/package-management/nixops2/pyproject.toml
* If needed, adjust the default.nix file for the new nixops version at: pkgs/tools/package-management/nixops2/default.nix
* Run the update script for nixops2 at: pkgs/tools/package-management/nixops2/update
* Add all diffs from the command above: git add ${CHANGED_FILES[@]}
* Generate a patch file: git diff --cached > new_patch.diff
* Use the new patch with nixops2 package generator in this repo: pkgs/nixops_2-unstable.nix
```
