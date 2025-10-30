# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a NixOS dotfiles repository that supports multiple platforms: NixOS, nixos-wsl, and nix-on-droid. The architecture is based on a module system with profiles that configure machines.

## Development Commands

### Building and Testing

```bash
# Rebuild system (NixOS or nix-on-droid)
sw

# Rebuild with confirmation prompt
swa

# Test configuration without saving to bootloader (NixOS only)
swt

# Boot configuration (NixOS only)
boot

# Update flake inputs and commit
update
```

Prefer to use `swt` for testing new configurations, if possible. Use `boot` after a `swt` to effectively "save" a tested configuration as the new config.

### Formatting and Linting

```bash
# Format all code with treefmt (nixfmt, black, shfmt, shellcheck)
fmt

# Check with statix (linter for Nix)
lint:statix

# Check for unused Nix code
lint:deadnix

# Check with nil (Nix LSP)
lint:nil
```

### Testing

```bash
# Build all NixOS configurations as checks
nix flake check

# Build specific machine
nixos-rebuild build --flake .#<hostname>
nix-on-droid build --flake .#<hostname>
```

## Architecture

### Three-Layer System

1. **Modules** (`./modules/`) - Smallest unit of abstraction
   - Must have a single entrypoint: `default.nix`
   - Self-managing and self-contained
   - Must not break on unsupported systems
   - Use `util.mkProgram`, `util.mkEnvironment`, etc. from `util.nix`
   - Toggleable via enable options (no effect when just imported)
   - Categories: `boot/`, `core/`, `environment/`, `hardware/`, `networking/`, `programs/`, `system/`, `windows/`

2. **Profiles** (`./profiles/`) - Collections of modules
   - Only toggle and configure modules
   - May overlap with other profiles
   - Examples: `cli.nix`, `desktop/`, `gaming.nix`, `secrets.nix`

3. **Machine Configurations** (`./machines/`) - Per-machine settings
   - Named after periodic table elements (argon, cobalt, helium, carbon)
   - Should primarily enable profiles
   - Machine-specific config kept to minimum
   - Use `util.mkToggledModule` from `util.nix`

### Key Utilities (`util.nix`)

- `mkModule` - Create cross-platform module with `hm`, `system-nixos`, `system-droid`, `system-all`, `shared` sections
- `mkToggledModule` - Create module with auto-generated enable option
- `mkProgram`, `mkProfile`, `mkEnvironment` - Shortcuts for specific module types
- `writeFishApplication`, `writeNushellApplication` - Create shell script packages
- `recurseFirstMatching` - Recursively import modules stopping at first `default.nix`

### Platform Compatibility

Modules must work across:

- NixOS (standard Linux)
- nixos-wsl (NixOS in WSL with systemd)
- nix-on-droid (Android with Termux)

Use `flags.isNixos`, `flags.isNixOnDroid`, `flags.isHm`, `flags.isSystem` to conditionally enable features.

## Machine Naming

Machines follow periodic table naming:

- **argon** - NixOS in WSL (Windows), supports GUI via WSLg
- **cobalt** - Lenovo Ideapad laptop
- **carbon** - Google Pixel 9 Pro XL (nix-on-droid on GrapheneOS)
- **helium** - Samsung Galaxy S21 Ultra (deprecated)

## Configuration Structure

```
flake.nix              # Main flake with outputs
hosts.nix              # Aggregates NixOS and nix-on-droid configs
util.nix               # Core utilities for building modules
machines/
  <hostname>/
    default.nix        # Machine config using util.mkToggledModule
    host.nix           # Just contains name
profiles/
  <profile>.nix        # Profile using util.mkProfile
modules/
  <category>/
    <program>/
      default.nix      # Module using util.mkProgram
```

## Important Files

- `flake.lock` - Dependency pins, updated with `update` command
- `statix.toml` - Linter config (disables `manual_inherit*`, ignores `.direnv` and `hardware-configuration.nix`)
- `.envrc` - Enables direnv for automatic dev shell
- `.sops.yaml` - Secrets management config
- `devShells/devShell.nix` - Custom commands available in dev shell

## Module Development Guidelines

1. Always use appropriate utilities from `util.nix`:
   - `util.mkProgram` - For `modules/programs/` modules
   - `util.mkEnvironment` - For `modules/environment/` modules
   - `util.mkHardware` - For `modules/hardware/` modules
   - `util.mkProfile` - For `profiles/` modules
   - `util.mkToggledModule` - For machine configs or when no shorthand exists
   - `util.mkModule` - Generic module creation without auto-enable option
2. Place module in appropriate category directory
3. Implement platform-specific logic in separate sections:
   - `hm` - Home Manager config
   - `system-nixos` - NixOS system config
   - `system-droid` - nix-on-droid config
   - `system-all` - Common system config
   - `shared` - Shared between all contexts
4. Ensure module has no effect unless explicitly enabled
5. Handle missing dependencies gracefully with `lib.mkIf`

## Special Features

- **Windows interop**: `profiles/windows-setup.nix` manages Windows configuration via PowerShell/Scoop
- **Secrets**: Managed with sops-nix, enabled via `profiles/secrets.nix`
- **Theming**: Catppuccin Macchiato theme via stylix input
- **Custom packages**: `packages/` directory with treefmt, custom fonts, Fish utilities

## Flake Inputs

Key dependencies:

- `nixpkgs` - Main package source (nixos-unstable)
- `home-manager` - User environment management
- `nix-on-droid` - Android support
- `wsl` - WSL support
- `hyprland`, `niri` - Wayland compositors
- `stylix` - System-wide theming
- `sops-nix` - Secrets management

## Testing Configurations

The flake checks build all configurations:

- All NixOS configs except "boron" on x86_64-linux
- All nix-on-droid configs on aarch64-linux

Access via `nix flake check` or view specific checks with `nix build .#checks.<system>.<config>`.
