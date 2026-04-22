{ writeTextFile, tricorder }:
writeTextFile {
  name = "claude-code-skill-tricorder.md";
  text = builtins.readFile "${tricorder}/.claude-plugin/tricorder/skills/tricorder/SKILL.md";
  destination = "/SKILL.md";
}
