#!/bin/bash
# Script to generate flatpakref files for VSTax versions
# Run this after the CI/CD workflow creates new manifests

set -e

RELEASES_DIR="${1:-.}"
YEAR="${2:-2025}"

# Get manifest details
MANIFEST_FILE="ch.abraxas.vstax${YEAR}.yaml"

if [[ ! -f "$MANIFEST_FILE" ]]; then
    echo "Error: Manifest $MANIFEST_FILE not found!"
    exit 1
fi

# Extract app-id
APP_ID=$(grep "^app-id:" "$MANIFEST_FILE" | awk '{print $2}')

# Extract version (from sources section)
DEB_URL=$(grep -A1 "url:" "$MANIFEST_FILE" | grep "sftp.vs.ch" | head -1 | awk '{print $2}')
SHA256=$(grep "sha256:" "$MANIFEST_FILE" | head -1 | awk '{print $2}')

# Extract version number from URL
VERSION=$(echo "$DEB_URL" | grep -o 'vstax'"${YEAR}"'_[^/]*' | sed 's/vstax'"${YEAR}"'_//' | sed 's/_amd64.deb//')

# Create flatpakref file
cat > "releases/${APP_ID}.flatpakref" << EOF
[Flatpak Ref]
Title=VSTax ${YEAR}
URL=https://github.com/chdude-bot/vstax-flatpak/releases/${APP_ID}.flatpakref
Metadata=${APP_ID}.flatpakmeta
EOF

# Create flatpakmeta file
cat > "releases/${APP_ID}.flatpakmeta" << EOF
{
  "metadata": {
    "app-id": "${APP_ID}",
    "title": "VSTax ${YEAR}",
    "version": "${VERSION}",
    "description": "Swiss Federal Tax Declaration Software for Vaud"
  },
  "releases": [
    {
      "version": "${VERSION}",
      "url": "${DEB_URL}",
      "sha256": "${SHA256}"
    }
  ],
  "repository": "https://github.com/chdude-bot/vstax-flatpak/"
}
EOF

echo "Generated ${APP_ID}.flatpakref and ${APP_ID}.flatpakmeta"
echo "Version: $VERSION"
echo "SHA256: $SHA256"
