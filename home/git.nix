{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Sadjow Leão";
    userEmail = "sadjow@gmail.com";
    
    ignores = [
      # Claude settings
      "**/.claude/settings.local.json"
      
      # VSCode extension folders
      ".clj-kondo/"
      ".lsp/"
    ];
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
}