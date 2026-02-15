# Setup Guide

## Prerequisites

1. **R 4.1+** - Required for native pipe (`|>`) support
2. **RStudio** - For editor integration features
3. **Claude Code** - With MCP server support

## ⚠️ Security Notice

**Claude gets FULL access to your R session, workspace, and files** when BTW is connected. Only use with trusted AI assistants and avoid sharing sensitive data.

## Installation

### Step 1: Install R Packages

```r
# Install from GitHub (development versions required)
remotes::install_github("tidyverse/ellmer")
remotes::install_github("posit-dev/btw")
remotes::install_github("posit-dev/mcptools")

# Install evaluate for v3 complete console visibility
install.packages("evaluate")  # Required for bidirectional visibility
```

### Step 2: Configure Claude Code

Add to your Claude Code settings (`~/.claude.json`):

```json
{
  "mcpServers": {
    "btw-r-v3": {
      "type": "stdio",
      "command": "Rscript",
      "args": [
        "/path/to/your/r_mcp/src/btw_mcp_server_v3.R"
      ]
    }
  }
}
```

**✨ v3 **: This server provides complete console visibility—both you AND Claude see all execution output simultaneously.

Replace `/path/to/your/r_mcp` with the actual path to this repository.

### Step 3: Connect RStudio

In RStudio, run once per session:

```r
library(btw)
btw_mcp_session()  # Creates connection socket
```

You should see:
```
Starting MCP session...
Socket created at: /tmp/mcptools-socket-[id]
Ready for connections!
```

## Verification

Test the connection:

```r
# Ask Claude to run:
# mcp__btw-r-v3__execute_r(code = "1 + 1")
```

If you see `[1] 2` in your RStudio console, setup is complete!

**✨ v3 Feature**: With the `evaluate` package installed, you'll see:
- All code Claude executes (with `# BTW executing via MCP:` prefix)
- All output Claude sees (prints, summaries, plots, warnings, errors)
- Complete bidirectional visibility—no blind spots!

## Troubleshooting

**Tools not responding**: Ensure `btw_mcp_session()` was run in current R session

**"RStudio not available" errors**: Check that you're running code in RStudio, not terminal R

**Socket connection lost**: Run `btw_mcp_session()` again after restarting R

## Next Steps

- **Start using BTW**: See [user-guide.md](user-guide.md) for daily workflow
- **Understand tools**: Check [tools.md](tools.md) for complete tool reference
- **Troubleshoot issues**: Visit [troubleshooting.md](troubleshooting.md) for common problems

For detailed setup information and advanced configuration options, see [README.md](README.md) for complete documentation.