{ pkgs }: {
  Default = "Startpage";
  Add = [
    {
      Name = "Startpage";
      URLTemplate = "https://www.startpage.com/do/search?cat=web&query={searchTerms}";
      IconURL = "https://www.startpage.com/favicon.ico";
      Alias = "@sp";
    }
    {
      Name = "nixpkgs";
      URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
      IconURL = "https://nixos.org/favicon.ico";
      Alias = "@nix";
    }
    {
      Name = "NixOS options";
      URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
      IconURL = "https://nixos.org/favicon.ico";
      Alias = "@nixos";
    }
    {
      Name = "Home Manager Options";
      URLTemplate = "https://search.nixos.org/options?channel=unstable&source=home_manager&query={searchTerms}";
      IconURL = "https://nixos.org/favicon.ico";
      Alias = "@hm";
    }
    {
      Name = "Nixpkgs function";
      URLTemplate = "https://noogle.dev/q?term={searchTerms}";
      IconURL = "https://nixos.org/favicon.ico";
      Alias = "@nixf";
    }
    {
      Name = "GitHub search";
      URLTemplate = "https://github.com/search?q={searchTerms}&type=code";
      IconURL = "https://github.com/favicon.ico";
      Alias = "@gh";
    }
    {
      Name = "Hoogle";
      URLTemplate = "https://hoogle.haskell.org/?hoogle={searchTerms}";
      IconURL = "https://hoogle.haskell.org/favicon.ico";
      Alias = "@hoogle";
    }
    {
      Name = "Wikipedia";
      URLTemplate = "https://en.wikipedia.org/w/index.php?search={searchTerms}";
      IconURL = "https://www.wikipedia.org/favicon.ico";
      Alias = "@w";
    }
  ];
  Remove = [ "Perplexity" ];
}
