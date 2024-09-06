rec {
  k = mode: key: action: options: {
    inherit key action;
    options = {
      silent = true;
    } // options;
    mode = if builtins.isList mode then mode else [ mode ];
  };

  kv =
    mode: key: action: options:
    k mode key { __raw = action; } options;
}
