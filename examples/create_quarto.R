#!/usr/bin/env Rscript

# Creating a Quarto Document with Claude
#
# This example demonstrates the collaborative workflow for building
# a Quarto document from scratch using BTW R MCP v3 and Claude.
#
# Prerequisites:
# - btw_mcp_session() active in RStudio
# - quarto package installed: install.packages("quarto")
#
# Try asking Claude:
# "Help me create a Quarto document for my mtcars analysis"
# "Build a .qmd step by step, adding sections as we go"

cat("Collaborative Quarto Document Creation\n")
cat("======================================\n\n")

# ============================================================================
# WORKFLOW: Creating a Quarto Document with Claude
# ============================================================================

cat("This script demonstrates the workflow, but Claude does the actual work!\n\n")

# ============================================================================
# STEP 1: ASK CLAUDE TO CREATE THE DOCUMENT STRUCTURE
# ============================================================================

cat("STEP 1: Ask Claude to Create Basic Structure\n")
cat("----------------------------------------------\n")
cat('Example prompt: "Create a Quarto document called my_analysis.qmd with:\n')
cat("  - YAML header with title, author, date\n")
cat("  - HTML output with table of contents\n")
cat("  - Setup chunk loading tidyverse\n")
cat("  - Introduction section\n")
cat("  - Placeholder sections for analysis\"\n\n")

cat("Claude will use btw_tool_editor_write to create the file:\n")
cat("  mcp__btw-r-v3__btw_tool_editor_write(\n")
cat("    text = '---\\ntitle: My Analysis\\n...', \n")
cat("    action = 'replace'  # Creates new document\n")
cat("  )\n\n")

# ============================================================================
# STEP 2: ADD DATA LOADING SECTION
# ============================================================================

cat("STEP 2: Add Data Loading Section\n")
cat("---------------------------------\n")
cat('Example prompt: "Add a section that loads mtcars and shows its structure"\n\n')

cat("Claude will:\n")
cat("  1. Read current document content\n")
cat("  2. Insert new section with code chunk\n")
cat("  3. Use btw_tool_editor_write(action='insert_at_line')\n\n")

# ============================================================================
# STEP 3: ADD ANALYSIS SECTIONS ITERATIVELY
# ============================================================================

cat("STEP 3: Build Analysis Sections Iteratively\n")
cat("--------------------------------------------\n")
cat("You and Claude work together, adding one section at a time:\n\n")

sections <- c(
  "Summary statistics table",
  "Visualization of mpg vs weight",
  "Linear model fitting",
  "Model diagnostic plots",
  "Conclusions"
)

for (i in seq_along(sections)) {
  cat(sprintf("  %d. Ask: 'Add a section for %s'\n", i, sections[i]))
}

cat("\nClaude appends each section, you review, iterate!\n\n")

# ============================================================================
# STEP 4: TEST RENDERING
# ============================================================================

cat("STEP 4: Test Rendering\n")
cat("-----------------------\n")
cat('Ask Claude: "Render my_analysis.qmd to HTML"\n\n')

cat("Claude will execute:\n")
cat("  mcp__btw-r-v3__execute_r(\n")
cat('    code = "quarto::quarto_render(\'my_analysis.qmd\')"\n')
cat("  )\n\n")

cat("You see the rendering output in your console!\n")
cat("Claude sees it too and can help fix any errors.\n\n")

# ============================================================================
# STEP 5: ITERATE AND REFINE
# ============================================================================

cat("STEP 5: Iterate Based on Output\n")
cat("--------------------------------\n")
cat("Common refinements:\n")
cat("  - 'Add figure captions to all plots'\n")
cat("  - 'Make the tables prettier with kableExtra'\n")
cat("  - 'Add a methods section explaining the linear model'\n")
cat("  - 'Include session info at the end'\n\n")

cat("Claude uses:\n")
cat("  - btw_tool_ide_read_current_editor (read current state)\n")
cat("  - btw_tool_editor_write(action='replace_lines') (modify sections)\n")
cat("  - execute_r (test rendering)\n\n")

# ============================================================================
# STEP 6: FINAL POLISH AND EXPORT
# ============================================================================

cat("STEP 6: Final Polish and Export\n")
cat("--------------------------------\n")
cat('Ask Claude: "Render to both HTML and PDF, save to reports/ folder"\n\n')

cat("Claude executes:\n")
cat('  quarto::quarto_render("my_analysis.qmd", output_format = "html")\n')
cat('  quarto::quarto_render("my_analysis.qmd", output_format = "pdf")\n')
cat("  # Then moves files to reports/\n\n")

# ============================================================================
# EXAMPLE CONVERSATION FLOW
# ============================================================================

cat("\n")
cat("============================================================================\n")
cat("EXAMPLE CONVERSATION WITH CLAUDE\n")
cat("============================================================================\n\n")

cat('YOU: "Create a Quarto document analyzing mtcars with ggplot2 visualizations"\n\n')

cat("CLAUDE: 'I'll create my_analysis.qmd with:\n")
cat("  - YAML header for HTML output\n")
cat("  - Setup chunk loading libraries\n")
cat("  - Data overview section\n")
cat("  - Visualization section\n")
cat("  - Statistical analysis section\n")
cat("  Creating now...'\n\n")

cat("  [Claude uses btw_tool_editor_write to create the file]\n\n")

