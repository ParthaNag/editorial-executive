#!/usr/bin/env bash
# ============================================================================
# editorial-executive — Claude Code skill installer
#
# Installs to ~/.claude/skills/editorial-executive (user-scoped, all projects)
# or pass a custom path as $1, e.g.:
#     ./install.sh ./my-project/.claude/skills
#
# Usage:
#     bash install.sh
#     bash install.sh /path/to/.claude/skills    # install in a specific dir
#
# Re-running is safe — overwrites existing files of the same name.
# ============================================================================
set -euo pipefail

SKILL_NAME="editorial-executive"
DEFAULT_DIR="$HOME/.claude/skills"
TARGET_PARENT="${1:-$DEFAULT_DIR}"
TARGET="$TARGET_PARENT/$SKILL_NAME"

echo ""
echo "  Editorial Executive — Claude Code skill installer"
echo "  ──────────────────────────────────────────────────"
echo ""
echo "  Installing to: $TARGET"
echo ""

mkdir -p "$TARGET/examples"

# ----------------------------------------------------------------------------
echo "  · writing SKILL.md"
cat > "$TARGET/SKILL.md" << 'EDITORIAL_EXECUTIVE_SKILL_PAYLOAD_1777139073'
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
EDITORIAL_EXECUTIVE_SKILL_PAYLOAD_1777139073

# ----------------------------------------------------------------------------
echo "  · writing starter.html"
cat > "$TARGET/starter.html" << 'EDITORIAL_EXECUTIVE_SKILL_PAYLOAD_1777139073'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Project Title — change me</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300;9..144,400;9..144,600;9..144,700&family=Geist:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
  /* ============================================================
     DESIGN TOKENS — light mode default, dark mode via [data-theme="dark"]
     ============================================================ */
  :root {
    --bg:          #faf9f6;
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

  /* ============================================================ */
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    background: var(--bg); color: var(--ink);
    font-family: "Geist", -apple-system, sans-serif;
    font-size: 14px; line-height: 1.6;
    transition: background .3s, color .3s;
  }
  .container { max-width: 1240px; margin: 0 auto; padding: 48px 32px 80px; }

  /* HEADER */
  .header {
    display: flex; justify-content: space-between; align-items: flex-end;
    border-bottom: 1px solid var(--line); padding-bottom: 24px; margin-bottom: 48px;
  }
  .brand-mark {
    font-family: "Fraunces", serif; font-weight: 600; font-size: 13px;
    letter-spacing: 0.18em; text-transform: uppercase; color: var(--accent);
  }
  h1 {
    font-family: "Fraunces", serif; font-weight: 400; font-size: 44px;
    letter-spacing: -0.02em; line-height: 1.1; margin-top: 8px;
    font-variation-settings: "opsz" 144;
  }
  h1 em { font-style: italic; color: var(--accent); }
  .subtitle { color: var(--ink-soft); font-size: 14px; margin-top: 12px; max-width: 620px; }
  .toggle-btn {
    background: transparent; border: 1px solid var(--line); color: var(--ink);
    padding: 8px 14px; font-size: 12px; cursor: pointer;
    font-family: "Geist", sans-serif; letter-spacing: 0.05em; text-transform: uppercase;
  }
  .toggle-btn:hover { background: var(--surface); }

  /* SECTION */
  .section { margin-bottom: 56px; }
  .section-label {
    font-family: "Fraunces", serif; font-weight: 600; font-size: 11px;
    letter-spacing: 0.2em; text-transform: uppercase; color: var(--accent);
    margin-bottom: 8px;
  }
  h2 {
    font-family: "Fraunces", serif; font-weight: 400; font-size: 28px;
    letter-spacing: -0.01em; margin-bottom: 24px;
    border-bottom: 1px solid var(--line); padding-bottom: 12px;
  }
  h3 {
    font-family: "Fraunces", serif; font-weight: 500; font-size: 20px;
    margin-bottom: 16px; color: var(--ink);
  }

  /* SURFACE — the only container component */
  .surface {
    background: var(--surface); border: 1px solid var(--line); padding: 24px;
  }

  /* KPI GRID */
  .kpi-grid {
    display: grid; grid-template-columns: repeat(4, 1fr); gap: 1px;
    background: var(--line); border: 1px solid var(--line);
  }
  .kpi { background: var(--surface); padding: 24px 20px; }
  .kpi-label {
    font-size: 10px; letter-spacing: 0.15em; text-transform: uppercase;
    color: var(--muted); margin-bottom: 10px;
  }
  .kpi-value {
    font-family: "Fraunces", serif; font-weight: 400; font-size: 32px;
    letter-spacing: -0.02em; line-height: 1;
  }
  .kpi-sub { font-size: 12px; color: var(--ink-soft); margin-top: 8px; }
  .pos { color: var(--positive); }
  .neg { color: var(--negative); }

  /* TABS */
  .tabs { display: flex; border-bottom: 1px solid var(--line); margin-bottom: 32px; }
  .tab {
    background: none; border: none; cursor: pointer;
    padding: 14px 24px; font-family: "Geist", sans-serif;
    font-size: 13px; letter-spacing: 0.05em; text-transform: uppercase;
    color: var(--ink-soft); border-bottom: 2px solid transparent;
    margin-bottom: -1px;
  }
  .tab.active { color: var(--accent); border-bottom-color: var(--accent); }
  .tab-panel { display: none; }
  .tab-panel.active { display: block; }

  /* TABLE */
  table { width: 100%; border-collapse: collapse; font-size: 13px; }
  th {
    text-align: left; padding: 12px 16px;
    font-size: 10px; letter-spacing: 0.12em; text-transform: uppercase;
    color: var(--muted); font-weight: 500;
    border-bottom: 1px solid var(--line);
  }
  th.num, td.num { text-align: right; font-family: "JetBrains Mono", monospace; }
  td { padding: 14px 16px; border-bottom: 1px solid var(--line); }
  tr:last-child td { border-bottom: none; }
  tbody tr:hover { background: var(--surface); }

  /* CALLOUT */
  .callout {
    background: var(--accent-soft); border-left: 3px solid var(--accent);
    padding: 18px 24px; font-size: 13px; line-height: 1.7;
  }
  .callout strong { color: var(--accent); }

  /* CHIPS */
  .chip {
    background: transparent; border: 1px solid var(--line); color: var(--ink-soft);
    padding: 6px 14px; font-size: 11px; cursor: pointer;
    font-family: "Geist", sans-serif; letter-spacing: 0.05em;
    text-transform: uppercase;
  }
  .chip:hover { border-color: var(--accent); color: var(--accent); }
  .chip.active { background: var(--ink); color: var(--bg); border-color: var(--ink); }

  /* TWO-COL */
  .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }

  /* FOOTER */
  footer {
    margin-top: 80px; padding-top: 32px; border-top: 1px solid var(--line);
    color: var(--muted); font-size: 11px; text-align: center;
    letter-spacing: 0.05em;
  }

  /* RESPONSIVE — single breakpoint */
  @media (max-width: 880px) {
    .kpi-grid { grid-template-columns: repeat(2, 1fr); }
    .two-col  { grid-template-columns: 1fr; }
    h1        { font-size: 32px; }
  }
