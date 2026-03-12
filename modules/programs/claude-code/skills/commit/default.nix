{ writeTextFile }:
writeTextFile {
  name = "claude-code-skill-commit.md";
  text = builtins.readFile ./SKILL.md;
  destination = "/SKILL.md";
}
