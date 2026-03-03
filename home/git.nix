{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    ignores = [
      "**/.claude/settings.local.json"
      ".clj-kondo/"
      ".lsp/"
    ];

    settings = {
      user.name = "Sadjow Leão";
      user.email = "sadjow@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
}