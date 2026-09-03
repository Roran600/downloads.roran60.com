# downloads.roran60.com

Minimalist Hugo site for publishing downloadable files. The production site is intended to run on Cloudflare Pages, with GitHub Pages available as a fallback deployment.

The site uses the [Accessible Minimalism](https://github.com/leonstafford/accessible-minimalism-hugo-theme) theme and has no JavaScript or application server.

## Repository layout

```text
content/_index.md                  Home page content
layouts/partials/file-tree.html    Recursive file listing
layouts/shortcodes/file-tree.html  File listing shortcode
static/files/                      Download files
themes/accessible-minimalism/      Theme Git submodule
.github/workflows/hugo-pages.yml   GitHub Pages fallback deployment
```

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

No `index.md` file is needed in any download directory. Hugo recursively lists the files on the home page and copies them to `public/files/` with the same directory structure.

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
hugo server
```

Build a clean production output:

```bash
hugo build --gc --minify --cleanDestinationDir
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
Build command: hugo --gc --minify
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

- The file tree is generated at build time. A newly added file appears in the index after the next deployment.
- Hugo and static hosting do not provide an upload interface. Files must be added to Git and pushed, or supplied through a separate storage workflow.
- Large binaries should use Git LFS, Cloudflare R2, or another object-storage service instead of ordinary Git history.
- The same custom domain must not be configured as production on both Cloudflare Pages and GitHub Pages at the same time.

## Sources

- [Accessible Minimalism Hugo theme](https://github.com/leonstafford/accessible-minimalism-hugo-theme)
- [Hugo directory structure and static files](https://gohugo.io/getting-started/directory-structure/#static)
- [Hugo `os.ReadDir`](https://gohugo.io/functions/os/readdir/)
- [Cloudflare Pages Hugo deployment](https://developers.cloudflare.com/pages/framework-guides/deploy-a-hugo-site/)
- [Hugo deployment to GitHub Pages](https://gohugo.io/hosting-and-deployment/hosting-on-github/)
