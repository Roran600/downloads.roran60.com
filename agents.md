# Agent Instructions

## Project purpose

This repository is a static Hugo download index for `downloads.roran60.com`.
Cloudflare Pages is the primary deployment target. The GitHub Pages workflow is a fallback deployment only.

## Required behavior

- Keep the Accessible Minimalism theme in `themes/accessible-minimalism/` as a Git submodule.
- Keep downloadable files below `static/files/`.
- Preserve the filesystem path below `static/files/` in the published URL below `/files/`.
- Keep the directory browser working without `index.md` files in download directories.
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

Do not create `index.md` files in download directories. Do not manually duplicate download links in `content/_index.md`; `scripts/hugo.sh` generates the directory pages automatically from `static/files/`.

Prefer URL-friendly names using letters, numbers, `.`, `-`, and `_`. Renaming or moving a file changes its public URL.

## Editing the homepage

- The homepage source is `content/_index.md`.
- `content/_index.md` is the only source file for editable homepage information; do not create a second homepage content file.
- Edit its front matter and Markdown content to change homepage information, notices, links, or explanatory text.
- Preview changes with `./scripts/hugo.sh server`.
- Publish approved changes by committing and pushing `content/_index.md`.
- Never edit generated pages under `content/files/` manually; the build wrapper recreates them from `static/files/`.
- Do not add a CMS, database, login, or client-side editor for homepage editing; local Git-based editing is intentional.

## Main navigation

- The main navigation is rendered at the top of every page by `layouts/partials/header.html`.
- It must contain links to the homepage (`/`) and file browser (`/files/`).
- The navigation labels are configured in the `menu.main` entries in `hugo.toml`.
- The project footer override in `layouts/partials/footer.html` must not restore the theme's bottom `Site menu` or the obsolete `#nav-menu` jump link.
- Keep the navigation accessible with a labeled `<nav>` element and semantic list items.

## Hugo implementation

- `scripts/generate-file-pages.sh` creates ignored Hugo section pages from `static/files/` before each build.
- `scripts/hugo.sh` runs the generator and then passes all arguments to Hugo; use it for local development and production builds.
- `layouts/shortcodes/directory-browser.html` renders the listing for each generated directory page.
- `layouts/partials/directory-browser.html` reads the current directory with `os.ReadDir`.
- Links are built from the relative path and point to `/files/...`.
- `disablePathToLower = true` preserves the case of directory URLs.
- Any template change must keep the existing theme layout and accessible semantic HTML intact.

## Deployment

Cloudflare Pages settings:

```text
Production branch: main
Build command: ./scripts/hugo.sh --gc --minify
Build directory: public
Environment variable: HUGO_VERSION=0.165.0
```

GitHub Pages deployment is defined in `.github/workflows/hugo-pages.yml`. It must check out submodules and publish the Hugo `public/` directory.

Do not configure `downloads.roran60.com` as the production custom domain on both providers simultaneously.

## Verification

Run the following before finishing a change:

```bash
./scripts/hugo.sh build --gc --minify --cleanDestinationDir
git diff --check
```

Use `./scripts/hugo.sh server` for local development so directory pages are regenerated before the server starts.

When changing the directory browser, also verify that a temporary file nested at least two directories below `static/files/` produces both:

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
