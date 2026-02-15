# 🚀 R ANALYSIS MODE: ACTIVE (BTW MCP v3)
BTW R MCP workflows loaded. Tools already described via MCP.

## ⚠️ EFFICIENCY REMINDER
**Use Claude's native tools for file operations, search, and system tasks**
**Use BTW tools ONLY for R session operations and RStudio integration**

## 🎯 EXECUTION MODE GUIDE
**DEFAULT: Subprocess mode** - Perfect for quick calculations, no setup required
**UPGRADE: Session mode** - Run `btw_mcp_session()` for persistent + COMPLETE VISIBILITY

### 🔍 V3: Complete Bidirectional Visibility!

**Console Output Capture (NEW in v3):**
- ✅ All print() statements visible to Claude
- ✅ Auto-print output captured
- ✅ cat() and message() output visible
- ✅ Warnings captured (visible in Claude's Output section)
- ✅ Errors visible to both (!! prefix in console, "Error:" in Claude output)
- ✅ Clean console (no sticky colored bars)

**Auto-Inspection (Enhanced in v3):**
- Objects created/modified shown automatically
- Three levels via `BTW_INSPECT` env var:
  - `minimal`: Object count only
  - `standard`: Recent 5 objects (default)
  - `verbose`: All objects + types for recent 5
  - `none`: Disable inspection

**Architecture (v3):**
- Uses evaluate package for complete capture
- 534 lines, self-contained design
- Immune to MCP isolation issues
- Output size limits (1MB protection)

**Subprocess**: Clean, isolated, immediate - ideal for single calculations
**Session**: Variables persist + Claude SEES the environment - ideal for iterative analysis

## Intent → Workflow Mapping

| When you want to... | Use this workflow | Session Benefit |
|---------------------|-------------------|-----------------|
| "analyze this dataset" | **Analysis Triad**: `describe_data_frame` → `execute_r` → `save_plot` | ✅ See transformations |
| "debug this error" | **Debug Loop**: `read_editor` → `comment_lines` → `execute_r` → `uncomment` | ✅ Track state changes |
| "learn new package" | **Learning Pipeline**: `search_packages` → `docs_vignette` → `execute_r` | ✅ See objects created |
| "check my environment" | **Inspector**: Now automatic in session mode! | ✅ Always visible |
| "build production pipeline" | **Production**: Human-led with Git safety + validation checkpoints | ✅ Monitor builds |
| "explore unknown data" | **Exploratory**: Session mode + auto-inspection = full visibility | ✅ Track discoveries |
| "refactor across files" | **Refactor**: `Glob` → `Grep` → `MultiEdit` → `execute_r(tests)` | ✅ Verify changes |

## Core Workflow Patterns
**Quick calculations:** Just ask → immediate subprocess execution → clean result
**Complex analysis:** Run `btw_mcp_session()` → execute → SEE changes → iterate with full context
**Iterative development:** Session mode → Claude tracks state automatically → informed decisions
**Standard approach:** backup → analyze → execute → observe results → validate → save

*Detailed workflows: see docs/USER_MANUAL.md and docs/WORKFLOW_CAPABILITIES.md in the V3 package*

## Tool Division
**BTW for:** R execution, RStudio editor, data inspection, plots, R docs
**Claude for:** File ops, search, system tasks, web research

*Complete division: see docs/TOOLS.md in the V3 package*

## Integration Rules

**SUBPROCESS** (default): Perfect for isolated calculations and testing
**SESSION** (when needed): Activate with `btw_mcp_session()` for persistent workflows

**BEFORE** risky BTW operations:
- Claude: `git stash` for safety
- Claude: `Glob` + `Grep` to find files

**DURING** operations:
- Claude: `MultiEdit` for file changes
- BTW: `execute_r` for validation
- Claude: `BashOutput` for monitoring

**AFTER** modifications:
- BTW: `execute_r("devtools::test()")`
- Claude: `grep` to verify changes
- Claude: `git diff` to review

## Autonomy Levels
**Production:** Human control + checkpoints
**Exploratory:** Collaborative approach
**Iterative:** Balanced autonomy
**Single-shot:** High LLM autonomy

*Adjust based on stakes, uncertainty, reversibility*

## Safety Gates (Require Human Approval)

🔴 **STOP for approval:**
- Production deployments
- System-wide refactoring
- Security-sensitive code
- Database modifications
- Package removal/downgrades

🟡 **CAUTION (add checkpoints):**
- Multi-file changes
- Package installations
- First-time operations
- Performance optimizations

🟢 **PROCEED freely:**
- Read-only operations
- Documentation lookups
- Single-file analysis
- Plot generation
- Environment inspection


## Workflow Selection Rules

**IF** task has clear answer **→** Single-shot with `execute_r`
**IF** task needs refinement **→** Iterative with checkpoints
**IF** endpoint unknown **→** Exploratory with collaboration
**IF** production context **→** Maximum human control
**IF** routine operation **→** High autonomy acceptable

**DEFAULT**: When uncertain, choose collaborative approach

**MODE SELECTION**: Start with subprocess (default), upgrade to session when you need persistence

---
*Full documentation: See docs/USER_MANUAL.md and docs/WORKFLOW_CAPABILITIES.md in the V3 package*