cat("CLAUDE: 'Created! Here's the structure:\n")
cat("  - Introduction\n")
cat("  - Data Overview (shows str and summary)\n")
cat("  - Visualizations (mpg vs wt scatter plot)\n")
cat("  - Linear Model (mpg ~ wt + hp)\n")
cat("  Would you like me to render it?'\n\n")

cat('YOU: "Yes, render it and show me any warnings"\n\n')

cat("CLAUDE: [executes quarto::quarto_render()]\n\n")

cat("  'Rendered successfully! The HTML is at my_analysis.html.\n")
cat("  I notice the plot could use better axis labels. Should I improve it?'\n\n")

cat('YOU: "Yes, make the labels more descriptive"\n\n')

cat("CLAUDE: [uses btw_tool_editor_write(action='replace_lines')]\n\n")

cat("  'Updated plot labels. Re-rendering...'\n")
cat("  [executes quarto::quarto_render() again]\n\n")

cat("CLAUDE: 'Perfect! The document now has:\n")
cat("  - Clear axis labels\n")
cat("  - Publication-quality plot\n")
cat("  - Statistical results table\n")
cat("  Ready to share!'\n\n")

# ============================================================================
# KEY COLLABORATION PATTERNS
# ============================================================================

cat("\n")
cat("============================================================================\n")
cat("KEY COLLABORATION PATTERNS FOR QUARTO CREATION\n")
cat("============================================================================\n\n")

cat("1. START BROAD → REFINE\n")
cat("   'Create a basic structure' → 'Add more detail' → 'Polish formatting'\n\n")

cat("2. BUILD INCREMENTALLY\n")
cat("   Add one section at a time, test rendering after each\n\n")

cat("3. ITERATE ON ERRORS\n")
cat("   Render → See error → Claude fixes → Re-render\n\n")

cat("4. USE CHUNK OPTIONS\n")
cat("   'Add code-fold to all chunks' → Claude updates YAML and chunks\n\n")

cat("5. LEVERAGE COMPLETE VISIBILITY\n")
cat("   You AND Claude see rendering output → Both spot issues\n\n")

# ============================================================================
# REAL EXAMPLE: CREATE A SIMPLE QMD NOW
# ============================================================================

cat("\n")
cat("============================================================================\n")
cat("WANT TO TRY IT NOW?\n")
cat("============================================================================\n\n")

cat("Copy this prompt to Claude:\n\n")
cat('---\n')
cat('"Create a simple Quarto document called test_report.qmd that:\n')
cat("1. Loads the iris dataset\n")
cat("2. Creates a summary table using knitr::kable\n")
cat("3. Makes a scatter plot of Sepal.Length vs Sepal.Width colored by Species\n")
cat('4. Has a clean HTML output with code folding"\n')
cat('---\n\n')

cat("Then ask Claude to render it:\n")
cat('"Render test_report.qmd and show me the output path"\n\n')

cat("You'll see the full process in your RStudio console!\n\n")

# ============================================================================
# ADVANCED: PARAMETERIZED REPORTS
# ============================================================================

cat("\n")
cat("============================================================================\n")
cat("ADVANCED: PARAMETERIZED QUARTO DOCUMENTS\n")
cat("============================================================================\n\n")

cat("Ask Claude to create a parameterized report:\n\n")
cat('"Create a Quarto document with parameters for:\n')
cat("  - dataset_name (default: mtcars)\n")
cat("  - response_var (default: mpg)\n")
cat("  - predictor_var (default: wt)\n")
cat('Then render it with different parameters"\n\n')

cat("YAML example:\n")
cat("---\n")
cat("title: 'Analysis Report'\n")
cat("params:\n")
cat("  dataset: 'mtcars'\n")
cat("  response: 'mpg'\n")
cat("  predictor: 'wt'\n")
cat("---\n\n")

cat("Render with custom params:\n")
cat('quarto::quarto_render("report.qmd", \n')
cat('  execute_params = list(dataset = "iris", \n')
cat('                        response = "Sepal.Length",\n')
cat('                        predictor = "Petal.Length"))\n\n')

# ============================================================================
# SUMMARY
# ============================================================================

cat("\n")
cat("============================================================================\n")
cat("SUMMARY: WHY QUARTO + BTW R MCP v3 IS POWERFUL\n")
cat("============================================================================\n\n")

cat("✓ COLLABORATIVE CREATION: Claude helps build the document structure\n")
cat("✓ IMMEDIATE FEEDBACK: Render and see results instantly\n")
cat("✓ BIDIRECTIONAL VISIBILITY: Both see output, both catch errors\n")
cat("✓ ITERATIVE REFINEMENT: Add sections incrementally\n")
cat("✓ REPRODUCIBLE: The .qmd IS the analysis documentation\n")
cat("✓ SHARABLE: HTML/PDF output for colleagues\n\n")

cat("Quarto documents created with Claude are:\n")
cat("  - Well-structured (Claude knows Quarto best practices)\n")
cat("  - Fully reproducible (all code included)\n")
cat("  - Publication-ready (professional formatting)\n")
cat("  - Iteratively refined (test as you build)\n\n")

cat("Start with: 'Create a Quarto document for [your analysis goal]'\n")
cat("Claude handles the structure, you provide the domain knowledge!\n\n")

cat("✓ See quarto_document.qmd for a complete working example!\n")