</style>
</head>
<body>
<div class="container">

  <!-- ============================================================
       HEADER — change brand-mark, h1, subtitle
       ============================================================ -->
  <header class="header">
    <div>
      <div class="brand-mark">Project Category</div>
      <h1>Project Title<br><em>Italic subtitle</em></h1>
      <p class="subtitle">A one-line summary describing the document's purpose.</p>
    </div>
    <button class="toggle-btn" onclick="toggleTheme()">◐ Theme</button>
  </header>

  <!-- ============================================================
       SECTION 1 — Overview with KPI grid
       ============================================================ -->
  <section class="section">
    <div class="section-label">01 / Overview</div>
    <h2>Headline metrics</h2>
    <div class="kpi-grid">
      <div class="kpi">
        <div class="kpi-label">Metric One</div>
        <div class="kpi-value">42.0%</div>
        <div class="kpi-sub">Description</div>
      </div>
      <div class="kpi">
        <div class="kpi-label">Metric Two</div>
        <div class="kpi-value pos">+12.4%</div>
        <div class="kpi-sub">vs baseline</div>
      </div>
      <div class="kpi">
        <div class="kpi-label">Metric Three</div>
        <div class="kpi-value">1.85</div>
        <div class="kpi-sub">ratio</div>
      </div>
      <div class="kpi">
        <div class="kpi-label">Metric Four</div>
        <div class="kpi-value neg">-3.2%</div>
        <div class="kpi-sub">drawdown</div>
      </div>
    </div>
  </section>

  <!-- ============================================================
       SECTION 2 — Detail with surface containing prose + table
       ============================================================ -->
  <section class="section">
    <div class="section-label">02 / Detail</div>
    <h2>Section heading</h2>

    <div class="surface" style="margin-bottom: 24px;">
      <h3>Subsection title</h3>
      <p style="margin-bottom: 14px;">
        Body copy in Geist, 14px, line-height 1.6. Mix in <strong>strong emphasis</strong>
        sparingly. Paragraphs do the heavy lifting in this design system — avoid bullet
        lists for prose. Lists are reserved for genuinely enumerable data.
      </p>
      <p>
        For a key phrase that needs visual weight, italicize with <em>em tags</em>
        — italics on Fraunces are genuinely beautiful and quietly authoritative.
      </p>
    </div>

    <div class="surface">
      <h3>Tabular data</h3>
      <p style="font-size: 12px; color: var(--ink-soft); margin-bottom: 16px;">
        Every numerical column gets <code>class="num"</code> on the th and td — applies
        right-alignment and JetBrains Mono in one move.
      </p>
      <table>
        <thead>
          <tr>
            <th>Item</th>
            <th class="num">Count</th>
            <th class="num">Value</th>
            <th class="num">Change</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>First item</td>
            <td class="num">142</td>
            <td class="num">3,450.20</td>
            <td class="num pos">+2.1%</td>
          </tr>
          <tr>
            <td>Second item</td>
            <td class="num">98</td>
            <td class="num">1,820.50</td>
            <td class="num neg">-0.8%</td>
          </tr>
          <tr>
            <td>Third item</td>
            <td class="num">211</td>
            <td class="num">5,120.00</td>
            <td class="num pos">+4.7%</td>
          </tr>
        </tbody>
      </table>
    </div>
  </section>

  <!-- ============================================================
       SECTION 3 — Two-column comparison
       ============================================================ -->
  <section class="section">
    <div class="section-label">03 / Comparison</div>
    <h2>Side by side</h2>
    <div class="two-col">
      <div class="surface">
        <h3>Variant A</h3>
        <p>Use the two-col grid for paired data that should be read as direct comparison —
           e.g. before/after, region A vs region B, strategy vs baseline.</p>
      </div>
      <div class="surface">
        <h3>Variant B</h3>
        <p>The grid stacks to a single column on screens narrower than 880px.</p>
      </div>
    </div>
  </section>

  <!-- ============================================================
       SECTION 4 — Filter chips + tabs (interactive UI patterns)
       ============================================================ -->
  <section class="section">
    <div class="section-label">04 / Interactive</div>
    <h2>Filters and tabs</h2>

    <div class="surface" style="margin-bottom: 24px;">
      <h3>Chip filters</h3>
      <p style="font-size: 12px; color: var(--ink-soft); margin-bottom: 16px;">
        Active state inverts (ink background, canvas text). Hover tints to accent.
      </p>
      <div style="display: flex; gap: 8px; flex-wrap: wrap;">
        <button class="chip active">All</button>
        <button class="chip">Winners</button>
        <button class="chip">Losers</button>
        <button class="chip">Last 30 days</button>
      </div>
    </div>

    <div class="tabs">
      <button class="tab active">Tab one</button>
      <button class="tab">Tab two</button>
      <button class="tab">Tab three</button>
    </div>
    <div class="surface">
      <p>Tab content goes here. The active tab's underline sits flush on the section
         divider via <code>margin-bottom: -1px</code> — no double line, no gap.</p>
    </div>
  </section>

  <!-- ============================================================
       SECTION 5 — Callout (use sparingly: 1-2x per page max)
       ============================================================ -->
  <section class="section">
    <div class="callout">
      <p>
        <strong>Key insight.</strong> Use callouts once or twice per document for the
        single most important takeaway. Overuse turns them into wallpaper. The left
        accent border and tinted background reserve them for moments that genuinely
        need to interrupt the reading flow.
      </p>
    </div>
  </section>

  <!-- FOOTER -->
  <footer>
    Generated [date] · [source] · [disclaimer or attribution]
  </footer>
</div>

<script>
  function toggleTheme() {
    const c = document.documentElement.getAttribute('data-theme');
    document.documentElement.setAttribute('data-theme', c === 'dark' ? 'light' : 'dark');
  }
</script>
</body>
</html>
EDITORIAL_EXECUTIVE_SKILL_PAYLOAD_1777139073

