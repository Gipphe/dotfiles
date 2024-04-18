{ lib, ... }:
with lib.lists;
with builtins;
let

  mimicBackground = k: x: if hasAttr "background" x then { ${k} = x.background; } else { };

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

  formatBeginning = segment: "[${segment.beginning}](fg:${segment.toColor})";
  formatEnd = segment: "[${segment.end}](fg:${segment.fromColor})";
  formatDivider = segment: "[${segment.divider}](fg:${segment.fromColor} bg:${segment.toColor})";
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

      isNonEmptyStringAttr = attr: set: hasAttr attr set && isString set.${attr} && set.${attr} != "";
      foreground = [ ]; # if isNonEmptyStringAttr "foreground" section then [ "fg:${section.foreground}" ] else [ ];
      background =
        if isNonEmptyStringAttr "background" section then [ "bg:${section.background}" ] else [ ];
      style = "${concatStringsSep " " (foreground ++ background)}";
      inherit (section) shared;
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
      description,
      modules,
      shared,
      background,
      foreground,
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
