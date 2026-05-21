# 🏥 SBA-BurkinaFaso-ML-DHS

<div align="center">

![R](https://img.shields.io/badge/R-4.2+-276DC3?style=for-the-badge&logo=r&logoColor=white)
![Stata](https://img.shields.io/badge/Stata-17-1A5276?style=for-the-badge&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-2ECC71?style=for-the-badge&logo=opensourceinitiative&logoColor=white)
![Status](https://img.shields.io/badge/Status-Under_Review-F39C12?style=for-the-badge)
![Last Commit](https://img.shields.io/github/last-commit/muhammadsalek/SBA-BurkinaFaso-ML-DHS?style=for-the-badge&color=8E44AD)
![Stars](https://img.shields.io/github/stars/muhammadsalek/SBA-BurkinaFaso-ML-DHS?style=for-the-badge&color=F1C40F)
![Forks](https://img.shields.io/github/forks/muhammadsalek/SBA-BurkinaFaso-ML-DHS?style=for-the-badge&color=1ABC9C)

<br/>

> ### 📄 *"Machine Learning Analysis of Factors Influencing Skilled Birth Attendance in Burkina Faso: Assessing Spatial Inequalities Using Imbalanced Survey Data"*
>
> **Md Salek Miah** · Department of Statistics, Shahjalal University of Science and Technology, Sylhet-3114, Bangladesh
>
> [![ORCID](https://img.shields.io/badge/ORCID-0009--0005--5973--461X-A6CE39?style=flat-square&logo=orcid&logoColor=white)](https://orcid.org/0009-0005-5973-461X)
> [![Email](https://img.shields.io/badge/Email-saleksta%40gmail.com-D44638?style=flat-square&logo=gmail&logoColor=white)](mailto:saleksta@gmail.com)
> [![DHS Data](https://img.shields.io/badge/Data_Source-DHS_Program_2021-0074D9?style=flat-square)](https://dhsprogram.com)

</div>

---

## 📌 Table of Contents

- [Project Overview](#-project-overview)
- [Study Design & Data Source](#-study-design--data-source)
- [Repository Structure](#-repository-structure)
- [Tech Stack](#-tech-stack)
- [Analytical Workflow](#-analytical-workflow)
- [Key Findings](#-key-findings)
- [Installation & Requirements](#-installation--requirements)
- [Reproducibility Steps](#-reproducibility-steps)
- [Ethical Statement](#-ethical-statement)
- [Citation](#-citation)
- [License](#-license)

---

## 🌟 Project Overview

This repository contains all code, supplementary materials, and analysis scripts for the above-named manuscript, submitted for peer review. The study applies an **interpretable machine learning (ML) framework** to nationally representative survey data to:

- 🎯 **Identify and rank key predictors** of Skilled Birth Attendance (SBA) using five supervised ML algorithms
- 🧠 **Explain model predictions** using SHapley Additive exPlanations (**SHAP**) for global and local interpretability
- 🗺️ **Map province-level spatial inequalities** in predicted SBA probabilities across Burkina Faso
- 🏘️ **Quantify urban–rural disparities** to inform context-specific maternal health interventions
- ⚖️ **Address class imbalance** using SMOTE with rigorous train/test separation to avoid data leakage
- 📐 **Evaluate clinical utility** via Decision Curve Analysis (DCA) across RF, LR, and SVM models

> ⚠️ **Conceptual Note:** This study adopts a **predictive modeling framework**, not causal inference. All identified variables should be interpreted as *predictors associated with the outcome*, not causal determinants.

---

## 🏗️ Study Design & Data Source

| Attribute            | Details |
|----------------------|---------|
| **Study Design**     | Cross-sectional, secondary data analysis |
| **Data Source**      | 2021 Burkina Faso Demographic and Health Survey (BF-DHS) |
| **Sampling Design**  | Stratified two-stage cluster sampling |
| **Analytic Sample**  | 5,111 ever-married women aged 15–49 with ≥1 live birth in last 5 years |
| **Outcome Variable** | Skilled Birth Attendance (SBA) — binary: skilled vs. unskilled |
| **Access**           | [https://dhsprogram.com](https://dhsprogram.com) *(registration required)* |

> ⚠️ Raw DHS microdata are **not redistributed** in this repository in compliance with DHS data use agreements. Please request access directly from the [DHS Program](https://dhsprogram.com/data/dataset_admin/login_main.cfm).

---

## 🗂️ Repository Structure

```
SBA-BurkinaFaso-ML-DHS/
│
├── 📂 Main Scripts
│   ├── Salek_ML(BF)_SBA.R                    # Full ML pipeline: preprocessing, modelling, SHAP, spatial maps
│   ├── Salek_ML_without_Some_Model_train.R   # Alternative training script (subset of models)
│   ├── Correltaion Heatmaps.R                # Cramér's V correlation heatmap (Supplementary Figure S7)
│   ├── Precision _recall curve.R             # Precision-recall curves (Supplementary Figure S5)
│   ├── Salek_data manegments_SBA.do          # Stata: DHS data cleaning & variable construction
│   └── Svy_LR(Sensistivity).do               # Stata: survey-weighted logistic regression (sensitivity analysis)
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
│   └── Supplementary Figure S7.tiff          # Cramér's V correlation heatmap
│
├── 📂 Supplementary Tables
│   ├── SUpplementary Tabl S1.docx            # Background characteristics of analytic sample
│   ├── Supplementary Table S2.docx           # Hyperparameter tuning grid (all models)
│   ├── Supplementary Table S3.docx           # Baseline model performance without SMOTE
│   └── Supplementary Table S4.docx           # Survey-weighted sensitivity analysis results
│
├── 📂 Reference
│   └── Burkina-Faso-DHS-2021(Reports).pdf    # Official BF-DHS 2021 final report
│
├── Table1_SBA_Logistic_Regression.xlsx        # Table 1: ML model performance metrics
├── README.md                                  # Project documentation (this file)
└── LICENSE                                    # MIT License
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
│   • SMOTE applied to training set only                              │
│   • Test set preserved in original class distribution               │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      Model Training                                 │
│   RF · Decision Tree · KNN · Logistic Regression · SVM             │
│   10-fold cross-validation · Grid hyperparameter tuning             │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     Model Evaluation                                │
│   Accuracy · Precision · Recall · F1 · MCC · Kappa · AUROC         │
│   Calibration plots · Brier scores · PR-AUC curves                 │
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
│   • Decision Curve Analysis (DCA) — RF, LR, SVM                    │
│   • Province-level prediction mapping (national)                    │
│   • Urban–rural stratified spatial maps                             │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📊 Key Findings

### Model Performance Comparison

| Model               | Accuracy | Precision | Recall | F1-Score | MCC  | Kappa | AUROC |
|---------------------|:--------:|:---------:|:------:|:--------:|:----:|:-----:|:-----:|
| 🏆 **Random Forest**| **0.89** | **0.93**  | **0.96**| **0.94**|**0.31**|**0.30**|**0.71**|
| SVM                 | 0.88     | 0.93      | 0.94   | 0.93     | 0.27 | 0.27  | 0.69  |
| Decision Tree       | 0.85     | 0.92      | 0.90   | 0.91     | 0.19 | 0.19  | 0.64  |
| KNN                 | 0.76     | 0.94      | 0.79   | 0.86     | 0.19 | 0.17  | 0.67  |
| Logistic Regression | 0.71     | 0.94      | 0.72   | 0.82     | 0.19 | 0.15  | 0.69  |

> 📌 Due to high class imbalance (90.4% skilled vs 9.6% unskilled), **MCC, AUROC, and F1-score** are the primary evaluation metrics. Accuracy alone is misleading.

### Top Predictors (SHAP — Random Forest)

| Rank | Predictor | Direction |
|------|-----------|-----------|
| 1 | **Province** (esp. Sahel) | ↓ Negative SHAP (lower SBA probability) |
| 2 | **ANC visits ≥ 4** | ↑ Positive SHAP |
| 3 | **Maternal age at first birth ≥ 20 years** | ↑ Positive SHAP |
| 4 | **Current sexual activity** | ↑ Positive SHAP |
| 5 | **Age at first sexual intercourse ≥ 18 years** | ↑ Positive SHAP |
| 6 | **Household wealth** | ↑ Positive SHAP |
| 7 | **Religion** | Variable |
| 8 | **Media/internet exposure** | ↑ Positive SHAP |

### Spatial Patterns

| Region | Predicted SBA Probability | Classification |
|--------|--------------------------|----------------|
| Centre, Centre-Nord, Centre-Ouest, Nord, Cascades | 0.60 – 0.80 | 🟢 High coverage |
| Hauts-Bassins, Boucle-du-Mouhoun, Centre-Sud | 0.55 – 0.70 | 🟡 Moderate coverage |
| Sud-Ouest, Est, parts of Centre-Est | 0.30 – 0.50 | 🟠 Low coverage |
| **Sahel** | **0.20 – 0.40** | 🔴 Lowest coverage — priority zone |

---

## ⚡ Installation & Requirements

### R (>= 4.2)

```r
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

> Follow these steps in order to fully reproduce all results, figures, and tables reported in the manuscript.

**Step 1 — Obtain Data**
```
1. Register at https://dhsprogram.com
2. Request access to: Burkina Faso DHS 2021 — Individual Recode (IR) dataset
3. Download the Stata-format file (.dta)
```

**Step 2 — Data Management (Stata)**
```stata
* Open Stata 17, set working directory, then run:
do "Salek_data manegments_SBA.do"
* Output: DataDHS_cleaned_descriptive.dta
```

**Step 3 — Main ML Analysis (R)**
```r
# Set working directory to repository root, then run:
source("Salek_ML(BF)_SBA.R")
# Produces: all main figures, Table 1, SHAP plots, spatial maps
```

**Step 4 — Supplementary Figures (R)**
```r
source("Correltaion Heatmaps.R")        # → Supplementary Figure S7
source("Precision _recall curve.R")     # → Supplementary Figure S5
```

**Step 5 — Sensitivity Analysis (Stata)**
```stata
do "Svy_LR(Sensistivity).do"
* Output: Supplementary Table S4 (survey-weighted LR results)
```

**Step 6 — Alternative Model Training (Optional)**
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
  orcid     = {0009-0005-5973-461X}
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

*Department of Statistics · Shahjalal University of Science and Technology · Sylhet-3114 · Bangladesh*

</div>
