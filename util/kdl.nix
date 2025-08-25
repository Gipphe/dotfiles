let
  inherit (builtins)
    concatStringsSep
    filter
    isAttrs
    isBool
    isFloat
    isInt
    length
    isPath
    isString
    map
    replaceStrings
    split
    typeOf
    ;

  indent =
    str:
    let
      lines = filter isString (split "\n" str);
      indentedLines = map (x: "  ${x}") lines;
    in
    concatStringsSep "\n" indentedLines;

  node = name: attrs: children: {
    _type = "node";
    inherit name attrs children;
  };
  keyVal = key: val: {
    _type = "keyVal";
    inherit key val;
  };
  lit = val: {
    _type = "lit";
    inherit val;
  };
  doc = nodes: {
    _type = "doc";
    inherit nodes;
  };

  isDoc = x: x ? _type && x._type == "doc";
  isNode = x: x ? _type && x._type == "node";
  isKeyVal = x: x ? _type && x._type == "keyVal";
  isLit = x: x ? _type && x._type == "lit";

  escapeKDLString = replaceStrings [ "\"" ] [ "\\\"" ];

  renderLit =
    x:
    if isString x then
      "\"${escapeKDLString x}\""
    else if isPath x then
      "\"${escapeKDLString (toString x)}\""
    else if isInt x then
      "${toString x}"
    else if isFloat x then
      "${toString x}"
    else if isBool x then
      "#${toString x}"
    else
      throw "Invalid literal value for KDL: ${typeOf x}, ${toString x}";

  renderAttr =
    attr:
    if isKeyVal attr then
      "${renderLit attr.key}=${renderLit attr.val}"
    else if isLit attr then
      renderLit attr.val
    else
      throw "Invalid attr value: ${typeOf attr}, ${toString attr}";

  renderAttrs = attrs: concatStringsSep " " (map renderAttr attrs);

  validChildren = children: length (filter (x: !(isAttrs x)) children) == 0;

  render =
    x:
    if isDoc x then
      concatStringsSep "\n\n" (map render x.nodes)
    else if isNode x then
      let
        children =
          if !(validChildren x.children) then
            abort "Invalid children for node"
          else if length x.children > 0 then
            " {\n${indent (concatStringsSep "\n" (map render x.children))}\n}"
          else
            "";
        attrs = if length x.attrs > 0 then " ${renderAttrs x.attrs}" else "";
      in
      "\"${escapeKDLString x.name}\"${attrs}${children}"

    else
      renderLit x.val;
in
{
  inherit
    node
    lit
    keyVal
    doc
    render
    ;

  testDoc = render (doc [
    (node "title" [ (lit "foobar") ] [ ])
    (node "quack"
      [ (keyVal "key" "val") (keyVal "some" 123) ]
      [
        (node "foo" [ ] [ ])
        (node "bar" [ ] [ (node "qux" [ ] [ ]) ])
      ]
    )
  ]);
}
