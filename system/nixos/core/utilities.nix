{
  programs.ssh.startAgent = true;
  programs.gnupg.agent = {
    enable = true;
  };
}
