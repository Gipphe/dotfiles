{
  prettier,
  symlinkJoin,
  makeWrapper,
  prettier-plugin-go-template,
}:
symlinkJoin {
  name = "prettier-with-plugins";
  paths = [ prettier ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/prettier \
      --add-flags "--plugin=${prettier-plugin-go-template}/lib/node_modules/prettier-plugin-go-template/lib/index.js"
  '';
}
