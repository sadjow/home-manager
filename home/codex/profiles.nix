# Isolated profiles sign in to their own account and keep separate runtime state
# under their own CODEX_HOME.
{
  default = ".codex";
  isolated = {
    codex-spireworks = ".codex-spireworks";
  };
}