# ----------------------------------------------------------------------------
echo "  · writing examples/kpi-grid.html"
cat > "$TARGET/examples/kpi-grid.html" << 'EDITORIAL_EXECUTIVE_SKILL_PAYLOAD_1777139073'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>KPI Grid Variants — Editorial Executive</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300;9..144,400;9..144,600;9..144,700&family=Geist:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
  /*
   * KPI GRID VARIANTS — for the Editorial Executive design system.
   *
   * Four patterns:
   *   1. Standard 4-column: top-of-page headline metrics
   *   2. 8-cell two-row: deeper diagnostics with secondary metrics
   *   3. Scorecard with delta arrows: when YoY/QoQ change is the story
   *   4. Compact mini-grid: 6-cell sidebar/dashboard summary (smaller type)
   *
   * The signature trick is `gap: 1px` with `background: var(--line)` on the parent
   * container, producing continuous hairline gutters with no doubled borders.
   */

  :root {
    --bg: #faf9f6; --surface: #fff; --ink: #0a1628; --ink-soft: #4a5568;
    --line: #e2e0d8; --accent: #b8341a; --accent-soft: #f4ddd5;
    --positive: #1b5e20; --negative: #b8341a; --muted: #8a8578; --gold: #b08d3a;
  }
  [data-theme="dark"] {
    --bg: #0e1116; --surface: #181c23; --ink: #f0ede4; --ink-soft: #b0aea6;
    --line: #2a2e36; --accent: #e85a3c; --accent-soft: #3a1d15;
    --positive: #6dd474; --negative: #e85a3c; --muted: #6f6c63; --gold: #d4a85a;
  }
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    background: var(--bg); color: var(--ink);
    font-family: "Geist", sans-serif; font-size: 14px; line-height: 1.6;
    transition: background .3s, color .3s;
  }
  .container { max-width: 1240px; margin: 0 auto; padding: 48px 32px 80px; }
  .demo-section { margin-bottom: 64px; }
  .demo-label {
    font-family: "Fraunces", serif; font-weight: 600; font-size: 11px;
    letter-spacing: 0.2em; text-transform: uppercase; color: var(--accent);
    margin-bottom: 8px;
  }
  .demo-title {
    font-family: "Fraunces", serif; font-weight: 400; font-size: 24px;
    letter-spacing: -0.01em; margin-bottom: 8px;
  }
  .demo-desc { color: var(--ink-soft); font-size: 13px; margin-bottom: 24px; max-width: 720px; }
  .toggle-btn {
    background: transparent; border: 1px solid var(--line); color: var(--ink);
    padding: 8px 14px; font-size: 12px; cursor: pointer; float: right;
    font-family: "Geist", sans-serif; letter-spacing: 0.05em; text-transform: uppercase;
  }

  /* ============================================================
     SHARED KPI BASE
     ============================================================ */
  .kpi-grid {
    display: grid; gap: 1px;
    background: var(--line); border: 1px solid var(--line);
  }
  .kpi { background: var(--surface); padding: 24px 20px; }
  .kpi-label {
    font-size: 10px; letter-spacing: 0.15em; text-transform: uppercase;
    color: var(--muted); margin-bottom: 10px;
  }
  .kpi-value {
    font-family: "Fraunces", serif; font-weight: 400; font-size: 32px;
    letter-spacing: -0.02em; line-height: 1;
  }
  .kpi-sub { font-size: 12px; color: var(--ink-soft); margin-top: 8px; }
  .pos { color: var(--positive); }
  .neg { color: var(--negative); }

  /* ============================================================
     VARIANT 1 — Standard 4-column
     ============================================================ */
  .kpi-grid-4 { grid-template-columns: repeat(4, 1fr); }

  /* ============================================================
     VARIANT 2 — 8-cell two-row (4×2 layout)
     ============================================================ */
  .kpi-grid-8 { grid-template-columns: repeat(4, 1fr); }

  /* ============================================================
     VARIANT 3 — Scorecard with delta arrows
     The arrow + change pattern: stack value over change in a horizontal row
     ============================================================ */
  .kpi-scorecard { grid-template-columns: repeat(3, 1fr); }
  .kpi-scorecard .kpi { padding: 28px 24px; }
  .kpi-scorecard .kpi-value { font-size: 40px; }
  .kpi-delta {
    display: inline-flex; align-items: baseline; gap: 6px;
    font-family: "JetBrains Mono", monospace; font-size: 13px;
    margin-top: 12px;
  }
  .kpi-delta .arrow { font-size: 11px; }
  .kpi-delta-label { color: var(--muted); font-size: 11px; margin-left: 6px;
                     font-family: "Geist", sans-serif; letter-spacing: 0.05em; }

  /* ============================================================
     VARIANT 4 — Compact mini-grid (6 cells, smaller scale)
     ============================================================ */
  .kpi-mini { grid-template-columns: repeat(3, 1fr); }
  .kpi-mini .kpi { padding: 16px 18px; }
  .kpi-mini .kpi-label { font-size: 9px; margin-bottom: 6px; }
  .kpi-mini .kpi-value { font-size: 22px; }
  .kpi-mini .kpi-sub { font-size: 11px; margin-top: 4px; }

  /* ============================================================
     VARIANT 5 — KPI with embedded sparkline strip
     A 1-line trend indicator beneath the value
     ============================================================ */
  .kpi-spark .spark {
    margin-top: 14px; display: flex; align-items: flex-end;
    gap: 2px; height: 24px;
  }
  .spark-bar {
    flex: 1; background: var(--ink-soft); opacity: 0.4; min-height: 2px;
    transition: opacity .15s;
  }
  .spark-bar.last { background: var(--accent); opacity: 1; }
  .kpi-spark:hover .spark-bar { opacity: 0.7; }
  .kpi-spark:hover .spark-bar.last { opacity: 1; }

  /* RESPONSIVE */
  @media (max-width: 880px) {
    .kpi-grid-4 { grid-template-columns: repeat(2, 1fr); }
    .kpi-grid-8 { grid-template-columns: repeat(2, 1fr); }
    .kpi-scorecard { grid-template-columns: 1fr; }
    .kpi-mini { grid-template-columns: repeat(2, 1fr); }
  }
