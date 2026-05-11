final: prev:

let
  version = "1.0.44";
  sources = {
    x86_64-linux = {
      name = "copilot-linux-x64";
      hash = "sha256-/wdMa5iYdRGiLukIuGzUmXIXaa+lmxaI79M5gHCS0Dw=";
    };
    aarch64-linux = {
      name = "copilot-linux-arm64";
      hash = "sha256-Lq9Fu4OGNMpBPrOXm4MSiWarArG8XNamH0WYFqfVXps=";
    };
    x86_64-darwin = {
      name = "copilot-darwin-x64";
      hash = "sha256-z5k8EKSzPKpSYNawl47ranPhW4KiBC078vx1smiZ9jI=";
    };
    aarch64-darwin = {
      name = "copilot-darwin-arm64";
      hash = "sha256-1am4zC3h0dbgiuZYzDUgacbucPJtEbPXdjtG5ECYMxo=";
    };
  };
  srcConfig =
    sources.${prev.stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${prev.stdenv.hostPlatform.system}");
in
{
  github-copilot-cli = prev.github-copilot-cli.overrideAttrs (_oldAttrs: {
    inherit version;

    src = prev.fetchurl {
      url = "https://github.com/github/copilot-cli/releases/download/v${version}/${srcConfig.name}.tar.gz";
      inherit (srcConfig) hash;
    };

    installPhase = ''
      runHook preInstall
      install -Dm755 copilot $out/libexec/copilot
      runHook postInstall
    '';

    postInstall = ''
      makeWrapper $out/libexec/copilot $out/bin/copilot \
        --add-flags "--no-auto-update" \
        --prefix PATH : "${prev.lib.makeBinPath [ prev.bash ]}"
    '';
  });
}
