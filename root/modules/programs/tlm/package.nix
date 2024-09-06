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
    hash = "sha256-bVo2rumMrrJrFFvmpbrfHANmn3FfwjcJ8bT8svBbI8A=";
  };

  vendorHash = "sha256-hd/xj/PX0p7Ol0zan420QQzXbZLoDZRI1VQmcraeOTc=";

  doCheck = false;

  meta = {
    description = "Local CLI Copilot, powered by CodeLLaMa.";
    mainProgram = "tlm";
    homepage = "https://github.com/yusufcanb/tlm";
    changelog = "https://github.com/yusufcanb/tlm/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
