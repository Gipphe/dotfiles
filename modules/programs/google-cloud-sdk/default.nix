{
  util,
  config,
  pkgs,
  lib,
  ...
}:
let
  region = "europe-west1-b";
  mkCommon = alias: {
    name = alias;
    inherit alias region;
    project = "strise-common";

  };
  mkCosmos = alias: {
    inherit alias region;
    name = "cosmos";
    project = alias;
  };

  common_ns = [
    "jenkins"
    "shared"
    "janitor"
    "knowledge"
  ];
  cosmos = [
    "strise-stage"
    "strise-prod"
  ];
  inherit (builtins) map concatLists;
  default_clusters = concatLists [
    (map mkCommon common_ns)
    (map mkCosmos cosmos)
  ];

  gcloud = pkgs.google-cloud-sdk.withExtraComponents (
    with pkgs.google-cloud-sdk.components;
    [
      bq
      gke-gcloud-auth-plugin
      kubectl
    ]
  );

  addClusters = pkgs.writeShellApplication {
    name = "add-clusters";
    runtimeInputs = [
      gcloud
      pkgs.kubectx
    ];
    text = ''
      add-cluster-if-missing() {
        project=$1
        name=$2
        region=$3
        alias=$4
        if test -z "$project" || test -z "$name" || test -z "$region" || test -z "$alias"; then
          echo "Usage: add-cluster-if-missing <project> <name> <region> <alias>" >&2
          exit 1
        fi
        aliases=$(kubectx)
        if [[ ! $aliases =~ $alias ]]; then
          gcloud container clusters get-credentials "$name" --internal-ip --project "$project" --region "$region"
          kubectx "$alias"=gke_"$project"_"$region"_"$name"
        fi
      }

      ${lib.concatStringsSep "\n" (
        map (cluster: ''
          add-cluster-if-missing '${cluster.project}' '${cluster.name}' '${cluster.region}' '${cluster.alias}'
        '') config.gipphe.programs.google-cloud-sdk.clusters
      )}
    '';
  };
in
util.mkProgram {
  name = "google-cloud-sdk";
  options.gipphe.programs.google-cloud-sdk.clusters = lib.mkOption {
    description = "clusters";
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          alias = lib.mkOption {
            description = "Alias for the cluster.";
            default = throw "Missing alias for cluster.";
            type = lib.types.str;
          };
          name = lib.mkOption {
            description = "Name of the cluster.";
            default = throw "Missing name for cluster.";
            type = lib.types.str;
          };
          project = lib.mkOption {
            description = "Project name of the cluster.";
            default = throw "Missing project for cluster.";
            type = lib.types.str;
          };
          region = lib.mkOption {
            description = "Region of the cluster.";
            default = throw "Missing region for the cluster.";
            type = lib.types.str;
          };
        };
      }
    );
    default = default_clusters;
  };
  hm = {
    home = {
      packages = [
        gcloud
        addClusters
      ];
      activation.google-cloud-sdk-credentials = lib.hm.dag.entryAfter [ "onFilesChange" ] ''
        run ${lib.getExe addClusters}
      '';
    };
  };
}
