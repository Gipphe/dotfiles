{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "tlm";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "yusufcanb";
    repo = pname;
    rev = version;
    hash = "";
  };

  vendorHash = "";

  meta = {
    description = "Local CLI Copilot, powered by CodeLLaMa.";
    mainProgram = "tlm";
    homepage = "https://github.com/yusufcanb/tlm";
    changelog = "https://github.com/yusufcanb/tlm/releases/tag/${src.rev}";
    license = lib.licenses.as120;
    maintainers = [ ];
  };
}
