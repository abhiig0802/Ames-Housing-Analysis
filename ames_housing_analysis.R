# ============================================================
# MAT022 Final Project: Statistical Analysis of Ames Housing
# ============================================================

# ---- 0. Setup and Package Installation ----------------------

required_packages <- c("modeldata", "moments", "MASS", "car", "tidyverse", "fitdistrplus")
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if (length(new_packages)) install.packages(new_packages, quiet = TRUE)

suppressPackageStartupMessages({
  library(modeldata)
  library(moments)
  library(MASS)
  library(car)
  library(tidyverse)
  library(fitdistrplus)
})

# Load Ames dataset
data(ames)
cat("Dataset loaded.\n")
cat("Observations:", nrow(ames), "\nVariables:", ncol(ames), "\n")


# ---- 1. Initial Exploration and Missingness -----------------

cat("\n--- First few rows ---\n")
print(head(ames, n = 6))

cat("\n--- Structure ---\n")
str(ames)

cat("\n--- Missing values (actual NA) ---\n")
na_counts <- colSums(is.na(ames))
na_nonzero <- na_counts[na_counts > 0]
if (length(na_nonzero) > 0) {
  print(na_nonzero)
} else {
  cat("No actual NA values found.\n")
  cat("Missing cases encoded as factor levels (e.g. 'No Alley Access', 'None', etc.)\n")
}

cat("\nExplicit 'no feature' level counts:\n")
cat("Alley = 'No_Alley_Access':", sum(ames$Alley == "No_Alley_Access", na.rm = TRUE), "\n")
cat("Mas_Vnr_Type = 'None':", sum(ames$Mas_Vnr_Type == "None", na.rm = TRUE), "\n")
cat("Garage_Type = 'No_Garage':", sum(ames$Garage_Type == "No_Garage", na.rm = TRUE), "\n")
cat("Fence = 'No_Fence':", sum(ames$Fence == "No_Fence", na.rm = TRUE), "\n")


# ---- 2. Descriptive and Exploratory Analysis ----------------

key_vars <- c("Sale_Price", "Lot_Area", "Gr_Liv_Area", "Year_Built")
summary(ames[key_vars])

table(ames$Overall_Cond, useNA = "ifany")

cat("\nSale_Price: mean =", mean(ames$Sale_Price, na.rm = TRUE),
    " sd =", sd(ames$Sale_Price, na.rm = TRUE), "\n")
cat("Gr_Liv_Area: mean =", mean(ames$Gr_Liv_Area, na.rm = TRUE),
    " sd =", sd(ames$Gr_Liv_Area, na.rm = TRUE), "\n")

cat("Sale_Price skewness:", skewness(ames$Sale_Price, na.rm = TRUE), "\n")
cat("Sale_Price kurtosis:", kurtosis(ames$Sale_Price, na.rm = TRUE), "\n")
cat("Gr_Liv_Area skewness:", skewness(ames$Gr_Liv_Area, na.rm = TRUE), "\n")
cat("Gr_Liv_Area kurtosis:", kurtosis(ames$Gr_Liv_Area, na.rm = TRUE), "\n")

# Histograms
par(mfrow = c(2, 2))
hist(ames$Sale_Price, main = "Histogram of Sale_Price",
     xlab = "Sale_Price", col = "lightblue", breaks = 40)
hist(ames$Gr_Liv_Area, main = "Histogram of Gr_Liv_Area",
     xlab = "Gr_Liv_Area", col = "orange", breaks = 40)
hist(log(ames$Sale_Price), main = "Histogram of log(Sale_Price)",
     xlab = "log(Sale_Price)", col = "lightgreen", breaks = 40)
qqnorm(log(ames$Sale_Price), main = "Normal QQ Plot: log(Sale_Price)")
qqline(log(ames$Sale_Price), col = "red")
par(mfrow = c(1, 1))

# Shapiro-Wilk normality tests
shapiro.test(sample(ames$Sale_Price, 5000))        # raw (sample due to n limit)
shapiro.test(sample(log(ames$Sale_Price), 5000))   # log-transformed
shapiro.test(sample(ames$Gr_Liv_Area, 5000))
shapiro.test(sample(log(ames$Gr_Liv_Area), 5000))

# Correlations
cat("\nCorrelation Sale_Price ~ Gr_Liv_Area:",
    cor(ames$Sale_Price, ames$Gr_Liv_Area, use = "complete.obs"), "\n")
