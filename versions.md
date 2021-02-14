# Nixops Version Information

## Overview

* The information below contains each available nixops flake output attribute (in the section header name) along with corresponding source pin information.


## Repo URLs For the Plugins Referenced Below

* Nixops: `nixops` [https://github.com/NixOS/nixops](https://github.com/NixOS/nixops)
* Plugin: `aws` [https://github.com/NixOS/nixops-aws](https://github.com/NixOS/nixops-aws)
* Plugin: `contrib` [https://github.com/nix-community/nixos-modules-contrib](https://github.com/nix-community/nixos-modules-contrib)
* Plugin: `gcp` [https://github.com/nix-community/nixops-gce](https://github.com/nix-community/nixops-gce)
* Plugin: `libvirtd` [https://github.com/nix-community/nixops-libvirtd](https://github.com/nix-community/nixops-libvirtd)
* Plugin: `links` [https://github.com/nix-community/nixops-encrypted-links](https://github.com/nix-community/nixops-encrypted-links)
* Plugin: `packet` [https://github.com/input-output-hk/nixops-packet](https://github.com/input-output-hk/nixops-packet)
* Plugin: `vbox` [https://github.com/nix-community/nixops-vbox](https://github.com/nix-community/nixops-vbox)
* Plugin: `wg-links` [https://github.com/input-output-hk/nixops-wg-links](https://github.com/input-output-hk/nixops-wg-links)


## Nixops Version Commit Information

### nixops_2_0-2021-02-unstable (@version@)

* Pure builds are compiled with all mentioned plugins except for `encrypted-links`.
* Impure builds may be used to selectively choose plugins.
* Plugins available are aws, gcp, packet, libvirtd, vbox, nixos-modules-contrib ("contrib below"), encrypted-links ("links" below) and wg-links:
* Attribute Notes:
  * wg-links is a new plugin available which supports easy setup of wireguard mesh or star topologies to deployments.
    * It hasn't been throughly test yet and should be considered alpha quality.
  * The libvirtd plugin now builds again on Darwin and has been re-added to the pure build.
  * The encrypted-links plugin throws an error when deploying with `--include` or `--exclude` and so is not included in the pure build until fixed.
```
Component      Tag         Commit Date     Commit Revision                             Repo
-----------    --------    -----------     ----------------------------------------    ------------------------------------------------
nixops         > 1.7       2021-02-11      23db83fc91952d2dbcc64b8aa1ac16f8c8f45bed    github:NixOS/nixops
aws            > v1.0.0    2021-02-01      dbbaa1b15b6cf7ca1ceeb0a6195f5ee27693c505    github:NixOS/nixops-aws
gcp                        2021-02-10      fed6aadace9a9e914425589c065bb969d53f2309    github:nix-community/nixops-gce
packet         > v0.0.4    2021-02-14      da0421fc93240f822f9668bfb86096e4da19022b    github:input-output-hk/nixops-packet
libvirtd       > v1.0.0    2020-07-13      af6cf5b2ced57b7b6d36b5df7dd27a14e0a5cfb6    github:nix-community/nixops-libvirtd
vbox           > v1.0.0    2020-07-17      2729672865ebe2aa973c062a3fbddda8c1359da0    github:nix-community/nixops-vbox
links(!)                   2021-01-18      0bb9aa50a7294ee9dca10a18ff7d9024234913e1    github:nix-community/nixops-encrypted-links
wg-links                   2021-02-12      153f34ac8cba21b08641b4fd41f1595576be683e    github:input-output-hk/nixops-wg-links
contrib(*)                 2021-01-20      81a1c2ef424dcf596a97b2e46a58ca73a1dd1ff8    github:nix-community/nixos-modules-contrib

(!) = encrypted-links has a known partial deployment bug when using `--include` or `--exclude`
(*) = The nixos-modules-contrib plugin is a plugin dependency of some other plugins like `aws`
```


### nixops_2_0-2021-01-unstable (@version@)

* Pure builds are compiled with all mentioned plugins (except for libvirtd on Darwin).
* Impure builds may be used to selectively choose plugins.
* Plugins available are aws, gcp, packet, libvirtd(!), vbox, nixos-modules-contrib ("contrib below"), encrypted-links ("links" below):
* Attribute Notes:
  * The encrypted-links plugin has been fixed.
```
Component      Tag         Commit Date     Commit Revision                             Repo
-----------    --------    -----------     ----------------------------------------    ------------------------------------------------
nixops         > 1.7       2021-01-18      1239ff7fb94bd647ea54d18e7c7da4b81e63f422    github:NixOS/nixops
aws            > v1.0.0    2020-11-27      ce9e0ae63981c5c727a688eec5c314e38694eba2    github:NixOS/nixops-aws
gcp                        2020-12-26      4ac78a5a7f30170e58d4f376e46ab84736fbc046    github:nix-community/nixops-gce
packet         > v0.0.4    2021-01-17      9e800f5cf9b0b387f4b96683f2dac16e7b56abb6    github:input-output-hk/nixops-packet
libvirtd(!)    > v1.0.0    2020-07-13      af6cf5b2ced57b7b6d36b5df7dd27a14e0a5cfb6    github:nix-community/nixops-libvirtd
vbox           > v1.0.0    2020-07-17      2729672865ebe2aa973c062a3fbddda8c1359da0    github:nix-community/nixops-vbox
links                      2021-01-18      0bb9aa50a7294ee9dca10a18ff7d9024234913e1    github:nix-community/nixops-encrypted-links
contrib(*)                 2020-07-10      6e4d21f47f0c40023a56a9861886bde146476198    github:nix-community/nixos-modules-contrib

(!) = There is a build error of the `libvirtd` plugin on Darwin at the moment
(*) = The nixos-modules-contrib plugin is a plugin dependency of some other plugins like `aws`
```


### nixops_2_0-2020-07-unstable (@version@)

* Pure builds are compiled with all mentioned plugins.
* Impure builds may be used to selectively choose plugins.
* Plugins available are aws, gcp, packet, libvirtd (!), vbox, nixos-modules-contrib ("contrib below"), encrypted-links ("links" below):
* Attribute Notes:
  * Due to bugs in the encrypted-links plugin, only impure builds without the encrypted-links plugin are functional.
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
(*) = The nixos-modules-contrib plugin is a plugin dependency of some other plugins like `aws`
(1) = Currently incompatible with other plugins due to bugs
```


### nixops_1_8-nixos-unstable (1.8pre0_abcdef)

* Pure builds are compiled with all mentioned plugins.
* Impure builds may be used to selectively choose plugins.
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

* Pure builds are compiled with all mentioned plugins.
* Impure builds may be used to selectively choose plugins.
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
