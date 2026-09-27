{ fetchzip }:

# The parser VS Code uses for settings.json; edits keep comments, trailing commas, and layout.
fetchzip rec {
  name = "jsonc-parser-${version}";
  version = "3.3.1";
  url = "https://registry.npmjs.org/jsonc-parser/-/jsonc-parser-${version}.tgz";
  hash = "sha256-eZb4Epz0UsTTaSstqBl46Sy/KRyKaJ+vBUJ92/6wsZY=";
}
