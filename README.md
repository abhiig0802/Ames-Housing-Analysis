# Statistical Analysis of the Ames Housing Dataset

A comprehensive statistical analysis of residential property sales in Ames, Iowa, completed as a final project for MAT022.

## Project Overview

This project applies a full statistical workflow to the Ames Housing dataset, covering:

- **Distributional Analysis** - fitting Normal, Lognormal, and Gamma distributions to Sale Price and Living Area using Maximum Likelihood Estimation (MLE)
- **Hypothesis Testing** - two-sample t-tests, one-way ANOVA, Chi-squared tests, and Kruskal-Wallis tests to identify significant predictors of sale price
- **Regression Modelling** - multiple linear regression models evaluated on held-out test data, including a quadratic living area specification selected as the final model

## Dataset

The [Ames Housing Dataset](https://www.tandfonline.com/doi/abs/10.1080/10691898.2011.11889627) contains 2,930 residential property sales in Ames, Iowa (2006–2010) with 74 variables describing property characteristics and sale conditions.

Loaded in R via the `modeldata` package:

```r
library(modeldata)
data(ames)
```

## Key Variables

| Variable | Description |
|---|---|
| `Sale_Price` | Final sale price in USD (response variable) |
| `Gr_Liv_Area` | Above-ground living area in square feet |
| `Year_Built` | Year the property was originally constructed |
| `Overall_Cond` | Ordinal condition rating (Very Poor → Excellent) |
| `Central_Air` | Binary indicator of central air conditioning (Y/N) |
| `Total_Bsmt_SF` | Total basement area in square feet |

## Main Findings

- Both `Sale_Price` and `Gr_Liv_Area` follow **Lognormal distributions**, justifying log transformation for regression modelling
- Houses with **central air conditioning** sell for approximately **14.6% more** than those without
- **Neighbourhood** has a highly significant effect on sale price (ANOVA: F(5, 1485) = 387, p < 2×10⁻¹⁶)
- Living area shows **diminishing marginal returns** — confirmed by a significant negative quadratic coefficient
- The **quadratic living area model** was selected as the best model (Test RMSE: $42,639, Adjusted R² = 0.771)

## Model Comparison

| Model | Test RMSE ($) | Test MAE ($) | Adj. R² |
|---|---|---|---|
| Baseline (log-linear) | 51,124 | 29,627 | 0.754 |
| **Quadratic Gr_Liv_Area** | **42,639** | **28,909** | **0.771** |
| Interaction | 51,176 | 29,679 | 0.755 |
| Extended + Basement | 50,852 | 24,274 | 0.792 |

## Repository Structure

```
ames-housing-analysis/
├── ames_housing_analysis.R   # Full R analysis script
├── README.md                 # This file
└── report/
    └── MAT022_Final_project.pdf
```

## How to Run

1. Make sure R is installed - download from [r-project.org](https://www.r-project.org/)
2. Clone this repository:
   ```bash
   git clone https://github.com/YOUR-USERNAME/ames-housing-analysis.git
   ```
3. Open `ames_housing_analysis.R` in RStudio or VS Code
4. Run the script - packages will install automatically on first run

## Dependencies

All packages are installed automatically by the script:

- `modeldata` - dataset
- `moments` - skewness and kurtosis
- `fitdistrplus` - distribution fitting
- `MASS` - statistical methods
- `car` - VIF and regression diagnostics
- `tidyverse` - data manipulation and plotting

## Authors

Abhiram Gadikota, Abhishek Javranayaka Chaluvarayee, Md Reaz Uddin, Nischitha Ravi, Winona Fernandes

*Cardiff University - MAT022 Final Project, January 2026*
