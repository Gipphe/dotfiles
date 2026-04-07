{ writeTextFile }:
writeTextFile {
  name = "claude-code-skill-ghcib.md";
  text = builtins.readFile ./SKILL.md;
  destination = "/SKILL.md";
}
