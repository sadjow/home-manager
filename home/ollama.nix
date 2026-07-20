{ ollamaPackage, ... }:

{
  services.ollama = {
    enable = true;
    package = ollamaPackage;

    # Do not expose the unauthenticated API to the local network.
    host = "127.0.0.1";

    environmentVariables = {
      # Keep inference local and reserve enough context for coding agents.
      OLLAMA_NO_CLOUD = "1";
      OLLAMA_CONTEXT_LENGTH = "65536";

      # Reduce the memory cost of long prompts with negligible quality loss.
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_KV_CACHE_TYPE = "q8_0";
    };
  };
}
