{ config, pkgs, ... }:

let
  unstable = import <nixpkgs-unstable> { };
  isMacOS = builtins.currentSystem == "x86_64-darwin" || builtins.currentSystem == "aarch64-darwin";
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "leopard2a5";
  home.homeDirectory = "/home/leopard2a5";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    zsh
    fira-code-nerdfont
    starship
    fzf
    bat
    eza
    fd
    ripgrep
    jq
    yq
    # unstable.vscode
    direnv
    nil
    nixfmt-rfc-style
    rustup
    bacon
    cargo-deny
    cargo-expand
    cargo-outdated
    cargo-udeps
  ];

  programs.git = {
    enable = true;
    userName = "René Perschon";
    userEmail = "rperschon85@gmail.com";
  };

  programs.vscode = {
    enable = true;
    enableUpdateCheck = true;
    enableExtensionUpdateCheck = true;
    extensions = with pkgs.vscode-extensions; [
      davidanson.vscode-markdownlint
      eamodio.gitlens
      github.vscode-github-actions
      hashicorp.terraform
      jnoortheen.nix-ide
      mkhl.direnv
      redhat.vscode-yaml
      rust-lang.rust-analyzer
      tamasfe.even-better-toml
      zxh404.vscode-proto3
    ];
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".zshrc".source = dotfiles/zshrc;
    ".config/starship.toml".source = dotfiles/starship.toml;
    ".config/Code/User/keybindings.json".source = (
      if isMacOS then dotfiles/vscode_keys_mac.json else dotfiles/vscode_keys_pc.json
    );
    ".config/Code/User/settings.json".source = dotfiles/vscode_settings.json;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/leopard2a5/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    DEV = "$HOME/dev";
    REPOS = "$DEV/repos";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
