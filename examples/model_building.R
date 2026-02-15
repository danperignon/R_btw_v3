#!/usr/bin/env Rscript

# Statistical Model Building Workflow
#
# This script demonstrates a complete modeling workflow:
# - Exploratory data analysis
# - Model selection
# - Fitting and diagnostics
# - Model comparison
#
# Prerequisites: btw_mcp_session() active in RStudio
#
# Try asking Claude:
# "Run examples/model_building.R and interpret the results"
# "Improve the model by adding interaction terms"

cat("Statistical Modeling Workflow\n")
cat("==============================\n\n")

# ============================================================================
# 1. LOAD AND EXPLORE DATA
# ============================================================================

cat("Step 1: Data Exploration\n")
cat("-------------------------\n")

data <- mtcars

cat("Dataset dimensions:", nrow(data), "rows x", ncol(data), "columns\n\n")

cat("Response variable (mpg) distribution:\n")
summary(data$mpg)

cat("\nPotential predictors:\n")
cat("  - wt (weight)\n")
cat("  - hp (horsepower)\n")
cat("  - cyl (cylinders)\n")
cat("  - disp (displacement)\n\n")

# Check for missing values
cat("Missing values:", sum(is.na(data)), "\n\n")

# Pairwise correlations with mpg
predictors <- c("wt", "hp", "cyl", "disp")
correlations <- sapply(predictors, function(var) cor(data$mpg, data[[var]]))

cat("Correlations with MPG:\n")
print(round(correlations, 3))
cat("\n")

# ============================================================================
# 2. VISUALIZE RELATIONSHIPS
# ============================================================================

cat("Step 2: Visualize Key Relationships\n")
cat("------------------------------------\n")

# Set up 2x2 plotting layout
par(mfrow = c(2, 2))

# Plot each predictor vs mpg
for (var in predictors) {
  plot(data[[var]], data$mpg,
       xlab = var,
       ylab = "MPG",
       main = paste("MPG vs", var),
       pch = 19,
       col = "steelblue")
  abline(lm(data$mpg ~ data[[var]]), col = "red", lwd = 2)
}

# Reset plotting layout
par(mfrow = c(1, 1))

cat("Plots created\n\n")

# ============================================================================
# 3. FIT CANDIDATE MODELS
# ============================================================================

cat("Step 3: Fit Candidate Models\n")
cat("-----------------------------\n\n")

# Model 1: Simple linear model (weight only)
model1 <- lm(mpg ~ wt, data = data)
cat("Model 1: mpg ~ wt\n")
cat("  R-squared:", round(summary(model1)$r.squared, 3), "\n")
cat("  AIC:", round(AIC(model1), 1), "\n\n")

# Model 2: Add horsepower
model2 <- lm(mpg ~ wt + hp, data = data)
cat("Model 2: mpg ~ wt + hp\n")
cat("  R-squared:", round(summary(model2)$r.squared, 3), "\n")
cat("  AIC:", round(AIC(model2), 1), "\n\n")

# Model 3: Add cylinders
model3 <- lm(mpg ~ wt + hp + cyl, data = data)
cat("Model 3: mpg ~ wt + hp + cyl\n")
cat("  R-squared:", round(summary(model3)$r.squared, 3), "\n")
cat("  AIC:", round(AIC(model3), 1), "\n\n")

# Model 4: Add displacement
model4 <- lm(mpg ~ wt + hp + cyl + disp, data = data)
cat("Model 4: mpg ~ wt + hp + cyl + disp\n")
cat("  R-squared:", round(summary(model4)$r.squared, 3), "\n")
cat("  AIC:", round(AIC(model4), 1), "\n\n")

# ============================================================================
# 4. MODEL COMPARISON
# ============================================================================

cat("Step 4: Model Comparison\n")
cat("------------------------\n\n")

# Compare models using ANOVA
cat("ANOVA comparison:\n")
anova(model1, model2, model3, model4)

cat("\n")

