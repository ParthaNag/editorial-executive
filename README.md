# Editorial Executive — Claude Code Skill

A McKinsey-grade design system for HTML reports, dashboards, and study tools. Once installed, Claude Code will automatically apply this design system whenever you ask for an HTML report, dashboard, study tool, or polished web deliverable.

## What's in the skill

```
editorial-executive/
├── SKILL.md                     # design principles, tokens, rules
├── starter.html                 # copy-paste base template
└── examples/
    ├── kpi-grid.html            # 5 KPI grid variants
    └── chart-config.js          # theme-aware Chart.js + SVG configs
```

---

## Installation — pick one of three methods

### Method 1 · One-line installer script (recommended)

The simplest. Download `install.sh` and run it once:

```bash
bash install.sh
```

That installs to `~/.claude/skills/editorial-executive/` (available across all your Claude Code sessions on this machine).

To install in a project-specific location instead:

```bash
bash install.sh /path/to/your/project/.claude/skills
```

The installer is self-contained — it has all four skill files embedded inside it. No internet connection or git required to run it.

### Method 2 · Zip archive

Download `editorial-executive.zip` and extract it into your skills folder:

```bash
mkdir -p ~/.claude/skills
unzip editorial-executive.zip -d ~/.claude/skills/
```

That's it. Verify with `ls ~/.claude/skills/editorial-executive/`.

### Method 3 · Git clone (if you want to version-control your customizations)

If you push the skill folder to a git repo (GitHub, GitLab, self-hosted), you can install via clone:

```bash
mkdir -p ~/.claude/skills
git clone https://github.com/ParthaNag/editorial-executive.git ~/.claude/skills/editorial-executive
```

This is the right choice if you'll iterate on the skill over time — `git pull` to update, version history preserved, easy to share with colleagues.

---

## Sharing your skill via GitHub

To make this skill available for others to install, push it to GitHub:

```bash
# Initialize git repo (if not already done)
git init
git add .
git commit -m "Initial commit: editorial-executive skill"

# Add your GitHub remote and push
git remote add origin https://github.com/ParthaNag/editorial-executive.git
git branch -M main
git push -u origin main
```

Now anyone can install your skill directly from GitHub using **Method 3** above.

---

## Verifying installation

Open a **new** Claude Code session (the skill registry is read at session start), then:

```
/skills
```

You should see `editorial-executive` in the list. If it doesn't appear, the most common causes are:

| Problem | Fix |
|---|---|
| Filename casing wrong | Must be exactly `SKILL.md`, not `skill.md` or `Skill.md` |
| Missing YAML frontmatter | The `---` block at the top of `SKILL.md` is required |
| Wrong path | Check `~/.claude/skills/editorial-executive/SKILL.md` exists |
| Old session | Open a new Claude Code session — skills load on start |

---

## Using the skill

You don't invoke skills explicitly. The `description` field in `SKILL.md` tells Claude when to load this skill automatically. Phrases that trigger it:

- "Create an HTML report for X"
- "Build me a study tool for Y"
- "Make a polished dashboard"
- "Make it look McKinsey-grade" / "consulting-grade" / "executive-grade"
- "Build an exam prep tool"

You can also force it: *"use the editorial-executive skill to build…"*

---

## Updating the skill

For methods 1 and 2, just re-run the installer or re-extract the zip — files overwrite cleanly. For method 3, `cd ~/.claude/skills/editorial-executive && git pull`.

To customize globally (e.g. change the brand-mark color from rust-red to your firm's color), edit `~/.claude/skills/editorial-executive/SKILL.md` directly. Your edits persist across all projects.

---

## Uninstalling

```bash
rm -rf ~/.claude/skills/editorial-executive
```
