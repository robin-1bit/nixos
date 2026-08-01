# /etc/nixos/configuration.nix

{ config, lib, pkgs, zen-browser, ... }:

{
imports = [
./hardware-configuration.nix
];

# ------------------------------------------------------------

# Nix

# ------------------------------------------------------------

nix.settings.experimental-features = [
"nix-command"
"flakes"
];

nixpkgs.config.allowUnfree = true;

# ------------------------------------------------------------

# System

# ------------------------------------------------------------

networking.hostName = "transcendent";
networking.networkmanager.enable = true;

time.timeZone = "Asia/Kolkata";

i18n.defaultLocale = "en_IN";

i18n.extraLocaleSettings = {
LC_ADDRESS = "en_IN";
LC_IDENTIFICATION = "en_IN";
LC_MEASUREMENT = "en_IN";
LC_MONETARY = "en_IN";
LC_NAME = "en_IN";
LC_NUMERIC = "en_IN";
LC_PAPER = "en_IN";
LC_TELEPHONE = "en_IN";
LC_TIME = "en_IN";
};

# ------------------------------------------------------------

# Bootloader and kernel

# ------------------------------------------------------------

boot.kernelPackages = pkgs.linuxPackages_latest;

boot.loader = {
systemd-boot.enable = false;

```
efi = {
  canTouchEfiVariables = true;
  efiSysMountPoint = "/boot/efi";
};

grub = {
  enable = true;
  efiSupport = true;
  device = "nodev";

  # Keep this enabled only when dual-booting.
  useOSProber = true;
};
```

};

# Keep this only if it fixes Intel display flickering,

# freezing, or other PSR-related issues.

boot.kernelParams = [
"i915.enable_psr=0"
];

# ------------------------------------------------------------

# User

# ------------------------------------------------------------

users.users.isandrin = {
isNormalUser = true;
description = "isandrin";
shell = pkgs.fish;

```
extraGroups = [
  "networkmanager"
  "wheel"
  "docker"
  "libvirtd"
  "kvm"
];

packages = [ ];
```

};

# ------------------------------------------------------------

# Shell

# ------------------------------------------------------------

programs.fish.enable = true;

environment.shells = [
pkgs.fish
];

environment.variables = {
EDITOR = "nvim";
VISUAL = "nvim";
};

# ------------------------------------------------------------

# Security

# ------------------------------------------------------------

security.sudo = {
enable = true;

```
extraConfig = ''
  Defaults pwfeedback
'';
```

};

security.rtkit.enable = true;

# ------------------------------------------------------------

# Desktop environment

# ------------------------------------------------------------

programs.hyprland = {
enable = true;
xwayland.enable = true;
};

programs.dconf.enable = true;

services.displayManager.sddm = {
enable = true;
wayland.enable = true;
};

services.gnome.gnome-keyring.enable = true;
services.tumbler.enable = true;
services.gvfs.enable = true;


# ------------------------------------------------------------

# XDG portals

# ------------------------------------------------------------

xdg.portal = {
enable = true;

```
extraPortals = with pkgs; [
  xdg-desktop-portal-hyprland
  xdg-desktop-portal-gtk
];
```

};

# ------------------------------------------------------------

# AppImage and Flatpak

# ------------------------------------------------------------

programs.appimage = {
enable = true;
binfmt = true;
};

services.flatpak.enable = true;

# ------------------------------------------------------------

# Laptop and power management

# ------------------------------------------------------------

services.logind.settings.Login = {
HandleLidSwitch = "ignore";
HandleLidSwitchExternalPower = "ignore";
};

services.tlp.enable = true;
services.acpid.enable = true;

# ------------------------------------------------------------

# Keyboard remapping

# ------------------------------------------------------------

services.keyd = {
enable = true;

```
keyboards.default = {
  ids = [ "*" ];

  settings.main = {
    rightalt = "leftmeta";
  };
};
```

};

# ------------------------------------------------------------

# Bluetooth

# ------------------------------------------------------------

hardware.bluetooth.enable = true;
services.blueman.enable = true;

systemd.user.services.blueman-applet.enable = false;

# ------------------------------------------------------------

# Audio

# ------------------------------------------------------------
services.pipewire = {
enable = true;

```
alsa = {
  enable = true;
  support32Bit = true;
};

pulse.enable = true;
jack.enable = true;
```

};

# ------------------------------------------------------------

# Containers and virtualization

# ------------------------------------------------------------

virtualisation.docker.enable = true;

virtualisation.libvirtd.enable = true;

# ------------------------------------------------------------

# X11 keyboard layout

# ------------------------------------------------------------

services.xserver.xkb = {
layout = "us";
variant = "";
};

# ------------------------------------------------------------

# System packages

# ------------------------------------------------------------

environment.systemPackages = with pkgs; [
# Development
gcc
gnumake
cmake
gdb
git
neovim

```
# Terminal tools
bc
curl
wget
unzip
tmux
stow
aria2

# Desktop utilities
brightnessctl
cliphist
libnotify
wl-clipboard
networkmanagerapplet

# Media and thumbnails
ffmpegthumbnailer

# System tools
lm_sensors

# GTK support
glib
gsettings-desktop-schemas
adwaita-icon-theme

  (zen-browser.packages.${pkgs.system}.default.overrideAttrs (oldAttrs: {
    buildInputs = (oldAttrs.buildInputs or []) ++ [ pkgs.libpulseaudio ];

    preFixup = (oldAttrs.preFixup or "") + ''
      gappsWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [ pkgs.libpulseaudio ]}"
      )
    '';
  }))

```

];

# ------------------------------------------------------------

# Fonts

# ------------------------------------------------------------

fonts = {
packages = with pkgs; [
cantarell-fonts
jetbrains-mono

```
  nerd-fonts.jetbrains-mono
  nerd-fonts.fira-code
  nerd-fonts.iosevka
];

fontconfig = {
  enable = true;

  defaultFonts = {
    monospace = [ "JetBrains Mono" ];
    sansSerif = [ "Cantarell" ];
    serif = [ "Noto Serif" ];
  };
};
```

};

# ------------------------------------------------------------

# State version

# ------------------------------------------------------------

system.stateVersion = "25.11";
}
