# BTW R MCP v3 - Quick Start Examples

Ready-to-use patterns for common R workflows with Claude.

---

## Basic Data Analysis

```r
# In RStudio:
library(btw)
btw_mcp_session()

# Ask Claude:
"Load mtcars, calculate summary statistics, and create a scatter plot of mpg vs wt"
```

**What happens:**
- Claude executes code in your session
- You see all output in console
- Plot appears in RStudio viewer
- Variables persist in your environment

---

## Creating a Function with Tests

```r
# Ask Claude:
"Create a function called calc_z_score that standardizes a numeric vector,
 add roxygen documentation, and write testthat tests"
```

**Claude will**:
1. Write the function to your editor
2. Add proper documentation
3. Create test file
4. Run tests to verify

---

## Debugging Workflow

```r
# You have an error in your script
# Ask Claude:
"Read my current editor, find the bug causing the error,
 and fix it on lines 25-30"
```

**Claude will**:
1. Read your script with `btw_tool_ide_read_current_editor`
2. Analyze the error
3. Use `editor_write(action="replace_lines")` to fix it
4. Test the fix with `execute_r`

---

## Package Discovery

```r
# Ask Claude:
"Find R packages for time series forecasting,
 show me the top 3, and give examples of each"
```

**Claude will**:
1. Search CRAN with `search_packages`
2. Get package details with `search_package_info`
3. Read vignettes with `docs_vignette`
4. Show you example code with `execute_r`

---

## Publication Figure

```r
# In RStudio (session mode):
library(btw)
btw_mcp_session()

# Ask Claude:
"Create a publication-quality figure of iris data:
 - ggplot scatter plot (Sepal.Length vs Sepal.Width)
 - Colored by Species
 - Minimal theme with 14pt text
 - Save as PNG (300 dpi) and PDF to ./figures/"
```

**What Claude does:**
```r
# Step 1: Create plot
mcp__btw-r-v3__execute_r(code = "
library(ggplot2)
p <- ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point(size = 3) +
  theme_minimal(base_size = 14) +
  labs(title = 'Iris Sepal Dimensions')
print(p)
")

# Step 2: Save multiple formats
mcp__btw-r-v3__btw_tool_save_plot(
  filename = "iris_plot.png",
  path = "figures",
  width = 7, height = 5, dpi = 300, format = "png"
)

mcp__btw-r-v3__btw_tool_save_plot(
  filename = "iris_plot.pdf",
  path = "figures",
  width = 7, height = 5, format = "pdf"
)
```

**You see**: Plot in viewer, then saved to files!

---

## Interactive Script Development

```r
# Ask Claude:
"Help me build a data cleaning script step by step.
 Start by reading data/raw.csv and showing me the structure"
```

**Collaborative workflow:**
1. Claude loads data: `execute_r("data <- read.csv('data/raw.csv')")`
2. Shows structure: `execute_r("str(data)")`
3. You review output together
4. Claude suggests: "I see missing values in column X, should we handle those?"
5. You decide: "Yes, remove rows with NA"
6. Claude adds to script: `editor_write(action="append", text="data <- na.omit(data)")`
7. Tests it: `execute_r("summary(data)")`
8. Iterates until complete

---

## Environment Inspection

```r
# After running analyses, ask:
"What objects are in my workspace and what are their types?"
```

**Claude uses:**
```r
mcp__btw-r-v3__btw_tool_env_describe_environment()
```

**Output:**
```
Environment contains 5 objects:
- data (data.frame): 150 obs. of 5 variables
- model (lm): Linear model object
- plot1 (ggplot): Plot object
- results (numeric): 100 values
- summary_stats (list): 3 elements
```

---

## Code Commenting for Debugging

```r
# Ask Claude:
"Comment out lines 50-65 in my current script,
 run the code, then uncomment if it works"
```

