function nixos {
  wsl -d NixOS --cd ~
}

$Env:STARSHIP_CONFIG = "$HOME\.config\starship.toml"
Invoke-Expression (&starship init powershell)
. "$HOME\.config\zoxide.ps1"
Invoke-Expression "$(direnv hook pwsh)"
