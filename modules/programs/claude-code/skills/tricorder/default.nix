{ writeTextFile }:
writeTextFile {
  name = "claude-code-skill-tricorder.md";
  text = builtins.readFile ./SKILL.md;
  destination = "/SKILL.md";
}
