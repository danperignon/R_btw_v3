#!/usr/bin/env Rscript

# Collaborative Debugging Exercise
#
# This script contains intentional errors for debugging practice.
# Work with Claude to find and fix all the bugs!
#
# Prerequisites: btw_mcp_session() active in RStudio
#
# Try asking Claude:
# "Debug examples/collaborative_debug.R and fix all errors"
# "Explain each error in collaborative_debug.R before fixing"

cat("Running analysis with bugs... (this will fail!)\n\n")

# ============================================================================
# BUG 1: Typo in function name
# ============================================================================

data <- mtcar  # Should be mtcars

# ============================================================================
# BUG 2: Using wrong column name
# ============================================================================

mean_mpg <- mean(data$MPG)  # R is case-sensitive! Should be $mpg

# ============================================================================
# BUG 3: Comparison operator instead of assignment
# ============================================================================

heavy_cars == data[data$wt > 3.5, ]  # Should be <- not ==

# ============================================================================
# BUG 4: Forgot to load required package
# ============================================================================

# ggplot2 isn't loaded!
plot <- ggplot(data, aes(x = wt, y = mpg)) +
  geom_point()

# ============================================================================
# BUG 5: Index out of bounds
# ============================================================================

first_20_cars <- data[1:20, ]  # mtcars only has 32 rows, but this works
fortieth_car <- data[40, ]      # THIS will be a problem!

# ============================================================================
# BUG 6: Logical error in subsetting
# ============================================================================

# Trying to find cars with mpg > 30 AND wt > 4
# (Spoiler: Heavy cars don't get 30+ mpg!)
efficient_heavy <- data[data$mpg > 30 & data$wt > 4, ]

if (nrow(efficient_heavy) == 0) {
  stop("No cars found! Maybe the criteria are impossible?")
}

# ============================================================================
# BUG 7: Missing closing parenthesis
# ============================================================================

model <- lm(mpg ~ wt + hp, data = data
# Forgot to close the parenthesis!

# ============================================================================
# BUG 8: Using = instead of == in logical test
# ============================================================================

automatic_cars <- data[data$am = 0, ]  # Should be == not =

# ============================================================================
# EXPECTED ERRORS (in order):
# ============================================================================

# 1. "object 'mtcar' not found" - typo
# 2. "$ operator is invalid for atomic vectors" - wrong column name
# 3. "object 'heavy_cars' not found" - used comparison instead of assignment
# 4. "could not find function 'ggplot'" - package not loaded
# 5. Might work depending on data... wait for #6
# 6. "subscript out of bounds" OR just get NA row
# 7. Empty result triggers stop()
# 8. "unexpected end of input" - missing parenthesis
# 9. "invalid (do_set) left-hand side" - assignment in logical test

cat("\nIf you see this, you've fixed all bugs! Well done!\n")

# ============================================================================
# FIXED VERSION (spoiler alert!)
# ============================================================================

# Uncomment below to see the corrected code:

# # FIXED VERSION:
# library(ggplot2)
#
# data <- mtcars  # Correct name
#
# mean_mpg <- mean(data$mpg)  # Correct case
# cat("Average MPG:", mean_mpg, "\n")
#
# heavy_cars <- data[data$wt > 3.5, ]  # Correct assignment operator
# cat("Found", nrow(heavy_cars), "heavy cars\n")
#
# # Now ggplot works
# plot <- ggplot(data, aes(x = wt, y = mpg)) +
#   geom_point()
# print(plot)
#
# # Only request rows that exist
# first_10_cars <- data[1:10, ]
# cat("First 10 cars extracted\n")
#
# # Use realistic criteria (OR instead of AND)
# efficient_or_heavy <- data[data$mpg > 30 | data$wt > 4, ]
# cat("Found", nrow(efficient_or_heavy), "cars that are efficient OR heavy\n")
#
# # Proper model syntax
# model <- lm(mpg ~ wt + hp, data = data)
# cat("Model R-squared:", summary(model)$r.squared, "\n")
#
# # Correct logical test
# automatic_cars <- data[data$am == 0, ]
# cat("Found", nrow(automatic_cars), "automatic cars\n")
#
# cat("\n✓ All fixed!\n")