cat("Correlation Sale_Price ~ Year_Built:",
    cor(ames$Sale_Price, ames$Year_Built, use = "complete.obs"), "\n")

# Scatterplots
par(mfrow = c(1, 3))
plot(ames$Gr_Liv_Area, ames$Sale_Price,
     main = "Sale_Price vs Gr_Liv_Area",
     xlab = "Gr_Liv_Area", ylab = "Sale_Price", pch = 16, col = "grey")
abline(lm(Sale_Price ~ Gr_Liv_Area, data = ames), col = "red", lwd = 2)

plot(ames$Year_Built, ames$Sale_Price,
     main = "Sale_Price vs Year_Built",
     xlab = "Year_Built", ylab = "Sale_Price", pch = 16, col = "grey")
abline(lm(Sale_Price ~ Year_Built, data = ames), col = "blue", lwd = 2)

plot(ames$Total_Bsmt_SF, ames$Sale_Price,
     main = "Sale_Price vs Total_Bsmt_SF",
     xlab = "Total_Bsmt_SF", ylab = "Sale_Price", pch = 16, col = "grey")
abline(lm(Sale_Price ~ Total_Bsmt_SF, data = ames), col = "purple", lwd = 2)
par(mfrow = c(1, 1))


# ---- 3. Distributional Fitting (Section 3) ------------------

# Fit Normal, Lognormal, Gamma to Sale_Price (rescaled)
sp_scaled <- ames$Sale_Price / 1000

fit_norm_sp  <- fitdist(sp_scaled, "norm")
fit_lnorm_sp <- fitdist(sp_scaled, "lnorm")
fit_gamma_sp <- fitdist(sp_scaled, "gamma")

cat("\n--- Sale_Price Distribution Fit ---\n")
gofstat(list(fit_norm_sp, fit_lnorm_sp, fit_gamma_sp),
        fitnames = c("Normal", "Lognormal", "Gamma"))

plot(fit_lnorm_sp)   # best fit diagnostics

# Fit to Gr_Liv_Area (rescaled)
gla_scaled <- ames$Gr_Liv_Area / 1000

fit_norm_gla  <- fitdist(gla_scaled, "norm")
fit_lnorm_gla <- fitdist(gla_scaled, "lnorm")
fit_gamma_gla <- fitdist(gla_scaled, "gamma")

cat("\n--- Gr_Liv_Area Distribution Fit ---\n")
gofstat(list(fit_norm_gla, fit_lnorm_gla, fit_gamma_gla),
        fitnames = c("Normal", "Lognormal", "Gamma"))

plot(fit_lnorm_gla)


# ---- 4. Hypothesis Testing (Section 4) ----------------------

# 4.1 Two-sample Welch t-test: Central Air vs log(Sale_Price)
dat_ca <- subset(ames, !is.na(Sale_Price) & !is.na(Central_Air))
dat_ca$logSalePrice <- log(dat_ca$Sale_Price)

cat("\nGroup counts by Central_Air:\n")
print(table(dat_ca$Central_Air))
cat("Group means (log scale):\n")
print(tapply(dat_ca$logSalePrice, dat_ca$Central_Air, mean, na.rm = TRUE))

t_ca <- t.test(logSalePrice ~ Central_Air, data = dat_ca)
print(t_ca)

diff_means_log <- diff(tapply(dat_ca$logSalePrice, dat_ca$Central_Air, mean, na.rm = TRUE))
mult_effect <- exp(diff_means_log)
cat("Multiplicative effect:", round(mult_effect, 2),
    "i.e.", round((mult_effect - 1) * 100, 0), "% higher on average.\n")

# 4.2 One-way ANOVA: Neighbourhood vs log(Sale_Price)
tab_nb <- sort(table(ames$Neighborhood), decreasing = TRUE)
top_nb <- names(tab_nb)[1:6]
dat_nb <- subset(ames, Neighborhood %in% top_nb & !is.na(Sale_Price))
dat_nb$logSalePrice <- log(dat_nb$Sale_Price)
dat_nb$Neighborhood <- droplevels(dat_nb$Neighborhood)

fit_aov <- aov(logSalePrice ~ Neighborhood, data = dat_nb)
cat("\n--- One-way ANOVA: Neighbourhood ---\n")
print(summary(fit_aov))

par(mfrow = c(2, 2))
plot(fit_aov)
par(mfrow = c(1, 1))

