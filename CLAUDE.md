# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a static personal portfolio website for Govind Gandhi (govgandhi.github.io), a network scientist. The site is hosted on GitHub Pages and uses pre-compiled/minified assets.

**Template Source:** Forked from [Ashay Changwani's website repo](https://github.com/ashaychangwani/website)

## Development Commands

### Local Preview
```bash
./Preview\ Website.command
```
Starts a livereload server on http://localhost:8000 with automatic browser refresh.

Requires the `livereload` npm package to be installed globally.

## Architecture

### Static Site Structure
- **index.html** - Single-page application with all content sections
- **public/main.js** - Minified JavaScript (canvas animations, interactions, modals)
- **public/head.js** - Feature detection script (JS availability, reduced motion, browser detection)
- **public/styles.css** - Minified CSS (responsive design, 3 breakpoints)
- **images/** - Project screenshots, demos (GIFs), and responsive fallback images

### Key Architectural Notes
- No build system in this repo - JavaScript and CSS are pre-minified
- Canvas-based hero animations with PNG fallbacks for non-canvas browsers
- Responsive images via `<picture>` elements with srcset
- Accessibility features: ARIA labels, reduced-motion support, semantic HTML
- External dependencies: Font Awesome 4.7.0 and jQuery 1.11.2 (both via CDN)

### Deployment
- **GitHub Pages**: Automatic deployment from main branch
- **cPanel**: Alternative deployment via `.cpanel.yml` to `/home/tcafgtry/public_html/`

## Content Sections in index.html

1. Navigation bar (Work, Resume, Blog links)
2. Hero section with animated canvas backgrounds
3. Interactive demonstration sections
4. Experience tabs (CNetS, Centre Marc Bloch, IISER Pune)
5. Education section (IU Bloomington PhD, IISER Pune)
6. Work portfolio grid (13+ projects)
7. Contact section and footer with social links

## Working with This Codebase

Since the JS and CSS are minified, content changes typically involve:
- Editing `index.html` directly for text/structure changes
- Adding/replacing images in `images/` directory
- The minified `public/` files would need source access to modify significantly
