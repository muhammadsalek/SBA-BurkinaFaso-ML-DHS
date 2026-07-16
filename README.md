# SBA-BurkinaFaso-ML-DHS

<div align="center">

![R](https://img.shields.io/badge/R-4.2+-276DC3?style=flat-square&logo=r&logoColor=white)
![Stata](https://img.shields.io/badge/Stata-17-1A5276?style=flat-square&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-2ECC71?style=flat-square&logo=opensourceinitiative&logoColor=white)
![Status](https://img.shields.io/badge/Status-Under_Review-F39C12?style=flat-square)
![Sensitivity Analysis](https://img.shields.io/badge/Sensitivity_Analysis-Imbalance_Handling-9B59B6?style=flat-square)
![Last Commit](https://img.shields.io/github/last-commit/muhammadsalek/SBA-BurkinaFaso-ML-DHS?style=flat-square&color=8E44AD)

<br/>

### *Machine Learning Analysis of Factors Influencing Skilled Birth Attendance in Burkina Faso: Assessing Spatial Inequalities Using Imbalanced Survey Data*

**Md Salek Miah**
Department of Statistics, Shahjalal University of Science and Technology, Sylhet‑3114, Bangladesh

[![ORCID](https://img.shields.io/badge/ORCID-0009--0005--5973--461X-A6CE39?style=flat-square&logo=orcid&logoColor=white)](https://orcid.org/0009-0005-5973-461X)
[![Email](https://img.shields.io/badge/Email-saleksta%40gmail.com-D44638?style=flat-square&logo=gmail&logoColor=white)](mailto:saleksta@gmail.com)
[![DHS Data](https://img.shields.io/badge/Data_Source-DHS_Program_2021-0074D9?style=flat-square)](https://dhsprogram.com)

</div>

---

## Abstract

Skilled birth attendance (SBA) remains a critical determinant of maternal and neonatal survival in sub-Saharan Africa, yet its subnational distribution is often poorly characterized by conventional regression-based approaches. This repository provides the complete analytical pipeline for a study that applies an interpretable machine learning (ML) framework to the 2021 Burkina Faso Demographic and Health Survey (BF-DHS) to identify predictors of SBA, quantify province-level spatial inequalities, and evaluate the clinical utility of the resulting prediction models. Five supervised classifiers are benchmarked under a rigorous train/test protocol with SMOTE-based class-imbalance correction, and model predictions are interpreted using SHapley Additive exPlanations (SHAP). To assess the robustness of the imbalance-handling strategy — a recognized methodological concern in synthetic oversampling — a dedicated sensitivity analysis re-estimates the best-performing model (Random Forest) under class weighting and Boruta-refined, balanced-accuracy-optimized specifications.

**Keywords:** skilled birth attendance; machine learning; SHAP; class imbalance; SMOTE; spatial inequality; Demographic and Health Survey; Burkina Faso; maternal health

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Study Design and Data Source](#2-study-design-and-data-source)
3. [Repository Structure](#3-repository-structure)
4. [Technical Stack](#4-technical-stack)
5. [Analytical Workflow](#5-analytical-workflow)
6. [Principal Findings](#6-principal-findings)
7. [Sensitivity Analysis: Class-Imbalance-Handling Strategies](#7-sensitivity-analysis-class-imbalance-handling-strategies)
8. [Installation and Requirements](#8-installation-and-requirements)
9. [Reproducibility Protocol](#9-reproducibility-protocol)
10. [Data Availability Statement](#10-data-availability-statement)
11. [Ethical Statement](#11-ethical-statement)
12. [Author Contributions](#12-author-contributions)
13. [Citation](#13-citation)
14. [License](#14-license)

---

## 1. Project Overview

This repository contains the full codebase, supplementary materials, and reproducibility artifacts accompanying the manuscript cited above, currently under peer review. The study implements an interpretable machine learning framework applied to a nationally representative household survey in order to:

- **Identify and rank key predictors** of skilled birth attendance using five supervised ML algorithms
- **Explain model predictions** using SHAP for both global and local interpretability
- **Map province-level spatial inequalities** in predicted SBA probability across Burkina Faso
- **Quantify urban–rural disparities** to inform context-specific maternal health interventions
- **Address class imbalance** using SMOTE, with rigorous train/test separation to prevent data leakage
- **Test the robustness of the imbalance-correction strategy** via a dedicated sensitivity analysis comparing SMOTE against class weighting and Boruta-refined, balanced-accuracy-optimized alternatives
- **Evaluate clinical utility** via Decision Curve Analysis (DCA) across Random Forest, Logistic Regression, and Support Vector Machine models

> **Conceptual note.** This study adopts a predictive modeling framework rather than a causal-inference framework. Variables identified as important predictors should be interpreted as statistically associated with the outcome, not as causal determinants of skilled birth attendance.

---

## 2. Study Design and Data Source

| Attribute | Details |
|---|---|
| Study design | Cross-sectional, secondary data analysis |
| Data source | 2021 Burkina Faso Demographic and Health Survey (BF-DHS) |
| Sampling design | Stratified two-stage cluster sampling |
| Analytic sample | 5,111 ever-married women aged 15–49 with ≥ 1 live birth in the last 5 years |
| Outcome variable | Skilled birth attendance (binary: skilled vs. unskilled) |
| Data access | [dhsprogram.com](https://dhsprogram.com) *(registration required)* |

> Raw DHS microdata are not redistributed in this repository, in compliance with the DHS Program's data use agreement. Access must be requested directly from the [DHS Program](https://dhsprogram.com/data/dataset_admin/login_main.cfm).

<p align="center">
  <img src="Figure%201.png" alt="Study sample selection flowchart" width="600">
  <br>
  <sub><b>Figure 1.</b> Study sample selection flowchart for the 2021 BF-DHS analytic cohort.</sub>
</p>

---

## 3. Repository Structure

```
SBA-BurkinaFaso-ML-DHS/
│
├── Main Scripts
│   ├── Salek_ML(BF)_SBA.R                      Full ML pipeline: preprocessing, modelling, SHAP, spatial maps
│   ├── Salek_ML_without_Some_Model_train.R     Alternative training script (subset of models)
│   ├── SBA_ML_Sensitivity_Analysis.R           Class-weighting, Boruta refinement & balanced-accuracy sensitivity analysis
│   ├── Correltaion Heatmaps.R                  Cramér's V correlation heatmap (Supplementary Figure S7)
│   ├── Precision _recall curve.R               Precision–recall curves (Supplementary Figure S5)
│   ├── Salek_data manegments_SBA.do            Stata: DHS data cleaning & variable construction
│   └── Svy_LR(Sensistivity).do                 Stata: survey-weighted logistic regression (sensitivity analysis)
│
├── Data
│   ├── DataDHS_cleaned_descriptive.dta         Cleaned DHS dataset (Stata format; derived variables only)
│   ├── comparison_df.csv                       Model comparison output (imbalance-handling sensitivity)
│   ├── ranking_df.csv                          Predictor ranking output (imbalance-handling sensitivity)
│   ├── rf_imbalance_comparison.csv             RF performance across imbalance-handling strategies
│   ├── rf_imbalance_ranking.csv                RF predictor ranking across imbalance-handling strategies
│   └── Supplementary_Table1_RF_Comparison.csv  Consolidated RF comparison table (machine-readable)
│
├── Figures
│   ├── Figure 1.png                            Study sample selection flowchart
│   ├── Supplementary Figure S1.tiff            SBA prevalence distribution
│   ├── Supplementary Figure S2.tiff            Class distribution before & after SMOTE
│   ├── Supplementray Figure S3.tiff            Boruta feature selection results
│   ├── Suppementary Figure S4.tiff             Cumulative SHAP contribution plot
│   ├── Supplementary Figure S5.png             Precision–recall curves across all models
│   ├── Supplementary Figure S6.tiff            Random Forest confusion matrix
│   ├── Supplementary Figure S7.tiff            Cramér's V correlation heatmap
│   ├── Supplementary Figure S8.tiff            Random Forest performance across alternative class-imbalance-handling strategies
│   ├── Supplementary Figure S9.tiff            Predictor importance under the Boruta-refined feature set
│   ├── Supplementary Figure S10.tiff           Balanced-accuracy comparison across imbalance-handling strategies
│   ├── Supplementary Figure S10(alternatives).tiff  Alternative visualization of Figure S10
│   └── Supplementary Figure S11.tiff           Stability of predictor rankings across imbalance-handling strategies
│
├── Supplementary Tables
│   ├── SUpplementary Tabl S1.docx              Background characteristics of the analytic sample
│   ├── Supplementary Table S2.docx             Hyperparameter tuning grid (all models)
│   ├── Supplementary Table S3.docx             Baseline model performance without SMOTE
│   ├── Supplementary Table S4.docx             Survey-weighted sensitivity analysis results
│   └── Supplementary Table S5.docx             Imbalance-handling sensitivity analysis (full results)
│
├── Reference
│   └── Burkina-Faso-DHS-2021(Reports).pdf      Official BF-DHS 2021 final report
│
├── Table1_SBA_Logistic_Regression.xlsx          Table 1: ML model performance metrics
├── README.md                                    Project documentation (this file)
└── LICENSE                                      MIT License
```

---

## 4. Technical Stack

<div align="center">

![R](https://img.shields.io/badge/R_4.2+-276DC3?style=flat-square&logo=r&logoColor=white)
![Stata](https://img.shields.io/badge/Stata_17-1A5276?style=flat-square&logoColor=white)
![Random Forest](https://img.shields.io/badge/Random_Forest-228B22?style=flat-square&logoColor=white)
![SVM](https://img.shields.io/badge/SVM-8E44AD?style=flat-square&logoColor=white)
![SHAP](https://img.shields.io/badge/SHAP-Explainability-E67E22?style=flat-square&logoColor=white)
![SMOTE](https://img.shields.io/badge/SMOTE-Imbalance_Handling-E74C3C?style=flat-square&logoColor=white)
![Class Weighting](https://img.shields.io/badge/Class_Weighting-Sensitivity_Analysis-9B59B6?style=flat-square&logoColor=white)
![Spatial](https://img.shields.io/badge/Spatial_Analysis-00BFFF?style=flat-square&logo=mapbox&logoColor=white)
![DHS](https://img.shields.io/badge/DHS_2021-Data_Source-95A5A6?style=flat-square&logoColor=white)

</div>

---

## 5. Analytical Workflow

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
│        Sensitivity Analysis: Imbalance-Handling Strategies          │
│   • RF re-estimated under: baseline (no correction) · SMOTE ·       │
│     class weighting · Boruta-refined feature set                    │
│   • Balanced-accuracy optimization & predictor-ranking stability    │
│   • Robustness check against the primary SMOTE-based specification  │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 6. Principal Findings

### 6.1 Model Performance Comparison (Primary Specification — SMOTE)

| Model | Accuracy | Precision | Recall | F1-Score | MCC | Kappa | AUROC |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| **Random Forest** | **0.89** | **0.93** | **0.96** | **0.94** | **0.31** | **0.30** | **0.71** |
| SVM | 0.88 | 0.93 | 0.94 | 0.93 | 0.27 | 0.27 | 0.69 |
| Decision Tree | 0.85 | 0.92 | 0.90 | 0.91 | 0.19 | 0.19 | 0.64 |
| KNN | 0.76 | 0.94 | 0.79 | 0.86 | 0.19 | 0.17 | 0.67 |
| Logistic Regression | 0.71 | 0.94 | 0.72 | 0.82 | 0.19 | 0.15 | 0.69 |

Random Forest is retained as the primary model on the basis of its Matthews Correlation Coefficient, F1-score, and AUROC — the metrics most appropriate under the observed class imbalance (90.4% skilled vs. 9.6% unskilled), where accuracy alone is not informative.

<p align="center">
  <img src="Supplementary%20Figure%20S5.png" alt="Precision-recall curves across all models" width="540">
  <br>
  <sub><b>Supplementary Figure S5.</b> Precision–recall curves across all five supervised models.</sub>
</p>

### 6.2 Top Predictors (SHAP — Random Forest)

| Rank | Predictor | Direction |
|:---:|---|---|
| 1 | Province (esp. Sahel) | Negative SHAP (lower SBA probability) |
| 2 | ANC visits ≥ 4 | Positive SHAP |
| 3 | Maternal age at first birth ≥ 20 years | Positive SHAP |
| 4 | Current sexual activity | Positive SHAP |
| 5 | Age at first sexual intercourse ≥ 18 years | Positive SHAP |
| 6 | Household wealth | Positive SHAP |
| 7 | Religion | Variable |
| 8 | Media/internet exposure | Positive SHAP |

<p align="center">
  <img src="Suppementary%20Figure%20S4.tiff" alt="Cumulative SHAP contribution plot" width="540">
  <br>
  <sub><b>Supplementary Figure S4.</b> Cumulative SHAP contribution plot.</sub>
</p>

### 6.3 Spatial Patterns

| Region | Predicted SBA probability | Classification |
|---|:---:|---|
| Centre, Centre-Nord, Centre-Ouest, Nord, Cascades | 0.60 – 0.80 | High coverage |
| Hauts-Bassins, Boucle-du-Mouhoun, Centre-Sud | 0.55 – 0.70 | Moderate coverage |
| Sud-Ouest, Est, parts of Centre-Est | 0.30 – 0.50 | Low coverage |
| **Sahel** | **0.20 – 0.40** | Lowest coverage — priority zone |

---

## 7. Sensitivity Analysis: Class-Imbalance-Handling Strategies

Synthetic oversampling techniques such as SMOTE can, under certain conditions, distort the estimated decision boundary and inflate apparent predictive performance. To evaluate whether the study's primary conclusions are an artifact of this choice, `SBA_ML_Sensitivity_Analysis.R` re-estimates the Random Forest model under a set of non-synthetic alternatives and re-assesses predictor-ranking stability — a robustness check that is standard practice for imbalanced classification tasks in clinical and epidemiological prediction research.

**Strategies compared**

| Strategy | Description |
|---|---|
| Baseline RF | No correction for class imbalance (reference) |
| RF + SMOTE | Primary specification reported in Section 6 |
| RF + class weighting | Inverse class-frequency weights applied during training; avoids synthetic sample generation |
| RF + Boruta-refined feature set | Re-confirmed predictor set with balanced accuracy as the optimization target rather than overall accuracy |

**Output files**

| File | Description |
|---|---|
| `rf_imbalance_comparison.csv` | Performance metrics (Accuracy, Precision, Recall, F1, MCC, Kappa, AUROC, Balanced Accuracy) for each strategy |
| `rf_imbalance_ranking.csv` | SHAP/importance-based predictor ranking under each strategy |
| `comparison_df.csv` | Consolidated model-comparison data frame underlying Figure S8 |
| `ranking_df.csv` | Consolidated ranking data frame underlying Figures S9 and S11 |
| `Supplementary_Table1_RF_Comparison.csv` | Machine-readable version of Supplementary Table S5 |
| `Supplementary Table S5.docx` | Full formatted results table for manuscript inclusion |

<p align="center">
  <img src="Supplementary%20Figure%20S8.tiff" alt="Random Forest performance across alternative class-imbalance-handling strategies" width="540">
  <br>
  <sub><b>Supplementary Figure S8.</b> Random Forest performance across alternative class-imbalance-handling strategies.</sub>
</p>

<p align="center">
  <img src="Supplementary%20Figure%20S9.tiff" alt="Predictor importance under the Boruta-refined feature set" width="540">
  <br>
  <sub><b>Supplementary Figure S9.</b> Predictor importance under the Boruta-refined feature set.</sub>
</p>

<p align="center">
  <img src="Supplementary%20Figure%20S10.tiff" alt="Balanced-accuracy comparison across imbalance-handling strategies" width="540">
  <br>
  <sub><b>Supplementary Figure S10.</b> Balanced-accuracy comparison across imbalance-handling strategies (see also <code>Supplementary Figure S10(alternatives).tiff</code> for an alternative visualization).</sub>
</p>

<p align="center">
  <img src="Supplementary%20Figure%20S11.tiff" alt="Stability of predictor rankings across imbalance-handling strategies" width="540">
  <br>
  <sub><b>Supplementary Figure S11.</b> Stability of predictor rankings across imbalance-handling strategies.</sub>
</p>

> **Note.** Full numeric results for this analysis are reported in `Supplementary Table S5.docx` and `Supplementary_Table1_RF_Comparison.csv`. Authors should confirm that the narrative summary of which strategy yields the most stable ranking is consistent with the final confirmed output before manuscript submission.

---

## 8. Installation and Requirements

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

## 9. Reproducibility Protocol

**Step 1 — Obtain data**
```
1. Register at https://dhsprogram.com
2. Request access to: Burkina Faso DHS 2021 — Individual Recode (IR) dataset
3. Download the Stata-format file (.dta)
```

**Step 2 — Data management (Stata)**
```stata
do "Salek_data manegments_SBA.do"
* Output: DataDHS_cleaned_descriptive.dta
```

**Step 3 — Main ML analysis (R)**
```r
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
* Output: Supplementary Table S4
```

**Step 6 — Sensitivity analysis: imbalance-handling strategies (R)**
```r
source("SBA_ML_Sensitivity_Analysis.R")
# Produces: Supplementary Figures S8-S11, Supplementary Table S5,
#           comparison_df.csv, ranking_df.csv,
#           rf_imbalance_comparison.csv, rf_imbalance_ranking.csv,
#           Supplementary_Table1_RF_Comparison.csv
```

**Step 7 — Alternative model training (optional)**
```r
source("Salek_ML_without_Some_Model_train.R")
```

---

## 10. Data Availability Statement

The 2021 Burkina Faso DHS microdata that support the findings of this study are available from the DHS Program upon reasonable request and registration at [dhsprogram.com](https://dhsprogram.com). Derived, de-identified analytic outputs (cleaned covariates, model outputs, and sensitivity-analysis results) generated by this pipeline are provided in this repository. Restrictions apply to the availability of raw individual-level microdata, which were used under license for the current study and are therefore not publicly redistributed.

---

## 11. Ethical Statement

- Ethical approval for the 2021 BF-DHS was obtained from the national ethics committees in Burkina Faso and the ICF International Institutional Review Board.
- All data are anonymized and made publicly available through the DHS Program.
- No additional ethical clearance was required for this secondary data analysis.
- Further details are available at [dhsprogram.com — Protecting the Privacy of DHS Survey Respondents](https://dhsprogram.com/Methodology/Protecting-the-Privacy-of-DHS-Survey-Respondents.cfm).
- Generative AI tools were used solely for language editing; all scientific content, analysis, and interpretation remain the sole responsibility of the author.

---

## 12. Author Contributions

**Md Salek Miah**: conceptualization, methodology, formal analysis, software, data curation, visualization, writing — original draft, writing — review and editing.

---

## 13. Citation

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

## 14. License

This project is licensed under the [MIT License](LICENSE). See the LICENSE file for full terms.

---

<div align="center">

*Department of Statistics · Shahjalal University of Science and Technology · Sylhet‑3114 · Bangladesh*

[![GitHub](https://img.shields.io/badge/GitHub-muhammadsalek-181717?style=flat-square&logo=github)](https://github.com/muhammadsalek)
[![ORCID](https://img.shields.io/badge/ORCID-0009--0005--5973--461X-A6CE39?style=flat-square&logo=orcid&logoColor=white)](https://orcid.org/0009-0005-5973-461X)
[![DHS](https://img.shields.io/badge/DHS_Program-Data_Access-0074D9?style=flat-square)](https://dhsprogram.com)

</div>
