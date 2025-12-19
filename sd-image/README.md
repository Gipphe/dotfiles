# SD card image

Usable with Raspberry Pi 4.

## Usage

1. Create `./sd-image-wifi-pw.nix` containing just the wifi password for the wifi
   network you want the computer to automatically connect to.
2. Set SSH key for the user.
3. Build image with `./build.sh`.
4. Decompress image with `zstd --decompress ./result/sd-image/*.img.zst`
5. Flash the resulting `.img` file to an SD card using something like [balenaEtcher]
6. Insert SD card and boot from it.
7. The computer should be available through SSH once booted.

[balenaEtcher]: https://etcher.balena.io
