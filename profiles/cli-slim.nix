{ util, ... }:
util.mkProfile {
  name = "cli-slim";
  shared.gipphe.programs = {
    atuin.enable = true;
    bat.enable = true;
    btop.enable = true;
    curl.enable = true;
    direnv.enable = true;
    dua.enable = true;
    entr.enable = true;
    eza.enable = true;
    fd.enable = true;
    fish.enable = true;
    fx.enable = true;
    gh.enable = true;
    git.enable = true;
    glab.enable = true;
    glow.enable = true;
    gnugrep.enable = true;
    gnused.enable = true;
    gnutar.enable = true;
    gpg.enable = true;
    gum.enable = true;
    jnv.enable = true;
    jq.enable = true;
    jujutsu.enable = true;
    less.enable = true;
    nh.enable = true;
    nixCats.enable = true;
    nushell.enable = true;
    ripgrep.enable = true;
    serpl.enable = true;
    ssh.enable = true;
    unzip.enable = true;
    yazi.enable = true;
    zellij.enable = true;
    zoxide.enable = true;
  };
}