</style>
</head>
<body>
<div class="container">
  <button class="toggle-btn" onclick="toggleTheme()">◐ Theme</button>
  <h1 style="font-family:'Fraunces',serif;font-weight:400;font-size:36px;
             letter-spacing:-0.02em;margin-bottom:48px;font-variation-settings:'opsz' 144;">
    KPI Grid <em style="color:var(--accent);font-style:italic">Variants</em>
  </h1>

  <!-- ============================================================
       VARIANT 1 — STANDARD 4-COLUMN
       ============================================================ -->
  <section class="demo-section">
    <div class="demo-label">Variant 01 / Standard</div>
    <div class="demo-title">Four-column headline metrics</div>
    <p class="demo-desc">
      The default. Use this at the top of any analytical page for top-line metrics.
      Drops to 2 columns on screens under 880px.
    </p>
    <div class="kpi-grid kpi-grid-4">
      <div class="kpi">
        <div class="kpi-label">Total Trades</div>
        <div class="kpi-value">142</div>
        <div class="kpi-sub">2021 → 2026</div>
      </div>
      <div class="kpi">
        <div class="kpi-label">Win Rate</div>
        <div class="kpi-value pos">58.4%</div>
        <div class="kpi-sub">vs baseline 52.1%</div>
      </div>
      <div class="kpi">
        <div class="kpi-label">Profit Factor</div>
        <div class="kpi-value pos">1.62</div>
        <div class="kpi-sub">Σwins ÷ |Σlosses|</div>
      </div>
      <div class="kpi">
        <div class="kpi-label">Total Return</div>
        <div class="kpi-value pos">+24.7%</div>
        <div class="kpi-sub">net of costs</div>
      </div>
    </div>
  </section>

  <!-- ============================================================
       VARIANT 2 — 8-CELL TWO-ROW
       ============================================================ -->
  <section class="demo-section">
    <div class="demo-label">Variant 02 / Extended</div>
    <div class="demo-title">Eight-cell diagnostic grid</div>
    <p class="demo-desc">
      For when headline + secondary metrics are both essential. Layout naturally as
      two rows of four with no special markup — the parent grid handles it.
    </p>
    <div class="kpi-grid kpi-grid-8">
      <div class="kpi"><div class="kpi-label">Trades</div>
        <div class="kpi-value">142</div>
        <div class="kpi-sub">2021 → 2026</div></div>
      <div class="kpi"><div class="kpi-label">Win Rate</div>
        <div class="kpi-value pos">58.4%</div>
        <div class="kpi-sub">vs base 52.1%</div></div>
      <div class="kpi"><div class="kpi-label">Profit Factor</div>
        <div class="kpi-value pos">1.62</div>
        <div class="kpi-sub">net</div></div>
      <div class="kpi"><div class="kpi-label">Total Return</div>
        <div class="kpi-value pos">+24.7%</div>
        <div class="kpi-sub">cumulative</div></div>
      <div class="kpi"><div class="kpi-label">Expectancy</div>
        <div class="kpi-value">+0.18%</div>
        <div class="kpi-sub">per trade</div></div>
      <div class="kpi"><div class="kpi-label">Avg Win/Loss</div>
        <div class="kpi-value">1.42</div>
        <div class="kpi-sub">+0.51% / -0.36%</div></div>
      <div class="kpi"><div class="kpi-label">Max Drawdown</div>
        <div class="kpi-value neg">-8.2%</div>
        <div class="kpi-sub">peak-to-trough</div></div>
      <div class="kpi"><div class="kpi-label">Sharpe</div>
        <div class="kpi-value">0.42</div>
        <div class="kpi-sub">per trade</div></div>
    </div>
  </section>

  <!-- ============================================================
       VARIANT 3 — SCORECARD WITH DELTAS
       ============================================================ -->
  <section class="demo-section">
    <div class="demo-label">Variant 03 / Scorecard</div>
    <div class="demo-title">Three-column scorecard with period deltas</div>
    <p class="demo-desc">
      When the change is the story (YoY, QoQ, vs benchmark). Larger value type,
      explicit delta arrows below. The arrow uses the unicode triangle character —
      no icon library needed.
    </p>
    <div class="kpi-grid kpi-scorecard">
      <div class="kpi">
        <div class="kpi-label">Revenue</div>
        <div class="kpi-value">₹4.82 Cr</div>
        <div class="kpi-delta pos">
          <span class="arrow">▲</span><span>+12.4%</span>
          <span class="kpi-delta-label">vs Q3</span>
        </div>
      </div>
      <div class="kpi">
        <div class="kpi-label">Active Clients</div>
        <div class="kpi-value">38</div>
        <div class="kpi-delta pos">
          <span class="arrow">▲</span><span>+4</span>
          <span class="kpi-delta-label">net new</span>
        </div>
      </div>
      <div class="kpi">
        <div class="kpi-label">Avg Deal Size</div>
        <div class="kpi-value">₹12.7 L</div>
        <div class="kpi-delta neg">
          <span class="arrow">▼</span><span>-3.1%</span>
          <span class="kpi-delta-label">vs Q3</span>
        </div>
      </div>
    </div>
  </section>

  <!-- ============================================================
       VARIANT 4 — COMPACT MINI-GRID
       ============================================================ -->
  <section class="demo-section">
    <div class="demo-label">Variant 04 / Compact</div>
    <div class="demo-title">Six-cell mini-grid for sidebars or dense dashboards</div>
    <p class="demo-desc">
      Smaller type scale (22px values vs 32px) for when KPIs are supporting content
      rather than the page's headline. Good in two-col layouts or above detail tables.
    </p>
    <div class="kpi-grid kpi-mini">
      <div class="kpi"><div class="kpi-label">CPU</div>
        <div class="kpi-value">42%</div></div>
      <div class="kpi"><div class="kpi-label">Memory</div>
        <div class="kpi-value">61%</div></div>
      <div class="kpi"><div class="kpi-label">Disk</div>
        <div class="kpi-value">23%</div></div>
      <div class="kpi"><div class="kpi-label">Latency p50</div>
        <div class="kpi-value">38ms</div></div>
      <div class="kpi"><div class="kpi-label">Latency p99</div>
        <div class="kpi-value neg">412ms</div></div>
      <div class="kpi"><div class="kpi-label">Errors</div>
        <div class="kpi-value pos">0.02%</div></div>
    </div>
  </section>

  <!-- ============================================================
       VARIANT 5 — KPI WITH SPARKLINE
       ============================================================ -->
  <section class="demo-section">
    <div class="demo-label">Variant 05 / With Sparkline</div>
    <div class="demo-title">KPIs with embedded micro-trend strips</div>
    <p class="demo-desc">
      A pure-CSS sparkline (no library needed). The last bar is colored
      <code>--accent</code> to anchor "now" in the visual. Use when trend matters
      as much as the current value.
    </p>
    <div class="kpi-grid kpi-grid-4">
      <div class="kpi kpi-spark">
        <div class="kpi-label">Daily Active Users</div>
        <div class="kpi-value">8,420</div>
        <div class="spark">
          <div class="spark-bar" style="height: 30%"></div>
          <div class="spark-bar" style="height: 45%"></div>
          <div class="spark-bar" style="height: 38%"></div>
          <div class="spark-bar" style="height: 52%"></div>
          <div class="spark-bar" style="height: 60%"></div>
          <div class="spark-bar" style="height: 55%"></div>
          <div class="spark-bar" style="height: 70%"></div>
          <div class="spark-bar" style="height: 68%"></div>
          <div class="spark-bar" style="height: 80%"></div>
          <div class="spark-bar last" style="height: 95%"></div>
        </div>
      </div>
      <div class="kpi kpi-spark">
        <div class="kpi-label">Conversion</div>
        <div class="kpi-value">3.42%</div>
        <div class="spark">
          <div class="spark-bar" style="height: 70%"></div>
          <div class="spark-bar" style="height: 65%"></div>
          <div class="spark-bar" style="height: 80%"></div>
          <div class="spark-bar" style="height: 60%"></div>
          <div class="spark-bar" style="height: 55%"></div>
          <div class="spark-bar" style="height: 75%"></div>
          <div class="spark-bar" style="height: 50%"></div>
          <div class="spark-bar" style="height: 45%"></div>
          <div class="spark-bar" style="height: 40%"></div>
          <div class="spark-bar last" style="height: 35%"></div>
        </div>
      </div>
      <div class="kpi kpi-spark">
        <div class="kpi-label">NPS</div>
        <div class="kpi-value pos">+62</div>
        <div class="spark">
          <div class="spark-bar" style="height: 40%"></div>
          <div class="spark-bar" style="height: 50%"></div>
          <div class="spark-bar" style="height: 55%"></div>
          <div class="spark-bar" style="height: 65%"></div>
          <div class="spark-bar" style="height: 72%"></div>
          <div class="spark-bar" style="height: 80%"></div>
          <div class="spark-bar" style="height: 85%"></div>
          <div class="spark-bar" style="height: 88%"></div>
          <div class="spark-bar" style="height: 90%"></div>
          <div class="spark-bar last" style="height: 92%"></div>
        </div>
      </div>
      <div class="kpi kpi-spark">
        <div class="kpi-label">Revenue</div>
        <div class="kpi-value">₹4.8 Cr</div>
        <div class="spark">
          <div class="spark-bar" style="height: 30%"></div>
          <div class="spark-bar" style="height: 35%"></div>
          <div class="spark-bar" style="height: 45%"></div>
          <div class="spark-bar" style="height: 50%"></div>
          <div class="spark-bar" style="height: 60%"></div>
          <div class="spark-bar" style="height: 65%"></div>
          <div class="spark-bar" style="height: 75%"></div>
          <div class="spark-bar" style="height: 80%"></div>
          <div class="spark-bar" style="height: 88%"></div>
          <div class="spark-bar last" style="height: 100%"></div>
        </div>
      </div>
    </div>
  </section>

