# Tool Reference

## Available Tools (16)

### Execution
- **execute_r** - Run R code in session or subprocess
  ```r
  mcp__btw-r-v3__execute_r(code = "plot(1:10)")
  ```

#### Execution Modes
- **Subprocess mode**: Clean isolated execution - **DEFAULT**
  - Behavior: Each call is independent, no side effects
  - Variables: Don't persist between calls
  - Use case: Quick calculations, testing code, one-off operations
  - Advantage: No setup required, no workspace pollution
- **Session mode**: Persistent analysis workflows
  - Requires: `btw_mcp_session()` active in RStudio
  - Behavior: Code executes in YOUR RStudio session
  - Variables: Persist between calls
  - Plots: Appear in YOUR viewer
  - Use case: Complex analysis, iterative development, building workflows

**When to upgrade to session mode**: Multi-step analysis, building complex workflows, when you need variables to persist across execute_r calls.

### Environment
- **btw_tool_env_describe_environment** - List workspace objects
- **btw_tool_env_describe_data_frame** - Analyze data structure
  ```r
  mcp__btw-r-v3__btw_tool_env_describe_data_frame(data_frame = "mtcars")
  ```

### Editor
- **btw_tool_ide_read_current_editor** - Read active file
- **btw_tool_editor_write** - Write to editor (9 actions)
  - `insert` - at cursor
  - `replace` - entire document
  - `append` - to end
  - `prepend` - to start
  - `insert_at_line` - at specific line
  - `replace_selection` - selected text
  - `replace_lines` - line range
  - `comment_lines` - add comments
  - `uncomment_lines` - remove comments

### Documentation
- **btw_tool_docs_help_page** - R help pages
- **btw_tool_docs_available_vignettes** - List vignettes
- **btw_tool_docs_vignette** - Read vignette
- **btw_tool_docs_package_news** - Package news
- **btw_tool_docs_package_help_topics** - Package topics

### Search
- **btw_tool_search_packages** - Find CRAN packages
- **btw_tool_search_package_info** - Package details

### Session
- **btw_tool_session_platform_info** - System information
- **btw_tool_session_package_info** - Installed packages
- **btw_tool_session_check_package_installed** - Check installation

### Plotting
- **btw_tool_save_plot** - Save current plot
  ```r
  mcp__btw-r-v3__btw_tool_save_plot(
    filename = "myplot.png",
    width = 8,
    height = 6
  )
  ```

## Tool Naming Convention

All tools follow the pattern:
```
mcp__btw-r-v3__[tool_name]
```

**Note**: Original BTW MCP v1 used `mcp__btw-r__` prefix. V2 uses `mcp__btw-r-v3__` for clarity.

## Excluded Tools

These BTW tools are excluded because Claude's native tools are better:
- File operations → Use Claude's `Read`, `Write`, `Edit`
- Code search → Use Claude's `Grep`, `Glob`
- Web reading → Use Claude's `WebFetch`

## Examples

### Complete Analysis Workflow
```r
# 1. Load data
mcp__btw-r-v3__execute_r(code = "data <- read.csv('data.csv')")

# 2. Explore structure
mcp__btw-r-v3__btw_tool_env_describe_data_frame(data_frame = "data")

# 3. Create visualization
mcp__btw-r-v3__execute_r(code = "plot(data$x, data$y)")

# 4. Save plot
mcp__btw-r-v3__btw_tool_save_plot(filename = "analysis.png")
```

### Editor Workflow
```r
# Read current file
mcp__btw-r-v3__btw_tool_ide_read_current_editor(consent = TRUE)

# Insert new function
mcp__btw-r-v3__btw_tool_editor_write(
  text = "my_function <- function(x) {\n  x * 2\n}",
  action = "insert"
)

# Comment lines 5-10
mcp__btw-r-v3__btw_tool_editor_write(
  action = "comment_lines",
  start_line = 5,
  end_line = 10
)
```

## Detailed References

This document provides a quick tool reference. For comprehensive information:

- **[guides/BTW_VS_CLAUDE_TOOLS.md](guides/BTW_VS_CLAUDE_TOOLS.md)** - Detailed comparison of when to use BTW vs Claude native tools
- **[references/COMPLETE_FUNCTION_REFERENCE.md](references/COMPLETE_FUNCTION_REFERENCE.md)** - Complete catalog of all functions with examples
- **[references/ELLMER_BTW_ARCHITECTURE.md](references/ELLMER_BTW_ARCHITECTURE.md)** - How the three-layer package stack works

See [README.md](README.md) for complete navigation.