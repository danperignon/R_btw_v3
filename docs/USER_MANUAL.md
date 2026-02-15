# BTW R MCP User Manual
**A Practical Guide to Real-World Usage**
*Last Updated: 2025-09-30 (v3)*

## Table of Contents

1. [Quick Start](#quick-start)
2. [Known Quirks & Workarounds](#known-quirks--workarounds)
3. [Best Practices](#best-practices)
4. [Tool-Specific Guidance](#tool-specific-guidance)
5. [Troubleshooting](#troubleshooting)

---

## Quick Start

### Essential Daily Setup - JUST 2 COMMANDS!
```r
# In RStudio (once per session):
library(btw)
btw_mcp_session()  # Creates the socket connection

# That's it! BTW MCP is ready to use
# No additional files or enhancements needed
```

### How to Know It's Working
- Claude can see your workspace variables
- Code appears in console with `# BTW executing via MCP:`
- Plots appear automatically in RStudio
- File operations work in your current directory

### 🎯 Choose Your Execution Mode

**DEFAULT: Subprocess Mode** - Works immediately, no setup required
- **Use for**: Quick calculations, testing code, one-off operations
- **Behavior**: Clean isolated execution, no workspace effects
- **Example**: "What's the mean of 1:100?" → Immediate answer, no variables created

**UPGRADE: Session Mode** - For persistent analysis workflows
- **When to use**: Multi-step analysis, building complex workflows, iterative development
- **Setup**: Run `btw_mcp_session()` in RStudio first
- **Behavior**: Variables persist, plots in YOUR viewer, full RStudio integration

**Session mode workflow example**:
```r
# In RStudio (when you want persistent workflows):
library(btw)
btw_mcp_session()

# Now variables persist between execute_r calls:
# Call 1: Create variable
mcp__btw-r-v3__execute_r(code = "x <- 1:10")

# Call 2: Variable is available!
mcp__btw-r-v3__execute_r(code = "summary(x)")  # Works perfectly
```

**Quick calculation example** (subprocess mode):
```r
# No setup needed - just ask:
# "Calculate the correlation between mtcars$mpg and mtcars$wt"
# → Immediate answer, no variables left in workspace
```

---

## Known Quirks & Workarounds

### 1. Console Prompt Disappears After Execution ⚠️

**Symptom**: After Claude runs code, the `>` prompt doesn't return. Console shows blank line instead.

**What's Happening**: 
- Code executes perfectly
- Results display correctly
- Session remains fully active
- Only the prompt display is missing

**Workarounds**:
1. **Just press Enter** - Brings back the `>` prompt immediately
2. **Press Escape** - Also restores the prompt
3. **Keep working through Claude** - Session works fine even without visible prompt
4. **Both work simultaneously** - You can type commands while Claude runs code

**Example Console State**:
```r
# BTW executing via MCP:
> 2 + 2
[1] 4
                    # <- No prompt here, just blank line
```

### 2. File Listing Token Limits 🚫

⚠️ **IMPORTANT NOTE**: File operations using BTW tools are **not recommended**. Claude Code's native tools (Read, Write, Bash) are superior for file operations. See [BTW_VS_CLAUDE_TOOLS.md](BTW_VS_CLAUDE_TOOLS.md) for detailed comparison. The guidance below is kept for reference but avoid BTW file tools when possible.

**Symptom**: Error "response exceeds maximum allowed tokens (25000)"

**Real Example**: Your `/Users/danielrowe/Desktop/GitHubRepos/Demo_Components_Chng` directory has **7,257 files**!

**When This Happens**:
- Large project directories (100s/1000s of files)
- Using `btw_tool_files_list_files` without filters
- Current directory has many subdirectories
- Even listing immediate directory can exceed limits with detailed file info

**Solutions**:

#### Option 1: Use Filters
```r
# Instead of listing everything:
mcp__btw-r-v3__btw_tool_files_list_files()  # ❌ May exceed limits

# Filter by file type:
mcp__btw-r-v3__btw_tool_files_list_files(regexp = "\\.R$")  # ✅ Only R files
mcp__btw-r-v3__btw_tool_files_list_files(type = "file")     # ✅ Only files, no dirs
```

#### Option 2: List Specific Subdirectory
```r
# List a subdirectory instead:
mcp__btw-r-v3__btw_tool_files_list_files(path = "src")      # ✅ Smaller scope
mcp__btw-r-v3__btw_tool_files_list_files(path = "tests")    # ✅ Focused listing
```

#### Option 3: Change Working Directory First
```r
# Move to a smaller directory:
setwd("src")
mcp__btw-r-v3__btw_tool_files_list_files()  # Now lists only src/
```

### 3. File Paths Must Be Relative 📁

⚠️ **NOTE**: This section covers BTW file tools which are **not recommended**. Use Claude's native Read/Write tools instead.

**Symptom**: "not allowed to list or read files outside of project directory"

**Rule**: All file operations require relative paths from current working directory

**Examples**:
```r
# ❌ WRONG - Absolute paths fail:
mcp__btw-r-v3__btw_tool_files_read_text_file(
  path = "/Users/danielrowe/project/file.txt"
)

# ✅ CORRECT - Relative paths work:
mcp__btw-r-v3__btw_tool_files_read_text_file(
  path = "file.txt"  # In current directory
)

mcp__btw-r-v3__btw_tool_files_read_text_file(
  path = "data/input.csv"  # Relative subdirectory
)
```

### 4. Web Reading Requires chromote Package 🌐

**Symptom**: "there is no package called 'chromote'"

**Fix**:
```r
install.packages("chromote")
```

**Alternative**: Use Claude's WebFetch tool instead of btw_tool_web_read_url

---

## Best Practices

### 1. Session Management

**Always Start With**:
```r
library(btw)
btw_mcp_session()
```

**Check Connection**:
```r
# Verify socket exists:
list.files("/tmp", pattern = "mcptools-socket")

# Test with simple command through Claude:
# "What's in my R environment?"
```

### 2. File Operations Strategy

**For Large Projects**:
```r
# Start broad, then narrow:
1. Check current directory:
   getwd()

2. Count files first (in R directly):
   length(list.files(recursive = TRUE))

3. If > 100 files, use filters:
   mcp__btw-r-v3__btw_tool_files_list_files(regexp = "\\.R$")
   
4. Or list subdirectories only:
   mcp__btw-r-v3__btw_tool_files_list_files(type = "directory")
```

### 3. Console Management

**Mixed Workflow** (You + Claude):
```r
# You type in console:
x <- 1:10

# Claude runs code (no prompt appears)
# You press Enter to restore prompt
# Continue working...

# Both can work simultaneously!
```

**Monitoring Claude's Work**:
- Watch console for `# BTW executing via MCP:` tags
- Check plots pane for visualizations
- Verify variables in Environment pane

### 4. Performance Tips

**Fast Operations** (<100ms):
- Platform info
- Package checks
- Environment listing
- Simple calculations

**Slower Operations** (1-3s):
- CRAN searches
- Large file operations
- Complex plotting
- Package documentation

**Plan Accordingly**:
```r
# Batch related operations:
# Claude can run multiple analyses while you work on other things
```

---

## BTW MCP v2 - Enhanced Editor Control

### Complete Editor Write System (9 Actions)

**Server**: `mcp__btw-r-v3__` - Streamlined with powerful editor capabilities

#### Basic Text Operations
```r
# 1. Insert at cursor
mcp__btw-r-v3__btw_tool_editor_write(
  text = "# New code here",
  action = "insert"
)

# 2. Replace entire document
mcp__btw-r-v3__btw_tool_editor_write(
  text = "# Completely new script\ncat('Fresh start!')",
  action = "replace"
)

# 3. Append to end
mcp__btw-r-v3__btw_tool_editor_write(
  text = "# Added to end of script",
  action = "append"
)

# 4. Prepend to beginning
mcp__btw-r-v3__btw_tool_editor_write(
  text = "# Added to top of script",
  action = "prepend"
)
```

#### Precise Line Operations
```r
# 5. Insert at specific line number
mcp__btw-r-v3__btw_tool_editor_write(
  text = "# Inserted at line 10",
  action = "insert_at_line",
  line_number = 10
)

# 6. Replace selected text (select text first in RStudio)
mcp__btw-r-v3__btw_tool_editor_write(
  text = "# Replaces whatever you selected",
  action = "replace_selection"
)

# 7. Replace specific line range (3 lines → 5 lines example)
mcp__btw-r-v3__btw_tool_editor_write(
  text = "# Line 1 of replacement\n# Line 2\n# Line 3\n# Line 4\n# Line 5",
  action = "replace_lines",
  start_line = 10,
  end_line = 12
)
```

#### Code Commenting Operations
```r
# 8. Comment lines (add # to start of lines)
mcp__btw-r-v3__btw_tool_editor_write(
  action = "comment_lines",
  start_line = 15,
  end_line = 20
)

# 9. Uncomment lines (remove # from start of lines)
mcp__btw-r-v3__btw_tool_editor_write(
  action = "uncomment_lines", 
  start_line = 15,
  end_line = 20
)
```

### Collaborative Scripting Workflow

**Pattern**: Edit → Test → Iterate
```r
# Claude adds code to your script:
mcp__btw-r-v3__btw_tool_editor_write(
  text = "data <- read.csv('myfile.csv')\nhead(data)",
  action = "append"
)

# Claude runs specific lines to test:
mcp__btw-r-v3__execute_r(
  code = "# Extract and run lines 25-26 from script\n..."
)

# Claude fixes issues by replacing problem lines:
mcp__btw-r-v3__btw_tool_editor_write(
  text = "data <- read.csv('myfile.csv', stringsAsFactors = FALSE)",
  action = "replace_lines",
  start_line = 25,
  end_line = 25
)
```

### Advanced Use Cases

**Smart Line Management**:
- Replace 3 lines with 5 lines automatically
- Comment entire function blocks for debugging
- Insert multiple code sections without recalculating line numbers

**Debugging Workflow**:
```r
# Comment out problematic section:
comment_lines(start_line = 50, end_line = 65)

# Test rest of script
# Fix the issue
# Uncomment when ready:
uncomment_lines(start_line = 50, end_line = 65)
```

**Code Generation**:
- Claude can build scripts incrementally
- Add functions, test data, analyses step by step
- Collaborative development with immediate testing

### Plot Saving (v2 Exclusive)
```r
# Create plot in script, then save it:
mcp__btw-r-v3__btw_tool_save_plot(
  filename = "analysis_plot.png",
  path = "/Users/you/results",
  width = 10,
  height = 8,
  dpi = 300,
  format = "png"
)
```

---

## BTW MCP v3 - Complete Console Visibility ()

### The Visibility Breakthrough

**Status**: Production-ready as of 2025-09-30

BTW MCP v3 achieves complete bidirectional visibility—both you and Claude see ALL code execution output simultaneously. This includes:
- ✅ **Print statements** (`print()`, `cat()`)
- ✅ **Auto-print output** (last expression values)
- ✅ **Warnings** (displayed naturally in console)
- ✅ **Errors** (with clear `!!` prefix)
- ✅ **Messages** (status updates, package loading)
- ✅ **Environment state** (auto-inspection of workspace)

### How It Works: The `evaluate` Package

v3 uses the `evaluate` package (the engine behind knitr/rmarkdown) with a key innovation:

```r
evaluate::evaluate(
  code,
  keep_warning = NA,   # Capture AND display naturally
  keep_message = NA    # Capture AND display naturally
)
```

**The Magic of `NA`**:
- `TRUE` = Capture but **suppress** console display
- `FALSE` = Don't capture at all
- `NA` = Capture **AND** display naturally ← v3's breakthrough

This provides the "best of both worlds" that previous versions couldn't achieve.

### What You See in RStudio Console

```r
# BTW executing via MCP:
> data <- mtcars[1:5, 1:3]
> summary(data)
      mpg             cyl             disp
 Min.   :18.10   Min.   :4.00   Min.   :108.0
 1st Qu.:18.70   1st Qu.:6.00   1st Qu.:120.3
 Median :19.20   Median :6.00   Median :160.0
 Mean   :20.98   Mean   :6.00   Mean   :201.2
 3rd Qu.:21.40   3rd Qu.:6.00   3rd Qu.:258.0
 Max.   :26.00   Max.   :8.00   Max.   :360.0

Auto-context: 1 object | Recent: data
```

### What Claude Sees

Claude receives the **same output** you see, structured for analysis:
```
Mode: session (with evaluate)

Output:
      mpg             cyl             disp
 Min.   :18.10   Min.   :4.00   Min.   :108.0
[... complete output ...]

Auto-context: 1 object | Recent: data
```

### Configuration Options

Control what appears in your console with environment variables:

```r
# Default: Show everything (recommended)
Sys.setenv(BTW_ECHO_CODE = "TRUE")      # Show code being executed
Sys.setenv(BTW_ECHO_OUTPUT = "TRUE")    # Show output
Sys.setenv(BTW_INSPECT = "standard")    # Auto-show workspace objects

# Silent mode: Claude sees everything, console stays clean
Sys.setenv(BTW_ECHO_CODE = "FALSE")
Sys.setenv(BTW_ECHO_OUTPUT = "FALSE")
Sys.setenv(BTW_INSPECT = "none")

# Verbose mode: Maximum visibility
Sys.setenv(BTW_ECHO_CODE = "TRUE")
Sys.setenv(BTW_ECHO_OUTPUT = "TRUE")
Sys.setenv(BTW_INSPECT = "verbose")     # Shows object types too
```

**Inspection Levels**:
- `none` - No automatic workspace inspection
- `minimal` - Object count only
- `standard` - Recent 5 objects (default)
- `verbose` - All objects + types for recent 5

### Warnings and Errors

**Warnings**:
- Display naturally in RStudio (proper yellow console highlighting)
- Captured for Claude with "Warning: " prefix
- No sticky bars (the v2 problem is solved!)

**Errors**:
- Show in console with `!! ` prefix (avoids RStudio error pattern matching)
- Full error messages captured for Claude
- No console artifacts

### Example: Complete Visibility

```r
# In RStudio:
library(btw)
btw_mcp_session()

# Claude executes:
mcp__btw-r-v3__execute_r(code = "
  x <- 1:10
  print('Hello from R!')
  cat('Mean:', mean(x), '\\n')
  warning('This is a warning')
  sqrt(-1)  # Produces NaN warning
")

# You see in console:
# BTW executing via MCP:
> x <- 1:10
> print('Hello from R!')
[1] "Hello from R!"
> cat('Mean:', mean(x), '\n')
Mean: 5.5
> warning('This is a warning')
Warning: This is a warning
> sqrt(-1)
!! NaNs produced
[1] NaN

Auto-context: 1 object | Recent: x

# Claude receives the same output, structured for analysis
```

### Technical Details

For implementation details, see:
- **System architecture**: [ARCHITECTURE.md](ARCHITECTURE.md)
- **Server implementation**: `../src/btw_mcp_server_v3.R`
- **Key innovations**: Single-pass extraction, keep_warning=NA, size limits

**Key Implementation Lines** (in src/btw_mcp_server_v3.R):
- Lines 110-163: evaluate integration with keep_warning=NA
- Lines 204-243: Single-pass output extraction
- Lines 167-206: Inline auto-inspection

### Why This Matters

**Previous Limitation**: You had to choose—either YOU see output OR Claude sees output, not both.

**v3 Solution**: Complete transparency. No workarounds, no manual functions, no stderr hacks. The `evaluate` package handles everything naturally, and RStudio displays it correctly.

This is production-ready and has replaced all previous workarounds.

---

## Tool-Specific Guidance

### Execute_R Tool

**What You'll See**:
```r
# BTW executing via MCP:
> your_code_here
[output appears here]
[no prompt - press Enter]
```

**Plot Handling**:
- Plots appear automatically in RStudio
- Previous plots preserved in history
- Use `dev.off()` to clear if needed

### File Listing Tool

**Pre-Check Before Listing** (RECOMMENDED):
```r
# First, check file count in R directly:
length(list.files(recursive = TRUE))  # Total files
length(list.files())                  # Immediate directory only

# If > 100 files, use filtering
```

**Token-Efficient Patterns**:
```r
# List only R files (non-recursive by default):
mcp__btw-r-v3__btw_tool_files_list_files(regexp = "\\.R$")

# List only CSV data:
mcp__btw-r-v3__btw_tool_files_list_files(regexp = "\\.csv$")

# List only directories:
mcp__btw-r-v3__btw_tool_files_list_files(type = "directory")

# Combine directory + pattern:
mcp__btw-r-v3__btw_tool_files_list_files(
  path = "data",
  regexp = "\\.csv$"
)
```

**Directory-Specific Examples** (from your actual project):
```r
# Your Demo_Components_Chng has 7,257 files!
# Too many for: mcp__btw-r-v3__btw_tool_files_list_files()

# Better approaches for large projects:
# 1. List just R files (found 16):
mcp__btw-r-v3__btw_tool_files_list_files(regexp = "\\.R$")

# 2. List just immediate directory files:
mcp__btw-r-v3__btw_tool_files_list_files(type = "file")
# Still might be too many if lots of detail

# 3. List specific subdirectory:
mcp__btw-r-v3__btw_tool_files_list_files(path = "scripts")
```

### Search Tools

**CRAN Search Tips**:
```r
# Specific terms work better:
"ggplot2" > "plotting"
"dplyr" > "data manipulation"
"sf" > "spatial data"

# Warning about broad searches is helpful:
# "WARNING: YOUR PACKAGE SEARCH QUERY IS TOO BROAD"
```

### Documentation Tools

**Efficient Help Usage**:
```r
# Get help for specific function:
mcp__btw-r-v3__btw_tool_docs_help_page(
  package_name = "stats",
  topic = "lm"
)

# List all topics first, then drill down:
mcp__btw-r-v3__btw_tool_docs_package_help_topics(
  package_name = "ggplot2"
)
```

---

## Troubleshooting

### Problem: All tools hang/no response

**Solution**:
```r
# In RStudio:
library(btw)
btw_mcp_session()  # Re-establish connection
```

### Problem: Can't see what Claude is doing

**Check These**:
1. RStudio console for code + output
2. Plots pane for visualizations
3. Environment pane for new variables
4. Files pane for created files

### Problem: "Socket not found" errors

**Fix Sequence**:
```r
# 1. Check if socket exists:
list.files("/tmp", pattern = "mcptools-socket")

# 2. If missing, recreate:
library(btw)
btw_mcp_session()

# 3. Restart Claude Code if needed
```

### Problem: Want to stop Claude's execution

**Options**:
1. Press Escape in RStudio console
2. Click Stop button in RStudio
3. Wait for timeout (operations have limits)

---

## Appendix: Complete Tool List with Quirks

| Tool | Quirks | Best Practice |
|------|--------|---------------|
| execute_r | No prompt return | Press Enter after |
| files_list_files | Token limits, relative paths only | Use filters/subdirs |
| files_read_text_file | Relative paths only | Use getwd() to check location |
| files_write_text_file | Relative paths only | Creates in current dir |
| web_read_url | Needs chromote | Use WebFetch alternative |
| ide_read_current_editor | Works perfectly | Use consent = TRUE |
| All others | None discovered | Work as expected |

---

## Quick Reference Card

```r
# Daily startup (ONLY 2 COMMANDS):
library(btw)
btw_mcp_session()

# Check connection:
# Ask Claude: "What's in my environment?"

# If console prompt disappears:
# Press Enter to restore it

# For large directories:
# Use regexp filters to avoid token limits

# This manual: ~/.claude/r_mcp/USER_MANUAL.md
```

---

*This is a living document. Updates based on real usage experience.*