{ den, ... }:
{
  den.aspects.profiles.cli-extra.includes = [
    den.aspects.programs.fastgron
    den.aspects.programs.fzf
    den.aspects.programs.hygg
    den.aspects.programs.pay-respects
    den.aspects.programs.procs
  ];
}
