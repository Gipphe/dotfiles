{ inputs, ... }:
{
  den.aspects.programs.logseq.homeManager =
    { pkgs, ... }:
    {
      home = {
        packages = [
          # TODO: Use Logseq 2 (DB-version) once I can self-host Logseq sync
          # server to sync between Android and PC.
          inputs.nixpkgs-logseq-og.legacyPackages.${pkgs.stdenv.hostPlatform.system}.logseq
        ];
        file.".logseq/config/config.edn".text = /* clojure */ ''
          {:meta/version 1
           :preferred-workflow :todo
           :start-of-week 0
           :feature/enable-block-timestamps? true
           :file/name-format :triple-lowbar
           :journal/page-title-format "yyyy-MM-dd EEEE"
           :editor/logical-outdenting? true
           :editor/preferred-pasting-file? true}
        '';
      };
    };
}
