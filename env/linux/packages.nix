{ pkgs }: {
  home.packages = with pkgs; [
    # Programming tools
    docker
    docker-compose
    lazydocker
  ];
}