# Boxplot
boxplot(Sale_Price ~ Neighborhood, data = dat_nb,
        main = "Sale Price by Top 6 Neighbourhoods",
        xlab = "Neighbourhood", ylab = "Sale Price",
        las = 2, col = "lightblue")

# 4.3 Chi-squared: Central Air vs Garage Type
tab_cagar <- table(ames$Central_Air, ames$Garage_Type, useNA = "no")
print(tab_cagar)
print(chisq.test(tab_cagar))

# Collapse rare Garage_Type levels
gar_freq <- sort(colSums(tab_cagar), decreasing = TRUE)
common_gar <- names(gar_freq[gar_freq > 100])
dat_cagar2 <- subset(ames, !is.na(Central_Air) & !is.na(Garage_Type))
dat_cagar2$GarageTypeCollapsed <- ifelse(
  dat_cagar2$Garage_Type %in% common_gar,
  as.character(dat_cagar2$Garage_Type), "Other"
)
dat_cagar2$GarageTypeCollapsed <- factor(dat_cagar2$GarageTypeCollapsed)
tab_cagar2 <- table(dat_cagar2$Central_Air, dat_cagar2$GarageTypeCollapsed)
print(chisq.test(tab_cagar2, simulate.p.value = TRUE, B = 10000))

# 4.4 Kruskal-Wallis: Overall Condition vs Sale Price
kw_test <- kruskal.test(Sale_Price ~ Overall_Cond, data = ames)
cat("\n--- Kruskal-Wallis: Overall Condition ---\n")
print(kw_test)


# ---- 5. Regression Analysis (Section 5) ---------------------

# Data preparation
dat_reg <- subset(ames,
                  !is.na(Sale_Price) & !is.na(Gr_Liv_Area) &
                  !is.na(Overall_Cond) & !is.na(Year_Built) &
                  !is.na(Central_Air))

dat_reg$LogSalePrice <- log(dat_reg$Sale_Price)
dat_reg$Central_Air  <- factor(dat_reg$Central_Air)
dat_reg$Overall_Cond <- factor(dat_reg$Overall_Cond)

if ("Average" %in% levels(dat_reg$Overall_Cond)) {
  dat_reg$Overall_Cond <- relevel(dat_reg$Overall_Cond, ref = "Average")
}

set.seed(123)
n <- nrow(dat_reg)
train_idx  <- sample(seq_len(n), size = round(0.8 * n))
train_dat  <- dat_reg[train_idx, ]
test_dat   <- dat_reg[-train_idx, ]
cat("Training set:", nrow(train_dat), "| Test set:", nrow(test_dat), "\n")


# 5.1 Baseline log-linear model
lm_base <- lm(LogSalePrice ~ Gr_Liv_Area + Year_Built + Overall_Cond + Central_Air,
              data = train_dat)

cat("\n--- Baseline Model Summary ---\n")
print(summary(lm_base))

cat("\nVariance Inflation Factors:\n")
print(round(vif(lm_base), 2))

cat("\nBreusch-Pagan test:\n")
print(ncvTest(lm_base))

cat("\nShapiro-Wilk test on residuals:\n")
print(shapiro.test(residuals(lm_base)))

par(mfrow = c(2, 2))
plot(lm_base)
par(mfrow = c(1, 1))

# Baseline test-set performance
pred_log_base  <- predict(lm_base, newdata = test_dat)
pred_price_base <- exp(pred_log_base)

rmse_base <- sqrt(mean((test_dat$Sale_Price - pred_price_base)^2, na.rm = TRUE))
mae_base  <- mean(abs(test_dat$Sale_Price - pred_price_base), na.rm = TRUE)
ss_res    <- sum((test_dat$Sale_Price - pred_price_base)^2, na.rm = TRUE)
ss_tot    <- sum((test_dat$Sale_Price - mean(test_dat$Sale_Price))^2, na.rm = TRUE)
r2_base   <- 1 - ss_res / ss_tot
rmse_log_base <- sqrt(mean((test_dat$LogSalePrice - pred_log_base)^2, na.rm = TRUE))

cat("\n--- Baseline Test-Set Performance ---\n")
cat("RMSE ($):", round(rmse_base, 2), "\n")
cat("MAE  ($):", round(mae_base, 2), "\n")
cat("R^2 (test):", round(r2_base, 4), "\n")
cat("RMSE (log scale):", round(rmse_log_base, 3), "\n")

plot(test_dat$Sale_Price, pred_price_base,
     xlab = "Actual Sale_Price", ylab = "Predicted Sale_Price",
     main = "Predicted vs Actual (Test Set) – Base Model",
     pch = 16, col = "grey")