**Claude workflow:**
```r
# Step 1: Comment
mcp__btw-r-v3__btw_tool_editor_write(
  action = "comment_lines",
  start_line = 50,
  end_line = 65
)

# Step 2: Test
mcp__btw-r-v3__execute_r(code = "source('script.R')")

# Step 3: If successful, uncomment
mcp__btw-r-v3__btw_tool_editor_write(
  action = "uncomment_lines",
  start_line = 50,
  end_line = 65
)
```

---

## Learning a New Function

```r
# Ask Claude:
"Explain how dplyr::group_by works and show me 3 examples"
```

**Claude will:**
1. Get help: `docs_help_page(package_name="dplyr", topic="group_by")`
2. Find vignette: `docs_available_vignettes(package_name="dplyr")`
3. Show examples with real data: `execute_r("...")`
4. You see output in console

---

## Configuration Examples

### Verbose Mode (Maximum Visibility)
```r
# See everything Claude does
Sys.setenv(BTW_ECHO_CODE = "TRUE")
Sys.setenv(BTW_ECHO_OUTPUT = "TRUE")
Sys.setenv(BTW_INSPECT = "verbose")  # Shows all object types
```

### Silent Mode (Claude Sees, Console Stays Clean)
```r
# Useful for long outputs
Sys.setenv(BTW_ECHO_CODE = "FALSE")
Sys.setenv(BTW_ECHO_OUTPUT = "FALSE")
Sys.setenv(BTW_INSPECT = "none")
```

### Inspection Levels
```r
# Minimal: Just object count
Sys.setenv(BTW_INSPECT = "minimal")
# → "Auto-context: 5 objects"

# Standard: Recent 5 objects (default)
Sys.setenv(BTW_INSPECT = "standard")
# → "Auto-context: 5 objects | Recent: data, model, plot1, results, stats"

# Verbose: All objects + types
Sys.setenv(BTW_INSPECT = "verbose")
# → "Auto-context: 5 objects | All: data, model, plot1, results, stats |
#    Recent: data(data.frame), model(lm), plot1(ggplot), results(numeric), stats(list)"
```

---

## Tips for Effective Use

### 1. Session Mode vs Subprocess Mode

**Use Session Mode when:**
- Building multi-step analyses
- Variables need to persist
- Creating complex workflows
- Debugging interactively

```r
library(btw)
btw_mcp_session()  # Run this first!
```

**Use Subprocess Mode when:**
- Quick calculations
- One-off operations
- Testing code snippets
- No RStudio session needed

*Just ask Claude—no setup required!*

### 2. Batch Related Operations

```r
# Instead of asking separately:
# "Load data"
# "Summarize it"
# "Plot it"

# Ask all at once:
"Load data/sales.csv, show summary statistics,
 create a time series plot, and save it as sales_plot.png"
```

### 3. Use Editor Actions Strategically

```r
# For large changes: replace_lines or replace entire document
# For additions: append or insert_at_line
# For debugging: comment_lines, test, then uncomment_lines
# For selected text: replace_selection (select in RStudio first)
```

### 4. Leverage Auto-Inspection

After running code, Claude automatically sees what was created:
```r
execute_r("x <- 1:10")
# Claude sees: "Auto-context: 1 object | Recent: x"
```

No need to manually ask "what did that create?"

---

## Common Patterns

### Pattern: Explore → Analyze → Visualize
```r
# 1. Explore
"What's in the mtcars dataset?"

# 2. Analyze
"Create a linear model of mpg vs wt and hp"

# 3. Visualize
"Plot the residuals and save as diagnostics.png"
```

### Pattern: Search → Learn → Implement
```r
# 1. Search
"Find packages for mixed-effects models"

# 2. Learn
"Show me the lme4 vignette and explain random effects"

# 3. Implement
"Create a mixed model for my nested data"
```

### Pattern: Read → Modify → Test
```r
# 1. Read
"Read my current script"

# 2. Modify
"Refactor the data loading section to use readr instead of base R"

# 3. Test
"Run the modified code and verify it still works"
```

---

**Ready to start? See [USER_MANUAL.md](USER_MANUAL.md) for detailed daily usage patterns!**
