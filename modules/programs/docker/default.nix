{ util, ... }:
util.mkProgram {
  name = "docker";
  hm.programs.fish.shellAbbrs = {
    docker_clean_images = "docker rmi (docker images -a --filter=dangling=true -q)";
    docker_clean_ps = "docker rm (docker ps --filter=status=exited --filter=status=created -q)";
    docker_clean_testcontainer = ''docker rmi -f (docker images --filter="reference=*-*-*-*-*:*-*-*-*-*" --format "{{ .ID }}" | sort | uniq)'';
    docker_pull_images = "docker images --format '{{.Repository}}:{{.Tag}}' | xargs -n 1 -P 1 docker pull";
  };
  system-nixos.virtualisation.docker.enable = true;
  system-darwin.homebrew.casks = [ "docker" ];
}
