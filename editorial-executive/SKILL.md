---
name: editorial-executive
description: A refined McKinsey-grade design system for HTML reports, dashboards, study tools, and analytical deliverables. Use this skill whenever the user asks for an HTML report, dashboard, presentation deliverable, study tool, exam preparation interface, or any polished web document where executive-grade visual quality matters. Triggers include phrases like "polished HTML", "executive report", "professional dashboard", "consulting-grade", "McKinsey-style", "study tool", "exam prep tool", or any request to "make it look professional". Defaults to light mode with a dark mode toggle. Pairs Fraunces (display serif), Geist (body sans), and JetBrains Mono (numerical) on a warm off-white canvas with a single rust-red accent.
---

# Editorial Executive Design System

When building HTML deliverables, follow this design system end-to-end. Do not deviate from the color palette, typography, or component patterns. The aesthetic is intentionally restrained — editorial seriousness, not SaaS decoration.

## How to use this skill

This skill has supporting files. Read them as needed:

| File | When to read |
|---|---|
| `starter.html` | **Always read this first** for any new HTML deliverable. It's the complete copy-paste base template — change the title and content, keep the rest. |
| `examples/kpi-grid.html` | When the user wants headline metrics, dashboards, or scorecards. Has 4 variants of the KPI grid pattern. |
| `examples/chart-config.js` | When the deliverable includes charts (line, bar, heatmap, custom SVG). Contains theme-aware Chart.js configs and a diverging-bar SVG generator. |

For simple deliverables, `starter.html` alone is enough. For data-heavy reports, also read `examples/chart-config.js`. For dashboards, also read `examples/kpi-grid.html`.

## Design Principles

- **Serif headlines, sans body** — Fraunces for display, Geist for body, JetBrains Mono for numbers. Never two serifs.
- **One accent, used sparingly** — rust-red `#b8341a`. No second accent ever; use `--gold` if a third state is needed.
- **Thin lines, no boxes** — 1px hairline dividers. Never `border-radius`, never `box-shadow`.
- **Numbers in monospace** — every quantitative value uses JetBrains Mono via `class="num"`.
- **Color encodes meaning** — green = positive, red = negative, gold = neutral marker. Never use accent for "good" or "bad".

## Design Tokens (always include in `<style>`)

```css
:root {
  --bg:          #faf9f6;   /* warm off-white — never pure white */
  --surface:     #ffffff;
  --ink:         #0a1628;
  --ink-soft:    #4a5568;
  --line:        #e2e0d8;
  --accent:      #b8341a;
  --accent-soft: #f4ddd5;
  --positive:    #1b5e20;
  --negative:    #b8341a;
  --muted:       #8a8578;
  --gold:        #b08d3a;
}
[data-theme="dark"] {
  --bg:          #0e1116;
  --surface:     #181c23;
  --ink:         #f0ede4;
  --ink-soft:    #b0aea6;
  --line:        #2a2e36;
  --accent:      #e85a3c;
  --accent-soft: #3a1d15;
  --positive:    #6dd474;
  --negative:    #e85a3c;
  --muted:       #6f6c63;
  --gold:        #d4a85a;
}
```

## Fonts (always include in `<head>`)

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300;9..144,400;9..144,600;9..144,700&family=Geist:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
```

## Typographic Rules

- Use `font-variation-settings: "opsz" 144` for any headline ≥32px to activate Fraunces's display optical size.
- Italicize one phrase in the H1 with `<em>`, colored `--accent`. One phrase only, never the whole title.
- Section labels are ALL CAPS with `letter-spacing: 0.2em` in `--accent` (replaces big section headers with quiet wayfinding).
- Negative letter-spacing (`-0.02em`) on large display type. Positive (`+0.15em`+) on small uppercase.

## Layout Rules

- Container: `max-width: 1240px; margin: 0 auto; padding: 48px 32px 80px;`
- Every major section follows: `section-label` → `<h2>` → content.
- The `.section-label` uses numbered wayfinding: `01 / Overview`, `02 / Results`. This replaces sidebar nav.
- The only container component is `.surface` — `background: var(--surface); border: 1px solid var(--line); padding: 24px;`. No radius, no shadow.
- Single responsive breakpoint at 880px: KPI grid drops to 2 columns, two-col layouts stack, h1 scales to 32px.

## Theme Toggle (always include)

```html
<button class="toggle-btn" onclick="toggleTheme()">◐ Theme</button>
```

```javascript
function toggleTheme() {
  const c = document.documentElement.getAttribute('data-theme');
  document.documentElement.setAttribute('data-theme', c === 'dark' ? 'light' : 'dark');
}
```

If charts are present, also re-call the chart constructor after theme toggle so chart colors swap live (see `examples/chart-config.js`).

## Color Usage Discipline

- `--accent` → section markers, KPI emphasis, links, active tab underline, hover states. Never for backgrounds (except `--accent-soft`) or large blocks of text.
- `--accent-soft` → callout backgrounds, ledger row hover. Never page-wide.
- `--positive`/`--negative` → numerical signed values, win/loss indicators, heatmap cells. Never decorative.
- `--gold` → averages, benchmark lines, third-state markers. Never where `--accent` would do.

## Anti-patterns — Never Do These

These break the aesthetic:

- `border-radius` on surfaces or buttons. Square corners are load-bearing.
- `box-shadow` anywhere. Hairlines only.
- A second accent color. Use `--gold` or intensity if a third state is needed.
- Inter, Roboto, Arial, or `system-ui` for body. Geist, or step up to IBM Plex Sans.
- Pairing Fraunces with another serif. One serif, one sans, one mono — three families maximum.
- Bullet lists for prose. Paragraphs do the work. Lists only for genuinely enumerable data.
- Filling chart areas with gradient color. 1.5px line, transparent fill, `pointRadius: 0`.
- Emoji as section icons. The `01 /` numbered labels are the wayfinding.
- Centered body text. Center alignment is for headlines and chart titles only.
- Page-load animations or scroll reveals. Static loads feel professional.
- `transition` on hover states for tabs, chips, buttons. Instant feedback feels more responsive.

## Workflow Summary

1. Read `starter.html` and use it as the base.
2. Change `<title>`, `.brand-mark` text, `<h1>` content, footer text.
3. Replace demo sections with the user's content using component patterns from this file.
4. If KPIs are needed, read `examples/kpi-grid.html` for variants.
5. If charts are needed, read `examples/chart-config.js` for theme-aware configs.
6. Validate against the anti-patterns list before delivering.
