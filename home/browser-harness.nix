{ pkgs, lib, ... }:

let
  browserHarnessVersion = "0.1.9";
  browserHarnessRequirement = "browser-harness==${browserHarnessVersion}";
  expectedTool = "browser-harness v${browserHarnessVersion} [required: ==${browserHarnessVersion}] [CPython 3.12.";
in
{
  programs.uv.enable = true;

  home.sessionVariables.BH_TELEMETRY = "0";

  home.activation.browserHarness = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    browser_harness_tools="$(${pkgs.uv}/bin/uv tool list --show-version-specifiers --show-python 2>/dev/null || true)"
    browser_harness_bin="$(${pkgs.uv}/bin/uv tool dir --bin)/browser-harness"

    if ! printf '%s\n' "$browser_harness_tools" \
      | ${pkgs.gnugrep}/bin/grep -Fq ${lib.escapeShellArg expectedTool}; then
      ${pkgs.uv}/bin/uv tool install \
        --python 3.12 \
        --upgrade \
        --force \
        ${lib.escapeShellArg browserHarnessRequirement}
    fi

    BH_TELEMETRY=0 \
      "$browser_harness_bin" telemetry disable >/dev/null
  '';
}
