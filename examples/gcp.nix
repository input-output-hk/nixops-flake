let
  project = "...";
  serviceAccount = "...";
  accessKey = "...";
  rootDiskSize = 10;
  region = "us-central1-a";
in {
  network.description = "gcp";

  machine1 = {
    deployment.targetEnv = "gce";
    deployment.gce = {
      inherit project serviceAccount accessKey rootDiskSize region;
      instanceType = "e2-micro";
    };
  };
}
