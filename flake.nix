{
  description = "Flake containing various nixops versions utilized at IOHK over time";

  # nixConfig = { ... };

  inputs = {
    # Supporting inputs
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";

    # Top level nixpkgs version inputs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";

    # Nixops pre plugins related repo pinned inputs
    # Commit pin from branch nixos-20.09
    nixpkgs-pin = {
      url = "github:NixOS/nixpkgs?rev=c30ad096b2cd5f64d479a70e656b315ea5e96ae9";
    };


    # Nixops post plugins 1.7 related repo pinned inputs
    nixpkgs-plugin-1 = {
      # Commit pin from branch: release-19.09
      url = "github:NixOS/nixpkgs?rev=f79f998f3163481a4d4ae90e8ea516df3980fe9f";
      flake = false;
    };

    nixops_1_7-plugin-core-iohk = {
      # Commit pin from branch: nixops-core-pr-int
      url = "github:input-output-hk/nixops?rev=2a94052d3d69953d098b917b392f2e134b499791";
      flake = false;
    };

    nixops_1_8-plugin-core-nixos = {
      # Commit pin from branch: master
      # This is actually 2 commits into the 1.8 version to include a reboot exception fix
      url = "github:NixOS/nixops?rev=360342437d236060c9951b7fdfdea49bdeb46b6b";
      flake = false;
    };

    nixops_1_7-plugin-aws = {
      # Commit pin from branch: master, v1.0.0 tag
      url = "github:NixOS/nixops-aws?rev=5a267e66de4b239f640bbbf43bb41bd72f2cbee3";
      flake = false;
    };

    nixops_1_7-plugin-vultr = {
      # Commit pin from branch: master, v1.0.1 tag
      url = "github:disassembler/nixops-vultr";
      flake = false;
    };

    nixops_1_7-plugin-hetzner = {
      # Commit pin from branch: master, v1.0.1 tag
      url = "github:NixOS/nixops-hetzner?rev=6245ca44f3682e45d6d82cee7d873f76b51ff693";
      flake = false;
    };

    nixops_1_7-plugin-packet = {
      # Commit pin from branch: master
      url = "github:input-output-hk/nixops-packet?rev=08992f6f69dbe1d7f98783d43bb2be758f8d6676";
      flake = false;
    };

    nixops_1_7-plugin-libvirtd = {
      # Commit pin from branch: master, v1.0.0 tag
      url = "github:nix-community/nixops-libvirtd?rev=1c29f6c716dad9ad58aa863ebc9575422459bf95";
      flake = false;
    };

    nixops_1_7-plugin-vbox = {
      # Commit pin from branch: master
      url = "github:nix-community/nixops-vbox?rev=bff6054ce9e7f5f9aa830617577f1a511a461063";
      flake = false;
    };


    # Nixops 2.X related repo pinned inputs
    nixpkgs-plugin-2 = {
      # Commit pin from branch: master
      url = "github:NixOS/nixpkgs?rev=714fac4cc9ba9b0ef29964c8b7fd9d50455aa380";
      flake = false;
    };

    nixpkgs-plugin-2-2021-02 = {
      # Commit pin from branch: master
      url = "github:NixOS/nixpkgs?rev=1ca7cd20ace967b3740893231e1586069e223af5";
    };

    # Keep this updated to the latest nixpkgs patch so the setup-patchdir.sh pin
    # doesn't need to change
    nixpkgs-plugin-2-latest = {
      # Commit pin from branch: master
      url = "github:NixOS/nixpkgs?rev=1ca7cd20ace967b3740893231e1586069e223af5";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-pin, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ] (system: let
      pkgs = import nixpkgs-pin {
        inherit system;
      };
      inherit (pkgs) lib;
    in rec {
      overlay = import ./overlay.nix { inherit self system pkgs; };

      defaultPackage = packages.nixops_2_0-latest-unstable;
      defaultApp = apps.info;

      legacyPackages = import nixpkgs {
        inherit system;
        overlays = [ overlay ];
      };

      packages = {
        inherit (legacyPackages)
          nixops_2_0-latest-unstable
          nixops_2_0-2021-02-unstable
          nixops_2_0-2021-01-unstable
          nixops_2_0-2020-07-unstable
          nixops_1_8-nixos-unstable
          nixops_1_7-iohk-unstable
          nixops_1_7-preplugin-unstable
          nixops_1_7-preplugin
          nixops_1_6_1-preplugin;
      };

      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixfmt
        ];
      };

      impure = let
        mkNixops_1 = nixopsCore: coreVersion: p: pkgs.callPackage ./pkgs/nixops_1-unstable.nix {
          inherit self system pkgs nixopsCore coreVersion p;
          validPlugins = [ "aws" "hetzner" "packet" "virtd" "vbox" ];
        };

        mkNixops_2 = patches: p: pkgs.callPackage ./pkgs/nixops_2-unstable.nix {
          inherit self system pkgs patches p;
          validPlugins = [ "aws" "encrypted-links" "gcp" "virtd" "packet" "vbox" "vultr" ];
        };

        mkNixops_2-2021-02 = nixpkgs-src: patches: p: pkgs.callPackage ./pkgs/nixops_2-2021-02-unstable.nix {
          inherit self system pkgs nixpkgs-src patches p;
          validPlugins = [ "aws" "encrypted-links" "gcp" "virtd" "packet" "vbox" "wg-links" "vultr" ];
        };
      in rec {
        nixops_1_7-iohk-unstable = p: mkNixops_1 "core-iohk" "1_7" p;
        nixops_1_8-nixos-unstable = p: mkNixops_1 "core-nixos" "1_8" p;
        nixops_2_0-2020-07-unstable = p: mkNixops_2 [ ./patches/nixpkgs-pr83548-2020-07.diff ] p;
        nixops_2_0-2021-01-unstable = p: mkNixops_2 [ ./patches/nixpkgs-pr83548-2021-01.diff ] p;
        nixops_2_0-2021-02-unstable = p: mkNixops_2-2021-02 self.inputs.nixpkgs-plugin-2-2021-02 [ ./patches/nixpkgs-2021-02.diff ] p;
        nixops_2_0-latest-unstable = nixops_2_0-2021-02-unstable;
      };

      apps = {
        info = flake-utils.lib.mkApp {
          drv = pkgs.writeShellScriptBin "info" ''
            echo
            echo "NIXOPS VERSIONS INFO"
            echo
            echo "See the repo README.md file for a detailed description of each attribute and usage examples."
            echo
            echo "  https://github.com/input-output-hk/nixops-flake"
            echo
            echo
            echo "The following nixops packages are available from this flake:"
            echo
            echo "  ${lib.concatMapStringsSep "\n  " (s: s) (builtins.attrNames packages)}"
            echo
            echo
            echo "To summarize, these attributes (as \''${ATTRIBUTE}) can be built via flake, purely, with:"
            echo
            echo "  nix <build|shell> github:input-output-hk/nixops-flake#\''${ATTRIBUTE}"
            echo
            echo
            echo "This flakes nixops attributes can be built impurely, with specified plugins available (at least one of \''${PLUGIN}):"
            echo
            echo "  ${lib.concatMapStringsSep "\n  " (s: s) (builtins.attrNames impure)}"
            echo
            echo "nix <build|shell> --impure --expr '(builtins.getFlake \"github:input-output-hk/nixops-flake\")'\\"
            echo "'.impure.\''${builtins.currentSystem}.\''${ATTRIBUTE} [ \''${PLUGIN} ]'"
            echo
            echo "  where \''${PLUGIN} is of (with quotes):"
            echo
            echo "    \"aws\""
            echo "    \"encrypted-links\""
            echo "    \"gcp\""
            echo "    \"hetzner\""
            echo "    \"vultr\""
            echo "    \"packet\""
            echo "    \"vbox\""
            echo "    \"virtd\""
            echo "    \"wg-links\""
            echo
            echo "  and where \`(toString ./.)\` can be substituted for the remote flake path in the command above if you are in a root local repo dir."
            echo
            echo
            echo "A repl of this flake can be run by any of:"
            echo
            echo "  nix run github:input-output-hk/nixops-flake#repl-remote         # A repl for the remote flake not yet cloned locally"
            echo "  nix run .#repl                                                  # A repl for a local flake from the root repo dir"
            echo "  nix repl repl.nix                                               # A repl for a local flake from the root repo dir"
            echo
            echo
            echo "Legacy packages are also available from this flake from the \`legacyPackages.\''${system}.nixops*\` attributes via overlay."
            echo
          '';
        };
        repl = flake-utils.lib.mkApp {
          drv = pkgs.writeShellScriptBin "repl" ''
            replNix="$(mktemp)"
            echo "builtins.getFlake (toString $(git rev-parse --show-toplevel))" > $replNix
            trap "rm $replNix" EXIT
            nix repl $replNix
          '';
        };
        repl-remote = flake-utils.lib.mkApp {
          drv = pkgs.writeShellScriptBin "repl" ''
            replNix="$(mktemp)"
            echo "builtins.getFlake \"github:input-output-hk/nixops-flake\"" > $replNix
            trap "rm $replNix" EXIT
            nix repl $replNix
          '';
        };
      };
    }
  ) // { hydraJobs = self.packages; };
}
