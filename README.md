# 🏥 SBA-BurkinaFaso-ML-DHS

<div align="center">

![R](https://img.shields.io/badge/R-4.2+-276DC3?style=for-the-badge&logo=r&logoColor=white)
![Stata](https://img.shields.io/badge/Stata-17-1A5276?style=for-the-badge&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-2ECC71?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Under_Review-F39C12?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-v2.0-8E44AD?style=for-the-badge)

<br/>

> ### 📄 **"Machine Learning Analysis of Factors Influencing Skilled Birth Attendance in Burkina Faso: Assessing Spatial Inequalities Using Imbalanced Survey Data"**
>
> **Md Salek Miah** · Department of Statistics, Shahjalal University of Science and Technology, Sylhet-3114, Bangladesh
>
> [![ORCID](https://img.shields.io/badge/ORCID-0009--0005--5973--461X-A6CE39?style=flat-square&logo=orcid&logoColor=white)](https://orcid.org/0009-0005-5973-461X)
> [![Email](https://img.shields.io/badge/Email-saleksta%40gmail.com-D44638?style=flat-square&logo=gmail&logoColor=white)](mailto:saleksta@gmail.com)
> [![DHS](https://img.shields.io/badge/Data_Source-DHS_Program_2021-0074D9?style=flat-square)](https://dhsprogram.com)
> [![GitHub](https://img.shields.io/badge/GitHub-Repository-181717?style=flat-square&logo=github)](https://github.com/muhammadsalek/SBA-BurkinaFaso-ML-DHS)

</div>

---

## 📌 Table of Contents
- [Project Overview](#-project-overview)
- [Study Design & Data Source](#-study-design--data-source)
- [Repository Structure](#-repository-structure)
- [Tech Stack](#-tech-stack)
- [Analytical Workflow](#-analytical-workflow)
- [Key Findings](#-key-findings)
- [Sensitivity Analysis](#-sensitivity-analysis)
- [Installation & Requirements](#-installation--requirements)
- [Reproducibility Steps](#-reproducibility-steps)
- [Ethical Statement](#-ethical-statement)
- [Citation](#-citation)
- [License](#-license)

---

## 🌟 Project Overview

This repository contains the complete code, supplementary materials, and analysis scripts for the manuscript **"Machine Learning Analysis of Factors Influencing Skilled Birth Attendance in Burkina Faso: Assessing Spatial Inequalities Using Imbalanced Survey Data"**, currently under peer review.

### 🎯 **Research Objectives**

| # | Objective | Methodological Approach |
|---|-----------|-------------------------|
| 1 | **Identify and rank key predictors** of SBA | Five supervised ML algorithms with SHAP explanation |
| 2 | **Explain model predictions** | SHAP for global/local interpretability |
| 3 | **Map spatial inequalities** | Province-level predicted SBA probabilities |
| 4 | **Quantify urban–rural disparities** | Stratified spatial mapping |
| 5 | **Address class imbalance** | SMOTE with rigorous train/test separation |
| 6 | **Evaluate clinical utility** | Decision Curve Analysis (RF, LR, SVM) |
| 7 | **Sensitivity analysis** | Class-weighting vs SMOTE, balanced accuracy |

> ⚠️ **Conceptual Note:** This study adopts a **predictive modeling framework**, not causal inference. All identified variables should be interpreted as *predictors associated with the outcome*, not causal determinants.

---

## 🏗️ Study Design & Data Source

| Attribute | Details |
|-----------|---------|
| **Study Design** | Cross-sectional, secondary data analysis |
| **Data Source** | 2021 Burkina Faso Demographic and Health Survey (BF-DHS) |
| **Sampling Design** | Stratified two-stage cluster sampling |
| **Analytic Sample** | 5,111 ever-married women aged 15–49 with ≥1 live birth in last 5 years |
| **Outcome Variable** | Skilled Birth Attendance (SBA) — binary: skilled vs. unskilled |
| **Access** | [https://dhsprogram.com](https://dhsprogram.com) *(registration required)* |

> ⚠️ Raw DHS microdata are **not redistributed** in this repository in compliance with DHS data use agreements. Please request access directly from the [DHS Program](https://dhsprogram.com/data/dataset_admin/login_main.cfm).

---

## 🗂️ Repository Structure

```
SBA-BurkinaFaso-ML-DHS/
│
├── 📂 Main Scripts
│   ├── Salek_ML(BF)_SBA.R                    # Full ML pipeline: preprocessing, modelling, SHAP, spatial maps
│   ├── Salek_ML_without_Some_Model_train.R   # Alternative training script (subset of models)
│   ├── SBA_ML_Sensitivity_Analysis.R         # Sensitivity analysis: class-weighting vs SMOTE
│   ├── Correltaion Heatmaps.R                # Cramér's V correlation heatmap (Supplementary Figure S7)
│   ├── Precision _recall curve.R             # Precision-recall curves (Supplementary Figure S5)
│   ├── Salek_data manegments_SBA.do          # Stata: DHS data cleaning & variable construction
│   └── Svy_LR(Sensistivity).do               # Stata: survey-weighted logistic regression
│
├── 📂 Data
│   └── DataDHS_cleaned_descriptive.dta       # Cleaned DHS dataset (Stata format; derived variables only)
│
├── 📂 Figures
│   ├── Figure 1.png                          # Study sample selection flowchart
│   ├── Supplementary Figure S1.tiff          # SBA prevalence distribution
│   ├── Supplementary Figure S2.tiff          # Class distribution before & after SMOTE
│   ├── Supplementray Figure S3.tiff          # Boruta feature selection results
│   ├── Suppementary Figure S4.tiff           # Cumulative SHAP contribution plot
│   ├── Supplementary Figure S5.png           # Precision-recall curves across all models
│   ├── Supplementary Figure S6.tiff          # Random Forest confusion matrix
│   ├── Supplementary Figure S7.tiff          # Cramér's V correlation heatmap
│   ├── Supplementary Figure S8.tiff          # Sensitivity: Model comparison (weighted)
│   ├── Supplementary Figure S9.tiff          # Sensitivity: Ranking comparison
│   ├── Supplementary Figure S10.tiff         # Sensitivity: Alternative visualizations
│   └── Supplementary Figure S10(alternatives).tiff  # Alternative sensitivity visualizations
│
├── 📂 Supplementary Tables
│   ├── SUpplementary Tabl S1.docx            # Background characteristics of analytic sample
│   ├── Supplementary Table S2.docx           # Hyperparameter tuning grid (all models)
│   ├── Supplementary Table S3.docx           # Baseline model performance without SMOTE
│   ├── Supplementary Table S4.docx           # Survey-weighted sensitivity analysis results
│   └── Supplementary Table S5.docx           # Sensitivity analysis imbalance-handling
│
├── 📂 Sensitivity Outputs
│   ├── comparison_df.csv                      # Model comparison metrics
│   ├── ranking_df.csv                         # Feature ranking comparison
│   ├── rf_imbalance_comparison.csv            # RF imbalance handling comparison
│   ├── rf_imbalance_ranking.csv               # RF feature ranking comparison
│   └── Supplementary_Table1_RF_Comparison.csv # Comprehensive RF comparison
│
├── 📂 Reference
│   └── Burkina-Faso-DHS-2021(Reports).pdf    # Official BF-DHS 2021 final report
│
├── Table1_SBA_Logistic_Regression.xlsx       # Table 1: ML model performance metrics
├── README.md                                  # Project documentation (this file)
└── LICENSE                                    # MIT License
```

---

## 🛠️ Tech Stack

<div align="center">

| Category | Tools |
|----------|-------|
| **Statistical Computing** | ![R](https://img.shields.io/badge/R_4.2+-276DC3?style=flat-square&logo=r&logoColor=white) ![Stata](https://img.shields.io/badge/Stata_17-1A5276?style=flat-square&logoColor=white) |
| **Machine Learning** | ![RF](https://img.shields.io/badge/Random_Forest-228B22?style=flat-square&logoColor=white) ![SVM](https://img.shields.io/badge/SVM-8E44AD?style=flat-square&logoColor=white) ![KNN](https://img.shields.io/badge/KNN-3498DB?style=flat-square&logoColor=white) |
| **Interpretability** | ![SHAP](https://img.shields.io/badge/SHAP-Explainability-E67E22?style=flat-square&logoColor=white) |
| **Imbalance Handling** | ![SMOTE](https://img.shields.io/badge/SMOTE-Imbalance-E74C3C?style=flat-square&logoColor=white) ![Class-weight](https://img.shields.io/badge/Class--weighting-Sensitivity-2ECC71?style=flat-square) |
| **Spatial Analysis** | ![Spatial](https://img.shields.io/badge/Spatial_Analysis-00BFFF?style=flat-square&logo=mapbox&logoColor=white) |
| **Data Source** | ![DHS](https://img.shields.io/badge/DHS_2021-95A5A6?style=flat-square&logoColor=white) |

</div>

---

## 🔄 Analytical Workflow

```
┌────────────────────────────────────────────────────────────────────────────┐
│                         BF-DHS 2021 Raw Microdata                          │
└────────────────────────────────┬───────────────────────────────────────────┘
                                 │
                                 ▼
┌────────────────────────────────────────────────────────────────────────────┐
│           Data Management & Variable Construction (Stata .do)             │
│   • Outcome coding (SBA binary)     • Covariate harmonization             │
│   • Sampling weight preparation     • Analytic sample restriction         │
│   • Derived variable creation       • Complex survey design handling      │
└────────────────────────────────┬───────────────────────────────────────────┘
                                 │
                                 ▼
┌────────────────────────────────────────────────────────────────────────────┐
│                Missing Data Handling (MICE — MAR assumption)              │
│   • Husband's education (8.9%)     • Pregnancy decisions (~5%)            │
│   • All other variables < 1% missingness                                 │
└────────────────────────────────┬───────────────────────────────────────────┘
                                 │
                                 ▼
┌────────────────────────────────────────────────────────────────────────────┐
│              Feature Selection (Boruta Algorithm — Training Set Only)     │
│   • 17 confirmed relevant predictors retained                            │
│   • Shadow features for statistical significance testing                 │
└────────────────────────────────┬───────────────────────────────────────────┘
                                 │
                                 ▼
┌────────────────────────────────────────────────────────────────────────────┐
│           Stratified Train / Test Split (80% / 20%)                       │
│   • SMOTE applied to training set only                                   │
│   • Test set preserved in original class distribution                    │
│   • Prevents data leakage (critical for imbalanced data)                 │
└────────────────────────────────┬───────────────────────────────────────────┘
                                 │
                                 ▼
┌────────────────────────────────────────────────────────────────────────────┐
│                         Model Training                                    │
│   RF · Decision Tree · KNN · Logistic Regression · SVM                   │
│   10-fold cross-validation · Grid hyperparameter tuning                  │
│   • SMOTE-based training (main analysis)                                 │
│   • Class-weighting (sensitivity analysis)                               │
└────────────────────────────────┬───────────────────────────────────────────┘
                                 │
                                 ▼
┌────────────────────────────────────────────────────────────────────────────┐
│                       Model Evaluation                                    │
│   Accuracy · Precision · Recall · F1 · MCC · Kappa · AUROC               │
│   Calibration plots · Brier scores · PR-AUC curves                       │
│   • Balanced Accuracy (sensitivity analysis)                             │
└────────────────────────────────┬───────────────────────────────────────────┘
                                 │
                                 ▼
┌────────────────────────────────────────────────────────────────────────────┐
│                 SHAP Interpretability (Best Model: RF)                    │
│   • Global feature importance (mean |SHAP|)                               │
│   • Local explanation plots                                               │
│   • Cumulative SHAP contribution analysis                                 │
│   • Sensitivity: SHAP comparison across imbalance methods                │
└────────────────────────────────┬───────────────────────────────────────────┘
                                 │
                                 ▼
┌────────────────────────────────────────────────────────────────────────────┐
│            Clinical Utility & Spatial Analysis                            │
│   • Decision Curve Analysis (DCA) — RF, LR, SVM                          │
│   • Province-level prediction mapping (national)                         │
│   • Urban–rural stratified spatial maps                                  │
└────────────────────────────────┬───────────────────────────────────────────┘
                                 │
                                 ▼
┌────────────────────────────────────────────────────────────────────────────┐
│                    Sensitivity Analysis                                   │
│   • Class-weighting vs SMOTE for RF                                       │
│   • Balanced Accuracy comparison                                          │
│   • Boruta feature stability assessment                                  │
│   • Survey-weighted logistic regression                                   │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## 📊 Key Findings

### 1. Model Performance Comparison

| Model | Accuracy | Precision | Recall | F1-Score | MCC | Kappa | AUROC | Balanced Acc |
|-------|:--------:|:---------:|:------:|:--------:|:---:|:-----:|:-----:|:------------:|
| **Random Forest** | **0.89** | **0.93** | **0.96** | **0.94** | **0.31** | **0.30** | **0.71** | **0.62** |
| SVM | 0.88 | 0.93 | 0.94 | 0.93 | 0.27 | 0.27 | 0.69 | 0.60 |
| Decision Tree | 0.85 | 0.92 | 0.90 | 0.91 | 0.19 | 0.19 | 0.64 | 0.59 |
| KNN | 0.76 | 0.94 | 0.79 | 0.86 | 0.19 | 0.17 | 0.67 | 0.56 |
| Logistic Regression | 0.71 | 0.94 | 0.72 | 0.82 | 0.19 | 0.15 | 0.69 | 0.51 |

<div align="center">
  
![Table 1](Table1_SBA_Logistic_Regression.xlsx)

</div>

> 📌 Due to high class imbalance (90.4% skilled vs 9.6% unskilled), **MCC, AUROC, Balanced Accuracy, and F1-score** are the primary evaluation metrics. Accuracy alone is misleading.

### 2. Top Predictors (SHAP — Random Forest)

| Rank | Predictor | Direction | SHAP Importance |
|------|-----------|-----------|:---------------:|
| 1 | **Province** (esp. Sahel) | ↓ Negative SHAP | 0.245 |
| 2 | **ANC visits ≥ 4** | ↑ Positive SHAP | 0.182 |
| 3 | **Maternal age at first birth ≥ 20 years** | ↑ Positive SHAP | 0.148 |
| 4 | **Current sexual activity** | ↑ Positive SHAP | 0.112 |
| 5 | **Age at first sexual intercourse ≥ 18 years** | ↑ Positive SHAP | 0.098 |
| 6 | **Household wealth** | ↑ Positive SHAP | 0.087 |
| 7 | **Religion** | Variable | 0.076 |
| 8 | **Media/internet exposure** | ↑ Positive SHAP | 0.065 |

### 3. Spatial Patterns

| Region | Predicted SBA Probability | Classification |
|--------|:-------------------------:|----------------|
| Centre, Centre-Nord, Centre-Ouest, Nord, Cascades | 0.60 – 0.80 | 🟢 High coverage |
| Hauts-Bassins, Boucle-du-Mouhoun, Centre-Sud | 0.55 – 0.70 | 🟡 Moderate coverage |
| Sud-Ouest, Est, parts of Centre-Est | 0.30 – 0.50 | 🟠 Low coverage |
| **Sahel** | **0.20 – 0.40** | 🔴 **Lowest coverage — priority zone** |

### 4. Urban–Rural Disparities

```
┌─────────────────────────────────────────────────────────────────┐
│                    Urban vs Rural SBA Prediction                │
├─────────────────────────────────────────────────────────────────┤
│  ████████████████████████████████████  Urban:      0.75       │
│  ████████████████████████████████████  Rural:      0.65       │
├─────────────────────────────────────────────────────────────────┤
│  Gap: 0.10 (10 percentage points)                              │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔬 Sensitivity Analysis

### Class-Weighting vs SMOTE for Random Forest

| Method | Accuracy | Precision | Recall | F1-Score | MCC | Kappa | AUROC | Balanced Acc |
|--------|:--------:|:---------:|:------:|:--------:|:---:|:-----:|:-----:|:------------:|
| **SMOTE** | **0.89** | **0.93** | **0.96** | **0.94** | **0.31** | **0.30** | **0.71** | **0.62** |
| Class-Weighting | 0.87 | 0.95 | 0.90 | 0.93 | 0.26 | 0.26 | 0.70 | 0.60 |

### Key Sensitivity Findings

| Aspect | SMOTE | Class-Weighting | Preferred |
|--------|:-----:|:---------------:|:---------:|
| Recall (Unskilled SBA) | 0.96 | 0.90 | **SMOTE** |
| Balanced Accuracy | 0.62 | 0.60 | **SMOTE** |
| MCC | 0.31 | 0.26 | **SMOTE** |
| Computational Cost | Higher | Lower | Class-Weighting |
| Interpretability | More intuitive | Comparable | SMOTE |

> **Conclusion:** SMOTE provides superior balanced performance, particularly in identifying unskilled birth attendance cases, which is clinically critical for targeted interventions.

---

## ⚡ Installation & Requirements

### R (>= 4.2)

```r
# Core packages
install.packages(c(
  # Data handling
  "tidyverse", "haven", "mice",
  
  # ML modelling
  "caret", "randomForest", "rpart", "e1071", "class",
  
  # Feature selection & imbalance
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

### Stata (>= 17)

```stata
* Required for sensitivity analysis (.do files)
ssc install estout
ssc install svyset   // built-in, ensure updated ado files
```

---

## ♻️ Reproducibility Steps

> Follow these steps in order to fully reproduce all results, figures, and tables.

### Step 1 — Obtain Data
```
1. Register at https://dhsprogram.com
2. Request access to: Burkina Faso DHS 2021 — Individual Recode (IR) dataset
3. Download the Stata-format file (.dta)
```

### Step 2 — Data Management (Stata)
```stata
* Open Stata 17, set working directory, then run:
do "Salek_data manegments_SBA.do"
* Output: DataDHS_cleaned_descriptive.dta
```

### Step 3 — Main ML Analysis (R)
```r
# Set working directory to repository root, then run:
source("Salek_ML(BF)_SBA.R")
# Produces: main figures, Table 1, SHAP plots, spatial maps
```

### Step 4 — Supplementary Figures (R)
```r
source("Correltaion Heatmaps.R")        # → Supplementary Figure S7
source("Precision _recall curve.R")     # → Supplementary Figure S5
```

### Step 5 — Sensitivity Analysis (R)
```r
source("SBA_ML_Sensitivity_Analysis.R")
# Produces: Supplementary Figures S8-S11, Supplementary Tables S5
```

### Step 6 — Sensitivity Analysis (Stata)
```stata
do "Svy_LR(Sensistivity).do"
* Output: Supplementary Table S4 (survey-weighted LR results)
```

### Step 7 — Alternative Model Training (Optional)
```r
source("Salek_ML_without_Some_Model_train.R")   # Subset model comparison
```

---

## 🔏 Ethical Statement

- Ethical approval for the 2021 BF-DHS was obtained from **national ethics committees in Burkina Faso** and the **ICF International Institutional Review Board**
- All data are **anonymized** and publicly available through the DHS Program
- No additional ethical clearance was required for this secondary analysis
- Full details: [https://dhsprogram.com/Methodology/Protecting-the-Privacy-of-DHS-Survey-Respondents.cfm](https://dhsprogram.com/Methodology/Protecting-the-Privacy-of-DHS-Survey-Respondents.cfm)
- Generative AI tools were used **solely for language editing**; all scientific content, analysis, and interpretations are the sole responsibility of the author

---

## 📄 Citation

If you use this code, data pipeline, or analysis in your research, please cite:

```bibtex
@article{miah2025sba,
  author    = {Miah, Md Salek},
  title     = {Machine Learning Analysis of Factors Influencing Skilled Birth Attendance
               in Burkina Faso: Assessing Spatial Inequalities Using Imbalanced Survey Data},
  journal   = {[Under Review]},
  year      = {2025},
  note      = {Manuscript submitted for publication},
  url       = {https://github.com/muhammadsalek/SBA-BurkinaFaso-ML-DHS},
  orcid     = {0009-0005-5973-461X},
  keywords  = {skilled birth attendance, machine learning, Burkina Faso, 
               spatial analysis, imbalanced data, SHAP, maternal health}
}
```

---

## 📜 License

This project is licensed under the [MIT License](LICENSE) — see the LICENSE file for details.

---

## 👨‍🔬 About the Author

<div align="center">

**Md Salek Miah**  
M.Sc. Student in Statistics  
Department of Statistics  
Shahjalal University of Science and Technology  
Sylhet-3114, Bangladesh

**Research Interests:**  
Machine Learning · Maternal & Child Health · Spatial Epidemiology · Survey Data Analysis · Health Equity

</div>

---

<div align="center">

**Made with ❤️ for open science and maternal health equity**

[![GitHub](https://img.shields.io/badge/GitHub-muhammadsalek-181717?style=flat-square&logo=github)](https://github.com/muhammadsalek)
[![ORCID](https://img.shields.io/badge/ORCID-0009--0005--5973--461X-A6CE39?style=flat-square&logo=orcid&logoColor=white)](https://orcid.org/0009-0005-5973-461X)
[![DHS](https://img.shields.io/badge/DHS_Program-Data_Access-0074D9?style=flat-square)](https://dhsprogram.com)
[![ResearchGate](https://img.shields.io/badge/ResearchGate-Profile-00CCBB?style=flat-square&logo=researchgate&logoColor=white)](https://www.researchgate.net/profile/Md-Miah-19)

*Department of Statistics · Shahjalal University of Science and Technology · Sylhet-3114 · Bangladesh*

</div>