abline(0, 1, col = "red", lwd = 2)


# 5.2 Quadratic Living Area Model
lm_quad <- lm(LogSalePrice ~ Gr_Liv_Area + I(Gr_Liv_Area^2) +
                Year_Built + Overall_Cond + Central_Air,
              data = train_dat)

cat("\n--- Quadratic Model Summary ---\n")
print(summary(lm_quad))

cat("\nBreusch-Pagan test:\n")
print(ncvTest(lm_quad))

cat("\nVIF:\n")
print(round(vif(lm_quad), 2))

pred_log_quad   <- predict(lm_quad, newdata = test_dat)
pred_price_quad <- exp(pred_log_quad)
rmse_quad <- sqrt(mean((test_dat$Sale_Price - pred_price_quad)^2, na.rm = TRUE))
mae_quad  <- mean(abs(test_dat$Sale_Price - pred_price_quad), na.rm = TRUE)
cat("\nQuadratic Test RMSE ($):", round(rmse_quad, 2), "\n")
cat("Quadratic Test MAE  ($):", round(mae_quad, 2), "\n")


# 5.3 Interaction Model: Gr_Liv_Area x Overall_Cond
lm_int <- lm(LogSalePrice ~ Gr_Liv_Area * Overall_Cond +
               Year_Built + Central_Air,
             data = train_dat)

cat("\n--- Interaction Model Summary ---\n")
print(summary(lm_int))

pred_log_int   <- predict(lm_int, newdata = test_dat)
pred_price_int <- exp(pred_log_int)
rmse_int <- sqrt(mean((test_dat$Sale_Price - pred_price_int)^2, na.rm = TRUE))
mae_int  <- mean(abs(test_dat$Sale_Price - pred_price_int), na.rm = TRUE)
cat("\nInteraction Test RMSE ($):", round(rmse_int, 2), "\n")
cat("Interaction Test MAE  ($):", round(mae_int, 2), "\n")


# 5.4 Extended Model: + Total Basement SF
dat_ext <- subset(dat_reg, !is.na(Total_Bsmt_SF))
train_ext <- dat_ext[train_idx[train_idx <= nrow(dat_ext)], ]
test_ext  <- dat_ext[-train_idx[train_idx <= nrow(dat_ext)], ]

lm_ext <- lm(LogSalePrice ~ Gr_Liv_Area + Year_Built + Overall_Cond +
               Central_Air + Total_Bsmt_SF,
             data = train_dat)   # uses train_dat (Total_Bsmt_SF present in ames)

cat("\n--- Extended Model Summary ---\n")
print(summary(lm_ext))

cat("\nBreusch-Pagan test:\n")
print(ncvTest(lm_ext))

pred_log_ext   <- predict(lm_ext, newdata = test_dat)
pred_price_ext <- exp(pred_log_ext)
rmse_ext <- sqrt(mean((test_dat$Sale_Price - pred_price_ext)^2, na.rm = TRUE))
mae_ext  <- mean(abs(test_dat$Sale_Price - pred_price_ext), na.rm = TRUE)
cat("\nExtended Test RMSE ($):", round(rmse_ext, 2), "\n")
cat("Extended Test MAE  ($):", round(mae_ext, 2), "\n")


# 5.5 Model Comparison Table
model_comparison <- data.frame(
  Model = c("Baseline (log-linear)", "Quadratic Gr_Liv_Area",
            "Interaction", "Extended + Basement"),
  Test_RMSE = round(c(rmse_base, rmse_quad, rmse_int, rmse_ext), 0),
  Test_MAE  = round(c(mae_base,  mae_quad,  mae_int,  mae_ext),  0),
  Adj_R2    = round(c(
    summary(lm_base)$adj.r.squared,
    summary(lm_quad)$adj.r.squared,
    summary(lm_int)$adj.r.squared,
    summary(lm_ext)$adj.r.squared
  ), 3)
)
cat("\n--- Model Comparison ---\n")
print(model_comparison)

# Bar chart of RMSE
barplot(model_comparison$Test_RMSE,
        names.arg = c("Base", "Quadratic", "Interaction", "Extended"),
        main = "Test RMSE Comparison",
        ylab = "RMSE ($)", col = "lightblue", ylim = c(0, 60000))

cat("\nSelected model: Quadratic Gr_Liv_Area (lowest RMSE, no heteroscedasticity)\n")
