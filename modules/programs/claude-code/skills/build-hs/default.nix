{ writeTextFile }:
writeTextFile {
  name = "claude-code-skill-build-hs.md";
  text = builtins.readFile ./SKILL.md;
  destination = "/SKILL.md";
}
