# Dotfiles

This is my _attempt_ at configuring all my various machines using Nix. This
whole repo is a mess, and will probably remain a mess for the forseeable
future.

## Prerequisites

### WSL

WSL-specific manual steps are required to enable `systemd`:

- Copy `wsl.conf` into `/etc/wsl.conf`:

  ```sh
  sudo cp wsl.conf /etc/wsl.conf
  ```

### Debian

Debian does not enable `systemd` correctly by default. The following steps are
required to enable it. These steps are taken from [this
article].

#### User instance of systemd

- Check `systemd` status with `sudo service systemd-logind status`. You should
  get something along these lines:

  <!-- markdownlint-disable MD013 -->

  ```text
  systemd-logind.service - User Login Management
       Loaded: loaded (/lib/systemd/system/systemd-logind.service; static)
       Active: inactive (dead)
    Condition: start condition failed at Wed 2023-07-12 19:36:02 BST; 6min ago
               ├─ ConditionPathExists=|/lib/systemd/system/dbus.service was not met
               └─ ConditionPathExists=|/lib/systemd/system/dbus-broker.service was not met
         Docs: man:sd-login(3)
               man:systemd-logind.service(8)
               man:logind.conf(5)
               man:org.freedesktop.login1(5)

  Jul 12 19:36:02 UserName systemd[1]: systemd-logind.service - User Login Management was skipped because no trigger condi>
  ```

  <!-- markdownlint-enable MD013 -->

- Install `dbus-user-session`

  ```sh
  sudo apt install dbus-user-session
  ```

- Restart WSL VM with `wsl --shutdown` outside of WSL.
- Ensure `libpam-systemd` is up to date.

  ```sh
  sudo apt install --reinstall libpam-systemd
  ```

- Verify that it worked: `sudo service systemd-logind status`. You should see
  something along these lines:

  <!-- markdownlint-disable MD013 -->

  ```text
  systemd-logind.service - User Login Management
       Loaded: loaded (/lib/systemd/system/systemd-logind.service; static)
       Active: active (running) since Wed 2023-07-12 19:47:04 BST; 20s ago
         Docs: man:sd-login(3)
               man:systemd-logind.service(8)
               man:logind.conf(5)
               man:org.freedesktop.login1(5)
     Main PID: 130 (systemd-logind)
       Status: "Processing requests..."
        Tasks: 1 (limit: 16713)
       Memory: 1.8M
       CGroup: /system.slice/systemd-logind.service
               └─130 /lib/systemd/systemd-logind
  ```

  <!-- markdownlint-enable MD013 -->

#### Fix shutdown command

- Run `sudo apt-get install --reinstall dbus`
- Run `sudo systemctl start dbus`

#### VSCode WSL interop issue

- Run `echo ':WSLInterop:M::MZ::/init:PF' | sudo tee /usr/lib/binfmt.d/WSLInterop.conf`
- Run `sudo systemctl restart systemd-binfmt` and `sudo systemctl restart binfmt-support`
  - If either of those fail, run `sudo apt update && sudo apt install binfmt-support`
- Check

  ```sh
  $ sudo ls -Fal /proc/sys/fs/binfmt_misc
  total 0
  drwxr-xr-x 2 root root 0 Mar 24 11:11 ./
  dr-xr-xr-x 1 root root 0 Mar 24 11:11 ../
  -rw-r--r-- 1 root root 0 Mar 24 11:35 WSLInterop
  -rw-r--r-- 1 root root 0 Mar 24 11:35 jar
  -rw-r--r-- 1 root root 0 Mar 24 11:35 python3.11
  --w------- 1 root root 0 Mar 24 11:35 register
  -rw-r--r-- 1 root root 0 Mar 24 11:35 status

  $ sudo cat /proc/sys/fs/binfmt_misc/WSLInterop
  enabled
  interpreter /init
  flags: PF
  offset 0
  magic 4d5a
  ```

## Usage

- Run `home-manager switch --flake $(pwd)` in this folder to apply the config.

[this article]: https://avivarma1.medium.com/setting-up-debian-on-wsl2-with-systemd-fb4831dd7b82
