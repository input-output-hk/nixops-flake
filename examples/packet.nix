let
  accessKeyId = "...";
  projectId = "...";
in {
  network.description = "packet";

  resources.packetKeyPairs.packetKey = {
    inherit accessKeyId;
    project = projectId;
  };

  machine1 = { resources, ... }: {
    deployment.targetEnv = "packet";
    deployment.packet = {
      inherit accessKeyId;
      keyPair = resources.packetKeyPairs.packetKey;
      project = projectId;
      facility = "any";
      plan = "c3.medium.x86";
      ipxeScriptUrl = "http://images.platformequinix.net/nixos/installer-pre2/x86/netboot.ipxe";
    };
  };
}
