# Agent Instructions

## Project purpose

This repository is a static Hugo download index for `downloads.roran60.com`.
Cloudflare Pages is the primary deployment target. The GitHub Pages workflow is a fallback deployment only.

## Required behavior

- Keep the Accessible Minimalism theme in `themes/accessible-minimalism/` as a Git submodule.
- Keep downloadable files below `static/files/`.
- Preserve the filesystem path below `static/files/` in the published URL below `/files/`.
- Keep recursive file listing working without `index.md` files in download directories.
- Do not add an upload service, JavaScript application, database, or server-side dependency for the download index.
- Do not list hidden files or directories whose names start with `.`.
- Do not commit `public/` or `resources/`.

## Adding a download

Place the file in the desired directory:

```text
static/files/<directory>/<filename>
```

The direct URL is:

```text
https://downloads.roran60.com/files/<directory>/<filename>
```

Do not create `index.md` files in download directories. Do not manually duplicate download links in `content/_index.md`; the `file-tree` shortcode generates them.

Prefer URL-friendly names using letters, numbers, `.`, `-`, and `_`. Renaming or moving a file changes its public URL.

## Hugo implementation

- `layouts/shortcodes/file-tree.html` starts the listing at `static/files`.
- `layouts/partials/file-tree.html` recursively calls itself for subdirectories.
- `os.ReadDir` reads the source tree during the Hugo build.
- Links are built from the relative path and point to `/files/...`.
- Any template change must keep the existing theme layout and accessible semantic HTML intact.

## Deployment

Cloudflare Pages settings:

```text
Production branch: main
Build command: hugo --gc --minify
Build directory: public
Environment variable: HUGO_VERSION=0.165.0
```

GitHub Pages deployment is defined in `.github/workflows/hugo-pages.yml`. It must check out submodules and publish the Hugo `public/` directory.

Do not configure `downloads.roran60.com` as the production custom domain on both providers simultaneously.

## Verification

Run the following before finishing a change:

```bash
hugo build --gc --minify --cleanDestinationDir
git diff --check
```

When changing the file listing, also verify that a temporary file nested at least two directories below `static/files/` produces both:

```text
public/files/<same-path>
/files/<same-path>
```

Remove temporary test files after verification. Never add large binary fixtures to the repository.

## Change boundaries

- Prefer small, focused changes.
- Do not edit files inside the theme submodule for site-specific behavior; override templates in the project instead.
- Do not change the `/files/` URL prefix without an explicit migration plan.
- Do not commit secrets, API tokens, Cloudflare credentials, or generated output.
