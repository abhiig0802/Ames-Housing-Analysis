# Ames Housing Dataset – Statistical Analysis

A statistical analysis of residential property sales in Ames, Iowa, conducted as a project for MAT022.

## Project Summary

This project applies core statistical methods to the Ames Housing dataset, including:

- **Distribution Fitting** – Normal, Lognormal, and Gamma distributions fitted to Sale Price and Living Area via Maximum Likelihood Estimation (MLE)

- **Hypothesis Testing** – two-sample t-tests, one-way ANOVA, Chi-squared tests, and Kruskal-Wallis tests used to identify significant predictors of sale price

- **Regression Analysis** – multiple linear regression models compared on test data, with a quadratic living-area specification selected as the final model

## Dataset

The [Ames Housing Dataset](https://www.tandfonline.com/doi/abs/10.1080/10691898.2011.11889627) includes 2,930 residential sales in Ames, Iowa (2006–2010), across 74 variables.

Loaded in R using the `modeldata` package:

```r

library(modeldata)

data(ames)

```

## Key Variables

| Variable | Description |

|---|---|

| `Sale_Price` | Final sale price in USD (response variable) |

| `Gr_Liv_Area` | Above-ground living area, square feet |

| `Year_Built` | Year of original construction |

| `Overall_Cond` | Condition rating (Very Poor to Excellent) |

| `Central_Air` | Central air conditioning indicator (Y/N) |

| `Total_Bsmt_SF` | Total basement area, square feet |

## Main Findings

- `Sale_Price` and `Gr_Liv_Area` both follow **Lognormal distributions**, supporting log-transformation for regression modelling

- Properties with **central air conditioning** show an estimated **14.6% price premium**

- **Neighbourhood** is a statistically significant predictor of sale price (ANOVA: F(5, 1485) = 387, p < 2×10⁻¹⁶)

- Living area shows **diminishing marginal returns**, indicated by a significant negative quadratic coefficient

- The **quadratic living-area model** achieved the best fit (Test RMSE: $42,639, Adjusted R² = 0.771)

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
├── ames_housing_analysis.R  # Full R analysis script 
├── README.md                # This file 
└── report/ 
└── MAT022_Final_project.pdf

```

## How to Run

1. Install R: [r-project.org](https://www.r-project.org/)

2. Clone the repository:

```bash

   git clone https://github.com/abhiig0802/Ames-Housing-Analysis.git

```

3. Open `ames_housing_analysis.R` in RStudio or VS Code.

4. Run the script — required packages install automatically.

## Dependencies

All packages are installed automatically by the script:

- `modeldata` – dataset access

- `moments` – skewness and kurtosis calculations

- `fitdistrplus` – distribution fitting

- `MASS` – statistical methods

- `car` – regression diagnostics (VIF)

- `tidyverse` – data manipulation and visualization

## Authors

Abhishek Javranayaka Chaluvarayee, Abhiram Gadikota, Md Reaz Uddin, Nischitha Ravi, Winona Fernandes.

*Cardiff University – MAT022 Final Project, January 2026*
