# Isolated profiles sign in to their own account and keep separate runtime state
# while sharing the authored configuration in this directory.
{
  default = ".claude";
  isolated = {
    claude-stackbuilders = ".claude-stackbuilders";
  };
}
