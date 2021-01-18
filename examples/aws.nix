let
  region = "us-east-2";
  accessKeyId = "profile";
in {
  network.description = "aws";

  resources = {
    ec2KeyPairs.awsKey = { inherit region accessKeyId; };
    ec2SecurityGroups.allowSsh = {
      inherit region accessKeyId;
      name = "allowSsh";
      description = "Allow SSH";
      rules = [
        { fromPort = 22;  toPort = 22;  sourceIp = "0.0.0.0/0"; }
      ];
    };
    elasticIPs.awsIp = { inherit region accessKeyId; };
  };

  machine1 = { resources, config, pkgs, ... }: {
    deployment = {
      targetEnv = "ec2";
      ec2 = {
        inherit region accessKeyId;
        instanceType = "t3.small";
        ebsInitialRootDiskSize = 30;
        ebsOptimized = true;
        keyPair = resources.ec2KeyPairs.awsKey;
        elasticIPv4 = resources.elasticIPs.awsIp;
        securityGroups = [ resources.ec2SecurityGroups.allowSsh ];
      };
    };
  };
}
