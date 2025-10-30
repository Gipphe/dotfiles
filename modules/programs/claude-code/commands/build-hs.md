Start a ghcid session to monitor the build.

**Before starting**: Verify which command is actually allowed in
`.claude/settings.local.json` for ghcid and ensure you use it to avoid
prompting for permission.

First, check `package.yaml` to identify the test components:

- `tests:` section → use the test name with `-test` suffix (e.g., `dota-sage-test`)

Then run ghcid with the `all` target (which includes all libraries and
executables, including internal libraries) PLUS all test components using the
Bash tool with `run_in_background: true`:

```
nix develop -c ghcid -c 'cabal repl --enable-multi-repl all <test-name>' --restart=<project>.cabal --outputfile=build.log --clear
```

**Note**: The `all` target ensures internal libraries are included in the
build. Tests must be specified explicitly since `all` doesn't include them. The
`--restart` flag causes ghcid to automatically restart when the cabal file
changes (e.g., after hpack regeneration).

For this project:

```
nix develop -c ghcid -c 'cabal repl --enable-multi-repl all dota-sage-test' --restart=dota-sage.cabal --outputfile=build.log --clear
```

**IMPORTANT**: Use `run_in_background: true` parameter in the Bash tool
(without `&` at the end of the command) so ghcid appears in Claude Code's
background processes UI.

To keep context usage reasonable, only the file build.log should be used to
monitor the build status, ideally reading only the first few lines and then
more if needed using the Read tool.

**Monitoring build status**:

- Check for errors: Use Read tool with `file_path: "build.log"` and `limit: 20`
- Check if ghcid is running: View background processes in Claude Code UI, or
  `ps aux | grep ghcid`
- Kill ghcid: Use KillShell tool with the shell ID, or `pkill ghcid`

**When to restart ghcid**:

- If ghcid appears stuck or unresponsive
- When adding a new component (library, executable, test) to `package.yaml`
  that needs to be included in the repl command

**Note**: With the `--restart` flag, ghcid will automatically restart when the
cabal file changes, so manual restarts are not needed after running `hpack
--force`. Always use `hpack --force` to avoid version mismatch errors when
regenerating cabal files.

**Important**: If you add a new component (library, executable, or test suite)
to `package.yaml`, you must also remind me to update the permission in
`.claude/settings.local.json` to include the new component name in the ghcid
command.

**Note**: Avoid building the project directly with cabal or stack. Let ghcid
monitor compilation continuously.

## Documentation Search with Hoogle

Use hoogle CLI to search for documentation of project dependencies within the
nix develop shell.

**Basic search commands**:

1. **Search for a function by name**:

   ```
   nix develop -c hoogle search "mapMaybe"
   ```

   Example output: Shows functions from Data.Maybe and other modules

2. **Search by type signature**:

   ```
   nix develop -c hoogle search "(a -> Bool) -> [a] -> [a]"
   ```

   Finds functions like `filter`, `takeWhile`, etc.

3. **Search for specific package documentation**:

   ```
   nix develop -c hoogle search "aeson" --count=10
   ```

   Lists top 10 results from the aeson package

4. **Get detailed information about a function**:

   ```
   nix develop -c hoogle search "traverse" --info
   ```

   Shows full documentation with examples

5. **Search in specific modules**:
   ```
   nix develop -c hoogle search "module:Data.List take"
   ```
   Searches only within Data.List module

**Advanced usage**:

- **Limit results**: Add `--count=N` to show only N results
- **JSON output**: Add `--json` for machine-readable output
- **Exact match**: Use quotes for exact function name matching
- **Type class search**: Search for `"Monad m => ..."` to find typeclass
  instances

**Common search patterns**:

- Find JSON parsing: `nix develop -c hoogle search "ByteString -> Maybe Value"`
- Find list functions: `nix develop -c hoogle search "module:Data.List"`
- Find monad operations: `nix develop -c hoogle search "Monad m =>"`
- Find lens operations: `nix develop -c hoogle search "Lens'"`

**Integration with development**:

- When encountering unfamiliar functions in build.log errors, use hoogle to
  understand their usage
- Use type signature search to discover appropriate functions for your use case
- Explore package APIs by searching the package name to understand available
  modules and functions before implementing features
