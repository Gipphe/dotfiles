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

  addClusterIfMissing = util.writeFishApplication rec {
    name = "add_cluster_if_missing";
    runtimeInputs = [
      pkgs.kubectx
      gcloud
    ];
    runtimeEnv = {
      script_name = name;
    };
    text = # fish
      ''
        argparse --name $script_name 'p/project=' 'n/name=' 'r/region=' 'a/alias=' -- $argv
        or return

        set -l aliases $(kubectx)
        string match -rq $_flag_alias $aliases
        if test $status != 0
          gcloud container clusters get-credentials "$_flag_name" --internal-ip --project "$_flag_project" --region "$_flag_region"
          kubectx "$_flag_alias"=gke_"$_flag_project"_"$_flag_region"_"$_flag_name"
        end
      '';
  };
  addClusters = lib.pipe config.gipphe.programs.google-cloud-sdk.clusters [
    (map (
      cluster:
      pkgs.writeShellScriptBin "add_${cluster.alias}_cluster" ''
        ${lib.getExe addClusterIfMissing} --project '${cluster.project}' --name '${cluster.name}' --region '${cluster.region}' --alias '${cluster.alias}'
      ''
    ))
    (map lib.getExe)
    (lib.concatStringsSep "; ")
    (pkgs.writeShellScriptBin "add_clusters")
  ];
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
      packages = [ gcloud addClusters ];
      # activation.google-cloud-sdk-credentials = lib.hm.dag.entryAfter [ "onFilesChange" ] ''
      #   run ${lib.getExe addClusters}
      # '';
    };
  };
}