</div>

<script>
  function toggleTheme() {
    const c = document.documentElement.getAttribute('data-theme');
    document.documentElement.setAttribute('data-theme', c === 'dark' ? 'light' : 'dark');
  }
</script>
</body>
</html>
EDITORIAL_EXECUTIVE_SKILL_PAYLOAD_1777139073

# ----------------------------------------------------------------------------
echo "  · writing examples/chart-config.js"
cat > "$TARGET/examples/chart-config.js" << 'EDITORIAL_EXECUTIVE_SKILL_PAYLOAD_1777139073'
/* =============================================================================
 * CHART CONFIGURATIONS — Editorial Executive design system
 *
 * All chart colors are read from CSS variables so charts respond to theme toggle.
 * Call rerenderAllCharts() inside toggleTheme() to swap colors live.
 *
 * Includes:
 *   1. cssVar()                    — read CSS custom property at runtime
 *   2. baseChartOptions()          — shared scales/grid/font config
 *   3. createLineChart()           — single-line equity / time series
 *   4. createMultiLineChart()      — comparison overlays (strategy vs benchmark)
 *   5. createBarChart()            — categorical bars (yearly returns, by-segment)
 *   6. createDistributionChart()   — histogram of trade returns or P&L
 *   7. createDivergingBarSVG()     — wins-up / losses-down stacked bars (custom SVG)
 *   8. renderHeatmap()             — diverging color heatmap (matrix data)
 *   9. setupChartTheming()         — wires re-render to theme toggle
 *
 * Requires Chart.js 4.x via CDN:
 *   <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
 * ============================================================================= */

// -----------------------------------------------------------------------------
// 1. Read a CSS custom property — used by every chart
// -----------------------------------------------------------------------------
function cssVar(name) {
  return getComputedStyle(document.documentElement).getPropertyValue(name).trim();
}

// -----------------------------------------------------------------------------
// 2. Shared base options — never override these without good reason
// -----------------------------------------------------------------------------
function baseChartOptions(extra = {}) {
  return {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        display: extra.showLegend ?? false,
        labels: {
          color: cssVar('--ink-soft'),
          font: { family: 'Geist', size: 11 },
          boxWidth: 12, boxHeight: 12, padding: 16
        }
      },
      tooltip: {
        backgroundColor: cssVar('--ink'),
        titleColor: cssVar('--bg'),
        bodyColor: cssVar('--bg'),
        titleFont: { family: 'Geist', size: 11, weight: '600' },
        bodyFont:  { family: 'JetBrains Mono', size: 11 },
        padding: 10,
        cornerRadius: 0,           // square corners — design system rule
        displayColors: false,
        borderColor: cssVar('--accent'),
        borderWidth: 1
      }
    },
    scales: {
      x: {
        ticks: {
          color: cssVar('--ink-soft'),
          font: { family: 'JetBrains Mono', size: 10 },
          maxTicksLimit: 8
        },
        grid: { color: cssVar('--line'), drawBorder: false }
      },
      y: {
        ticks: {
          color: cssVar('--ink-soft'),
          font: { family: 'JetBrains Mono', size: 10 }
        },
        grid: { color: cssVar('--line'), drawBorder: false }
      }
    },
    ...extra.options
  };
}

// -----------------------------------------------------------------------------
// 3. Single-line chart (equity curves, time series, smooth metrics)
// -----------------------------------------------------------------------------
function createLineChart(canvasId, labels, values, options = {}) {
  const ctx = document.getElementById(canvasId);
  if (!ctx) return null;

  return new Chart(ctx, {
    type: 'line',
    data: {
      labels,
      datasets: [{
        label: options.label ?? 'Series',
        data: values,
        borderColor: cssVar('--accent'),
        borderWidth: 1.5,           // never thicker — thin lines are load-bearing
        backgroundColor: 'transparent',
        pointRadius: 0,             // no dots — clutter
        pointHoverRadius: 4,
        pointHoverBackgroundColor: cssVar('--accent'),
        pointHoverBorderColor: cssVar('--bg'),
        pointHoverBorderWidth: 2,
        tension: options.tension ?? 0.1   // tiny smoothing, never cartoon curves
      }]
    },
    options: baseChartOptions(options)
  });
}

