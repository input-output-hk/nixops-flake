with { pkgs = import ./nix { }; };
pkgs.mkShell {
  buildInputs = with pkgs; [
    niv
    nixops
    nixops-custom
  ];
}
