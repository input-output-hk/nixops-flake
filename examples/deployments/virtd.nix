{
  network.description = "virtd";

  machine1 = { config, pkgs, ... }: {
    deployment.targetEnv = "libvirtd";
  };
}
