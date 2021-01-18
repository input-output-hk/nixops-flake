{
  network.description = "none";

  # ssh-add an authorized ssh agent key so that the initial ssh connection will succeed
  # Ensure that the machine name is resolvable, for example, with ssh config.d file

  machine1 = { config, pkgs, ... }: {
    deployment.targetEnv = "none";
    networking.publicIPv4 = "...";
    boot.loader.grub.device = "/dev/sda";
    fileSystems = {
      "/" = {
        device = "/dev/sda1";
        fsType = "ext4";
      };
    };
  };
}
