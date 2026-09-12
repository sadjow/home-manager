{ config, pkgs, lib, skills, ... }:

let
  skillDirectories = [
    ".agents/skills"
    ".claude/skills"
    ".codex/skills"
    ".cursor/skills"
  ];
  publicSkills = builtins.attrNames (lib.filterAttrs
    (name: type: type == "directory" && builtins.pathExists "${skills}/skills/${name}/SKILL.md")
    (builtins.readDir "${skills}/skills"));
  upstreamSkills = [
    "find-skills"
    "flutter-adding-home-screen-widgets"
    "flutter-animating-apps"
    "flutter-architecting-apps"
    "flutter-building-forms"
    "flutter-building-layouts"
    "flutter-building-plugins"
    "flutter-caching-data"
    "flutter-embedding-native-views"
    "flutter-handling-concurrency"
    "flutter-handling-http-and-json"
    "flutter-implementing-navigation-and-routing"
    "flutter-improving-accessibility"
    "flutter-interoperating-with-native-apis"
    "flutter-localizing-apps"
    "flutter-managing-state"
    "flutter-reducing-app-size"
    "flutter-setting-up-on-linux"
    "flutter-setting-up-on-macos"
    "flutter-setting-up-on-windows"
    "flutter-testing-apps"
    "flutter-theming-apps"
    "flutter-working-with-databases"
    "graphql-schema"
    "playwright-best-practices"
    "postgresql-table-design"
    "rails-expert"
    "redis-development"
    "vue"
  ] ++ lib.optional (!(lib.elem "skill-creator" publicSkills)) "skill-creator";
  publicSkillFiles = builtins.listToAttrs (lib.concatMap
    (name: map
      (directory: {
        name = "${directory}/${name}";
        value = {
          source = "${skills}/skills/${name}";
          force = true;
        };
      })
      skillDirectories)
    publicSkills);
  upstreamSkillFiles = builtins.listToAttrs (map
    (name: {
      name = ".claude/skills/${name}";
      value = {
        source = config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/.agents/skills/${name}";
        force = true;
      };
    })
    upstreamSkills);
in {
  assertions = [{
    assertion = lib.intersectLists publicSkills upstreamSkills == [];
    message = "Public and upstream skill ownership must not overlap.";
  }];

  home.file = publicSkillFiles // upstreamSkillFiles;

  # Discover private content only at activation, outside Nix evaluation and the store.
  home.activation.privateAgentSkills = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run ${pkgs.bash}/bin/bash ${../scripts/link-private-skills} \
      "$HOME/.config/skills-private" ${lib.escapeShellArgs skillDirectories}
  '';
}
