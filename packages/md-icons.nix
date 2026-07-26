{
  jdenticon-cli,
  findutils,
  writeNushellApplication,
}:
writeNushellApplication {
  name = "md:icons";
  runtimeInputs = [
    jdenticon-cli
    findutils
  ];
  text = /* nu */ ''
    # Generate jdenticons for all hosts
    def main []: nothing -> nothing {
      let hosts = (ls ./hosts | where type == dir | each { $in.name })
      if ($hosts | length) == 0 {
        print -e "Hosts are not here"
        exit 1
      }

      mkdir assets/icon

      $hosts | par-each { |host| 
        jdenticon $host -s 100 -o $"assets/icon/($host).png"
      }
    }
  '';
}
