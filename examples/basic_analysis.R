#!/usr/bin/env Rscript

# Basic Data Analysis Workflow
#
# This script demonstrates a complete analysis workflow:
# - Loading data
# - Calculating summary statistics
# - Creating visualizations
# - Interpreting results
#
# Prerequisites: btw_mcp_session() active in RStudio
#
# Try asking Claude:
# "Read and execute examples/basic_analysis.R step by step"

# ============================================================================
# 1. LOAD DATA
# ============================================================================

cat("Loading mtcars dataset...\n")
data <- mtcars
cat("Loaded", nrow(data), "rows and", ncol(data), "columns\n\n")

# ============================================================================
# 2. SUMMARY STATISTICS
# ============================================================================

cat("Summary Statistics:\n")
cat("==================\n\n")

# Overall summary
summary(data)

# Specific statistics
cat("\nKey Statistics:\n")
cat("  Average MPG:", mean(data$mpg), "\n")
cat("  Average Weight:", mean(data$wt), "tons\n")
cat("  Average HP:", mean(data$hp), "\n")
cat("  Correlation (MPG vs Weight):", cor(data$mpg, data$wt), "\n\n")

# ============================================================================
# 3. DATA EXPLORATION
# ============================================================================

cat("Data Exploration:\n")
cat("=================\n\n")

# Fuel efficiency by cylinder count
cat("Average MPG by Cylinder Count:\n")
aggregate(mpg ~ cyl, data = data, FUN = mean)

# Performance by transmission type
cat("\nAverage HP by Transmission (0=auto, 1=manual):\n")
aggregate(hp ~ am, data = data, FUN = mean)

# ============================================================================
# 4. VISUALIZATION
# ============================================================================

cat("\nCreating visualizations...\n")

# Plot 1: MPG vs Weight
plot(data$wt, data$mpg,
     main = "Fuel Efficiency vs Weight",
     xlab = "Weight (1000 lbs)",
     ylab = "Miles per Gallon",
     pch = 19,
     col = "steelblue")

# Add regression line
abline(lm(mpg ~ wt, data = data), col = "red", lwd = 2)

# Plot 2: HP distribution
hist(data$hp,
     main = "Horsepower Distribution",
     xlab = "Horsepower",
     col = "lightgreen",
     breaks = 10)

# Plot 3: Boxplot of MPG by Cylinder
boxplot(mpg ~ cyl, data = data,
        main = "MPG by Number of Cylinders",
        xlab = "Cylinders",
        ylab = "Miles per Gallon",
        col = c("lightblue", "lightgreen", "lightcoral"))

# ============================================================================
# 5. SIMPLE LINEAR MODEL
# ============================================================================

cat("\nFitting linear model: mpg ~ wt + hp\n")
model <- lm(mpg ~ wt + hp, data = data)

cat("\nModel Summary:\n")
summary(model)

cat("\nModel R-squared:", summary(model)$r.squared, "\n")

# ============================================================================
# 6. INTERPRETATION
# ============================================================================

cat("\n\nKEY FINDINGS:\n")
cat("=============\n")
cat("1. Heavier cars have lower fuel efficiency (strong negative correlation)\n")
cat("2. Both weight and horsepower significantly predict MPG\n")
cat("3. The model explains", round(summary(model)$r.squared * 100, 1), "% of variance\n")
cat("4. 4-cylinder cars average", round(mean(data$mpg[data$cyl == 4]), 1), "MPG\n")
cat("5. 8-cylinder cars average", round(mean(data$mpg[data$cyl == 8]), 1), "MPG\n")

cat("\n✓ Analysis complete!\n")
cat("\nNext steps:\n")
cat("  - Modify this script for your own data\n")
cat("  - Ask Claude to add more visualizations\n")
cat("  - Try different models (polynomial, interactions)\n")
cat("  - Save plots with btw_tool_save_plot\n")
