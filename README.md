# 🚀 VSTax Flatpak Repository

## What This Does

This repository provides VSTax (Swiss Federal Tax Declaration Software) as a Flatpak package. It includes:

- **Auto-update workflow** that detects new VSTax yearly releases
- **Pre-generated manifests** for each VSTax version (2025, 2026, etc.)
- **GitHub Pages deployment** for easy Flatpak remote access

## How It Works

1. **Daily Check** (8 AM UTC): Tests if `/vstax/{YEAR}/` directory exists on sftp.vs.ch
2. **Version Discovery**: Tries version patterns (1.0.0-0, 1.0.1-1, etc.) to find the latest .deb
3. **Download & Verify**: Downloads the .deb, calculates SHA256 checksum
4. **Generate Files**: Creates manifest, desktop file, and metainfo.xml
5. **Create PR**: Opens a pull request for review and merge

## Files

```
.github/workflows/
├── autoupdate.yml  # Main auto-update workflow
└── test-detection.yml  # Manual testing workflow (optional)
```

## Deployment

### Step 1: Push to Repository

Upload these files to your repository (GitHub or Codeberg):

```bash
# Create the directory structure
mkdir -p .github/workflows

# Copy the workflow files
cp autoupdate.yml .github/workflows/
cp test-detection.yml .github/workflows/  # optional
```

### Step 2: Enable Actions

- **GitHub**: Actions are enabled by default
- **Codeberg**: Enable Actions in repository settings

### Step 3: Wait for VSTax Release

- **Automatic**: Daily check starts immediately
- **Manual**: Trigger manually via Actions UI

## Manual Trigger

When VSTax releases a new version:

1. Go to: `https://github.com/chdude-bot/vstax-flatpak/actions`
2. Select "Auto-Update VSTax" workflow
3. Click "Run workflow"
4. Enter the year (e.g., `2026`)
5. The workflow will detect, download, and create a PR

## Installation for Users

After deploying the repository (see below):

```bash
# Add the Flatpak repository
flatpak remote-add --if-not-exists vstax https://github.com/chdude-bot/vstax-flatpak/releases/

# Install VSTax 2025
flatpak install vstax ch.abraxas.vstax2025

# Run it
flatpak run ch.abraxas.vstax2025
```

### Quick Install

You can also install directly using the .flatpakref file:

```bash
# Download and install
flatpak install --assumeyes https://github.com/chdude-bot/vstax-flatpak/releases/ch.abraxas.vstax2025.flatpakref
```

## Version Patterns

The workflow searches for these version formats:
- `vstax2025_1.0.10-147_amd64.deb`
- `vstax2026_1.0.0-000_amd64.deb`

Format: `vstax{YEAR}_1.{major}.{minor}-{build}_amd64.deb`

## Troubleshooting

### Workflow doesn't run
- Check that Actions is enabled in repository settings
- Verify the workflow file has correct syntax (click "Run workflow" to test)

### No version found
- VSTax hasn't released the year yet (expected)
- Directory doesn't exist: `/vstax/2026/`
- Try manual trigger with the correct year

### SHA256 mismatch
- The .deb file changed unexpectedly
- Manually update SHA256 in the generated manifest

## Example PR

When the workflow detects VSTax 2026:

```
Add VSTax 2026
```

**Files changed:**
- `ch.abraxas.vstax2026.yaml`
- `ch.abraxas.vstax2026.desktop`
- `ch.abraxas.vstax2026.metainfo.xml`

**PR description:**
```
✅ Auto-detected VSTax 2026

Details:
- Year: 2026
- Version: 1.0.0-0
- URL: https://sftp.vs.ch/vstax/2026/vstax2026_1.0.0-0_amd64.deb
- SHA256: abc123...
- Generated: 2026-01-15
```

## Maintenance

No maintenance required! The workflow:
- Runs forever
- Creates separate apps for each year (2025, 2026, 2027, etc.)
- Users can install any year they want

---

## GitHub Pages Deployment

To make this repository accessible as a Flatpak remote:

1. **Enable GitHub Pages** in Settings → Pages
2. **Select source**: Deploy from branch (main)
3. **Wait for deployment** (a few minutes)
4. **Your Flatpak remote URL** will be: `https://chdude-bot.github.io/vstax-flatpak/releases/`

Or use the GitHub repository releases URL directly:
`https://github.com/chdude-bot/vstax-flatpak/releases/`

**Ready to deploy!** 🎉
