Create a jj descripton using conventional commit format.

1. Run `jj status` and `jj diff` to see staged changes
2. Run `jj log -r 'ancestors(@, 5)' -T 'description.first_line() ++ "\n"' --no-graph` to check commit history style
3. Analyze the changes and create a conventional commit message:
   - Use prefixes: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`, `style:`, `test:`
   - Keep the summary line concise (≤50 chars preferred)
   - Add details in body if needed
4. Commit with a HEREDOC to preserve formatting:

```
jj commit -m "$(cat <<'EOF'
<type>: <concise summary>

<optional body with more details>
EOF
)"
```

**IMPORTANT**:

- Never include Claude, AI, or co-authorship mentions
- Follow the repository's existing commit style
- Do NOT run `jj git push` or `git push` unless explicitly requested
