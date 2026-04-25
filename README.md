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

## Installation

### Quick Start (Choose Your Method Below)

Before installing, understand where Claude Code looks for skills:

**Global location** (available in all Claude Code sessions):
- **Mac/Linux:** `~/.claude/skills/`
- **Windows:** `%USERPROFILE%\.claude\skills\` (typically `C:\Users\YourUsername\.claude\skills\`)

**Project location** (only for current project):
- `.claude/skills/` in your project root

---

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

## Installing Skills in Claude Code (UI Guide)

### For Desktop App / Web App Users

1. **Open your operating system's file manager**
   - **Mac:** Press `Cmd + Space`, type "Finder"
   - **Windows:** Press `Win + E` to open File Explorer
   - **Linux:** Open your file manager

2. **Navigate to the skills directory**
   - **Mac/Linux:** Press `Cmd + Shift + G` (or equivalent), paste `~/.claude/skills/` (create folder if it doesn't exist)
   - **Windows:** Paste this in the address bar: `%USERPROFILE%\.claude\skills\` (create folder if it doesn't exist)

3. **Copy the skill folder here**
   - Extract the `editorial-executive` folder (from zip or git clone) into `~/.claude/skills/`
   - Final path should be: `~/.claude/skills/editorial-executive/SKILL.md`

4. **Restart Claude Code**
   - Close and reopen Claude Code completely (skills load on startup)

5. **Verify installation**
   - Open Claude Code and type `/skills` in any chat
   - You should see `editorial-executive` listed

---

### For CLI Users

Install via terminal using one of the methods below (pick the one that fits your workflow):

<details>
<summary><strong>Method A: Download & Extract (Easiest)</strong></summary>

Download the `editorial-executive.zip` from GitHub releases, then:

```bash
mkdir -p ~/.claude/skills
unzip ~/Downloads/editorial-executive.zip -d ~/.claude/skills/
```

Verify:
```bash
ls -la ~/.claude/skills/editorial-executive/SKILL.md
```

</details>

<details>
<summary><strong>Method B: Git Clone (Best for Updates)</strong></summary>

Clone directly from GitHub:

```bash
mkdir -p ~/.claude/skills
git clone https://github.com/ParthaNag/editorial-executive.git ~/.claude/skills/editorial-executive
```

Later, to update: `cd ~/.claude/skills/editorial-executive && git pull`

</details>

<details>
<summary><strong>Method C: Install Script</strong></summary>

Run the installer (self-contained, no dependencies):

```bash
bash install.sh
```

To install in a specific project:
```bash
bash install.sh /path/to/your/project/.claude/skills
```

</details>

---

## Verifying Installation

### Step 1: Check the filesystem

Verify the skill folder exists in the right place:

**Mac/Linux:**
```bash
ls -la ~/.claude/skills/editorial-executive/
# Should show: SKILL.md, starter.html, examples/
```

**Windows (PowerShell):**
```powershell
Get-ChildItem $env:USERPROFILE\.claude\skills\editorial-executive\
# Should show: SKILL.md, starter.html, examples/
```

### Step 2: Verify in Claude Code

1. **Close and reopen Claude Code completely** (skills load at startup)
2. Open any chat and type: `/skills`
3. You should see `editorial-executive` in the list

---

### Troubleshooting

| Problem | Solution |
|---|---|
| **Skill doesn't appear in `/skills` list** | Close Claude Code completely and reopen it. Skills load at session start, not dynamically. |
| **"File not found" error** | Verify path: `~/.claude/skills/editorial-executive/SKILL.md` exists (check exact spelling and casing) |
| **`SKILL.md` has wrong casing** | Rename to `SKILL.md` exactly. File names are case-sensitive on Mac/Linux. |
| **Frontmatter error** | Ensure `SKILL.md` starts with `---` on line 1 and has `name:` and `description:` fields. |
| **Wrong installation folder** | Delete and reinstall to: `~/.claude/skills/editorial-executive/` (NOT a project subfolder unless intended) |
| **Permissions denied (Mac/Linux)** | Run: `chmod -R 755 ~/.claude/skills/editorial-executive/` |

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
