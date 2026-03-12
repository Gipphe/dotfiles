{ writeTextFile, symlinkJoin }:
let
  skill = writeTextFile {
    name = "claude-code-skill-codebase-visualizer.md";
    text = builtins.readFile ./SKILL.md;
    destination = "/SKILL.md";
  };
  script = writeTextFile {
    name = "visualizer.py";
    text = builtins.readFile ./scripts/visualize.py;
    destination = "/scripts/visualizer.py";
  };
in
symlinkJoin {
  name = "claude-code-skill-coebase-visualizer";
  paths = [
    skill
    script
  ];
}
