{ pkgs, lib, ... }:

let
  claudeProfiles = import ./claude/profiles.nix;
  codexProfiles = import ./codex/profiles.nix;
  userData = ".t3/userdata";
  organizations = {
    spireworks = {
      displayName = "Spireworks";
      accentColor = "#7c3aed";
    };
    durst = {
      displayName = "Durst";
      accentColor = "#0f766e";
    };
    stackbuilders = {
      displayName = "Stack Builders";
      accentColor = "#ea580c";
    };
  };
  # Isolated profiles run through their wrapper command, and homePath points the
  # driver at the same config directory the wrapper exports.
  profileInstance = { driver, profiles, profile, organization }: organization // {
    inherit driver;
    enabled = true;
    config = {
      binaryPath = profile;
      homePath = "~/${profiles.isolated.${profile}}";
    };
  };
  claudeProfileInstance = instance: profileInstance (instance // {
    driver = "claudeAgent";
    profiles = claudeProfiles;
  });
  codexProfileInstance = instance: profileInstance (instance // {
    driver = "codex";
    profiles = codexProfiles;
  });
  # The Cursor agent keeps one browser login per machine, so additional
  # organizations authenticate through a sensitive CURSOR_API_KEY variable
  # added once in the instance's Environment section of T3 Code.
  cursorInstance = { organization, enabled }: organization // {
    driver = "cursor";
    inherit enabled;
    config.binaryPath = "cursor-agent";
  };
  settings = (pkgs.formats.json { }).generate "t3-code-settings.json" {
    providers = {
      cursor.enabled = false;
      grok.enabled = false;
      opencode.enabled = false;
    };
    providerInstances = {
      claudeAgent = {
        driver = "claudeAgent";
        enabled = true;
        config.binaryPath = "claude";
      };
      codex = {
        driver = "codex";
        enabled = true;
        config.binaryPath = "codex";
      };
      claude_spireworks = claudeProfileInstance {
        profile = "claude-spireworks";
        organization = organizations.spireworks;
      };
      claude_stackbuilders = claudeProfileInstance {
        profile = "claude-stackbuilders";
        organization = organizations.stackbuilders;
      };
      codex_spireworks = codexProfileInstance {
        profile = "codex-spireworks";
        organization = organizations.spireworks;
      };
      cursor_spireworks = cursorInstance {
        organization = organizations.spireworks;
        enabled = true;
      };
      cursor_durst = cursorInstance {
        organization = organizations.durst;
        enabled = false;
      };
    };
  };
in
{
  # T3 Code rewrites settings.json from its Settings UI and reloads it whenever
  # the file changes, so the declared providers merge into the writable runtime
  # file instead of replacing it with a store symlink.
  home.activation.t3CodeSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run ${pkgs.python3}/bin/python3 ${../scripts/reconcile-json-settings.py} \
      ${settings} \
      "$HOME/${userData}/settings.json" \
      "$HOME/${userData}/.home-manager-settings/settings.json"
  '';
}
