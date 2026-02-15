# /btw Slash Command

**Quick access to BTW R MCP workflows and best practices**

---

## What Is a Slash Command?

Slash commands are custom shortcuts in Claude Code that load context and instructions. The `/btw` command activates "R Analysis Mode" with optimized BTW MCP workflows.

---

## Installation

### Step 1: Create Commands Directory

```bash
mkdir -p ~/.claude/commands
```

### Step 2: Copy the Command File

```bash
cp claude-commands/btw.md ~/.claude/commands/
```

### Step 3: Verify Installation

Start Claude Code and type:
```
/btw
```

You should see:
```
🚀 R ANALYSIS MODE: ACTIVE (BTW MCP v3 - )
BTW R MCP workflows loaded. Tools already described via MCP.
```

---

## What Does /btw Do?

The `/btw` command loads:

1. **Execution mode guidance** (subprocess vs session)
2. **V3 visibility features** (complete bidirectional capture)
3. **Workflow patterns** (Analysis Triad, Debug Loop, etc.)
4. **Tool division rules** (when to use BTW vs Claude tools)
5. **Safety gates** (production/caution/proceed)
6. **Autonomy level guidance** (how much automation to use)

---

## When to Use /btw

### Use it when:
- ✅ Starting a new R analysis session
- ✅ Need a reminder of workflow patterns
- ✅ Unsure whether to use session or subprocess mode
- ✅ Want efficiency reminders (BTW vs Claude tool division)
- ✅ Planning complex multi-step analysis

### Don't need it when:
- ❌ Quick one-off R calculations (subprocess mode works automatically)
- ❌ You're already in the middle of an analysis (context already loaded)
- ❌ Simple questions that don't require workflow guidance

---

## What It Contains

### 1. Efficiency Reminder
```
Use Claude's native tools for file operations, search, and system tasks
Use BTW tools ONLY for R session operations and RStudio integration
```

**Why?** Claude's Glob/Grep/Read/Write are faster and more capable than BTW file tools.

### 2. Execution Mode Guide

**Subprocess Mode** (default):
- Quick calculations
- No setup required
- Clean, isolated
- Example: "What's the mean of 1:100?"

**Session Mode** (advanced):
- Run `btw_mcp_session()` first
- Variables persist
- Complete visibility
- Example: Multi-step analysis workflows

### 3. V3  Features

Highlights what's NEW in v3:
- Complete bidirectional visibility (both you AND Claude see output)
- No sticky console bars
- Natural warning/error display
- Auto-inspection with 3 levels

### 4. Intent → Workflow Mapping

Quick reference table showing:
- Common tasks ("analyze dataset", "debug error", "learn package")
- Recommended workflow patterns
- Whether session mode helps

### 5. Core Workflow Patterns

**Analysis Triad**: `describe_data_frame` → `execute_r` → `save_plot`
**Debug Loop**: `read_editor` → `comment_lines` → `execute_r` → `uncomment`
**Learning Pipeline**: `search_packages` → `docs_vignette` → `execute_r`

### 6. Safety Gates

- 🔴 STOP for approval (production, security)
- 🟡 CAUTION (multi-file changes)
- 🟢 PROCEED freely (read-only ops)

### 7. Autonomy Level Guidance

When to use:
- **High LLM autonomy** (routine tasks, low stakes)
- **Collaborative** (exploratory, learning)
- **Human control** (production, critical fixes)

---

## Example Usage

### Starting a New Analysis

```bash
claude
# Type:
/btw

# Then ask:
"I have a CSV file with sales data. Help me analyze it."
```

**What happens:**
1. `/btw` loads workflow patterns
2. Claude sees: subprocess mode is default
3. Claude recommends: "Do you want session mode for multi-step analysis?"
4. You decide and proceed

### Mid-Analysis Workflow Check

```bash
# During complex analysis:
/btw

# Then ask:
"I'm building a complex model. Should I add safety checkpoints?"
```

**What happens:**
1. `/btw` loads safety gates
2. Claude sees: production work needs checkpoints
3. Claude suggests: "Let's use git stash before model changes"

---

## Customizing the Command

You can edit `~/.claude/commands/btw.md` to:
- Add your own workflow patterns
- Customize safety rules
- Add project-specific guidance
- Include frequently-used code snippets

**Example customization:**
```markdown
## My Custom Workflows

**Sales Analysis:**
1. Load from data/sales.csv
2. Clean dates with lubridate
3. Plot with ggplot2 using company theme
4. Save to reports/ folder
```

---

## Other Useful Slash Commands

Consider creating:
- `/r-debug` - Focused debugging workflows
- `/r-viz` - Plotting-specific guidance
- `/r-model` - Statistical modeling patterns
- `/r-package` - Package development workflows

**How to create:**
1. Copy `claude-commands/btw.md` to `~/.claude/commands/your-command.md`
2. Edit the content
3. Restart Claude Code
4. Use `/your-command`

---

## Troubleshooting

### "/btw command not found"

**Check:**
```bash
ls ~/.claude/commands/btw.md
```

If missing, copy from V3 package:
```bash
cp ~/path/to/V3/claude-commands/btw.md ~/.claude/commands/
```

### "Command loads but workflows don't work"

**Verify BTW MCP is connected:**
```
/mcp
```

Should show: `btw-r-v3 ✔ connected`

### "I want to modify the command"

**Edit it:**
```bash
nano ~/.claude/commands/btw.md
# Or: code ~/.claude/commands/btw.md
```

Changes take effect on next `/btw` invocation.

---

## Quick Reference

```bash
# Load R analysis mode
/btw

# Check MCP status
/mcp

# Get general help
/help

# Exit Claude Code
/exit
```

---

**Pro tip:** Use `/btw` at the start of R analysis sessions to load best practices and workflow patterns into Claude's context. This helps Claude make better decisions about tool usage and autonomy levels.
