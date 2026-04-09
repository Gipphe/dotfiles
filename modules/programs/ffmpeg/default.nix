{ util, pkgs, ... }:
util.mkProgram {
  name = "ffmpeg";
  hm = {
    home.packages = [
      pkgs.ffmpeg
      (pkgs.writeShellApplication {
        name = "normalize-video";
        runtimeInputs = [ pkgs.ffmpeg ];
        text = /* bash */ ''
          info() {
            echo "$@" >&2
          }
          print_help() {
            info "Usage: normalize-video <input-path> <output-path>"
          }
          if test $# -ne 2; then
            info "Missing an argument"
            print_help
            exit 1
          fi

          ffmpeg -i "$1" -vf scale=-2:720,fps=25 -c:v libx264 -crf 23 -preset slow -c:a aac -b:a 128k -movflags +faststart "$2"
        '';
      })
    ];
  };
}
