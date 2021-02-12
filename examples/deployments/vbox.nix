{
  network.description = "vbox";

  machine1 = { config, pkgs, ... }: {
    deployment.targetEnv = "virtualbox";
  };
}
