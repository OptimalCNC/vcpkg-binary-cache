# vcpkg Binary Cache with GitHub Packages

This repository contains GitHub Actions workflows configured to use GitHub Packages as a binary cache for vcpkg on both Windows and Linux platforms.

## Files

- **Windows Workflow**: `.github/workflows/windows-vcpkg-cache.yml`
- **Linux Workflow**: `.github/workflows/linux-vcpkg-cache.yml`
- **vcpkg Manifest**: `vcpkg.json` - Declares package dependencies
- **vcpkg Configuration**: `vcpkg-configuration.json` - Registry configuration

## Features

- ✅ Automatic binary caching using GitHub Packages (NuGet feed)
- ✅ Uses built-in `GITHUB_TOKEN` for authentication (no additional secrets needed)
- ✅ Read and write permissions for package caching
- ✅ Supports both Windows and Linux runners
- ✅ Manifest mode for declarative dependency management
- ✅ Versioned baseline for reproducible builds

## How It Works

1. **Authentication**: The workflows use `GITHUB_TOKEN` with `packages: write` permission
2. **Bootstrap vcpkg**: Automatically clones and bootstraps vcpkg from the official repository
3. **NuGet Configuration**: Configures the NuGet source to point to GitHub Packages
4. **Binary Caching**: vcpkg will automatically cache built packages and restore them on subsequent runs

## Environment Variables

Both workflows configure the following environment variables:

- `USERNAME`: Your GitHub username or organization name (automatically set to `${{ github.repository_owner }}`)
- `VCPKG_EXE`: Path to the vcpkg executable
- `FEED_URL`: GitHub Packages NuGet feed URL
- `VCPKG_BINARY_SOURCES`: vcpkg binary source configuration

## Usage

### vcpkg Manifest Mode

This project uses vcpkg's **manifest mode** which allows you to declare dependencies in `vcpkg.json`. The workflows automatically install all packages listed in the manifest.

#### Adding or Removing Packages

Edit `vcpkg.json` to add or remove dependencies:

```json
{
  "dependencies": [
    "zlib",
    "fmt",
    "nlohmann-json",
    "boost-system",
    "curl"
  ]
}
```

The workflows will automatically install these packages when they run.

#### Updating the Baseline

The `builtin-baseline` field in `vcpkg.json` pins the vcpkg registry to a specific commit. To update to a newer version:

1. Visit https://github.com/microsoft/vcpkg/commits/master
2. Copy a recent commit hash
3. Update both `vcpkg.json` and `vcpkg-configuration.json`:

```json
"builtin-baseline": "YOUR_NEW_COMMIT_HASH"
```

#### Platform-Specific Dependencies

You can also specify platform-specific dependencies:

```json
{
  "dependencies": [
    "zlib",
    {
      "name": "curl",
      "platform": "windows"
    }
  ]
}
```

#### Version Constraints

You can pin specific versions or use version ranges:

```json
{
  "dependencies": [
    {
      "name": "fmt",
      "version>=": "10.0.0"
    }
  ],
  "overrides": [
    {
      "name": "fmt",
      "version": "10.2.1"
    }
  ]
}
```

### Viewing Cached Packages

After the workflow runs successfully, you can view the cached NuGet packages in your repository:
1. Go to your repository on GitHub
2. Click on "Packages" in the right sidebar
3. You'll see the vcpkg binary cache packages stored there

## Requirements

### Linux Workflow
- Uses `ubuntu-latest` runner (currently `ubuntu-24.04`)
- Installs `mono-complete` for running `nuget.exe` (not preinstalled on ubuntu-24.04)
- vcpkg provides its own NuGet executable via `vcpkg fetch nuget`

### Windows Workflow
- Uses `windows-latest` runner
- No additional dependencies required

## Permissions

The workflows require the following permission:
```yaml
permissions:
  packages: write
```

This grants both read and write access to GitHub Packages for the repository.

## Alternative: Using Personal Access Token (PAT)

If you need cross-repository access or advanced scenarios, you can use a Personal Access Token instead:

1. Create a classic PAT with `packages:write` and `packages:read` permissions
2. Add it as a repository secret (e.g., `VCPKG_PAT`)
3. Replace `${{ secrets.GITHUB_TOKEN }}` with `${{ secrets.VCPKG_PAT }}` in the workflows

## References

- [Microsoft vcpkg Binary Caching Documentation](https://learn.microsoft.com/en-us/vcpkg/consume/binary-caching-github-packages)
- [vcpkg Official Repository](https://github.com/microsoft/vcpkg)
- [GitHub Packages Documentation](https://docs.github.com/en/packages)

## Troubleshooting

### Package Not Found
If you encounter "package not found" errors on the first run, this is expected. The first build will populate the cache.

### Authentication Errors
- Ensure the `permissions: packages: write` is set in your workflow
- For forks, pull requests will have read-only access by default

### Updating the Baseline
To update to the latest vcpkg baseline, run:
```bash
curl -s https://api.github.com/repos/microsoft/vcpkg/commits/master | grep -o '"sha": "[^"]*' | head -1 | cut -d'"' -f4
```
Then update the hash in both `vcpkg.json` and `vcpkg-configuration.json`.

Current baseline: `faf665cf8aca288b636d9de887f5cdfa3cff1a9e` (as of October 2025)

