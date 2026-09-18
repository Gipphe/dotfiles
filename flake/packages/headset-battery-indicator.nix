{
  python3,
  pyproject-nix,
  headset-battery-indicator,
}:
let
  python = python3;
  project = pyproject-nix.lib.project.loadPyproject {
    projectRoot = headset-battery-indicator;
  };
  attrs = project.renderers.buildPythonPackage { inherit python; };
in
python.pkgs.buildPythonPackage attrs
