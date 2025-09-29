{ util, ... }:
util.mkToggledModule [ "lovdata" ] {
  name = "git";
  hm = {
    programs.git.includes = [
      {
        condition = "gitdir:**/lovdata/**/.git";
        contents = {
          user = {
            name = "Victor Nascimento Bakke";
            email = "vnb@lovdata.no";
          };
        };
      }
    ];
    xdg.configFile."git/allowed_signers".text = ''
      vnb@lovdata.no namespaces="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINzkW4CGcY2zjXnWx1o7uy85D0O7OvjzTa51GLtA0uQv
    '';
  };
}
