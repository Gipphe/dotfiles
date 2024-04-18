{ enable, ... }: if enable then builtins.fromTOML (builtins.readFile ./settings.toml) else { }
