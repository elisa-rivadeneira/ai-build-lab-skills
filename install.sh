#!/bin/bash
# Instalador del Skill "AI Build Lab" para Claude Code en Mac/Linux.
# Uso: pegar esto en una terminal y presionar Enter:
#   curl -fsSL https://raw.githubusercontent.com/elisa-rivadeneira/ai-build-lab-skills/main/install.sh | bash

set -e

REPO_ZIP_URL="https://github.com/elisa-rivadeneira/ai-build-lab-skills/archive/refs/heads/main.zip"
TMP_DIR=$(mktemp -d)
TARGET_DIR="$HOME/.claude/skills"
SKILL_FOLDERS=("ai-build-lab-builder")

echo "Descargando el Skill de AI Build Lab..."
curl -fsSL "$REPO_ZIP_URL" -o "$TMP_DIR/skills.zip"

unzip -q "$TMP_DIR/skills.zip" -d "$TMP_DIR/extract"
EXTRACTED_ROOT=$(find "$TMP_DIR/extract" -mindepth 1 -maxdepth 1 -type d | head -n 1)

mkdir -p "$TARGET_DIR"

for folder in "${SKILL_FOLDERS[@]}"; do
  if [ -d "$EXTRACTED_ROOT/$folder" ]; then
    cp -r "$EXTRACTED_ROOT/$folder" "$TARGET_DIR/"
    echo "Instalado: $folder"
  fi
done

rm -rf "$TMP_DIR"

echo ""
echo "Listo! El Skill de AI Build Lab ya está instalado en tu computadora."
echo "Abre Claude Code en cualquier carpeta de proyecto nueva, pega el prompt que te dio ChatGPT"
echo "junto con la imagen de referencia, y Claude construirá la aplicación automáticamente."
