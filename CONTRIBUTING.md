# Contributing to shopify_sheet

Thank you for considering contributing to **Shopify Sheet Flutter Plugin**! We appreciate your help in improving this package and making it even more useful for the Flutter community.

## How to Contribute

1. **Fork the Repository**: Create your own fork of the project to work on.

2. **Clone the Repository**:
   ```bash
   git clone https://github.com/farooq958/shopify_sheet.git
   ```

3. **Create a Branch**: Work on your feature or bug fix in a new branch.
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Make Changes**: Implement your feature or fix, and make sure to write tests if necessary.

5. **Run Tests**: Run all tests to ensure your changes don’t break existing functionality.
   ```bash
   flutter test
   ```

6. **Commit Your Changes**:
   ```bash
   git commit -m "Add your detailed commit message here"
   ```

7. **Push to GitHub**:
   ```bash
   git push origin feature/your-feature-name
   ```

8. **Submit a Pull Request**: Open a pull request on the main repository with a detailed description of your changes.

## Releasing a new version

1. Bump `version` in `pubspec.yaml`.
2. Add a matching `## x.y.z` entry in `CHANGELOG.md`.
3. Merge to `master`.

CI then:

1. Creates git tag `vX.Y.Z` (if that version is not already on pub.dev).
2. Publishes to [pub.dev](https://pub.dev/packages/shopify_sheet) from that tag.

### One-time setup (required for publish)

1. Open [pub.dev package admin](https://pub.dev/packages/shopify_sheet/admin).
2. Under **Automated publishing**, enable **publishing from GitHub Actions**.
3. Set **Repository** to `farooq958/shopify_sheet`.
4. Set **Tag pattern** to `v{{version}}`.

### One-time setup (recommended for master → publish)

GitHub does not let workflows started with the default `GITHUB_TOKEN` trigger other workflows. Add a repo secret so tagging on `master` can start the publish job:

1. Create a fine-grained PAT with **Contents: Read and write** on `farooq958/shopify_sheet`.
2. In the repo: **Settings → Secrets and variables → Actions → New repository secret**.
3. Name: `RELEASE_TOKEN`, value: the PAT.

Without `RELEASE_TOKEN`, the tag is still created; push it yourself once to publish:

```bash
git push origin vX.Y.Z
```

## Code of Conduct

By participating in this project, please be respectful and considerate of others when contributing.

## Reporting Issues

If you find any bugs or have feature requests, please open an issue on GitHub. Describe the problem or suggestion clearly, and include any relevant code or error messages.

Thank you for contributing! 🎉