// -----------------------------------------------------------------------------
// 4. Multi-line comparison (strategy vs benchmark, A vs B)
//    Use accent for the primary series, gold for benchmark/baseline.
// -----------------------------------------------------------------------------
function createMultiLineChart(canvasId, labels, series, options = {}) {
  // series: [{ label, data, color: 'accent'|'gold'|'ink-soft' }, ...]
  const ctx = document.getElementById(canvasId);
  if (!ctx) return null;

  const colorMap = {
    accent:   cssVar('--accent'),
    gold:     cssVar('--gold'),
    'ink-soft': cssVar('--ink-soft'),
    positive: cssVar('--positive'),
    negative: cssVar('--negative')
  };

  return new Chart(ctx, {
    type: 'line',
    data: {
      labels,
      datasets: series.map((s, i) => ({
        label: s.label,
        data: s.data,
        borderColor: colorMap[s.color] ?? cssVar('--accent'),
        borderWidth: i === 0 ? 1.5 : 1.2,    // primary series slightly heavier
        borderDash: s.dashed ? [4, 4] : [],   // dashed for benchmarks
        backgroundColor: 'transparent',
        pointRadius: 0, pointHoverRadius: 4,
        tension: 0.1
      }))
    },
    options: baseChartOptions({ showLegend: true, ...options })
  });
}

// -----------------------------------------------------------------------------
// 5. Categorical bar chart (yearly returns, segment performance)
//    Auto-colors bars positive (green) / negative (red) based on value sign.
// -----------------------------------------------------------------------------
function createBarChart(canvasId, labels, values, options = {}) {
  const ctx = document.getElementById(canvasId);
  if (!ctx) return null;

  const colors = values.map(v =>
    v >= 0 ? cssVar('--positive') : cssVar('--negative')
  );

  return new Chart(ctx, {
    type: 'bar',
    data: {
      labels,
      datasets: [{
        label: options.label ?? 'Value',
        data: values,
        backgroundColor: colors,
        borderColor: colors,
        borderWidth: 0,
        borderRadius: 0,           // square corners — design system rule
        barPercentage: 0.7,
        categoryPercentage: 0.85
      }]
    },
    options: baseChartOptions(options)
  });
}

// -----------------------------------------------------------------------------
// 6. Distribution / histogram (return distribution, P&L spread)
// -----------------------------------------------------------------------------
function createDistributionChart(canvasId, bins, counts, options = {}) {
  // bins: array of bin labels (e.g. ['-3%', '-2%', ...])
  // counts: array of frequencies
  const ctx = document.getElementById(canvasId);
  if (!ctx) return null;

  // Color each bin: negative bins red, positive bins green, zero bin muted
  const zeroIdx = bins.findIndex(b => parseFloat(b) >= 0);
  const colors = bins.map((b, i) => {
    const v = parseFloat(b);
    if (Math.abs(v) < 0.01) return cssVar('--muted');
    return v < 0 ? cssVar('--negative') : cssVar('--positive');
  });

  return new Chart(ctx, {
    type: 'bar',
    data: {
      labels: bins,
      datasets: [{
        data: counts,
        backgroundColor: colors,
        borderWidth: 0,
        borderRadius: 0,
        barPercentage: 0.95,
        categoryPercentage: 0.95
      }]
    },
    options: baseChartOptions(options)
  });
}

