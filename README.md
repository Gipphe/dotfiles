# Dotfiles

Nix configuration for NixOS, nix-darwin and nixos-wsl.

## Getting started

To start using this dotfiles repo on a machine of yours, run `./setup.sh` to
ensure `nix` is installed, as well as `nix-darwin` or `home-manager`. After
ensuring `nix` is available, it bootstraps the system using `nixos-rebuild`,
`darwin-rebuild` or `home-manager`.

## Machines

This dotfiles repo consists of NixOS configurations and nix-darwin
configurations for a variety of machines.

Machine configs are located in [`./root/machines`](./root/machines).

### Jarle

NixOS in WSL on Windows. Supports GUI programs through WSLg.

Located in [`./root/machines/Jarle`](./root/machines/Jarle).

### VNB-MB-Pro

Corporate-issued Macbook Pro with nix-darwin.

Located in [`./root/machines/VNB-MB-Pro`](./root/machines/VNB-MB-Pro).

### trond-arne

Lenovo Ideapad laptop running NixOS.

Located in [`./root/machines/trond-arne`](./root/machines/trond-arne).

## Architecture

To support NixOS, nix-darwin _and_ nixos-wsl, some choices have been made in
these dotfiles that might be of interest to others.

- Modules generally abstract over a feature.
- A module _must_ not cause any errors when enabled on systems that do not
  support it.
- Modules are enabled through profiles.
  - The only exception to this is the machine hostname, which is set in the
    machine's config directly.
- A profile can enable one or many modules.
- A machine configuration enables one or more profiles.
- Machine configurations are distinct based on the hostname of the machine.
- Each machine I have uses one and only one machine config each.

### Modules

- A module abstracts over a feature, whether it be a program or a set of
  settings.
- A module must have only 1 entrypoint, its `default.nix` file.
- Modules must be self-managing.
  - It is up to the module to ensure that its dependencies are in place.
  - It is up to the module to ensure the config as a whole is not invalid
    because of it.
  - Modules must account for being used in multiple different contexts: NixOS,
    nix-darwin, nixos-wsl, home-manager, etc.
- Modules should be toggleable. Listing a module in `imports` should not have
  any effect unless the module is explicitly toggled as well.
- Packages should be encapsulated in a separate module, as far as makes sense.
  Even simple packages with no extra configuration. This means the module is
  the smallest unit of abstraction in this dotfiles system.

All modules are located in [`./root/modules`](./root/modules), and are loosely grouped based on
their type.

### Profiles

- A profile can _only_ toggle modules, nothing else.
- A profile can overlap with another profile.

All profiles are located in [`./root/profiles`](./root/profiles).

### Machine configuration

- A machine configuration is unique to a single machine.
- A machine configuration should only enable profiles.
- A machine configuration may include extra machine-specific options if
  necessary. Generally, this should be kept to a minimum, or preferrably
  avoided entirely.

## Legacy troubleshooting steps

### WSL

WSL-specific manual steps are required to enable `systemd`:

- Copy `wsl.conf` into `/etc/wsl.conf`:

  ```sh
  sudo cp wsl.conf /etc/wsl.conf
  ```

### Debian

Debian does not enable `systemd` correctly by default. The following steps are
required to enable it. These steps are taken from [this article].

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

[this article]: https://avivarma1.medium.com/setting-up-debian-on-wsl2-with-systemd-fb4831dd7b82