# Extract comparison metrics
comparison <- data.frame(
  Model = c("Model 1", "Model 2", "Model 3", "Model 4"),
  Formula = c("mpg ~ wt",
              "mpg ~ wt + hp",
              "mpg ~ wt + hp + cyl",
              "mpg ~ wt + hp + cyl + disp"),
  R_squared = c(summary(model1)$r.squared,
                 summary(model2)$r.squared,
                 summary(model3)$r.squared,
                 summary(model4)$r.squared),
  Adj_R_squared = c(summary(model1)$adj.r.squared,
                     summary(model2)$adj.r.squared,
                     summary(model3)$adj.r.squared,
                     summary(model4)$adj.r.squared),
  AIC = c(AIC(model1), AIC(model2), AIC(model3), AIC(model4))
)

cat("Model Comparison Table:\n")
print(comparison)
cat("\n")

# Select best model (lowest AIC)
best_model_idx <- which.min(comparison$AIC)
best_model <- list(model1, model2, model3, model4)[[best_model_idx]]

cat("Best model (by AIC):", comparison$Model[best_model_idx], "\n")
cat("Formula:", as.character(comparison$Formula[best_model_idx]), "\n\n")

# ============================================================================
# 5. DIAGNOSTIC PLOTS
# ============================================================================

cat("Step 5: Model Diagnostics\n")
cat("-------------------------\n\n")

# Standard diagnostic plots
par(mfrow = c(2, 2))
plot(best_model, main = "Diagnostic Plots for Best Model")
par(mfrow = c(1, 1))

cat("Diagnostic plots created\n\n")

# Check assumptions
cat("Assumption Checks:\n")

# Normality of residuals (Shapiro-Wilk test)
shapiro_test <- shapiro.test(residuals(best_model))
cat("  Normality (Shapiro-Wilk p-value):", round(shapiro_test$p.value, 3))
if (shapiro_test$p.value > 0.05) {
  cat(" ✓ Residuals appear normal\n")
} else {
  cat(" ✗ Residuals may not be normal\n")
}

# Constant variance (Breusch-Pagan test alternative: visual check)
# For simplicity, just note it
cat("  Constant variance: Check residuals vs fitted plot\n")
cat("  Independence: Check for patterns in residuals\n\n")

# ============================================================================
# 6. FINAL MODEL SUMMARY
# ============================================================================

cat("Step 6: Final Model Summary\n")
cat("---------------------------\n\n")

cat("Selected Model:\n")
summary(best_model)

cat("\n")

# Model interpretation
coefs <- coef(best_model)
cat("Model Interpretation:\n")
cat("  - Intercept:", round(coefs[1], 2), "mpg (baseline)\n")

if ("wt" %in% names(coefs)) {
  cat("  - Weight:", round(coefs["wt"], 2), "mpg per 1000 lbs (negative = heavier cars less efficient)\n")
}

if ("hp" %in% names(coefs)) {
  cat("  - Horsepower:", round(coefs["hp"], 2), "mpg per HP (negative = powerful cars less efficient)\n")
}

if ("cyl" %in% names(coefs)) {
  cat("  - Cylinders:", round(coefs["cyl"], 2), "mpg per cylinder\n")
}

cat("\n")

# ============================================================================
# 7. PREDICTIONS
# ============================================================================

cat("Step 7: Making Predictions\n")
cat("--------------------------\n\n")

# Example predictions for new data
new_data <- data.frame(
  wt = c(2.5, 3.0, 3.5),
  hp = c(100, 150, 200),
  cyl = c(4, 6, 8),
  disp = c(120, 180, 300)
)

predictions <- predict(best_model, newdata = new_data, interval = "prediction")

cat("Example Predictions:\n")
cat("Car 1 (light, low power, 4 cyl):", round(predictions[1, "fit"], 1), "mpg\n")
cat("Car 2 (medium, med power, 6 cyl):", round(predictions[2, "fit"], 1), "mpg\n")
cat("Car 3 (heavy, high power, 8 cyl):", round(predictions[3, "fit"], 1), "mpg\n\n")

cat("95% Prediction Intervals:\n")
print(round(predictions, 1))

cat("\n✓ Modeling workflow complete!\n\n")

cat("Next steps:\n")
cat("  - Try adding interaction terms: mpg ~ wt * hp\n")
cat("  - Test polynomial terms: mpg ~ poly(wt, 2)\n")
cat("  - Cross-validate the model\n")
cat("  - Try other model types (GLM, GAM, random forest)\n")
