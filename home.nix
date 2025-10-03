{ config, pkgs, devenv, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "sadjow";
  home.homeDirectory = "/Users/sadjow";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  imports = [
    ./home/nix
    ./home/claude-code.nix
    # ./home/claude-code-settings.nix  # Disabled - Claude Code manages its own MCP servers
    ./home/shell.nix
    ./home/git.nix
    ./home/mcp-servers.nix
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # devenv - Fast, Declarative, Reproducible, and Composable Developer Environments
    devenv.packages.${pkgs.system}.default

    pkgs.git
    pkgs.tmux
    pkgs.awscli2
    pkgs.aws-vault
    pkgs.bat
    pkgs.direnv
    pkgs.nmap
    pkgs.ripgrep
    pkgs.pstree
    pkgs.gh  # GitHub CLI
    pkgs.asdf-vm
    pkgs.neovim
    pkgs.ruby
    pkgs.nodejs_22  # Node.js 22.x LTS
    pkgs.cocoapods
    pkgs.dart
    pkgs.ffmpeg
    pkgs.cachix
    pkgs.git-lfs
    # Use our custom claude-code overlay
    pkgs.claude-code
    # OpenAI Codex CLI
    pkgs.codex

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
  ];



  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # Global asdf tool versions
    ".tool-versions".text = ''
      ruby 3.2.9
      nodejs 22.17.1
      elixir system
      terraform system
      yarn system
    '';

    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
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
  #  /etc/profiles/per-user/sadjow/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    # Ensure direnv is always available in PATH for all applications
    PATH = "$PATH:${pkgs.direnv}/bin";
  };

  # Add direnv initialization to session startup for all shell types
  home.sessionPath = [
    "${pkgs.direnv}/bin"
    "$HOME/.pub-cache/bin"  # Dart pub global packages (fvm, etc.)
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.gpg.enable = true;
}
