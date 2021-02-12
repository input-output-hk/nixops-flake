{
  network.description = "links";

  machine1 = { config, pkgs, ... }: {
    deployment = {
      targetEnv = "virtualbox";
      encryptedLinksTo = [ "machine2" ];
    };
  };

  machine2 = { config, pkgs, ... }: {
    deployment = {
      targetEnv = "virtualbox";
      encryptedLinksTo = [ "machine1" ];
    };
  };
}
