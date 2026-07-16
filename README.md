# 🏥 SBA-BurkinaFaso-ML-DHS

<div align="center">

![R](https://img.shields.io/badge/R-4.2+-276DC3?style=for-the-badge&logo=r&logoColor=white)
![Stata](https://img.shields.io/badge/Stata-17-1A5276?style=for-the-badge&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-2ECC71?style=for-the-badge&logo=opensourceinitiative&logoColor=white)
![Status](https://img.shields.io/badge/Status-Under_Review-F39C12?style=for-the-badge)
![Sensitivity Analysis](https://img.shields.io/badge/Sensitivity_Analysis-Imbalance_Handling-9B59B6?style=for-the-badge)
![Last Commit](https://img.shields.io/github/last-commit/muhammadsalek/SBA-BurkinaFaso-ML-DHS?style=for-the-badge&color=8E44AD)
![Stars](https://img.shields.io/github/stars/muhammadsalek/SBA-BurkinaFaso-ML-DHS?style=for-the-badge&color=F1C40F)
![Forks](https://img.shields.io/github/forks/muhammadsalek/SBA-BurkinaFaso-ML-DHS?style=for-the-badge&color=1ABC9C)

<br/>

> ### 📄 *"Machine Learning Analysis of Factors Influencing Skilled Birth Attendance in Burkina Faso: Assessing Spatial Inequalities Using Imbalanced Survey Data"*
>
> **Md Salek Miah** · Department of Statistics, Shahjalal University of Science and Technology, Sylhet‑3114, Bangladesh
>
> [![ORCID](https://img.shields.io/badge/ORCID-0009--0005--5973--461X-A6CE39?style=flat-square&logo=orcid&logoColor=white)](https://orcid.org/0009-0005-5973-461X)
> [![Email](https://img.shields.io/badge/Email-saleksta%40gmail.com-D44638?style=flat-square&logo=gmail&logoColor=white)](mailto:saleksta@gmail.com)
> [![DHS Data](https://img.shields.io/badge/Data_Source-DHS_Program_2021-0074D9?style=flat-square)](https://dhsprogram.com)

</div>

---

## 📌 Table of Contents

- [Project Overview](#-project-overview)
- [Study Design & Data Source](#️-study-design--data-source)
- [Repository Structure](#️-repository-structure)
- [Tech Stack](#️-tech-stack)
- [Analytical Workflow](#-analytical-workflow)
- [Key Findings](#-key-findings)
- [Sensitivity Analysis: Imbalance-Handling Strategies](#-sensitivity-analysis-imbalance-handling-strategies)
- [Installation & Requirements](#-installation--requirements)
- [Reproducibility Steps](#-reproducibility-steps)
- [Ethical Statement](#-ethical-statement)
- [Citation](#-citation)
- [License](#-license)

---

## 🌟 Project Overview

This repository contains the full analytical codebase, supplementary materials, and reproducibility artifacts accompanying the manuscript cited above, currently under peer review. The study implements an **interpretable machine learning (ML) framework** applied to a nationally representative household survey to:

- 🎯 **Identify and rank key predictors** of Skilled Birth Attendance (SBA) using five supervised ML algorithms
- 🧠 **Explain model predictions** using SHapley Additive exPlanations (**SHAP**) for global and local interpretability
- 🗺️ **Map province-level spatial inequalities** in predicted SBA probabilities across Burkina Faso
- 🏘️ **Quantify urban–rural disparities** to inform context-specific maternal health interventions
- ⚖️ **Address class imbalance** using SMOTE, with a dedicated **sensitivity analysis** benchmarking alternative imbalance-correction strategies (class weighting, Boruta-refined feature sets, and balanced-accuracy optimization) to test the robustness of the primary findings
- 📐 **Evaluate clinical utility** via Decision Curve Analysis (DCA) across Random Forest, Logistic Regression, and Support Vector Machine models

> ⚠️ **Conceptual note.** This study adopts a **predictive modeling framework**, not a causal-inference framework. All variables identified as important predictors should be interpreted as statistically associated with the outcome, not as causal determinants of skilled birth attendance.

---

## 🏗️ Study Design & Data Source

| Attribute | Details |
|---|---|
| **Study design** | Cross-sectional, secondary data analysis |
| **Data source** | 2021 Burkina Faso Demographic and Health Survey (BF-DHS) |
| **Sampling design** | Stratified two-stage cluster sampling |
| **Analytic sample** | 5,111 ever-married women aged 15–49 with ≥ 1 live birth in the last 5 years |
| **Outcome variable** | Skilled Birth Attendance (SBA) — binary: skilled vs. unskilled |
| **Data access** | [dhsprogram.com](https://dhsprogram.com) *(registration required)* |

> ⚠️ Raw DHS microdata are **not redistributed** in this repository, in compliance with the DHS Program's data use agreement. Access must be requested directly from the [DHS Program](https://dhsprogram.com/data/dataset_admin/login_main.cfm).

<p align="center">
  <img src="Figure%201.png" alt="Study sample selection flowchart" width="620">
  <br>
  <sub><b>Figure 1.</b> Study sample selection flowchart for the 2021 BF-DHS analytic cohort.</sub>
</p>

---

## 🗂️ Repository Structure

```
SBA-BurkinaFaso-ML-DHS/
│
├── 📂 Main Scripts
│   ├── Salek_ML(BF)_SBA.R                      # Full ML pipeline: preprocessing, modelling, SHAP, spatial maps
│   ├── Salek_ML_without_Some_Model_train.R     # Alternative training script (subset of models)
│   ├── SBA_ML_Sensitivity_Analysis.R           # NEW — Class-weighting, Boruta refinement & balanced-accuracy sensitivity analysis
│   ├── Correltaion Heatmaps.R                  # Cramér's V correlation heatmap (Supplementary Figure S7)
│   ├── Precision _recall curve.R               # Precision–recall curves (Supplementary Figure S5)
│   ├── Salek_data manegments_SBA.do            # Stata: DHS data cleaning & variable construction
│   └── Svy_LR(Sensistivity).do                 # Stata: survey-weighted logistic regression (sensitivity analysis)
│
├── 📂 Data
│   ├── DataDHS_cleaned_descriptive.dta         # Cleaned DHS dataset (Stata format; derived variables only)
│   ├── comparison_df.csv                       # NEW — Model comparison output (imbalance-handling sensitivity)
│   ├── ranking_df.csv                          # NEW — Predictor ranking output (imbalance-handling sensitivity)
│   ├── rf_imbalance_comparison.csv             # NEW — RF performance across imbalance-handling strategies
│   ├── rf_imbalance_ranking.csv                # NEW — RF predictor ranking across imbalance-handling strategies
│   └── Supplementary_Table1_RF_Comparison.csv  # NEW — Consolidated RF comparison table (machine-readable)
│
├── 📂 Figures
│   ├── Figure 1.png                            # Study sample selection flowchart
│   ├── Supplementary Figure S1.tiff            # SBA prevalence distribution
│   ├── Supplementary Figure S2.tiff            # Class distribution before & after SMOTE
│   ├── Supplementray Figure S3.tiff            # Boruta feature selection results
│   ├── Suppementary Figure S4.tiff             # Cumulative SHAP contribution plot
│   ├── Supplementary Figure S5.png             # Precision–recall curves across all models
│   ├── Supplementary Figure S6.tiff            # Random Forest confusion matrix
│   ├── Supplementary Figure S7.tiff            # Cramér's V correlation heatmap
│   ├── Supplementary Figure S8.tiff            # NEW — RF performance across imbalance-handling strategies
│   ├── Supplementary Figure S9.tiff            # NEW — Boruta-refined predictor importance (sensitivity)
│   ├── Supplementary Figure S10.tiff           # NEW — Balanced-accuracy comparison across strategies
│   ├── Supplementary Figure S10(alternatives).tiff  # NEW — Alternative visualization of Figure S10
│   └── Supplementary Figure S11.tiff           # NEW — Predictor ranking stability under alternative imbalance handling
│
├── 📂 Supplementary Tables
│   ├── SUpplementary Tabl S1.docx              # Background characteristics of analytic sample
│   ├── Supplementary Table S2.docx             # Hyperparameter tuning grid (all models)
│   ├── Supplementary Table S3.docx             # Baseline model performance without SMOTE
│   ├── Supplementary Table S4.docx             # Survey-weighted sensitivity analysis results
│   └── Supplementary Table S5.docx             # NEW — Imbalance-handling sensitivity analysis (full results)
│
├── 📂 Reference
│   └── Burkina-Faso-DHS-2021(Reports).pdf      # Official BF-DHS 2021 final report
│
├── Table1_SBA_Logistic_Regression.xlsx          # Table 1: ML model performance metrics
├── README.md                                    # Project documentation (this file)
└── LICENSE                                      # MIT License
```

---

## 🛠️ Tech Stack

<div align="center">

![R](https://img.shields.io/badge/R_4.2+-276DC3?style=for-the-badge&logo=r&logoColor=white)
![Stata](https://img.shields.io/badge/Stata_17-1A5276?style=for-the-badge&logoColor=white)
![Random Forest](https://img.shields.io/badge/Random_Forest-228B22?style=for-the-badge&logoColor=white)
![SVM](https://img.shields.io/badge/SVM-8E44AD?style=for-the-badge&logoColor=white)
![SHAP](https://img.shields.io/badge/SHAP-Explainability-E67E22?style=for-the-badge&logoColor=white)
![SMOTE](https://img.shields.io/badge/SMOTE-Imbalance_Handling-E74C3C?style=for-the-badge&logoColor=white)
![Class Weighting](https://img.shields.io/badge/Class_Weighting-Sensitivity_Analysis-9B59B6?style=for-the-badge&logoColor=white)
![Spatial](https://img.shields.io/badge/Spatial_Analysis-00BFFF?style=for-the-badge&logo=mapbox&logoColor=white)
![DHS](https://img.shields.io/badge/DHS_2021-Data_Source-95A5A6?style=for-the-badge&logoColor=white)

</div>

---

## 🔄 Analytical Workflow

```
┌─────────────────────────────────────────────────────────────────────┐
│                     BF-DHS 2021 Raw Microdata                       │
└──────────────────────────────┬──────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│         Data Management & Variable Construction  (Stata .do)        │
│   • Outcome coding (SBA binary)  • Covariate harmonization          │
│   • Sampling weight preparation  • Analytic sample restriction      │
└──────────────────────────────┬──────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│              Missing Data Handling  (MICE — MAR assumption)         │
│   • Husband's education (8.9%)  • Pregnancy decisions (~5%)         │
│   • All other variables < 1% missingness                            │
└──────────────────────────────┬──────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│            Feature Selection  (Boruta Algorithm)                    │
│   • Applied on training set only (leakage prevention)               │
│   • 17 confirmed relevant predictors retained                       │
└──────────────────────────────┬──────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│         Stratified Train / Test Split  (80% / 20%)                  │
│   • SMOTE applied to training set only (primary specification)      │
│   • Test set preserved in original class distribution               │
└──────────────────────────────┬──────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      Model Training                                 │
│   RF · Decision Tree · KNN · Logistic Regression · SVM              │
│   10-fold cross-validation · Grid hyperparameter tuning             │
└──────────────────────────────┬──────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     Model Evaluation                                │
│   Accuracy · Precision · Recall · F1 · MCC · Kappa · AUROC          │
│   Calibration plots · Brier scores · PR-AUC curves                  │
└──────────────────────────────┬──────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│               SHAP Interpretability  (Best Model: RF)               │
│   • Global feature importance (mean |SHAP|)                         │
│   • Local explanation plots                                         │
│   • Cumulative SHAP contribution analysis                           │
└──────────────────────────────┬──────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│          Clinical Utility & Spatial Analysis                        │
│   • Decision Curve Analysis (DCA) — RF, LR, SVM                     │
│   • Province-level prediction mapping (national)                    │
│   • Urban–rural stratified spatial maps                             │
└──────────────────────────────┬──────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│     NEW — Sensitivity Analysis: Imbalance-Handling Strategies       │
│   • RF re-estimated under: baseline (no correction) · SMOTE ·       │
│     class weighting · Boruta-refined feature set                    │
│   • Balanced-accuracy optimization & predictor-ranking stability    │
│   • Robustness check against the primary SMOTE-based specification  │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📊 Key Findings

### Model Performance Comparison (Primary Specification — SMOTE)

| Model | Accuracy | Precision | Recall | F1-Score | MCC | Kappa | AUROC |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| 🏆 **Random Forest** | **0.89** | **0.93** | **0.96** | **0.94** | **0.31** | **0.30** | **0.71** |
| SVM | 0.88 | 0.93 | 0.94 | 0.93 | 0.27 | 0.27 | 0.69 |
| Decision Tree | 0.85 | 0.92 | 0.90 | 0.91 | 0.19 | 0.19 | 0.64 |
| KNN | 0.76 | 0.94 | 0.79 | 0.86 | 0.19 | 0.17 | 0.67 |
| Logistic Regression | 0.71 | 0.94 | 0.72 | 0.82 | 0.19 | 0.15 | 0.69 |

> 📌 Given the pronounced class imbalance (90.4% skilled vs. 9.6% unskilled), **MCC, AUROC, and F1-score** are treated as the primary evaluation metrics; accuracy alone is not informative in this setting.

<p align="center">
  <img src="Supplementary%20Figure%20S5.png" alt="Precision-recall curves across all models" width="560">
  <br>
  <sub><b>Supplementary Figure S5.</b> Precision–recall curves across all five supervised models.</sub>
</p>

### Top Predictors (SHAP — Random Forest)

| Rank | Predictor | Direction |
|:---:|---|---|
| 1 | **Province** (esp. Sahel) | ↓ Negative SHAP (lower SBA probability) |
| 2 | **ANC visits ≥ 4** | ↑ Positive SHAP |
| 3 | **Maternal age at first birth ≥ 20 years** | ↑ Positive SHAP |
| 4 | **Current sexual activity** | ↑ Positive SHAP |
| 5 | **Age at first sexual intercourse ≥ 18 years** | ↑ Positive SHAP |
| 6 | **Household wealth** | ↑ Positive SHAP |
| 7 | **Religion** | Variable |
| 8 | **Media/internet exposure** | ↑ Positive SHAP |

<p align="center">
  <img src="Suppementary%20Figure%20S4.tiff" alt="Cumulative SHAP contribution plot" width="560">
  <br>
  <sub><b>Supplementary Figure S4.</b> Cumulative SHAP contribution plot for the Random Forest model.</sub>
</p>

### Spatial Patterns

| Region | Predicted SBA probability | Classification |
|---|:---:|---|
| Centre, Centre-Nord, Centre-Ouest, Nord, Cascades | 0.60 – 0.80 | 🟢 High coverage |
| Hauts-Bassins, Boucle-du-Mouhoun, Centre-Sud | 0.55 – 0.70 | 🟡 Moderate coverage |
| Sud-Ouest, Est, parts of Centre-Est | 0.30 – 0.50 | 🟠 Low coverage |
| **Sahel** | **0.20 – 0.40** | 🔴 Lowest coverage — priority zone |

---

## 🧪 Sensitivity Analysis: Imbalance-Handling Strategies

To evaluate whether the primary conclusions are an artifact of the SMOTE specification, `SBA_ML_Sensitivity_Analysis.R` re-estimates the Random Forest model under a set of alternative class-imbalance-handling strategies and re-assesses predictor rankings for stability. This analysis was undertaken in direct response to the well-established methodological concern that synthetic oversampling can distort the decision boundary and inflate apparent predictive performance; benchmarking against non-synthetic alternatives is therefore standard practice for imbalanced clinical/epidemiological prediction tasks.

**Strategies compared:**

1. **Baseline RF** — no correction for class imbalance (reference)
2. **RF + SMOTE** — primary specification reported above
3. **RF + class weighting** — inverse class-frequency weights applied during training, avoiding synthetic sample generation
4. **RF + Boruta-refined feature set** — re-confirmed predictor set with balanced-accuracy as the optimization target rather than overall accuracy

**Outputs of this analysis:**

| File | Description |
|---|---|
| `rf_imbalance_comparison.csv` | Performance metrics (Accuracy, Precision, Recall, F1, MCC, Kappa, AUROC, Balanced Accuracy) for each imbalance-handling strategy |
| `rf_imbalance_ranking.csv` | SHAP/importance-based predictor ranking under each strategy |
| `comparison_df.csv` | Consolidated model-comparison data frame underlying Figure S8 |
| `ranking_df.csv` | Consolidated ranking data frame underlying Figure S9/S11 |
| `Supplementary_Table1_RF_Comparison.csv` | Machine-readable version of Supplementary Table S5 |
| `Supplementary Table S5.docx` | Full formatted results table for manuscript inclusion |

<p align="center">
  <img src="Supplementary%20Figure%20S8.tiff" alt="RF performance across imbalance-handling strategies" width="560">
  <br>
  <sub><b>Supplementary Figure S8.</b> Random Forest performance across alternative class-imbalance-handling strategies.</sub>
</p>

<p align="center">
  <img src="Supplementary%20Figure%20S9.tiff" alt="Boruta-refined predictor importance sensitivity" width="560">
  <br>
  <sub><b>Supplementary Figure S9.</b> Predictor importance under the Boruta-refined feature set.</sub>
</p>

<p align="center">
  <img src="Supplementary%20Figure%20S10.tiff" alt="Balanced accuracy comparison across strategies" width="560">
  <br>
  <sub><b>Supplementary Figure S10.</b> Balanced-accuracy comparison across imbalance-handling strategies (see also Supplementary Figure S10(alternatives).tiff for an alternative visualization).</sub>
</p>

<p align="center">
  <img src="Supplementary%20Figure%20S11.tiff" alt="Predictor ranking stability under alternative imbalance handling" width="560">
  <br>
  <sub><b>Supplementary Figure S11.</b> Stability of predictor rankings across imbalance-handling strategies.</sub>
</p>

> 📌 **Interpretation guidance.** The exact numeric results for this analysis are reported in `Supplementary Table S5.docx` / `Supplementary_Table1_RF_Comparison.csv`. Please verify that the figure captions above match your final analysis output before submission, and update the summary narrative (e.g., which strategy yields the most stable ranking) to reflect the confirmed results.

---

## ⚡ Installation & Requirements

### R (≥ 4.2)

```r
install.packages(c(
  # Data handling
  "tidyverse", "haven", "mice",

  # ML modelling
  "caret", "randomForest", "rpart", "e1071", "class",

  # Feature selection & imbalance handling
  "Boruta", "themis", "recipes",

  # Model interpretation
  "shapviz", "SHAPforxgboost",

  # Evaluation & clinical utility
  "pROC", "MLmetrics", "rmda",

  # Spatial analysis & visualization
  "sf", "ggplot2", "tmap", "RColorBrewer",

  # Correlation
  "corrplot", "DescTools"
))
```

### Stata (≥ 17)

```stata
* Required for sensitivity analysis (.do files)
ssc install estout
ssc install svyset   // built-in, ensure updated ado files
```

---

## ♻️ Reproducibility Steps

> Follow these steps in order to fully reproduce all results, figures, and tables reported in the manuscript, including the imbalance-handling sensitivity analysis.

**Step 1 — Obtain data**
```
1. Register at https://dhsprogram.com
2. Request access to: Burkina Faso DHS 2021 — Individual Recode (IR) dataset
3. Download the Stata-format file (.dta)
```

**Step 2 — Data management (Stata)**
```stata
* Open Stata 17, set working directory, then run:
do "Salek_data manegments_SBA.do"
* Output: DataDHS_cleaned_descriptive.dta
```

**Step 3 — Main ML analysis (R)**
```r
# Set working directory to repository root, then run:
source("Salek_ML(BF)_SBA.R")
# Produces: all main figures, Table 1, SHAP plots, spatial maps
```

**Step 4 — Supplementary figures (R)**
```r
source("Correltaion Heatmaps.R")        # → Supplementary Figure S7
source("Precision _recall curve.R")     # → Supplementary Figure S5
```

**Step 5 — Sensitivity analysis: survey-weighted logistic regression (Stata)**
```stata
do "Svy_LR(Sensistivity).do"
* Output: Supplementary Table S4 (survey-weighted LR results)
```

**Step 6 — Sensitivity analysis: imbalance-handling strategies (R)**
```r
source("SBA_ML_Sensitivity_Analysis.R")
# Produces: Supplementary Figures S8–S11, Supplementary Table S5,
#           comparison_df.csv, ranking_df.csv,
#           rf_imbalance_comparison.csv, rf_imbalance_ranking.csv,
#           Supplementary_Table1_RF_Comparison.csv
```

**Step 7 — Alternative model training (optional)**
```r
source("Salek_ML_without_Some_Model_train.R")   # Subset model comparison
```

---

## 🔏 Ethical Statement

- Ethical approval for the 2021 BF-DHS was obtained from the **national ethics committees in Burkina Faso** and the **ICF International Institutional Review Board**.
- All data are **anonymized** and publicly available through the DHS Program.
- No additional ethical clearance was required for this secondary analysis.
- Full details: [dhsprogram.com — Protecting the Privacy of DHS Survey Respondents](https://dhsprogram.com/Methodology/Protecting-the-Privacy-of-DHS-Survey-Respondents.cfm)
- Generative AI tools were used **solely for language editing**; all scientific content, analysis, and interpretation remain the sole responsibility of the author.

---

## 📄 Citation

If you use this code, data pipeline, or analysis in your research, please cite:

```bibtex
@article{miah2025sba,
  author  = {Miah, Md Salek},
  title   = {Machine Learning Analysis of Factors Influencing Skilled Birth Attendance
             in Burkina Faso: Assessing Spatial Inequalities Using Imbalanced Survey Data},
  journal = {[Under Review]},
  year    = {2025},
  note    = {Manuscript submitted for publication; includes sensitivity analysis of
             class-imbalance-handling strategies},
  url     = {https://github.com/muhammadsalek/SBA-BurkinaFaso-ML-DHS},
  orcid   = {0009-0005-5973-461X}
}
```

---

## 📜 License

This project is licensed under the [MIT License](LICENSE) — see the LICENSE file for details.

---

<div align="center">

**Made with ❤️ for open science and maternal health equity**

[![GitHub](https://img.shields.io/badge/GitHub-muhammadsalek-181717?style=flat-square&logo=github)](https://github.com/muhammadsalek)
[![ORCID](https://img.shields.io/badge/ORCID-0009--0005--5973--461X-A6CE39?style=flat-square&logo=orcid&logoColor=white)](https://orcid.org/0009-0005-5973-461X)
[![DHS](https://img.shields.io/badge/DHS_Program-Data_Access-0074D9?style=flat-square)](https://dhsprogram.com)

*Department of Statistics · Shahjalal University of Science and Technology · Sylhet‑3114 · Bangladesh*

</div>
