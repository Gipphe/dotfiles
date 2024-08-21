{ lib, ... }:
let
  inherit (builtins)
    concatStringsSep
    elemAt
    filter
    foldl'
    genList
    hasAttr
    isString
    length
    listToAttrs
    zipAttrsWith
    zipLists
    ;

  isNonEmptyStringAttr = attr: set: hasAttr attr set && isString set.${attr} && set.${attr} != "";
  mimicBackground =
    k: x:
    if hasAttr "background" x && isString x.background && x.background != "" then
      { ${k} = x.background; }
    else
      { };

  enrichBeginning =
    {
      idx,
      segment,
      segments,
    }:
    let
      nextSegment = elemAt segments (idx + 1);
    in
    segment // (mimicBackground "toColor" nextSegment);

  enrichEnd =
    {
      idx,
      segment,
      segments,
    }:
    let
      previousSegment = elemAt segments (idx - 1);
    in
    segment // (mimicBackground "fromColor" previousSegment);

  enrichDivider =
    {
      idx,
      segment,
      segments,
    }:
    let
      previousSegment = elemAt segments (idx - 1);
      nextSegment = elemAt segments (idx + 1);
    in
    segment // (mimicBackground "fromColor" previousSegment) // (mimicBackground "toColor" nextSegment);

  enrichSection = { segment, ... }: segment;

  enrichSegment =
    {
      idx,
      segment,
      segments,
    }:
    if segment.type == "beginning" then
      enrichBeginning { inherit idx segment segments; }
    else if segment.type == "end" then
      enrichEnd { inherit idx segment segments; }
    else if segment.type == "divider" then
      enrichDivider { inherit idx segment segments; }
    else
      enrichSection { inherit idx segment segments; };

  enrichSegments =
    segments:
    let
      segmentsWithIdx = zipLists (genList (x: x) (length segments)) segments;
    in
    map (
      { fst, snd }:
      enrichSegment {
        idx = fst;
        segment = snd;
        inherit segments;
      }
    ) segmentsWithIdx;

  mkStyleString =
    { bg, fg }:
    section:
    let
      foreground = if isNonEmptyStringAttr fg section then [ "fg:${section.${fg}}" ] else [ ];
      background = if isNonEmptyStringAttr bg section then [ "bg:${section.${bg}}" ] else [ ];
      style = concatStringsSep " " (foreground ++ background);
    in
    style;

  formatBeginning =
    segment:
    if isNonEmptyStringAttr "toColor" segment then
      "[${segment.beginning}](fg:${segment.toColor})"
    else
      segment.beginning;
  formatEnd =
    segment:
    if isNonEmptyStringAttr "fromColor" segment then
      "[${segment.end}](fg:${segment.fromColor})"
    else
      segment.end;
  formatDivider =
    segment:
    let
      style = mkStyleString {
        fg = "fromColor";
        bg = "toColor";
      } segment;
    in
    if style != "" then "[${segment.divider}](${style})" else segment.divider;
  formatSection =
    segment:
    lib.pipe segment.modules [
      (map (x: "\$${x.name}"))
      (concatStringsSep "")
    ];
  formatSegment =
    acc: segment:
    acc
    + (
      if segment.type == "beginning" then
        formatBeginning segment
      else if segment.type == "end" then
        formatEnd segment
      else if segment.type == "divider" then
        formatDivider segment
      else
        formatSection segment
    );
  formatSegments = foldl' formatSegment "";

  correctAttrs =
    section:
    let
      base = removeAttrs section [ "name" ];
    in
    if section.name == "username" then
      removeAttrs base [ "style" ]
      // {
        style_user = base.style;
        style_root = base.style;
      }
    else
      base;
  mkSectionSettings =
    section:
    let
      style = mkStyleString {
        fg = "foreground";
        bg = "background";
      } section;
      shared = section.shared or { };
      modules = listToAttrs (
        map (module: {
          inherit (module) name;
          value = correctAttrs ({ inherit style; } // shared // module);
        }) section.modules
      );
    in
    modules;

  mkSegmentsSettings =
    segments:
    let
      sections = filter (x: x.type == "section") segments;
    in
    zipAttrsWith (_: vs: elemAt vs (length vs - 1)) (map mkSectionSettings sections);
in
{
  beginning = beginning: {
    type = "beginning";
    inherit beginning;
  };
  end = end: {
    type = "end";
    inherit end;
  };
  divider = divider: {
    type = "divider";
    inherit divider;
  };
  section =
    {
      description ? "",
      modules,
      shared ? { },
      background ? null,
      foreground ? null,
    }:
    {
      type = "section";
      inherit
        description
        modules
        shared
        background
        foreground
        ;
    };
  mkStarship =
    segments:
    let
      enriched = enrichSegments segments;
      format = formatSegments enriched;
      settings = mkSegmentsSettings enriched;
    in
    {
      inherit format settings;
    };
}
