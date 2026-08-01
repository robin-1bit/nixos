{ config, pkgs, ... }:

{
home = {
username = "isandrin";
homeDirectory = "/home/isandrin";
stateVersion = "25.11";

```
pointerCursor = {
  name = "Adwaita";
  size = 27;
  package = pkgs.adwaita-icon-theme;

  gtk.enable = true;

  x11 = {
    enable = true;
    defaultCursor = "Adwaita";
  };
};
```

};

programs.home-manager.enable = true;

# ------------------------------------------------------------

# GTK, icons, cursor, and dark mode

# ------------------------------------------------------------

gtk = {
enable = true;

```
theme = {
  name = "Adwaita-dark";
  package = pkgs.gnome-themes-extra;
};

iconTheme = {
  name = "Adwaita";
  package = pkgs.adwaita-icon-theme;
};
```

};

dconf.settings = {
"org/gnome/desktop/interface" = {
color-scheme = "prefer-dark";
gtk-theme = "Adwaita-dark";
icon-theme = "Adwaita";
cursor-theme = "Adwaita";
cursor-size = 27;
};
};

# ------------------------------------------------------------

# Nix

# ------------------------------------------------------------

programs.nix-index = {
enable = true;
};

# ------------------------------------------------------------

# Configuration symlinks

# ------------------------------------------------------------

home.file = {
".config/niri/config.kdl".source =
../niri/config.kdl;

```
".config/nvim/init.lua".source =
  ../nvim/init.lua;

".config/noctalia/config.toml".source =
  ../noctalia/config.toml;

".config/alacritty/alacritty.toml".source =
  ./alacritty/alacritty.toml;

".config/rofi" = {
  source = ./rofi;
  recursive = true;
};

".config/hypr" = {
  source = ./hypr;
  recursive = true;
};

".config/waybar" = {
  source = ./waybar;
  recursive = true;
};

".local/bin/brave-scaled" = {
  executable = true;

  text = ''
    #!/usr/bin/env bash

    exec brave \
      --enable-features=UseOzonePlatform \
      --ozone-platform=wayland \
      --force-device-scale-factor=1.25 \
      "$@"
  '';
};
```

};

# ------------------------------------------------------------

# Git

# ------------------------------------------------------------

programs.git = {
enable = true;

```
settings = {
  user = {
    name = "robin";
    email = "robinmogha@outlook.com";
  };

  init.defaultBranch = "main";

  pull.rebase = true;

  rebase = {
    autoStash = true;
  };

  fetch.prune = true;

  core = {
    editor = "nvim";
    pager = "less -FRSX";
  };

  color.ui = true;
};
```

};

# ------------------------------------------------------------

# Direnv

# ------------------------------------------------------------

programs.direnv = {
enable = true;
nix-direnv.enable = true;
};

# ------------------------------------------------------------

# Fish

# ------------------------------------------------------------

programs.fish = {
enable = true;

```
shellInit = ''
  set -gx LIBVIRT_DEFAULT_URI "qemu:///system"

  fish_add_path $HOME/.opencode/bin
  fish_add_path $HOME/.local/bin

  set -U fish_greeting
'';

shellAliases = {
  aria = "aria2c -x16 -s16";

  vid =
    "yt-dlp --cookies-from-browser chrome";

  nrs =
    "sudo nixos-rebuild switch --flake /home/isandrin/nix#transcendent";

  hrs =
    "home-manager switch --flake /home/isandrin/nix#isandrin";

  hconf =
    "nvim /home/isandrin/nix/home/isandrin.nix";

  ins =
    "yt-dlp --cookies /home/isandrin/.cookies/instagram.txt";

  nconf =
    "nvim /home/isandrin/nix/configuration.nix";

  nfk =
    "nvim /home/isandrin/nix/flake.nix";
};

interactiveShellInit = ''
  set -g fish_prompt_pwd_dir_length 0

  fzf --fish | source
  zoxide init fish | source
'';
```

};

# ------------------------------------------------------------

# Tmux

# ------------------------------------------------------------

programs.tmux = {
enable = true;

```
terminal = "tmux-256color";

baseIndex = 1;
keyMode = "vi";
mouse = true;

historyLimit = 100000;

extraConfig = ''
  unbind C-b

  set-option -g prefix C-a

  bind C-a send-prefix

  set -g pane-base-index 1

  set -g set-clipboard on

  set -g allow-passthrough on

  set -as terminal-features '*:clipboard'

  # Vim-style pane navigation
  bind -n C-h select-pane -L
  bind -n C-j select-pane -D
  bind -n C-k select-pane -U
  bind -n C-l select-pane -R

  # Pane splitting
  bind | split-window -h
  bind - split-window -v

  # Pane resizing
  bind -n M-h resize-pane -L 3
  bind -n M-j resize-pane -D 3
  bind -n M-k resize-pane -U 3
  bind -n M-l resize-pane -R 3

  # Faster Escape handling
  set-option -g escape-time 0

  # Status bar
  set -g status on
  set -g status-interval 5

  set -g status-style \
    bg=#1e1e2e,fg=#cdd6f4

  set -g status-left-length 40
  set -g status-right-length 100

  set -g status-left \
    "  #[bold]#S  "

  set -g status-right \
    "  %Y-%m-%d %H:%M  "
'';
```

};

# ------------------------------------------------------------

# User packages

# ------------------------------------------------------------

home.packages = with pkgs; [
# Terminal and system tools
fastfetch
file
tree
less
ripgrep
fd
bat
eza
htop
ncdu
lsof
strace
jq
yq
tldr
s-tui

```
# File management
yazi
zip
p7zip
rsync

# Desktop applications
zathura
evince
mpv
nautilus
alacritty
rofi

# Wayland utilities
grim
slurp
gammastep
swaynotificationcenter
swayosd
hyprpaper

# Desktop integration
blueman
tumbler
ffmpegthumbnailer

# Shell tools
fzf
zoxide
direnv
nix-direnv

# Other
noctalia-shell
openssl
ps_mem
```

];
}

