# Troubleshooting

## Common Issues

### Tools Not Responding
**Symptom**: Claude's BTW tools hang with no output

**Solution**:
```r
# Run in RStudio:
btw_mcp_session()
```
The socket connection must be created each R session.

---

### Console Prompt Missing
**Symptom**: After code execution, the `>` prompt doesn't return

**Solution**: Press Enter once. This is a cosmetic issue only.

---

### "RStudio not available"
**Symptom**: Editor tools return this error

**Solutions**:
1. Ensure you're in RStudio, not terminal R
2. Check rstudioapi is installed: `install.packages("rstudioapi")`
3. Restart RStudio and try again

---

### Variables Not Persisting
**Symptom**: Variables created by Claude disappear

**Cause**: Not connected to your session

**Solution**: Run `btw_mcp_session()` to connect

---

### Plot Not Saving
**Symptom**: "No active plot to save"

**Solution**: Create a plot first:
```r
plot(1:10)  # Create plot
# Then ask Claude to save it
```

---

### Long Running Code
**Symptom**: Code runs forever

**Current Limitation**: No timeout in session mode (unlike ClaudeR which has timeout control)

**Risk**: Long-running operations can hang indefinitely

**Workaround**: Use Ctrl+C in RStudio console to interrupt

---

### IPC Socket Issues
**Symptom**: Tools hang with no error message

**Technical Details**: BTW uses IPC socket at `/tmp/mcptools-socket*` to bridge Claude ↔ RStudio

**Failure Mode**: Without `btw_mcp_session()`, socket doesn't exist and tools hang silently

**Solution**: Always run `btw_mcp_session()` after R restarts

---

## Verification Commands

### Check Connection
```r
# Check if socket exists:
list.files("/tmp", pattern = "mcptools-socket")
```

### Test Execution
Ask Claude to run:
```
mcp__btw-r-v3__execute_r(code = "sessionInfo()")
```

### Test Editor
```r
# Open any R file in RStudio, then ask Claude:
# mcp__btw-r-v3__btw_tool_ide_read_current_editor(consent = TRUE)
```

## Getting Help

1. Check this guide first
2. Restart R and re-run `btw_mcp_session()`
3. Restart Claude Code if issues persist
4. Check [GitHub Issues](https://github.com/posit-dev/btw/issues)

## Debug Mode

For detailed debugging:
```r
# Enable verbose output
options(btw.verbose = TRUE)
btw_mcp_session()
```

## Technical Details

### Architecture Breakthrough
**Key Discovery**: stderr output interferes with MCP stdio protocol

**Why BTW works**: Clean stdio communication without debug output
```r
#!/usr/bin/env Rscript
library(mcptools); library(btw)
mcptools::mcp_server(tools = btw::btw_tools())  # Direct call, clean stdio
```

### Anti-Patterns (Avoid These)
❌ **Don't output to stderr**: `cat("debug", file = stderr())` breaks MCP protocol
❌ **Don't use launcher scripts**: `btw::btw_mcp_server()` wrapper has limitations
❌ **Don't use -e flag**: BTW expects direct script execution, not sourcing

### BTW vs ClaudeR Comparison
| Feature | ClaudeR | BTW v2 | Notes |
|---------|---------|--------|-------|
| Execute in RStudio | ✅ | ✅ | Both work |
| Timeout control | ✅ | ❌ | **Risk gap** - BTW can hang |
| Editor actions | 1 | 9 | BTW superior |
| Plot saving | ❌ | ✅ | BTW advantage |
| Total R tools | 7 | 16 | BTW advantage |

## Advanced Troubleshooting

For complex issues beyond this quick guide:

- **✨ [USER_MANUAL.md#btw-mcp-v3---complete-console-visibility](USER_MANUAL.md#btw-mcp-v3---complete-console-visibility)** - v3 console visibility (production-ready)
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - System design and component relationships
- **[USER_MANUAL.md](USER_MANUAL.md)** - Comprehensive usage guide with real-world examples

**Note**: v2 visibility workarounds have been archived—v3 provides complete bidirectional visibility natively.

See [README.md](README.md) for complete documentation navigation.