{
  jdenticon-cli,
  findutils,
  writeFishApplication,
}:
let
  help = "Generate jdenticons for all hosts";
  name = "md:icons";
in
writeFishApplication {
  inherit name;
  runtimeInputs = [
    jdenticon-cli
    findutils
  ];
  text = # fish
    ''
      function info
        echo "$args" > &2
      end
      if contains "--help" $args || contains "-h" $args
        info "${name} - ${help}"
        exit 0
      end

      set hosts (find ./machines/* -maxdepth 0 -type d -exec basename {} \;)
      or begin
        echo "Machines are not here" >&2
        exit 1
      end

      mkdir -p assets/icon

      for host in $hosts
        jdenticon "$host" -s 100 -o "assets/icon/$host.png"
      end
    '';
}
