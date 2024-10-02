function nixos {
  wsl -d NixOS --cd ~
}

$Env:STARSHIP_CONFIG = "$HOME\.config\starship.toml"
Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })
Invoke-Expression "$(direnv hook pwsh)"
