#!/usr/bin/env Rscript

# Publication-Quality Plotting with ggplot2
#
# This script demonstrates creating professional visualizations
# that are ready for publications, presentations, or reports.
#
# Prerequisites:
# - btw_mcp_session() active in RStudio
# - ggplot2 installed
#
# Try asking Claude:
# "Run examples/plotting.R and save all figures to ./figures/"

# Load required library
if (!require("ggplot2", quietly = TRUE)) {
  cat("Installing ggplot2...\n")
  install.packages("ggplot2")
  library(ggplot2)
}

cat("Creating publication-quality plots...\n\n")

# Load data
data <- mtcars
data$cyl <- factor(data$cyl)  # Convert cylinders to factor
data$am <- factor(data$am, labels = c("Automatic", "Manual"))

# ============================================================================
# PLOT 1: Scatter Plot with Regression Lines
# ============================================================================

cat("Plot 1: MPG vs Weight by Cylinder Count\n")

p1 <- ggplot(data, aes(x = wt, y = mpg, color = cyl)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, alpha = 0.2) +
  scale_color_manual(values = c("4" = "#E69F00",
                                  "6" = "#56B4E9",
                                  "8" = "#D55E00")) +
  labs(
    title = "Fuel Efficiency vs Vehicle Weight",
    subtitle = "Grouped by number of cylinders",
    x = "Weight (1000 lbs)",
    y = "Miles per Gallon",
    color = "Cylinders"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(color = "gray40"),
    legend.position = "top"
  )

print(p1)

# ============================================================================
# PLOT 2: Bar Plot with Error Bars
# ============================================================================

cat("\nPlot 2: Average MPG by Transmission Type\n")

# Calculate means and standard errors
summary_data <- aggregate(mpg ~ am, data = data,
                         FUN = function(x) c(mean = mean(x),
                                            se = sd(x)/sqrt(length(x))))
summary_df <- data.frame(
  am = summary_data$am,
  mean_mpg = summary_data$mpg[, "mean"],
  se = summary_data$mpg[, "se"]
)

p2 <- ggplot(summary_df, aes(x = am, y = mean_mpg, fill = am)) +
  geom_col(width = 0.6) +
  geom_errorbar(aes(ymin = mean_mpg - se, ymax = mean_mpg + se),
                width = 0.2, size = 0.8) +
  scale_fill_manual(values = c("Automatic" = "#E69F00",
                                "Manual" = "#56B4E9")) +
  labs(
    title = "Fuel Efficiency by Transmission Type",
    x = "Transmission",
    y = "Average Miles per Gallon"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    legend.position = "none"
  ) +
  coord_cartesian(ylim = c(0, max(summary_df$mean_mpg + summary_df$se) * 1.1))

print(p2)

# ============================================================================
# PLOT 3: Faceted Plots
# ============================================================================

cat("\nPlot 3: HP vs Weight, Faceted by Cylinder\n")

p3 <- ggplot(data, aes(x = wt, y = hp)) +
  geom_point(aes(color = am), size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", color = "black", se = FALSE, linetype = "dashed") +
  facet_wrap(~ cyl, ncol = 3) +
  scale_color_manual(values = c("Automatic" = "#E69F00",
                                 "Manual" = "#56B4E9")) +
  labs(
    title = "Horsepower vs Weight Across Cylinder Counts",
    x = "Weight (1000 lbs)",
    y = "Horsepower",
    color = "Transmission"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    strip.background = element_rect(fill = "gray90"),
    strip.text = element_text(face = "bold")
  )

print(p3)

# ============================================================================
# PLOT 4: Distribution Plots
# ============================================================================

cat("\nPlot 4: MPG Distribution with Density Curves\n")

p4 <- ggplot(data, aes(x = mpg, fill = cyl)) +
  geom_histogram(aes(y = after_stat(density)),
                 bins = 15, alpha = 0.6, position = "identity") +
  geom_density(alpha = 0.3) +
  scale_fill_manual(values = c("4" = "#E69F00",
                                "6" = "#56B4E9",
                                "8" = "#D55E00")) +
  labs(
    title = "Distribution of Fuel Efficiency",
    subtitle = "Overlaid by cylinder count",
    x = "Miles per Gallon",
    y = "Density",
    fill = "Cylinders"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(color = "gray40")
  )

print(p4)

# ============================================================================
# SAVING PLOTS
# ============================================================================

cat("\n✓ All plots created!\n\n")
cat("To save these plots, ask Claude:\n")
cat("  'Save plot p1 as figures/mpg_vs_weight.png (300 dpi, 10x7 inches)'\n")
cat("  'Save plot p2 as figures/transmission_comparison.pdf'\n")
cat("  'Save all plots as high-resolution PNGs'\n\n")

cat("Or use btw_tool_save_plot manually:\n")
cat("  mcp__btw-r-v3__btw_tool_save_plot(\n")
cat("    filename = 'figure.png',\n")
cat("    path = './figures',\n")
cat("    width = 10, height = 7,\n")
cat("    dpi = 300, format = 'png'\n")
cat("  )\n")