// -----------------------------------------------------------------------------
// 7. Diverging bar SVG (wins-up / losses-down with optional overlay line)
//    Returns an SVG string. Inject with element.innerHTML = result.
//    Drives all colors from CSS classes so it responds to theme toggle.
// -----------------------------------------------------------------------------
function createDivergingBarSVG(data, options = {}) {
  // data: [{ label, up, down, marker (optional, 0..1 for overlay dot) }]
  if (!data || data.length === 0 || data.every(d => d.up === 0 && d.down === 0)) {
    return '<svg viewBox="0 0 800 60" xmlns="http://www.w3.org/2000/svg">' +
           '<text class="dow-empty" x="400" y="35">No data to display</text></svg>';
  }

  const W = options.width  ?? 800;
  const H = options.height ?? 320;
  const PAD_L = options.padL ?? 60, PAD_R = options.padR ?? 60;
  const PAD_T = options.padT ?? 40, PAD_B = options.padB ?? 60;
  const CHART_W = W - PAD_L - PAD_R;
  const CHART_H = H - PAD_T - PAD_B;
  const ZERO_Y  = PAD_T + CHART_H * 0.55;

  const maxCount = Math.max(...data.map(d => Math.max(d.up, d.down))) || 1;
  const aboveH = ZERO_Y - PAD_T;
  const belowH = (PAD_T + CHART_H) - ZERO_Y;
  const pxAbove = aboveH / maxCount;
  const pxBelow = belowH / maxCount;
  const band = CHART_W / data.length;
  const barW = band * 0.55;

  let svg = `<svg viewBox="0 0 ${W} ${H}" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet">`;

  // Grid lines + count labels at quartiles
  for (const frac of [0.25, 0.5, 0.75, 1.0]) {
    const yUp = ZERO_Y - frac * aboveH;
    const yDn = ZERO_Y + frac * belowH;
    const cnt = Math.round(frac * maxCount);
    svg += `<line class="dow-axis-line" x1="${PAD_L}" y1="${yUp.toFixed(1)}" x2="${W-PAD_R}" y2="${yUp.toFixed(1)}" opacity="0.3"/>`;
    svg += `<line class="dow-axis-line" x1="${PAD_L}" y1="${yDn.toFixed(1)}" x2="${W-PAD_R}" y2="${yDn.toFixed(1)}" opacity="0.3"/>`;
    svg += `<text class="dow-axis-label" x="${PAD_L-8}" y="${(yUp+4).toFixed(1)}" text-anchor="end">${cnt}</text>`;
    svg += `<text class="dow-axis-label" x="${PAD_L-8}" y="${(yDn+4).toFixed(1)}" text-anchor="end">${cnt}</text>`;
  }

  // Zero line
  svg += `<line class="dow-zero-line" x1="${PAD_L}" y1="${ZERO_Y}" x2="${W-PAD_R}" y2="${ZERO_Y}"/>`;

  // Side labels
  svg += `<text class="dow-stat-label" x="${PAD_L-8}" y="${PAD_T-12}" text-anchor="end">${options.upLabel ?? 'Up'} ↑</text>`;
  svg += `<text class="dow-stat-label" x="${PAD_L-8}" y="${H-PAD_B+18}" text-anchor="end">${options.downLabel ?? 'Down'} ↓</text>`;

  // Bars + labels
  const markerPts = [];
  data.forEach((d, i) => {
    const cx = PAD_L + band * i + band / 2;
    const x  = cx - barW / 2;
    const upH   = d.up   * pxAbove;
    const downH = d.down * pxBelow;

    if (d.up > 0) {
      svg += `<rect class="dow-bar-win" x="${x.toFixed(1)}" y="${(ZERO_Y - upH).toFixed(1)}" width="${barW.toFixed(1)}" height="${upH.toFixed(1)}" rx="0"/>`;
      if (upH > 18) {
        svg += `<text class="dow-bar-label" x="${cx.toFixed(1)}" y="${(ZERO_Y - upH + 13).toFixed(1)}">${d.up}</text>`;
      } else {
        svg += `<text class="dow-axis-label" x="${cx.toFixed(1)}" y="${(ZERO_Y - upH - 6).toFixed(1)}" text-anchor="middle" style="fill:var(--positive);font-weight:600">${d.up}</text>`;
      }
    }
    if (d.down > 0) {
      svg += `<rect class="dow-bar-loss" x="${x.toFixed(1)}" y="${ZERO_Y.toFixed(1)}" width="${barW.toFixed(1)}" height="${downH.toFixed(1)}" rx="0"/>`;
      if (downH > 18) {
        svg += `<text class="dow-bar-label" x="${cx.toFixed(1)}" y="${(ZERO_Y + downH - 5).toFixed(1)}">${d.down}</text>`;
      } else {
        svg += `<text class="dow-axis-label" x="${cx.toFixed(1)}" y="${(ZERO_Y + downH + 14).toFixed(1)}" text-anchor="middle" style="fill:var(--negative);font-weight:600">${d.down}</text>`;
      }
    }

    svg += `<text class="dow-day-label" x="${cx.toFixed(1)}" y="${(H-PAD_B+38).toFixed(1)}" text-anchor="middle">${d.label}</text>`;
    if (d.sublabel) {
      svg += `<text class="dow-stat-label" x="${cx.toFixed(1)}" y="${(H-PAD_B+52).toFixed(1)}" text-anchor="middle">${d.sublabel}</text>`;
    }

    if (typeof d.marker === 'number') {
      const my = ZERO_Y - d.marker * aboveH;
      markerPts.push({ x: cx, y: my, value: d.marker });
    }
  });

  // Marker overlay line (e.g. win-rate line on top of win/loss bars)
  if (markerPts.length > 1) {
    const path = 'M ' + markerPts.map(p => `${p.x.toFixed(1)},${p.y.toFixed(1)}`).join(' L ');
    svg += `<path class="dow-winrate-line" d="${path}"/>`;
  }
  markerPts.forEach(p => {
    svg += `<circle class="dow-winrate-dot" cx="${p.x.toFixed(1)}" cy="${p.y.toFixed(1)}" r="4.5"/>`;
    svg += `<text class="dow-stat-value" x="${p.x.toFixed(1)}" y="${(p.y - 10).toFixed(1)}" text-anchor="middle" style="fill:var(--gold)">${(p.value * 100).toFixed(0)}%</text>`;
  });

  // Legend
  if (options.showLegend !== false) {
    const lgY = 18;
    svg += `<rect class="dow-bar-win"  x="${PAD_L}"     y="${lgY-9}" width="14" height="10" rx="0"/>`;
    svg += `<text class="dow-stat-label" x="${PAD_L+20}" y="${lgY}">${options.upLabel ?? 'Wins'}</text>`;
    svg += `<rect class="dow-bar-loss" x="${PAD_L+80}"  y="${lgY-9}" width="14" height="10" rx="0"/>`;
    svg += `<text class="dow-stat-label" x="${PAD_L+100}" y="${lgY}">${options.downLabel ?? 'Losses'}</text>`;
    if (markerPts.length > 0) {
      svg += `<circle class="dow-winrate-dot" cx="${PAD_L+180}" cy="${lgY-3}" r="4.5"/>`;
      svg += `<text class="dow-stat-label" x="${PAD_L+192}" y="${lgY}">${options.markerLabel ?? 'Rate'}</text>`;
    }
  }

  svg += '</svg>';
  return svg;
}

// Required CSS classes for the diverging bar SVG (add to your <style>):
//
//   .dow-bar-win   { fill: var(--positive); }
//   .dow-bar-loss  { fill: var(--negative); }
//   .dow-axis-line { stroke: var(--line); stroke-width: 1; }
//   .dow-zero-line { stroke: var(--ink-soft); stroke-width: 1; opacity: 0.4; }
//   .dow-axis-label { fill: var(--muted); font-family: "JetBrains Mono", monospace;
//                     font-size: 11px; }
//   .dow-day-label  { fill: var(--ink); font-family: "Fraunces", serif;
//                     font-size: 14px; font-weight: 500; }
//   .dow-stat-label { fill: var(--muted); font-family: "Geist", sans-serif;
//                     font-size: 9px; letter-spacing: 0.1em; text-transform: uppercase; }
//   .dow-stat-value { fill: var(--ink); font-family: "JetBrains Mono", monospace;
//                     font-size: 12px; font-weight: 500; }
//   .dow-bar-label  { fill: var(--surface); font-family: "JetBrains Mono", monospace;
//                     font-size: 10px; font-weight: 600; text-anchor: middle; }
//   .dow-winrate-line { stroke: var(--gold); stroke-width: 1.5;
//                       stroke-dasharray: 3 3; fill: none; }
//   .dow-winrate-dot  { fill: var(--gold); stroke: var(--bg); stroke-width: 2; }
//   .dow-empty { fill: var(--muted); font-family: "Fraunces", serif;
//                font-size: 11px; font-style: italic; text-anchor: middle; }

