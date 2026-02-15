# BTW R MCP v3

Provides complete and simultaneous bidirectional visibility of all execution output.

## Quick Start

### 1. Install R packages

```r
remotes::install_github("tidyverse/ellmer")
remotes::install_github("posit-dev/btw")
remotes::install_github("posit-dev/mcptools")
install.packages("evaluate")
```

### 2. Configure Claude Code

Add to `~/.claude.json`:

```json
{
  "mcpServers": {
    "btw-r-v3": {
      "type": "stdio",
      "command": "/Library/Frameworks/R.framework/Resources/bin/Rscript",
      "args": ["/path/to/R_btw_v3/src/btw_mcp_server_v3.R"]
    }
  }
}
```

### 3. Connect RStudio

```r
library(btw)
btw_mcp_session()
```

### 4. Test it

Ask Claude: "Execute: summary(mtcars)"

You'll see the code AND output in your RStudio console, and Claude sees it too.

## What You See

```r
# BTW executing via MCP:
> data <- mtcars[1:5, 1:3]
> summary(data)
      mpg             cyl             disp
 Min.   :18.10   Min.   :4.00   Min.   :108.0
 ...

Auto-context: 1 objects | Recent: data(data.frame)
```

## Tools Included

- **execute_r** - Run code in your session
- **editor_write** - 9 editor actions (insert, replace, comment, etc.)
- **save_plot** - Export plots
- **env_describe_environment** - Inspect workspace (5 detail levels)
- **env_describe_data_frame** - Analyze data frames
- **docs_help_page** / **docs_vignette** - R documentation
- **search_packages** - CRAN discovery
- Plus session info, package management tools

## Configuration

```r
# Control console output
Sys.setenv(BTW_ECHO_CODE = "TRUE")       # Show code being executed
Sys.setenv(BTW_ECHO_OUTPUT = "TRUE")     # Show output
Sys.setenv(BTW_INSPECT = "upgraded")     # none | minimal | standard | upgraded | verbose
```

## Requirements

- R 4.1+
- RStudio
- Claude Code (or any MCP client)

## Docs

See `docs/` for detailed guides and `examples/` for sample workflows.
