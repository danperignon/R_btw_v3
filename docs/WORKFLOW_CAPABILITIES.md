# BTW R MCP v3 - Workflow Capabilities Guide

> **✨ v3  Update**: Complete console visibility is now production-ready! Both you and Claude see ALL execution output simultaneously. See [USER_MANUAL.md](USER_MANUAL.md#btw-mcp-v3---complete-console-visibility) for details.



## 📚 Table of Contents

### Quick Navigation
- [🎯 I Want To...](#i-want-to) - Jump to your specific need
- [🚀 Quick Start Recipes](#quick-start-recipes) - Ready-to-use workflows
- [⚠️ Troubleshooting](#failure-modes-and-recovery) - When things go wrong

### Core Content
1. [**Tool Inventory**](#tool-inventory) - 16 capabilities at your disposal
2. [**Workflow Levels**](#workflow-levels-by-llm-involvement) - 5 levels from minimal to maximal LLM
3. [**The Complexity-Autonomy Matrix**](#the-complexity-autonomy-matrix) - 2D decision framework
4. [**Tool Synergy Patterns**](#tool-synergy-patterns) - Natural tool clusters
5. [**Workflow Transitions**](#workflow-transitions) - How tasks evolve
6. [**Risk Assessment**](#risk-assessment-framework) - Green/Yellow/Red zones
7. [**User Profiles**](#user-profiles-and-optimal-workflows) - Novice to expert patterns
8. [**Quick Start Recipes**](#quick-start-recipes) - 5 concrete scenarios
9. [**Failure Modes**](#failure-modes-and-recovery) - Recovery strategies
10. [**BTW + Claude Synergies**](#addendum-btw--claude-code-synergies) - Integrated workflows

### Reference Tables
- [Tool Categories](#tool-categories-table) - Quick tool reference
- [Workflow Selector](#workflow-selector-table) - Find your optimal approach
- [Risk Matrix](#risk-matrix-visualization) - Visual risk assessment
<!-- TOC END -->

---

## 🎯 I Want To...

### ...analyze data quickly
→ Jump to [Recipe 1: First Time with New Dataset](#recipe-1-first-time-with-new-dataset)

### ...debug my code
→ Jump to [Recipe 2: Debugging Unexpected Output](#recipe-2-debugging-unexpected-output)

### ...learn a new package
→ Jump to [Recipe 3: Learning New Package](#recipe-3-learning-new-package)

### ...create publication-quality figures
→ Jump to [Recipe 4: Preparing Publication Figure](#recipe-4-preparing-publication-figure)

### ...automate my analysis
→ Jump to [Recipe 5: Automated Report Generation](#recipe-5-automated-report-generation)

### ...understand what BTW can do

→ Continue to [Tool Inventory](#tool-inventory)

### ...choose the right automation level
→ Jump to [The Complexity-Autonomy Matrix](#the-complexity-autonomy-matrix)

### ...avoid common pitfalls
→ Jump to [Failure Modes and Recovery](#failure-modes-and-recovery)

---

## Overview

> **TLDR**: BTW R MCP v2 provides 16 tools that enable workflows ranging from simple queries to complex autonomous orchestration. This guide helps you choose the right level of LLM involvement for your specific task.

This document outlines the complete range of workflows enabled by BTW MCP v2, organized by level of LLM involvement from minimal to maximal. Each workflow demonstrates specific tool combinations and interaction patterns.

## Tool Inventory

> **TLDR**: 16 specialized R tools organized into 7 categories, from code execution to visualization.

### Tool Categories Table

| Category | Count | Tools | Primary Use |
|----------|-------|-------|-------------|
| **Execution** | 1 | `execute_r` | Run R code in session/subprocess |
| **Environment** | 2 | `env_describe_environment`<br>`env_describe_data_frame` | Workspace inspection<br>Data frame analysis |
| **Session** | 3 | `session_platform_info`<br>`session_package_info`<br>`session_check_package_installed` | System info<br>Package management<br>Availability checks |
| **Documentation** | 5 | `docs_help_page`<br>`docs_package_help_topics`<br>`docs_available_vignettes`<br>`docs_vignette`<br>`docs_package_news` | Function help<br>Package docs<br>Tutorials<br>Release notes |
| **Search** | 2 | `search_packages`<br>`search_package_info` | CRAN discovery<br>Package details |
| **IDE** | 2 | `ide_read_current_editor`<br>`editor_write` (9 actions) | Read RStudio<br>Manipulate code |
| **Visualization** | 1 | `save_plot` | Export plots |

### Editor Write Actions

```
┌─────────────────────────────────────────┐
│         9-Action Editor System          │
├─────────────────────────────────────────┤
│ Position Actions:                       │
│   • insert - at cursor                  │
│   • insert_at_line - specific line      │
│   • append - end of document            │
│   • prepend - start of document         │
├─────────────────────────────────────────┤
│ Replacement Actions:                    │
│   • replace - entire document           │
│   • replace_selection - selected text   │
│   • replace_lines - line range          │
├─────────────────────────────────────────┤
│ Debugging Actions:                      │
│   • comment_lines - add #               │
│   • uncomment_lines - remove #          │
└─────────────────────────────────────────┘
```

---

## Workflow Levels by LLM Involvement

> **TLDR**: Five levels of LLM involvement, from simple queries (Level 1) to autonomous orchestration (Level 5). Start low, increase as comfort grows.

Now that you understand the available tools, let's explore how to combine them at different levels of automation. Each level represents a different balance between human control and LLM assistance.

### Level 1: Simple Queries (Minimal LLM)
*Human asks direct questions, Claude provides single-tool answers*

| Example | Tools Used | Pattern | Time |
|---------|------------|---------|------|
| **Reference Lookup**<br>"What does lm() do?" | `docs_help_page` | Single query → response | <30s |
| **Environment Check**<br>"What's in my workspace?" | `env_describe_environment` | Status query → list | <30s |
| **Package Discovery**<br>"Find time series packages" | `search_packages` | Search → results | <1min |
| **Session Info**<br>"What R version?" | `session_platform_info` | Query → details | <30s |
| **Data Preview**<br>"Show mtcars structure" | `env_describe_data_frame` | Data → summary | <30s |

---

### Level 2: Exploratory Tasks (Light LLM)
*Human requests exploration, Claude combines 2-3 tools*

| Workflow | Tool Sequence | Use Case | Duration |
|----------|--------------|----------|----------|
| **Package Investigation** | `search_packages`<br>→ `search_package_info`<br>→ `session_check_package_installed` | Find and verify packages | 2-5min |
| **Function Learning** | `docs_help_page`<br>→ `execute_r` | Learn by example | 2-3min |
| **Data Exploration** | `env_describe_data_frame`<br>→ `execute_r`<br>→ `save_plot` | Quick data analysis | 5-10min |
| **Vignette Study** | `docs_available_vignettes`<br>→ `docs_vignette` | Package learning | 5-15min |
| **Code Context** | `ide_read_current_editor`<br>→ `env_describe_environment` | Understand state | 1-2min |

---

### Level 3: Interactive Development (Moderate LLM)

As complexity increases, we move into collaborative territory where human and Claude work together iteratively:
*Human and Claude iterate together on code*

| Workflow | Tool Flow | Pattern | Typical Duration |
|----------|-----------|---------|------------------|
| **Script Enhancement** | `ide_read_current_editor`<br>→ `editor_write(append)`<br>→ `execute_r` | Read → Modify → Test | 10-30min |
| **Debugging Session** | `editor_write(comment_lines)`<br>→ `execute_r`<br>→ `editor_write(uncomment)` | Isolate → Test → Fix | 15-45min |
| **Function Development** | `editor_write(insert_at_line)`<br>→ `execute_r`<br>→ `docs_help_page` | Write → Test → Validate | 20-60min |
| **Data Pipeline** | `execute_r(load)`<br>→ `env_describe_data_frame`<br>→ `editor_write`<br>→ `save_plot` | Load → Explore → Transform | 30-90min |
| **Package Integration** | `search_package_info`<br>→ `docs_vignette`<br>→ `editor_write`<br>→ `execute_r` | Research → Learn → Implement | 30-120min |

---

### Level 4: Collaborative Analysis (High LLM)

With increased trust and task complexity, Claude becomes a true analysis partner:

*Claude acts as analysis partner with significant autonomy*

| Workflow | Complexity | Tool Count | Human Role | Claude Role |
|----------|------------|------------|------------|--------------|
| **Statistical Modeling** | High | 4-6 tools | Set goals, validate | Propose methods, implement |
| **Report Generation** | Medium | 4-5 tools | Requirements, review | Execute, document |
| **Code Refactoring** | High | 4-5 tools | Performance goals | Identify improvements |
| **Exploratory Analysis** | High | 6+ tools | Review findings | Drive exploration |
| **Package Comparison** | Medium | 4-5 tools | Problem spec | Evaluate, recommend |

---

### Level 5: Autonomous Orchestration (Maximal LLM)

At the highest level, Claude orchestrates complete workflows autonomously:

*Claude manages complete workflows with minimal human intervention*

> ⚠️ **Warning**: High autonomy requires clear specifications and validation checkpoints

| Task | Input | Output | Risk Level | Time Saved |
|------|-------|--------|------------|------------|
| **Automated Testing** | "Test all functions" | Complete test suite | 🟡 Medium | 2-4 hours |
| **Data Quality Pipeline** | Dataset name | Quality report + fixes | 🟡 Medium | 3-6 hours |
| **Code Optimization** | "Optimize script" | Benchmarked improvements | 🔴 High | 4-8 hours |
| **Documentation Suite** | "Document package" | Complete docs | 🟢 Low | 2-3 hours |
| **Research Pipeline** | Research question | Full analysis + report | 🔴 High | Days |

---

## Capability Patterns

Having explored the five levels of LLM involvement, let's examine the underlying patterns that make these workflows effective:

| Pattern Type | Variants | Tool Requirements | Best For |
|--------------|----------|-------------------|----------|
| **Information Retrieval** | • Single lookup<br>• Comparative<br>• Comprehensive | 1-5 tools | Learning, reference |
| **Data Inspection** | • Quick view<br>• Deep dive<br>• Full profile | 1-3 tools | Understanding data |
| **Code Development** | • Incremental<br>• Refactor<br>• Debug | 2-4 tools | Building, fixing |
| **Analysis** | • Exploratory<br>• Confirmatory<br>• Comparative | 3-6 tools | Research, insights |
| **Collaboration** | • Human-led<br>• Balanced<br>• Claude-led | Any | Task dependent |

---

## Tool Combination Examples

Tools become most powerful when combined effectively:

| Combination Size | Example | Use Case | Complexity |
|-----------------|---------|----------|------------|
| **Minimal (2 tools)** | `docs_help` + `execute_r` | Learn and try | Low |
| | `describe_env` + `describe_df` | Workspace overview | Low |
| | `read_editor` + `execute_r` | Run selected code | Low |
| **Standard (3-4 tools)** | Search → Info → Check → Help | Package workflow | Medium |
| | Read → Write → Execute → Save | Development cycle | Medium |
| | Describe → Execute → Plot → Save | Analysis flow | Medium |
| **Complex (5+ tools)** | Full EDA suite | Complete exploration | High |
| | Package integration flow | New capability | High |
| | Production pipeline | Automated workflow | High |

---

## Key Insights & Recommendations

### 💡 Five Key Insights

| Insight | Implication |
|---------|-------------|
| **Tool Synergy** | Combining tools multiplies power |
| **Natural Progression** | Skills build from simple to complex |
| **Flexible Interaction** | Same tools, different styles |
| **Context Awareness** | Editor integration enables smart assistance |
| **Rich Manipulation** | 9-action editor supports any workflow |

### 🎯 Usage Recommendations

```
     Start Here
         ↓
    ┌───────────┐
    │ Level 1-2 │  Learn tool basics
    └─────┬─────┘
         │
    ┌─────┴─────┐
    │ Level 3   │  Build confidence
    └─────┬─────┘
         │
    ┌─────┴─────┐
    │ Level 4-5 │  Advanced automation
    └───────────┘
```

---

## The Complexity-Autonomy Matrix

> **TLDR**: Workflow selection isn't just about LLM involvement—it's a 2D decision based on task complexity AND desired autonomy level.

### The Two Dimensions

We've been discussing autonomy levels, but there's another crucial dimension:

```
        COMPLEXITY                    AUTONOMY
           ↑                            ↑
    Production                      Maximal
    Exploratory         vs          Collaborative
    Iterative                       Minimal
    Single-Shot                        ↓
           ↓
```

These dimensions are **independent**—high complexity doesn't require low autonomy!

### Complexity Pattern Definitions

| Pattern | Characteristics | Duration | Decision Points | Examples |
|---------|----------------|----------|-----------------|----------|
| **Single-Shot** | • Clear question<br>• Definitive answer<br>• No iteration | Seconds-Minutes | 0-1 | "What's the mean?"<br>"Show help for lm()" |
| **Iterative** | • Known goal<br>• Multiple attempts<br>• Convergence | Minutes-Hours | 2-5 | "Optimize function"<br>"Fix this error" |
| **Exploratory** | • Unknown endpoint<br>• Discovery-driven<br>• Emergent insights | Hours-Days | Many, branching | "Find patterns"<br>"Compare approaches" |
| **Production** | • Strict requirements<br>• Quality gates<br>• System integration | Days-Weeks | Structured | "Build pipeline"<br>"Deploy analysis" |

### Risk Matrix Visualization

```
         COMPLEXITY PATTERNS
              ↑
    ┌─────────┬───────────┬──────────┐
Prod │  🟡Med  │   🟡Med   │  🔴HIGH  │  Production
    ├─────────┼───────────┼──────────┤
Expl │  🟢Low  │  🟢OPTIMAL│  🟡Med   │  Exploratory
    ├─────────┼───────────┼──────────┤
Iter │  🟢Low  │   🟢Low   │  🟡Med   │  Iterative
    ├─────────┼───────────┼──────────┤
Sngl │  🟢Low  │   🟢Low   │  🟢Low   │  Single-Shot
    └─────────┴───────────┴──────────┘
       Human    Collaborative  LLM-Led
       Led
                AUTONOMY LEVEL →
```

### Workflow Selector Table

The same task can be approached differently based on your needs:

**Example Task: "Analyze sales data"**

| Approach | Complexity | Autonomy | Use Case | Time | Risk |
|----------|------------|----------|----------|------|------|
| Manual summary | Single-Shot | Minimal | Quick check | 30s | 🟢 |
| Specific query | Single-Shot | Maximal | Get metric | 10s | 🟢 |
| Joint exploration | Exploratory | Collaborative | Find insights | 2hr | 🟢 |
| Build pipeline | Production | Guided | Automation | 2d | 🟡 |

### Workflow Decision Tree

```
START: What's your task?
        │
        ↓
  Is endpoint known?
     /      \
   YES       NO → [Exploratory]
    │
  Stakes?
   /  |  \
 Low  Med High
  │    │    │
  ↓    ↓    ↓
[S-S] [Iter] [Prod]

Then choose autonomy:
- Low stakes → High LLM OK
- Med stakes → Collaborative
- High stakes → Human control
```

### Optimal Zone Mapping

> **TLDR**: Each task type has a "sweet spot" balancing efficiency and safety.

| Autonomy Level | Best For | Avoid For |
|----------------|----------|----------|
| **High (LLM-Led)** | • Documentation<br>• Standard plots<br>• Package discovery<br>• Syntax lookup<br>• Basic stats | • Critical bugs<br>• Security code<br>• Production |
| **Collaborative** | • EDA<br>• Refactoring<br>• Algorithm dev<br>• Complex debug<br>• Learning | • Trivial tasks<br>• Time-critical |
| **Human Control** | • Critical fixes<br>• Security<br>• Performance<br>• Production<br>• Novel algorithms | • Routine tasks<br>• Boilerplate |

### ⚠️ Anti-Patterns to Avoid

| Anti-Pattern | What It Looks Like | Risk | Better Approach |
|--------------|-------------------|------|------------------|
| **Over-Automation** | Level 5 for production | Subtle bugs | Level 3-4 + checkpoints |
| **Under-Automation** | Manual everything | Time waste | Delegate routine to LLM |
| **Complexity Mismatch** | Production for exploration | Rigidity | Match pattern to purpose |
| **Autonomy Inflexibility** | Always same level | Inefficiency | Adjust per task |

### Real-World Workflow Examples

Now let's see how tasks naturally evolve through the matrix:

| Scenario | Starting Point | Evolution | Final State |
|----------|---------------|-----------|-------------|
| **Debug Memory Leak** | Exploratory + Collab<br>(understand pattern) | → Human-Led<br>(critical code) | Production + Human<br>(deploy fix) |
| **Create Visualization** | Single-Shot + High LLM<br>(quick chart) | → Iterative + Collab<br>(refine) | Production + Human<br>(dashboard) |
| **Learn Package** | Exploratory + High LLM<br>(overview) | → Collaborative<br>(examples) | Iterative + Human<br>(integrate) |

### 🎯 Quick Workflow Selector

| Your Situation | Recommended Approach | Example |
|----------------|---------------------|----------|
| Known goal + Low stakes | Single-Shot + High LLM | "Get mean of column" |
| Known goal + High stakes | Iterative + Collaborative | "Fix critical bug" |
| Unknown goal + Learning | Exploratory + Collaborative | "Understand new data" |
| Strict requirements | Production + Human-Led | "Deploy pipeline" |
| Routine + Proven | Any + High LLM | "Generate docs" |

### Key Insights from 2D Framework

| Insight | Practical Implication |
|---------|----------------------|
| **Complexity ≠ Autonomy** | Don't assume complex = manual |
| **Context Determines** | Same task, different approach based on situation |
| **Dynamic Movement** | Start anywhere, adjust as you learn |
| **Tools Follow Pattern** | Complexity picks tools, autonomy picks driver |
| **Diagonal Often Optimal** | But not always—adapt to context |

---

## Tool Synergy Patterns

> **TLDR**: Tools work better together. Five natural clusters emerge from real-world use.

With the 2D framework established, let's explore how tools naturally combine to create powerful workflows:

### Natural Tool Clusters

| Cluster Name | Tool Flow | Purpose | When to Use |
|--------------|-----------|---------|-------------|
| **Analysis Triad** | `describe_df` → `execute_r` → `save_plot` | Data to insights | Any data analysis |
| **Learning Pipeline** | `search_packages` → `docs_vignette` → `editor_write` → `execute_r` | Discovery to implementation | New capabilities |
| **Debug Loop** | `read_editor` → `comment_lines` → `execute_r` → `uncomment` | Systematic isolation | Fixing errors |
| **Documentation Suite** | `help_page` → `help_topics` → `vignettes` → `news` | Deep understanding | Learning packages |
| **Environment Inspector** | `platform_info` → `package_info` → `describe_env` | Session awareness | Troubleshooting |

---

## Workflow Transitions

> **TLDR**: Real tasks evolve through phases. Understanding transitions helps you adapt your approach dynamically.

Building on tool synergies, let's examine how workflows naturally evolve during real work:

### How Tasks Naturally Evolve

```
       TYPICAL WORKFLOW EVOLUTION

  Discovery → Exploration → Iteration → Production
      🟢           🟡           🟡          🔴
   (Quick)     (Learning)   (Refining)  (Deploying)
```

| Task Type | Phase 1 | Phase 2 | Phase 3 | Phase 4 |
|-----------|---------|---------|---------|----------|
| **Debugging** | "What's this error?"<br>Single + High LLM | "Why does it happen?"<br>Exploratory + Collab | "Try solutions"<br>Iterative + Collab | "Deploy fix"<br>Production + Human |
| **Data Analysis** | "Summarize data"<br>Single + High LLM | "Find patterns"<br>Exploratory + Collab | "Build models"<br>Iterative + Balanced | "Create pipeline"<br>Production + Human |
| **Package Integration** | "Find package"<br>Single + High LLM | "Learn it"<br>Exploratory + Collab | "Test it"<br>Iterative + Balanced | "Deploy it"<br>Production + Human |

### Transition Triggers

| Signal Type | What to Watch For | Action to Take |
|-------------|-------------------|----------------|
| **Complexity ↑** | • Cryptic errors<br>• Dependencies emerge<br>• Performance issues<br>• Edge cases multiply | Move up complexity axis |
| **Autonomy ↓** | • Wrong results<br>• Critical context<br>• Stakes increase<br>• Precision needed | Reduce LLM autonomy |
| **Collaboration ↑** | • Uncertainty<br>• Multiple paths<br>• Learning opportunity<br>• Creativity needed | Shift to collaborative |

---

## Risk Assessment Framework

> **TLDR**: Green = Safe, Yellow = Caution, Red = Danger. Know your risk zones before choosing autonomy levels.

Understanding workflow transitions helps us identify and manage risks:

### Risk Zone Definitions

| Zone | Conditions | Examples | Mitigation |
|------|------------|----------|------------|
| **🟢 Green** | • Read-only ops<br>• Human in loop<br>• Full human control | • Data inspection<br>• Doc lookup<br>• Guided analysis | Proceed freely |
| **🟡 Yellow** | • Exploratory + High LLM<br>• Iterative + High LLM<br>• Production + Collab | • Auto optimization<br>• Unsupervised EDA<br>• Pipeline building | Add checkpoints |
| **🔴 Red** | • Production + High LLM<br>• High stakes + Unknown<br>• No validation | • Auto deployment<br>• Critical fixes<br>• Security code | Avoid or heavy oversight |

### Risk Mitigation Strategies

```
     RISK MITIGATION FLOWCHART

     Identify Risk Type
           │
    ┌──────┼──────┐
    ↓      ↓      ↓
Automation Complexity Stakes
    │      │      │
Checkpoints Break  Version
Review    Down    Control
Test      Test    Expert
Rollback  Build   Review
```

| Risk Type | Primary Strategy | Secondary Strategy |
|-----------|-----------------|--------------------|
| **High Automation** | Add checkpoints | Review before execution |
| **High Complexity** | Break into subtasks | Incremental testing |
| **High Stakes** | Version control | Expert review |

---

## User Profiles and Optimal Workflows

> **TLDR**: Your R experience level determines optimal workflow patterns. Match your profile for best results.

Different users benefit from different approaches based on their experience:

| Profile | Experience | Optimal Approach | Key Tools | Avoid |
|---------|------------|-----------------|-----------|--------|
| **Novice** | Learning R | • High LLM for syntax<br>• Collaborative learning<br>• Level 1-2 workflows | • help_page<br>• search_packages<br>• vignettes | Production patterns |
| **Intermediate** | Comfortable with basics | • Balanced approach<br>• Mix autonomy levels<br>• Level 2-4 workflows | • Full suite<br>• editor_write<br>• execute_r | Over-automation |
| **Expert** | Deep R knowledge | • Human-led critical<br>• High LLM for routine<br>• All levels | • Selective use<br>• Complex tools | Under-utilizing LLM |
| **Data Scientist** | Domain expert | • High LLM for R<br>• Human for domain<br>• Focus on analysis | • Analysis tools<br>• Visualization<br>• Reporting | R syntax details |

---

## Quick Start Recipes

> **TLDR**: Five ready-to-use workflows for common scenarios. Copy, paste, and adapt.

🎯 **RECIPE MODES**: These recipes show session mode workflows (for persistent analysis). For quick calculations, subprocess mode works immediately without setup.

**Session Mode Recipes** (run `btw_mcp_session()` first):
- Variables persist between `execute_r` calls
- Step-by-step workflows work naturally
- Full RStudio integration
- **✨ v3: Complete console visibility** - Both you AND Claude see all output simultaneously

**For Quick Calculations**: Just ask Claude directly - subprocess mode handles one-off operations perfectly.

With all the concepts covered, here are concrete recipes you can use immediately:

### Recipe 1: First Time with New Dataset

```r
# Quick Data Exploration Recipe
# Time: 5-10 minutes
# Risk: 🟢 Low
# Prerequisite: btw_mcp_session() active in RStudio

# Step 1: Overview
mcp__btw-r-v3__btw_tool_env_describe_data_frame(
  data_frame = "your_data",
  format = "skim"
)

# Step 2: Basic stats
mcp__btw-r-v3__execute_r("summary(your_data)")

# Step 3: Missing values
mcp__btw-r-v3__execute_r("table(is.na(your_data))")

# Step 4: Quick viz
mcp__btw-r-v3__execute_r("plot(your_data[1:4])")
mcp__btw-r-v3__btw_tool_save_plot(
  filename = "data_overview.png",
  path = ".", width = 10, height = 8,
  dpi = 150, format = "png"
)
```

### Recipe 2: Debugging Workflow

```r
# Systematic Debug Recipe
# Time: 15-30 minutes
# Risk: 🟢 Low (reversible)

# Step 1: Read current code
mcp__btw-r-v3__btw_tool_ide_read_current_editor()

# Step 2: Isolate suspect code
mcp__btw-r-v3__btw_tool_editor_write(
  action = "comment_lines",
  start_line = 10,
  end_line = 20
)

# Step 3: Test components
mcp__btw-r-v3__execute_r("# Test isolated parts")

# Step 4: Restore and fix
mcp__btw-r-v3__btw_tool_editor_write(
  action = "uncomment_lines",
  start_line = 10,
  end_line = 20
)
```

### Recipe 3: Package Discovery & Learning

```r
# Package Learning Recipe
# Time: 30-60 minutes
# Risk: 🟢 Low

# Step 1: Find packages
mcp__btw-r-v3__btw_tool_search_packages(
  query = "your topic",
  n_results = 10
)

# Step 2: Get details
mcp__btw-r-v3__btw_tool_search_package_info(
  package_name = "chosen_package"
)

# Step 3: Learn from vignettes
mcp__btw-r-v3__btw_tool_docs_available_vignettes(
  package_name = "chosen_package"
)
mcp__btw-r-v3__btw_tool_docs_vignette(
  package_name = "chosen_package",
  vignette = "introduction"
)

# Step 4: Try it
mcp__btw-r-v3__execute_r("library(chosen_package)")
```

### Recipe 4: Publication-Quality Figure

```r
# Publication Figure Recipe
# Time: 1-2 hours
# Risk: 🟢 Low
# Prerequisite: btw_mcp_session() active in RStudio

# Step 1: Create base plot
mcp__btw-r-v3__execute_r("
library(ggplot2)
base_plot <- ggplot(data, aes(x, y)) +
  geom_point() +
  theme_minimal()
print(base_plot)
")

# Step 2: Refine iteratively (variables persist)
mcp__btw-r-v3__execute_r("
final_plot <- base_plot +
  labs(title = 'Publication Figure',
       x = 'X Axis Label',
       y = 'Y Axis Label') +
  theme(text = element_text(size = 14))
print(final_plot)
")

# Step 3: Save multiple formats
for(fmt in c("png", "pdf", "svg")) {
  mcp__btw-r-v3__btw_tool_save_plot(
    filename = paste0("figure", fmt),
    path = "figures",
    width = 7, height = 5,
    dpi = 300, format = fmt
  )
}

# Step 4: Document
mcp__btw-r-v3__btw_tool_editor_write(
  action = "append",
  text = "# Figure generation code..."
)
```

### Recipe 5: Automated Pipeline

```r
# Automation Recipe
# Time: 2-4 hours initial, saves hours later
# Risk: 🟡 Medium (test thoroughly)

# Step 1: Parameterize existing code
mcp__btw-r-v3__btw_tool_editor_write(
  action = "prepend",
  text = "# Parameters\nDATA_PATH <- Sys.getenv('DATA_PATH')\n"
)

# Step 2: Add error handling
mcp__btw-r-v3__btw_tool_editor_write(
  action = "insert_at_line",
  line_number = 10,
  text = "tryCatch({\n  # existing code\n}, error = function(e) {\n  log_error(e)\n})"
)

# Step 3: Test pipeline
mcp__btw-r-v3__execute_r("source('pipeline.R')")

# Step 4: Schedule or integrate
# Add to cron, GitHub Actions, etc.
```

---

## Failure Modes and Recovery

> **TLDR**: Things go wrong. Here's how to recognize problems early and recover gracefully.

Finally, let's prepare for when things don't go as planned:

### Common Failure Patterns

| Pattern | Symptoms | Root Cause | Recovery Strategy |
|---------|----------|------------|-------------------|
| **Automation Spiral** | • Complex code<br>• Doesn't work<br>• Getting worse | Compounding errors | • Stop<br>• Reduce autonomy<br>• Break down |
| **Context Loss** | • Forgets requirements<br>• Wrong assumptions | Long conversation | • Summarize state<br>• Re-read files<br>• Consider restart |
| **Over-Confidence** | • Subtle errors<br>• Wrong approach | Underestimated complexity | • Go collaborative<br>• Add validation<br>• Review carefully |
| **Exploration Paralysis** | • No progress<br>• Too many options | Unclear goals | • Define success<br>• Time-box<br>• Force decision |

### Recovery Decision Matrix

```
         WHEN TO CHANGE APPROACH

    Failed Attempts?
         │
    ≥ 3 times?
      /     \
    YES      NO → Continue
     │
  Errors worse?
    /    \
  YES     NO → Debug
   │
 ABORT HIGH
 AUTOMATION
```

| Trigger | Action | New Approach |
|---------|--------|-------------|
| **3+ failures** | Abort automation | Go manual/collaborative |
| **Stakes increase** | Add human control | Reduce LLM autonomy |
| **Both stuck** | Seek collaboration | Joint problem solving |
| **Time pressure** | Simplify approach | Focus on essentials |

---

## Addendum: BTW + Claude Code Synergies

> **TLDR**: BTW R MCP gains superpowers when combined with Claude Code's native toolkit. This isn't just "more tools"—it's integrated layers that enable impossible workflows.

### The Integrated Toolkit Architecture

```
   CLAUDE CODE NATIVE TOOLS           BTW R MCP TOOLS
   ┌────────────────────┐            ┌──────────────┐
   │   System Layer     │            │              │
   │   Bash, Process    │◄──────────►│  execute_r   │
   ├────────────────────┤            │              │
   │   File Layer       │            │  editor_write│
   │   Read/Write/Edit  │◄──────────►│  read_editor │
   ├────────────────────┤            │              │
   │   Search Layer     │            │  search_*    │
   │   Grep/Glob        │◄──────────►│  docs_*      │
   ├────────────────────┤            │              │
   │   Version Layer    │            │  save_plot   │
   │   Git Operations   │◄──────────►│  env_*       │
   └────────────────────┘            └──────────────┘
           ↓                                ↓
   ════════════════════════════════════════════════
              INTEGRATED WORKFLOWS
   ════════════════════════════════════════════════
```

### Core Synergy Patterns

#### 1. Codebase-Wide R Analysis
**Pattern**: Search → Analyze → Modify → Verify
```
Glob("**/*.R") → Grep("function_name") →
BTW execute_r(test) → MultiEdit(refactor) →
Git commit
```
**Unique Value**: Analyze R code impact across entire projects

#### 2. Safe Experimentation Workflow
**Pattern**: Backup → Experiment → Validate/Rollback
```
Git stash → BTW execute_r(risky_operation) →
Grep(verify_changes) → Git stash pop OR Git reset
```
**Unique Value**: Risk-free R experimentation with instant rollback

#### 3. Multi-Language Data Pipeline
**Pattern**: System → Python → R → System
```
Bash(download_data.sh) → Write(python_prep.py) →
Bash(python) → BTW execute_r(analysis) →
BTW save_plot → Bash(upload_results.sh)
```
**Unique Value**: R as component in polyglot workflows

#### 4. Documentation Generation
**Pattern**: Analyze → Document → Integrate
```
BTW ide_read_current_editor → BTW execute_r(run_examples) →
BTW save_plot(figures) → Write(README.md) →
Git commit -m "Add documentation"
```
**Unique Value**: Auto-generated docs with live R examples

#### 5. Parallel Processing Orchestration
**Pattern**: Check → Distribute → Monitor → Collect
```
Bash(check_cores) → Split files with Write →
Launch multiple BTW execute_r → BashOutput(monitor) →
BTW env_describe_data_frame(combined_results)
```
**Unique Value**: System-aware R parallelization

#### 6. Test-Driven R Development
**Pattern**: Write Test → Run → Fix → Verify
```
Write(test_function.R) → BTW execute_r(testthat) →
Read(test_output) → Edit(fix_function.R) →
BTW execute_r(testthat) → Git commit
```
**Unique Value**: TDD workflow with integrated file management

#### 7. Production Deployment Pipeline
**Pattern**: Validate → Package → Test → Deploy
```
BTW session_check_package_installed →
Bash(R CMD build) → BTW execute_r(run_checks) →
Write(Dockerfile) → Bash(docker build) →
Git tag -a v1.0
```
**Unique Value**: End-to-end R package deployment

#### 8. Cross-Project Analysis
**Pattern**: Search Multiple Repos → Analyze → Report
```
Bash(find ~/projects -name "*.Rmd") →
Grep("statistical_test") across repos →
BTW execute_r(meta_analysis) →
BTW save_plot(comparison) → Write(report.md)
```
**Unique Value**: R analysis across multiple projects simultaneously

### Emergent Capabilities

| Capability | BTW Alone | Claude Alone | BTW + Claude |
|-----------|-----------|--------------|--------------|
| **R Execution** | ✓ In RStudio | ✗ | ✓ Anywhere |
| **File Search** | ✗ | ✓ Any file | ✓ R-aware search |
| **Version Control** | ✗ | ✓ Git | ✓ R-specific commits |
| **System Ops** | ✗ | ✓ Bash | ✓ R-orchestrated |
| **Risk Management** | Limited | ✓ Backups | ✓ Multi-layer safety |
| **Documentation** | R help only | ✓ Any format | ✓ Live R docs |

### Risk Mitigation Amplification

```
BTW HIGH-RISK OPERATION
         ↓
┌──────────────────────┐
│ Claude Safety Wrapper │
├──────────────────────┤
│ • Git stash changes  │
│ • Backup files       │
│ • Monitor resources  │
│ • Validate outputs   │
│ • Rollback if needed │
└──────────────────────┘
         ↓
RISK LEVEL: 🔴→🟡
```

### Example: Complete Integrated Workflow

**Task**: Refactor R package to use new statistical method

```bash
# 1. PREPARATION (Claude Tools)
Git checkout -b refactor-stats
Glob("**/*.R") → identify affected files
Grep("old_method") → find all occurrences

# 2. ANALYSIS (BTW Tools)
BTW search_packages("new_statistical_method")
BTW docs_vignette("new_package", "migration")
BTW execute_r("benchmark_old_vs_new.R")

# 3. MODIFICATION (Integrated)
MultiEdit(files, old_method → new_method)
BTW editor_write(action="insert", test_code)
BTW execute_r("devtools::test()")

# 4. VALIDATION (Integrated)
Grep("new_method") → verify all changed
BTW execute_r("run_all_examples.R")
BTW save_plot("performance_comparison.png")

# 5. DOCUMENTATION (Claude Tools)
Write("NEWS.md", "Migrated to new_method")
Edit("vignettes/package.Rmd", add_migration_note)

# 6. DEPLOYMENT (Claude Tools)
Git add -A
Git commit -m "refactor: migrate to new statistical method"
Git push origin refactor-stats
```

### When to Use Integrated Workflows

| Scenario | BTW Only | Integrated | Why Integration Wins |
|----------|----------|------------|---------------------|
| **Quick analysis** | ✓ Fine | Overkill | Single-file, low risk |
| **Package development** | Limited | ✓ Optimal | Need file ops + version control |
| **Multi-file refactor** | Can't do | ✓ Required | Must search/edit many files |
| **Production pipeline** | Risky | ✓ Essential | Need safety + deployment |
| **Cross-language** | Can't do | ✓ Required | R is one component |
| **Documentation** | Manual | ✓ Automated | Generate from analysis |

### Key Insight

The true power isn't 16 + 30 = 46 tools. It's that the tools operate at **different abstraction layers** that complement perfectly:

- **System Layer**: Resource management, process control
- **File Layer**: Code manipulation, project structure
- **Search Layer**: Pattern finding, impact analysis
- **R Layer**: Statistical computing, visualization
- **Version Layer**: Safety, collaboration, deployment

This creates a **complete development environment** where R is a first-class citizen, not an isolated island.

---

## Summary & Next Steps

> **TLDR**: You now have a complete framework for using BTW R MCP v2 effectively.

### 🎆 What You've Learned

1. **16 Tools** organized in 7 categories
2. **5 Levels** of LLM involvement
3. **2D Framework** for workflow selection
4. **Tool Synergies** that multiply power
5. **Risk Zones** to navigate safely
6. **5 Recipes** for immediate use

### 🚀 Your Next Actions

```
     START HERE
         ↓
   Try Recipe #1
   (Data exploration)
         ↓
   Experiment with
   Level 1-2 workflows
         ↓
   Find your optimal
   complexity/autonomy
         ↓
   Build custom
   workflows
```

### 📚 Further Resources

| Resource | Location | Purpose |
|----------|----------|----------|
| **Setup Guide** | `docs/setup.md` | Installation |
| **User Manual** | `docs/guides/USER_MANUAL.md` | Daily usage |
| **Function Reference** | `docs/references/COMPLETE_FUNCTION_REFERENCE.md` | Tool details |
| **Templates** | `templates/` | More examples |

### 🎯 Final Recommendations

| If You're... | Start With... | Then Move To... |
|--------------|---------------|------------------|
| **New to BTW** | Quick Start Recipes | Level 1-2 workflows |
| **Experienced** | Complexity Matrix | Custom combinations |
| **Debugging** | Failure Patterns | Recovery strategies |
| **Optimizing** | Tool Synergies | Advanced patterns |

---

*Document Version: 2.0 | Enhanced for clarity and navigation*
*Feedback: Create issue at github.com/anthropics/claude-code/issues*