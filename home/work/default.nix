{ lib, flags, ... }: lib.optionalAttrs flags.use-case.work { imports = [ ./idea ]; }
