# 📦 VSTax Flatpak Repository - Deployment Guide

## Quick Start

### 1. Create Your Repository

If you don't have one yet, create a new repository on Codeberg or GitHub:

```
Repository name: vstax-flatpak
Description: Self-hosted Flatpak repository for VSTax
```

### 2. Upload Workflow Files

Create this file structure:

```
vstax-flatpak/
├── .github/
│   └── workflows/
│       └── autoupdate.yml  ← Upload this
└── README.md               ← Upload this (optional)
```

### 3. Enable Actions

- **GitHub**: Actions enabled by default
- **Codeberg**: Go to Settings → Actions → Enable

### 4. (Optional) Add Existing Manifests

If you have pre-created manifests:

```
vstax-flatpak/
├── ch.abraxas.vstax2025.yaml
├── ch.abraxas.vstax2025.desktop
├── ch.abraxas.vstax2025.metainfo.xml
└── .github/
    └── workflows/
        └── autoupdate.yml
```

### 5. Deploy to Codeberg Pages

Add a deploy workflow for the Flatpak repository URL:

```yaml
# .github/workflows/deploy-pages.yml
name: Deploy to Pages

on:
  push:
    branches: ["main"]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Pages
        uses: actions/configure-pages@v4
      
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: '.'
      
      - name: Deploy to GitHub Pages
        uses: actions/deploy-pages@v4
```

For **Codeberg**, use a similar approach with Codeberg Pages.

## User Installation Instructions

After deploying, users can install via:

### KDE Discover / Flatpak

```bash
# Add the repository
flatpak remote-add --if-not-exists vstax https://codeberg.org/username/vstax-flatpak/

# Install VSTax 2025
flatpak install vstax ch.abraxas.vstax2025

# Run
flatpak run ch.abraxas.vstax2025
```

### Direct .flatpakref

Create a `.flatpakref` file for easy installation:

```
[Flatpak Ref]
Title=VSTax 2025
URL=https://codeberg.org/username/vstax-flatpak/ch.abraxas.vstax2025.flatpakref
```

## Manual Workflow Trigger

When VSTax releases a new version:

1. Navigate to: `https://codeberg.org/username/vstax-flatpak/actions`
2. Select "Auto-Update VSTax" from the workflow list
3. Click "Run workflow"
4. Enter the year: `2026`
5. Click "Run workflow"

The workflow will:
- Check if `/vstax/2026/` exists
- Find the latest .deb file
- Generate manifests
- Create a PR

## Testing

### Test with existing VSTax 2025

```yaml
# .github/workflows/test-manifest.yml
name: Test Manifest Generation

on:
  workflow_dispatch:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Verify manifest
        run: |
          cat ch.abraxas.vstax2025.yaml
          
          # Check required fields
          grep -q "app-id: ch.abraxas.vstax2025" ch.abraxas.vstax2025.yaml && echo "✓ app-id correct"
          grep -q "runtime: org.gnome.Platform" ch.abraxas.vstax2025.yaml && echo "✓ runtime correct"
          grep -q "sha256:" ch.abraxas.vstax2025.yaml && echo "✓ sha256 present"
```

### Test with curl

```bash
# Check if directory exists
curl -sI https://sftp.vs.ch/vstax/2025/

# Check if .deb is downloadable
curl -sI https://sftp.vs.ch/vstax/2025/vstax2025_1.0.10-147_amd64.deb

# Download and verify
curl -L https://sftp.vs.ch/vstax/2025/vstax2025_1.0.10-147_amd64.deb -o test.deb
sha256sum test.deb
```

## Security

### SHA256 Verification

The workflow automatically verifies the SHA256 checksum before generating manifests. This ensures:
- Downloaded files are not tampered with
- Build reproducibility
- Integrity verification

### GPG Signature (Optional)

If VSTax provides GPG signatures, add signature verification:

```yaml
- name: Verify GPG signature
  run: |
    curl -L "$DEB_URL" -o vstax.deb
    curl -L "$DEB_URL.asc" -o vstax.deb.asc
    gpg --verify vstax.deb.asc vstax.deb
```

## Troubleshooting

### Issue: "Workflow failed"

**Cause**: Directory doesn't exist (VSTax hasn't released yet)

**Fix**: Wait for release or manually trigger when ready

### Issue: "HTTP 403 Forbidden"

**Cause**: Directory listing disabled (expected behavior)

**Fix**: Workflow uses download testing instead of listing

### Issue: "No version found"

**Cause**: Version pattern doesn't match

**Fix**: Update version patterns in the workflow or use manual trigger

### Issue: "PR not created"

**Cause**: Permissions issue or token missing

**Fix**: Ensure `GITHUB_TOKEN` is available and has write permissions

## Next Steps

1. **Deploy workflow** to your repository
2. **Test** with manual trigger for VSTax 2025
3. **Wait** for VSTax 2026 release
4. **Monitor** Actions tab for successful detections
5. **Merge** PRs when ready
6. **Share** installation instructions with users

## Support

- **Issue**: Report bugs in repository Issues
- **Questions**: Create a discussion/thread
- **Documentation**: Update this README

---

**Ready to deploy! 🚀**
