# downloads.roran60.com

Minimalist Hugo site for publishing downloadable files. The production site is intended to run on Cloudflare Pages, with GitHub Pages available as a fallback deployment.

The site uses the [Accessible Minimalism](https://github.com/leonstafford/accessible-minimalism-hugo-theme) theme and has no JavaScript or application server.

## Repository layout

```text
content/_index.md                  Home page content
scripts/hugo.sh                    Generates directory pages and runs Hugo
scripts/generate-file-pages.sh     Generates directory pages
layouts/partials/directory-browser.html  Directory browser listing
layouts/shortcodes/directory-browser.html Directory browser shortcode
layouts/partials/header.html           Top-level navigation
layouts/partials/footer.html           Back-to-top footer only
static/files/                      Download files
themes/accessible-minimalism/      Theme Git submodule
.github/workflows/hugo-pages.yml   GitHub Pages fallback deployment
```

## Editing the homepage

The homepage content is maintained in `content/_index.md`. Edit only that file to change the title, description, notices, links, or any other Markdown information shown on `/`. Do not edit generated files in `content/files/`.

Preview the changes locally before publishing:

```bash
./scripts/hugo.sh server
```

After reviewing the page, commit and push the change:

```bash
git add content/_index.md
git commit -m "Update homepage information"
git push
```

The configured deployment then rebuilds the site and publishes the updated homepage. No CMS, database, login, or JavaScript editor is used.

## Adding files

Put files anywhere below `static/files/`:

```text
static/files/
├── latest.zip
├── linux/
│   └── app-amd64.tar.gz
└── windows/
    └── installer.exe
```

No `index.md` file is needed in any download directory. The `scripts/hugo.sh` wrapper automatically regenerates the ignored Hugo pages in `content/files/` from `static/files/` before every Hugo command. Hugo then copies the files to `public/files/` with the same directory structure.

The file browser is available at `/files/`. Each directory has its own page with clickable subdirectories, breadcrumb navigation, and a `../` link to the parent directory. Directory URLs preserve the exact case and characters used below `static/files/`.

The main navigation is displayed at the top of every page and contains links to `Hlavná stránka` and `Prehliadač súborov`. The old bottom `Site menu` has been removed.

The navigation is defined in `hugo.toml` and rendered by `layouts/partials/header.html`. The project overrides the theme footer with `layouts/partials/footer.html`; it must not contain the old `Site menu` or `#nav-menu` anchor.

The resulting direct links are:

```text
/files/latest.zip
/files/linux/app-amd64.tar.gz
/files/windows/installer.exe
```

Files or directories whose names start with `.` are hidden from the generated index. Keep filenames URL-friendly: use letters, numbers, `.`, `-`, and `_`. Existing links are not redirected when a file is renamed or moved.

The `public/` directory is build output and must not be committed.

## Local development

```bash
./scripts/hugo.sh server
```

Build a clean production output:

```bash
./scripts/hugo.sh build --gc --minify --cleanDestinationDir
```

The generated `public/` directory is ignored by Git.

To verify a direct file URL locally, start the server and open the path in a browser:

```text
http://localhost:1313/files/linux/app-amd64.tar.gz
```

## Cloudflare Pages

Create a Pages project from this GitHub repository with these settings:

```text
Production branch: main
Build command: ./scripts/hugo.sh --gc --minify
Build directory: public
```

Set `HUGO_VERSION` in the Cloudflare Pages environment variables, for example:

```text
HUGO_VERSION=0.165.0
```

Add `downloads.roran60.com` under the Pages project's Custom domains. Cloudflare then manages the DNS and HTTPS configuration for the production site.

Cloudflare Pages reads the Hugo version from the `HUGO_VERSION` environment variable. Set it for both Production and Preview environments when preview deployments are needed.

## GitHub Pages fallback

The workflow in `.github/workflows/hugo-pages.yml` builds and deploys the same site to GitHub Pages. Enable it under:

```text
Repository settings -> Pages -> Source -> GitHub Actions
```

The workflow is independent of Cloudflare Pages and is triggered by pushes to `main` or manually from the Actions tab.

## Important limitations

- The directory browser is generated at build time. A newly added, moved, or deleted file or directory appears correctly after the next build or deployment.
- `content/files/` is generated automatically and must not be edited manually. It is ignored by Git and recreated from `static/files/` on every Hugo command using `scripts/hugo.sh`.
- Hugo and static hosting do not provide an upload interface. Files must be added to Git and pushed, or supplied through a separate storage workflow.
- Large binaries should use Git LFS, Cloudflare R2, or another object-storage service instead of ordinary Git history.
- The same custom domain must not be configured as production on both Cloudflare Pages and GitHub Pages at the same time.

## Sources

- [Accessible Minimalism Hugo theme](https://github.com/leonstafford/accessible-minimalism-hugo-theme)
- [Hugo directory structure and static files](https://gohugo.io/getting-started/directory-structure/#static)
- [Hugo `os.ReadDir`](https://gohugo.io/functions/os/readdir/)
- [Cloudflare Pages Hugo deployment](https://developers.cloudflare.com/pages/framework-guides/deploy-a-hugo-site/)
- [Hugo deployment to GitHub Pages](https://gohugo.io/hosting-and-deployment/hosting-on-github/)
