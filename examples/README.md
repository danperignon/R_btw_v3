# BTW R MCP v3 - Example Scripts

Ready-to-run R scripts demonstrating collaborative workflows with Claude.

---

## How to Use These Examples

### Setup (Once per RStudio session)

```r
# In RStudio:
library(btw)
btw_mcp_session()
```

### Running Examples

**Option 1: Ask Claude to run them**
```
In Claude Code:
"Read examples/basic_analysis.R and execute it step by step, explaining what each part does"
```

**Option 2: Run directly in RStudio**
```r
# In RStudio:
source("examples/basic_analysis.R")
```

**Option 3: Copy-paste sections**
- Open the .R file
- Copy interesting parts
- Paste into RStudio console
- See Claude's perspective by checking what it would see

---

## Available Examples

### 1. basic_analysis.R
**What it does**: Complete data analysis workflow from loading to visualization

**Topics covered**:
- Loading data
- Summary statistics
- Data transformation
- Basic plotting
- Results interpretation

**Time**: ~5 minutes

**Try asking Claude**:
- "Run basic_analysis.R and explain the findings"
- "Modify basic_analysis.R to use dplyr instead of base R"
- "Add a correlation analysis to basic_analysis.R"

---

### 2. plotting.R
**What it does**: Creates publication-quality figures with ggplot2

**Topics covered**:
- ggplot2 basics
- Theme customization
- Multiple plot layouts
- Saving plots in different formats
- High-resolution exports

**Time**: ~10 minutes

**Try asking Claude**:
- "Run plotting.R and save all figures to ./figures/"
- "Modify plotting.R to use a different color scheme"
- "Add error bars to the plots in plotting.R"

---

### 3. package_learning.R
**What it does**: Demonstrates package discovery and learning workflow

**Topics covered**:
- Searching CRAN for packages
- Reading package documentation
- Exploring vignettes
- Testing package functions
- Comparing similar packages

**Time**: ~15 minutes

**Try asking Claude**:
- "Run package_learning.R and show me the top 3 results"
- "Find packages for time series analysis and compare them"
- "Show me how to use the package found in package_learning.R"

---

### 4. collaborative_debug.R
**What it does**: Intentionally broken code for debugging practice

**Topics covered**:
- Identifying errors
- Reading stack traces
- Systematic debugging
- Testing fixes
- Code refactoring

**Time**: ~15 minutes

**Try asking Claude**:
- "Debug collaborative_debug.R and fix all errors"
- "Explain why collaborative_debug.R fails and suggest fixes"
- "Refactor collaborative_debug.R to be more robust"

---

### 5. model_building.R
**What it does**: Statistical modeling workflow from EDA to diagnostics

**Topics covered**:
- Exploratory data analysis
- Model selection
- Fitting linear models
- Diagnostic plots
- Model comparison

**Time**: ~20 minutes

**Try asking Claude**:
- "Run model_building.R and interpret the results"
- "Improve the model in model_building.R by adding interactions"
- "Create a prediction function from model_building.R"

---

### 6. create_quarto.R
**What it does**: Shows how to CREATE Quarto documents collaboratively with Claude

**Topics covered**:
- Collaborative document building workflow
- Starting from scratch with Claude
- Iterative section addition
- Testing rendering as you build
- Parameterized reports
- Real conversation examples

**Time**: ~10 minutes

**Try asking Claude**:
- "Walk me through create_quarto.R and show me how to build a .qmd"
- "Create a Quarto document for analyzing my dataset using the workflow in create_quarto.R"
- "Help me build a parameterized report following the patterns in create_quarto.R"

---

### 7. quarto_document.qmd
**What it does**: Complete Quarto document for reproducible analysis reports (FINISHED EXAMPLE)

**Topics covered**:
- Quarto/RMarkdown syntax
- Code chunks with options
- Inline R code
- Tables with knitr::kable
- Publication-quality plots in documents
- Statistical analysis reporting
- Reproducible research workflow

**Time**: ~15 minutes

**Try asking Claude**:
- "Render quarto_document.qmd to HTML"
- "Add a new section analyzing sepal dimensions"
- "Create a similar Quarto doc for the mtcars dataset"
- "Convert this to PDF format"

**Prerequisites**:
```r
install.packages("quarto")  # Or install Quarto CLI from quarto.org
```
- Fitting linear models
- Diagnostic plots
- Model comparison

**Time**: ~20 minutes

**Try asking Claude**:
- "Run model_building.R and interpret the results"
- "Improve the model in model_building.R by adding interactions"
- "Create a prediction function from model_building.R"

---

## Example Workflows

### Workflow 1: Learn by Doing
```
1. "Read examples/basic_analysis.R"
2. "Explain what this script does, section by section"
3. "Now run it and show me the results"
4. "Modify it to analyze iris dataset instead"
```

### Workflow 2: Debug and Fix
```
1. "Run examples/collaborative_debug.R"
2. (See error)
3. "What's causing this error?"
4. "Fix it and run again"
5. (Iterate until working)
```

### Workflow 3: Extend and Enhance
```
1. "Run examples/plotting.R"
2. "These plots look good. Add a histogram of residuals"
3. "Now make all plots use theme_minimal()"
4. "Save everything as high-res PNGs"
```

---

## Creating Your Own Examples

Use these scripts as templates! Common patterns:

### Pattern: Analysis Script
```r
# 1. Load libraries
library(dplyr)
library(ggplot2)

# 2. Load/create data
data <- mtcars

# 3. Analyze
summary(data)

# 4. Visualize
plot(data$wt, data$mpg)

# 5. Interpret
# Ask Claude: "What does this analysis tell us?"
```

### Pattern: Package Exploration
```r
# 1. Search for packages
# Ask Claude: "Find packages for [topic]"

# 2. Get package info
# Ask Claude: "Tell me about package [name]"

# 3. Read vignette
# Ask Claude: "Show me the main vignette for [package]"

# 4. Try examples
# Ask Claude: "Run the first example from [package] documentation"
```

---

## Tips for Collaborative Work

### 1. Start with Questions
```
"What does examples/basic_analysis.R do?"
→ Claude reads and explains before running
```

### 2. Run Step-by-Step
```
"Run lines 1-10 of examples/plotting.R"
→ See intermediate results
```

### 3. Modify and Test
```
"Change the color scheme in examples/plotting.R to viridis and re-run"
→ Iterative development
```

### 4. Save Successful Experiments
```
"The modified version of examples/basic_analysis.R works great. Save it as my_analysis.R"
→ Build your own library
```

---

## What You'll Learn

By working through these examples, you'll understand:

1. **How Claude sees your R code** (complete visibility)
2. **How to collaborate iteratively** (modify, test, refine)
3. **Common R workflows** (analysis, plotting, modeling)
4. **BTW R MCP capabilities** (16 specialized tools)
5. **Debugging strategies** (systematic problem-solving)

---

## Next Steps

After trying these examples:

1. **Adapt them**: Modify for your own data/problems
2. **Combine them**: Mix patterns from different examples
3. **Create new ones**: Build your own collaborative workflows
4. **Share discoveries**: What works well for your use cases?

---

**Ready to start?** Try `basic_analysis.R` first—it's the gentlest introduction!
