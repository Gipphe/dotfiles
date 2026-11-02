{ den, ... }:
{
  den.aspects.profiles.calendar.includes = [
    den.aspects.environment.calendar
    den.aspects.programs.khal
    den.aspects.programs.vdirsyncer
  ];
}
