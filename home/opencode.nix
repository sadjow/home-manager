{ pkgs, opencodePackage, ... }:

let
  model = "qwen3.6:35b";
  json = pkgs.formats.json { };
in
{
  home.packages = [ opencodePackage ];

  # Use only the local Ollama service. Project-level opencode.json files can
  # still override these global defaults when a repository needs them to.
  xdg.configFile."opencode/opencode.json".source = json.generate "opencode.json" {
    "$schema" = "https://opencode.ai/config.json";

    autoupdate = false;
    share = "disabled";
    enabled_providers = [ "ollama" ];

    model = "ollama/${model}";
    small_model = "ollama/${model}";

    provider.ollama = {
      npm = "@ai-sdk/openai-compatible";
      name = "Ollama (local)";
      options = {
        baseURL = "http://127.0.0.1:11434/v1";
        timeout = 600000;
        chunkTimeout = 60000;
      };
      models.${model} = {
        name = "Qwen 3.6 35B (local)";
        limit = {
          context = 65536;
          output = 16384;
        };
      };
    };
  };
}
