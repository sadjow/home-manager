const fs = require("node:fs");
const path = require("node:path");
const { isDeepStrictEqual } = require("node:util");
const { applyEdits, modify, parse, printParseErrorCode } = require(
  process.env.JSONC_PARSER,
);

const formattingOptions = { insertSpaces: true, tabSize: 2 };

function readText(file) {
  const text = fs.existsSync(file) ? fs.readFileSync(file, "utf8") : "";
  return text.trim() === "" ? "{}\n" : text;
}

function parseSettings(text) {
  const errors = [];
  const settings = parse(text, errors, { allowTrailingComma: true });
  if (errors.length > 0) {
    const details = errors.map(
      ({ error, offset }) =>
        `${printParseErrorCode(error)} at offset ${offset}`,
    );
    throw new Error(`invalid JSONC (${details.join(", ")})`);
  }
  if (
    settings === null ||
    typeof settings !== "object" ||
    Array.isArray(settings)
  ) {
    throw new Error("settings must contain a JSON object");
  }
  return settings;
}

function replaceFile(file, text) {
  const temporary = path.join(
    path.dirname(file),
    `.${path.basename(file)}.${process.pid}`,
  );
  try {
    fs.writeFileSync(temporary, text);
    if (fs.existsSync(file)) {
      fs.chmodSync(temporary, fs.statSync(file).mode & 0o777);
    }
    fs.renameSync(temporary, file);
  } finally {
    fs.rmSync(temporary, { force: true });
  }
}

function setSetting(file, key, value) {
  const text = readText(file);
  if (isDeepStrictEqual(parseSettings(text)[key], value)) {
    return;
  }
  fs.mkdirSync(path.dirname(file), { recursive: true });
  if (fs.existsSync(file)) {
    fs.copyFileSync(file, `${file}.home-manager-backup`);
  }
  replaceFile(
    file,
    applyEdits(text, modify(text, [key], value, { formattingOptions })),
  );
}

const [file, key, encodedValue] = process.argv.slice(2);
try {
  setSetting(file, key, JSON.parse(encodedValue));
} catch (error) {
  console.error(`Could not set ${key} in ${file}: ${error.message}`);
  process.exit(1);
}
