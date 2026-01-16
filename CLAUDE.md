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
- **blog/** - Self-contained blog system (index, post template, markdown posts)
- **public/main.js** - Minified JavaScript (canvas animations, interactions, modals)
- **public/head.js** - Feature detection script (JS availability, reduced motion, browser detection)
- **public/styles.css** - Minified CSS (responsive design, 3 breakpoints)
- **public/mobile-responsive.css** - Custom responsive overrides for mobile/tablet
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
4. Experience tabs (UVA, Capital One, U. Barcelona, CNetS, Centre Marc Bloch, IISER Pune)
5. Education section (UVA, IU Bloomington, IISER Pune)
6. Work portfolio grid
7. Contact section and footer with social links (GitHub, LinkedIn, Instagram)

## Working with This Codebase

Since the JS and CSS are minified, content changes typically involve:
- Editing `index.html` directly for text/structure changes
- Adding/replacing images in `images/` directory
- The minified `public/` files would need source access to modify significantly

## Editing Content Sections

### Selected Experience (index.html ~line 240)
Tabbed interface - tabs and content must be added in matching pairs:

1. **Add a tab** in the `.menu` div:
   ```html
   <div class="tab_title"><span class="light"></span><span>ORG NAME</span></div>
   ```

2. **Add matching content** in the `.exp_tab_ul` list (same position as tab):
   ```html
   <li class="tab_des_li">
     <div class="t_content">
       <h2>Full Organization Name</h2>
       <h5>Start Date to End Date</h5>
       <ul class="desc" type="circle">
         <li>Bullet point</li>
       </ul>
     </div>
   </li>
   ```

3. **First tab/content** must have `active` class, others should not

### Schools Section (index.html ~line 310)
Each school uses a `school-behind-title-icon` container:

```html
<div class="school-behind-title-icon">
  <div class="school-icon-title-holder">
    <div class="school-icon-holder">
      <img class="s_icon1" src="images/resume-numb-X.png" alt="0X" aria-hidden="true" />
    </div>
    <div class="school-title-holder">
      <h3 class="school-title">School Name</h3>
    </div>
  </div>
  <div class="school-text-holder">
    <h3 class="school-subtitle">Degree, GPA: X.X/X.X</h3>
    <h3 class="school-dates">Start - End</h3>
    <p>Description or coursework</p>
  </div>
</div>
```

- Number icons: `images/resume-numb-1.png`, `resume-numb-2.png`, etc.
- Multiple degrees at same school: add more `school-text-holder` divs with a spacer between

## Blog System

The blog is self-contained in the `blog/` folder:

- **blog/index.html** - Blog index page listing all posts
- **blog/post.html** - Template that renders markdown posts client-side
- **blog/posts.json** - Manifest of all posts (title, date, file, excerpt)
- **blog/posts/** - Folder containing markdown files

### Publishing a New Blog Post

Use the publish script:
```bash
./Publish\ to\ Blog.command /path/to/your-post.md
```

Or double-click `Publish to Blog.command` and enter the file path when prompted.

The script will:
1. Copy the markdown file to `blog/posts/`
2. Extract the title from the first `# ` heading
3. Prompt for an optional excerpt
4. Update `posts.json` with the new entry

### Manual Post Addition

1. Copy your `.md` file to `blog/posts/`
2. Add an entry to `blog/posts.json`:
```json
{
  "title": "Post Title",
  "date": "2026-01-16",
  "file": "filename.md",
  "excerpt": "Optional short description"
}
```

Posts are rendered client-side using [marked.js](https://marked.js.org/) with syntax highlighting via highlight.js.

## Mobile Responsive Styles

Custom responsive overrides are in `public/mobile-responsive.css`:
- Loaded after `styles.css` to override fixed dimensions
- Breakpoints: 1024px (tablet), 768px (mobile), 480px (small mobile)
- Fixes for photography gallery, experience tabs, schools section