// -----------------------------------------------------------------------------
// 8. Diverging-color heatmap (matrix data — months × years, hours × days, etc.)
//    Renders into a parent div via innerHTML.
// -----------------------------------------------------------------------------
function renderHeatmap(containerId, data, options = {}) {
  // data: { rowLabels: ['2021','2022',...], colLabels: ['Jan','Feb',...],
  //         matrix: [[v1, v2, ...], ...] }   // null cells allowed
  const container = document.getElementById(containerId);
  if (!container) return;

  const flat = data.matrix.flat().filter(v => v !== null && v !== undefined);
  if (flat.length === 0) {
    container.innerHTML = '<p style="padding:24px;color:var(--muted);text-align:center;">No data</p>';
    return;
  }

  const vmax = Math.max(Math.abs(Math.min(...flat)), Math.abs(Math.max(...flat))) || 1;
  const decimals = options.decimals ?? 1;

  let html = '<div class="heatmap" style="display:grid;gap:2px;font-size:11px;font-family:\'JetBrains Mono\',monospace;">';
  // Header row
  html += `<div class="heatmap-row" style="display:grid;grid-template-columns:60px repeat(${data.colLabels.length},1fr);gap:2px;">`;
  html += '<div class="heatmap-cell label" style="background:transparent;color:var(--muted);"></div>';
  data.colLabels.forEach(c => {
    html += `<div class="heatmap-cell label" style="background:transparent;color:var(--muted);text-align:center;padding:8px 4px;font-size:10px;letter-spacing:0.1em;">${c}</div>`;
  });
  html += '</div>';

  // Data rows
  data.rowLabels.forEach((rowLabel, i) => {
    html += `<div class="heatmap-row" style="display:grid;grid-template-columns:60px repeat(${data.colLabels.length},1fr);gap:2px;">`;
    html += `<div class="heatmap-cell label" style="background:transparent;color:var(--muted);padding:10px 4px;font-weight:500;display:flex;align-items:center;">${rowLabel}</div>`;
    data.matrix[i].forEach(v => {
      if (v === null || v === undefined) {
        html += '<div class="heatmap-cell" style="padding:10px 4px;text-align:center;background:var(--surface);opacity:0.25;min-height:36px;">·</div>';
      } else {
        const intensity = Math.min(Math.abs(v) / vmax, 1.0);
        const bg = v >= 0
          ? `rgba(27,94,32,${0.10 + intensity * 0.55})`
          : `rgba(184,52,26,${0.10 + intensity * 0.55})`;
        const color = intensity > 0.4
          ? (v >= 0 ? '#0a3d10' : '#5a1a0a')
          : 'var(--ink)';
        const display = options.asPercent
          ? `${(v >= 0 ? '+' : '')}${(v * 100).toFixed(decimals)}`
          : v.toFixed(decimals);
        html += `<div class="heatmap-cell" style="padding:10px 4px;text-align:center;min-height:36px;background:${bg};color:${color};">${display}</div>`;
      }
    });
    html += '</div>';
  });
  html += '</div>';
  container.innerHTML = html;
}

// -----------------------------------------------------------------------------
// 9. Theme-aware re-rendering — wire this to the toggle button
// -----------------------------------------------------------------------------
const _chartRegistry = [];

function registerChart(chartInstance, rebuilderFn) {
  // rebuilderFn: () => Chart (a closure that reconstructs the chart)
  _chartRegistry.push({ chart: chartInstance, rebuild: rebuilderFn });
}

function rerenderAllCharts() {
  _chartRegistry.forEach(entry => {
    if (entry.chart && typeof entry.chart.destroy === 'function') {
      entry.chart.destroy();
    }
    entry.chart = entry.rebuild();
  });
}

// Wire into theme toggle. Replace the body of toggleTheme in your HTML with:
//
//   function toggleTheme() {
//     const c = document.documentElement.getAttribute('data-theme');
//     document.documentElement.setAttribute('data-theme', c === 'dark' ? 'light' : 'dark');
//     rerenderAllCharts();
//   }
//
// Then for each chart you create, register a rebuilder closure:
//
//   const rebuildEquity = () => createLineChart('eq-canvas', dates, values);
//   registerChart(rebuildEquity(), rebuildEquity);

// =============================================================================
// USAGE EXAMPLES
// =============================================================================
/*
// --- Single line chart ---
const rebuildEquity = () => createLineChart(
  'equity-canvas',
  ['Jan','Feb','Mar','Apr','May'],
  [1.00, 1.04, 1.02, 1.08, 1.12]
);
registerChart(rebuildEquity(), rebuildEquity);

// --- Multi-line comparison ---
const rebuildCompare = () => createMultiLineChart(
  'compare-canvas',
  ['2021','2022','2023','2024','2025'],
  [
    { label: 'Strategy',  data: [1.00, 1.18, 1.32, 1.55, 1.74], color: 'accent' },
    { label: 'Benchmark', data: [1.00, 1.08, 1.15, 1.22, 1.28], color: 'gold', dashed: true }
  ],
  { showLegend: true }
);
registerChart(rebuildCompare(), rebuildCompare);

// --- Bar chart with auto pos/neg coloring ---
const rebuildYears = () => createBarChart(
  'yearly-canvas',
  ['2021','2022','2023','2024','2025'],
  [12.4, -3.2, 8.7, 15.1, 6.8]
);
registerChart(rebuildYears(), rebuildYears);

// --- Diverging bar SVG (wins/losses by category) ---
document.getElementById('dow-chart').innerHTML = createDivergingBarSVG(
  [
    { label: 'Mon', up: 8,  down: 3, marker: 0.73, sublabel: 'n=11' },
    { label: 'Tue', up: 5,  down: 7, marker: 0.42, sublabel: 'n=12' },
    { label: 'Wed', up: 7,  down: 4, marker: 0.64, sublabel: 'n=11' },
    { label: 'Thu', up: 6,  down: 5, marker: 0.55, sublabel: 'n=11' },
    { label: 'Fri', up: 4,  down: 8, marker: 0.33, sublabel: 'n=12' }
  ],
  { upLabel: 'Wins', downLabel: 'Losses', markerLabel: 'Win rate' }
);

// --- Heatmap ---
renderHeatmap('monthly-heatmap', {
  rowLabels: ['2023','2024','2025'],
  colLabels: ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
  matrix: [
    [0.012, -0.005, 0.022, 0.018, -0.003, 0.011, 0.015, 0.024, -0.008, 0.019, 0.007, 0.013],
    [0.018, 0.022, -0.012, 0.015, 0.025, -0.005, 0.018, 0.011, 0.028, -0.014, 0.022, 0.017],
    [0.025, 0.018, 0.012, -0.008, 0.019, 0.024, null, null, null, null, null, null]
  ]
}, { asPercent: true, decimals: 1 });
*/
EDITORIAL_EXECUTIVE_SKILL_PAYLOAD_1777139073

echo ""
echo "  ✓ Installed 4 files to $TARGET"
echo ""
echo "  Verify with:"
echo "    ls $TARGET"
echo ""
echo "  In a new Claude Code session, the skill will be available."
echo "  Run /skills inside Claude Code to confirm it loaded."
echo ""
