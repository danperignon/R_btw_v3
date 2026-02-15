# Getting Started with BTW R MCP v3

**Complete setup guide from zero to running**

This guide walks you through everything: installing Claude Code, setting up BTW R MCP v3, and running your first collaborative R session.

---

## Prerequisites

Before starting, make sure you have:

- **macOS** or **Linux** (Windows support via WSL)
- **R 4.1+** installed ([download from CRAN](https://cran.r-project.org/))
- **RStudio** installed ([download from Posit](https://posit.co/download/rstudio-desktop/))
- **A Claude account** (sign up at [claude.ai](https://claude.ai))

---

## Part 1: Install Claude Code

### Step 1: Install Claude Code CLI

**On macOS/Linux:**

```bash
# Install via curl
curl -fsSL https://claude.com/install.sh | bash

# Or via Homebrew
brew install anthropics/anthropic/claude
```

After installation, verify:
```bash
claude --version
```

### Step 2: Authenticate

Sign in to your Claude account:

```bash
claude auth login
```

This will open your browser to authenticate. Follow the prompts.

### Step 3: Verify Installation

Test that Claude Code works:

```bash
cd ~
claude
```

You should see the Claude Code CLI interface. Type `/help` to see available commands. Type `/exit` to quit.

**✅ Claude Code is installed!**

---

## Part 2: Install BTW R MCP v3

### Step 1: Install R Packages

Open R or RStudio and run:

```r
# Install remotes if you don't have it
if (!require("remotes")) install.packages("remotes")

# Install the three-layer stack
remotes::install_github("tidyverse/ellmer")
remotes::install_github("posit-dev/btw")
remotes::install_github("posit-dev/mcptools")

# Install evaluate for v3 complete visibility
install.packages("evaluate")
```

**This might take 5-10 minutes.** Get a coffee! ☕

### Step 2: Copy BTW R MCP v3 Files

Copy the V3 directory somewhere permanent (don't leave it on Desktop):

```bash
# Choose a location (example uses ~/.local/share/)
mkdir -p ~/.local/share/btw-r-mcp
cp -r ~/Desktop/V3/* ~/.local/share/btw-r-mcp/
```

**Remember this path!** You'll need it in the next step.

### Step 3: Configure Claude Code

Edit your Claude Code configuration:

```bash
# Open the config file
nano ~/.claude.json
# (or use your favorite editor: vim, code, etc.)
```

Find the `"mcpServers": {` section and add:

```json
{
  "mcpServers": {
    "btw-r-v3": {
      "type": "stdio",
      "command": "/Library/Frameworks/R.framework/Resources/bin/Rscript",
      "args": [
        "/Users/YOUR_USERNAME/.local/share/btw-r-mcp/src/btw_mcp_server_v3.R"
      ],
      "env": {}
    }
  }
}
```

**⚠️ Important**: Replace `/Users/YOUR_USERNAME/` with your actual home directory path!

**Pro tip**: On macOS, `/Library/Frameworks/R.framework/Resources/bin/Rscript` is the standard R path. On Linux, it might be `/usr/bin/Rscript` or `/usr/local/bin/Rscript`.

### Step 4: Verify MCP Server Connection

Start Claude Code:

```bash
claude
```

Check MCP servers:

```
/mcp
```

You should see:
```
btw-r-v3    ✔ connected
```

If it shows ✘ failed, check:
1. Is the path in `~/.claude.json` correct?
2. Did you install all R packages?
3. Try restarting Claude Code

**✅ BTW R MCP v3 is installed!**

### Step 5: Install the /btw Slash Command (Optional but Recommended)

This custom command loads workflow patterns and best practices:

```bash
# Create commands directory
mkdir -p ~/.claude/commands

# Copy the command
cp claude-commands/btw.md ~/.claude/commands/
```

Now when you type `/btw` in Claude Code, it loads R Analysis Mode with workflow guidance!

See [SLASH_COMMAND.md](docs/SLASH_COMMAND.md) for details.

---

## Part 3: Your First Session

### Step 1: Start RStudio

Open RStudio and run:

```r
library(btw)
btw_mcp_session()
```

You should see:
```
Starting MCP session...
Socket created at: /tmp/mcptools-socket-[id]
Ready for connections!
```

**Keep RStudio open!**

### Step 2: Start Claude Code

In a terminal, start Claude Code from your project directory:

```bash
cd ~/projects/my-r-analysis
claude
```

### Step 3: Test the Connection

Ask Claude:

```
Execute: summary(mtcars)
```

**What you'll see in RStudio:**
```r
# BTW executing via MCP:
> summary(mtcars)
      mpg             cyl             disp          hp
 Min.   :10.40   Min.   :4.000   Min.   : 71.1   Min.   : 52.0
 1st Qu.:15.43   1st Qu.:4.000   1st Qu.:120.8   1st Qu.: 96.5
 Median :19.20   Median :6.000   Median :196.3   Median :123.0
[...complete output...]

Auto-context: 0 objects
```

**Claude also sees this exact output!** That's the v3 bidirectional visibility breakthrough.

**✅ It's working!**

---

## Try the Examples

Navigate to the examples directory:

```bash
cd ~/.local/share/btw-r-mcp/examples/
```

Run the example scripts (see `examples/README.md` for details):

1. **basic_analysis.R** - Simple data analysis workflow
2. **plotting.R** - Create and save publication figures
3. **package_learning.R** - Discover and learn new packages
4. **collaborative_debug.R** - Debug code with Claude's help

**To run an example:**

```r
# In RStudio with btw_mcp_session() active
```

Then in Claude Code:
```
"Read examples/basic_analysis.R and execute it step by step, explaining each part"
```

---

## Understanding the Workflow

### The Setup (Once per RStudio session)

```r
# In RStudio:
library(btw)
btw_mcp_session()
```

**This connects RStudio to Claude Code.**

### The Workflow (Every time)

1. **RStudio**: Run `btw_mcp_session()`
2. **Terminal**: Start `claude` in your project
3. **Ask Claude**: Natural language R tasks
4. **See Results**: In RStudio console AND Claude sees them too

### Two Modes

**Session Mode** (variables persist):
```r
# In RStudio first:
library(btw)
btw_mcp_session()

# Then ask Claude:
"Create variable x with values 1 to 10, then calculate mean and sd"
```

**Subprocess Mode** (quick calculations):
```
# No RStudio needed
# Just ask Claude:
"What's the correlation between mtcars$mpg and mtcars$wt?"
```

---

## Configuration Options

### See Everything (Default)

```r
# In RStudio:
Sys.setenv(BTW_ECHO_CODE = "TRUE")      # Show code
Sys.setenv(BTW_ECHO_OUTPUT = "TRUE")    # Show output
Sys.setenv(BTW_INSPECT = "standard")    # Show recent objects
```

### Silent Mode (Claude sees, console stays clean)

```r
Sys.setenv(BTW_ECHO_CODE = "FALSE")
Sys.setenv(BTW_ECHO_OUTPUT = "FALSE")
Sys.setenv(BTW_INSPECT = "none")
```

### Inspection Levels

- `"none"` - No automatic inspection
- `"minimal"` - Object count only
- `"standard"` - Recent 5 objects (default)
- `"verbose"` - All objects with types

---

## Common First-Time Issues

### "btw-r-v3 failed to connect"

**Check:**
1. Is the path in `~/.claude.json` correct?
   ```bash
   cat ~/.claude.json | grep btw-r-v3 -A5
   ```
2. Does the server file exist?
   ```bash
   ls -la ~/.local/share/btw-r-mcp/src/btw_mcp_server_v3.R
   ```
3. Are R packages installed?
   ```r
   # In R:
   library(btw)      # Should load without errors
   library(evaluate) # Should load without errors
   ```

### "Socket not found"

**Run in RStudio:**
```r
library(btw)
btw_mcp_session()
```

**Each RStudio session needs `btw_mcp_session()` once.**

### "Cannot find config.R"

**The server needs config.R in the same directory.**

Check:
```bash
ls ~/.local/share/btw-r-mcp/src/
# Should show: btw_mcp_server_v3.R AND config.R
```

If config.R is missing, copy it from the V3 package.

---

## What to Try Next

1. **Read the examples**: `examples/README.md`
2. **User guide**: `USER_GUIDE.md` for daily patterns
3. **Tool reference**: `docs/TOOLS.md` for all capabilities
4. **Troubleshooting**: `TROUBLESHOOTING.md` for common issues

---

## Quick Reference Card

```bash
# Start sequence
1. Open RStudio → library(btw); btw_mcp_session()
2. Open terminal → cd your-project && claude
3. Ask Claude natural language R tasks

# Check MCP status
/mcp

# Get help
/help

# Exit Claude Code
/exit
```

---

## What Makes v3 Special?

**Complete bidirectional visibility**: Both you AND Claude see all R output simultaneously—prints, plots, warnings, errors, everything. No workarounds needed.

**Powered by**: The `evaluate` package with `keep_warning=NA` parameter. This is the breakthrough that makes v3 production-ready.

---

**Questions?** See [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) or [USER_GUIDE.md](docs/USER_MANUAL.md).

**Ready to dive deeper?** Check out [docs/EXAMPLES.md](docs/EXAMPLES.md) for advanced patterns.
