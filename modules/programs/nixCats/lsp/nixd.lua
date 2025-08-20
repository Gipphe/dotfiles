return {
  settings = {
    nixpkgs = {
      expr = nixCats.extra 'nixd.nixpkgs' or 'import <nixpkgs> { }',
    },
    formatting = {
      command = { 'nixfmt' },
    },
    options = {
      nixos = {
        expr = nixCats.extra 'nixd.nixos_options',
      },
      darwin = {
        expr = nixCats.extra 'nixd.darwin_options',
      },
      droid = {
        expr = nixCats.extra 'nixd.droid_options',
      },
    },
  },
}
