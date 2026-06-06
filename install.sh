#!/usr/bin/env bash
set -euo pipefail

REPO_SOURCE="git:github.com/koko-t7i/MiniPi"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="${PI_AGENT_DIR:-$HOME/.pi/agent}"
SETTINGS_FILE="$AGENT_DIR/settings.json"
BAR_CONFIG_FILE="$AGENT_DIR/pi-bar.json"
PACKAGES_FILE="$SCRIPT_DIR/config/settings.packages.json"
BAR_CONFIG_SOURCE="$SCRIPT_DIR/config/pi-bar.json"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

if ! command -v pi >/dev/null 2>&1; then
  echo "Error: pi command not found. Install pi first, then rerun this script." >&2
  exit 1
fi

if ! command -v node >/dev/null 2>&1; then
  echo "Error: node command not found. Install Node.js, then rerun this script." >&2
  exit 1
fi

mkdir -p "$AGENT_DIR"

if [ -f "$SETTINGS_FILE" ]; then
  cp "$SETTINGS_FILE" "$SETTINGS_FILE.bak-$TIMESTAMP"
  echo "Backed up settings: $SETTINGS_FILE.bak-$TIMESTAMP"
else
  printf '{\n  "packages": []\n}\n' > "$SETTINGS_FILE"
  echo "Created settings: $SETTINGS_FILE"
fi

node - "$SETTINGS_FILE" "$PACKAGES_FILE" "$REPO_SOURCE" <<'JS'
const fs = require("node:fs");
const [settingsPath, packagesPath, repoSource] = process.argv.slice(2);

function readJson(path, fallback) {
  try {
    const raw = fs.readFileSync(path, "utf8").trim();
    if (!raw) return fallback;
    return JSON.parse(raw);
  } catch (error) {
    if (error && error.code === "ENOENT") return fallback;
    throw error;
  }
}

function sourceOf(entry) {
  if (typeof entry === "string") return entry;
  if (entry && typeof entry === "object" && typeof entry.source === "string") {
    return entry.source;
  }
  return "";
}

function normalizeNpm(source) {
  const body = source.slice("npm:".length);
  if (body.startsWith("@")) {
    const versionAt = body.indexOf("@", 1);
    return `npm:${versionAt === -1 ? body : body.slice(0, versionAt)}`;
  }
  const versionAt = body.indexOf("@");
  return `npm:${versionAt === -1 ? body : body.slice(0, versionAt)}`;
}

function normalizeSource(source) {
  const trimmed = source.trim();
  if (!trimmed) return "";
  if (trimmed.startsWith("npm:")) return normalizeNpm(trimmed);
  if (/github\.com[:/]koko-t7i\/MiniPi(?:\.git)?(?:@.*)?$/i.test(trimmed)) {
    return repoSource;
  }
  if (/github\.com[:/]tianrendong\/pi-bar(?:\.git)?(?:@.*)?$/i.test(trimmed)) {
    return "git:github.com/tianrendong/pi-bar";
  }
  return trimmed.replace(/\.git$/, "");
}

function identity(entry) {
  return normalizeSource(sourceOf(entry));
}

function isOldPiBar(entry) {
  const id = identity(entry);
  return id === "npm:pi-bar" || id === "git:github.com/tianrendong/pi-bar" || id === repoSource;
}

function pushUnique(target, seen, entry) {
  const id = identity(entry);
  if (!id || seen.has(id)) return;
  seen.add(id);
  target.push(entry);
}

const settings = readJson(settingsPath, {});
const recommended = readJson(packagesPath, { packages: [] });
const currentPackages = Array.isArray(settings.packages) ? settings.packages : [];
const recommendedPackages = Array.isArray(recommended.packages) ? recommended.packages : [];

const merged = [];
const seen = new Set();

for (const entry of currentPackages) {
  if (isOldPiBar(entry)) continue;
  pushUnique(merged, seen, entry);
}

for (const entry of recommendedPackages) {
  if (identity(entry) === "npm:pi-bar") continue;
  pushUnique(merged, seen, entry);
}

settings.packages = merged;
fs.writeFileSync(settingsPath, `${JSON.stringify(settings, null, 2)}\n`);
JS

echo "Updated packages in: $SETTINGS_FILE"

if [ -f "$BAR_CONFIG_FILE" ]; then
  cp "$BAR_CONFIG_FILE" "$BAR_CONFIG_FILE.bak-$TIMESTAMP"
  echo "Backed up pi-bar config: $BAR_CONFIG_FILE.bak-$TIMESTAMP"
fi
cp "$BAR_CONFIG_SOURCE" "$BAR_CONFIG_FILE"
echo "Wrote pi-bar config: $BAR_CONFIG_FILE"

cat <<EOF

MiniPi config installed.

Next steps:
  pi update --extensions
  # then restart pi, or run /reload inside pi

Package source:
  $REPO_SOURCE
EOF
