Here's the README code for your repository:

```markdown
# SBA-BurkinaFaso-ML-DHS
![R](https://img.shields.io/badge/R-4.2+-blue?logo=r&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?logo=github)
![Status](https://img.shields.io/badge/Status-Active-brightgreen)
![Last Commit](https://img.shields.io/github/last-commit/muhammadsalek/SBA-BurkinaFaso-ML-DHS)
![Stars](https://img.shields.io/github/stars/muhammadsalek/SBA-BurkinaFaso-ML-DHS?style=social)
![Forks](https://img.shields.io/github/forks/muhammadsalek/SBA-BurkinaFaso-ML-DHS?style=social)

---

## 🌟 Project Overview

This repository contains code and analysis for:

*"Machine Learning Analysis of Factors Influencing Skilled Birth Attendance in Burkina Faso: Assessing Spatial Inequalities Using Imbalanced Survey Data"*

**Goals:**
- Identify and rank key predictors of **Skilled Birth Attendance (SBA)** using supervised machine learning models.
- Apply **explainable ML models**: Random Forest, Decision Tree, K-Nearest Neighbors, Logistic Regression, and SVM.
- Interpret model outputs with **SHAP** (SHapley Additive exPlanations) for global and local feature importance.
- Visualize **province-level spatial inequalities** in SBA coverage across Burkina Faso.
- Examine **urban–rural disparities** to inform context-specific maternal health interventions.
- Provide actionable, data-driven insights for **maternal health policy** in Burkina Faso.

---

## 🗂 Repository Structure

| File / Folder                          | Description |
|----------------------------------------|-------------|
| `Salek_ML(BF)_SBA.R`                  | Main R script: preprocessing, ML modelling, SHAP, spatial mapping |
| `Salek_ML_without_Some_Model_train.R` | Alternative model training script (subset of models) |
| `Salek_data manegments_SBA.do`        | Stata data management script for DHS preprocessing |
| `Svy_LR(Sensistivity).do`             | Stata script for survey-weighted logistic regression (sensitivity analysis) |
| `Correltaion Heatmaps.R`              | R script for Cramér's V correlation heatmap |
| `Precision _recall curve.R`           | R script for precision-recall curve visualization |
| `DataDHS_cleaned_descriptive.dta`     | Cleaned DHS dataset (Stata format) |
| `Table1_SBA_Logistic_Regression.xlsx` | Supplementary Table 1 – descriptive and logistic regression results |
| `SUpplementary Tabl S1.docx`          | Supplementary Table S1 – background characteristics |
| `Supplementary Table S2.docx`         | Supplementary Table S2 – hyperparameter tuning grid |
| `Supplementary Table S3.docx`         | Supplementary Table S3 – baseline model performance (without SMOTE) |
| `Supplementary Table S4.docx`         | Supplementary Table S4 – survey-weighted sensitivity analysis |
| `Supplementary Figure S1.tiff`        | SBA prevalence distribution |
| `Supplementary Figure S2.tiff`        | Class distribution before and after SMOTE |
| `Supplementary Figure S3.tiff` (sic)  | Boruta feature selection results |
| `Suppementary Figure S4.tiff`         | Cumulative SHAP contribution plot |
| `Supplementary Figure S5.png`         | Precision-recall curves across models |
| `Supplementary Figure S6.tiff`        | Random Forest confusion matrix |
| `Supplementary Figure S7.tiff`        | Cramér's V correlation heatmap |
| `Figure 1.png`                        | Study sample flowchart |
| `Burkina-Faso-DHS-2021(Reports).pdf`  | Official BF-DHS 2021 report (reference) |
| `README.md`                           | Project documentation |
| `LICENSE`                             | MIT License |

---

## 🛠 Tech Stack

![R](https://img.shields.io/badge/R-4.2+-blue?logo=r&logoColor=white)
![Stata](https://img.shields.io/badge/Stata-17-darkblue?logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PC9zdmc+&logoColor=white)
![ML](https://img.shields.io/badge/Machine_Learning-F50057?logo=scikitlearn&logoColor=white)
![SHAP](https://img.shields.io/badge/SHAP-Explainability-orange)
![Spatial](https://img.shields.io/badge/Spatial_Analysis-00BFFF?logo=mapbox&logoColor=white)
![DHS](https://img.shields.io/badge/Data-DHS_2021-lightgrey)

---

## ⚡ Installation & Requirements

- **R version:** >= 4.2
- **Stata version:** >= 17 (for `.do` files)
- **Required R Packages:**

```r
install.packages(c(
  "tidyverse", "caret", "Boruta", "randomForest", "rpart",
  "e1071", "class", "mice", "themis", "recipes",
  "shapr", "shapviz", "rmda", "sf", "ggplot2",
  "pROC", "MLmetrics", "corrplot", "haven"
))
```

---

## 🔄 Workflow

```
Raw BF-DHS 2021 Data
        │
        ▼
Data Management (Salek_data manegments_SBA.do)
        │
        ▼
Missing Data Imputation (MICE) + Feature Selection (Boruta)
        │
        ▼
Train/Test Split (80/20, stratified) + SMOTE (training only)
        │
        ▼
Model Training: RF · DT · KNN · LR · SVM
(10-fold CV + grid hyperparameter tuning)
        │
        ▼
Evaluation: Accuracy · Precision · Recall · F1 · MCC · Kappa · AUROC
        │
        ▼
SHAP Interpretability (global + local feature importance)
        │
        ▼
Decision Curve Analysis (DCA) + Spatial Prediction Mapping
        │
        ▼
Urban–Rural Subgroup Analysis + Sensitivity Analysis (Stata)
```

---

## 📊 Key Findings

- **Best model:** Random Forest (AUROC = 0.71, F1 = 0.94, MCC = 0.31)
- **Top predictors (SHAP):** Province (especially Sahel), ANC visits ≥4, maternal age at first birth ≥20 years, age at first sexual intercourse ≥18 years, current sexual activity, household wealth, and religion
- **Spatial patterns:** High SBA probabilities in central and western provinces (Centre, Centre-Nord, Boucle-du-Mouhoun); persistently low coverage in Sahel, Sud-Ouest, and Est
- **Urban–rural gap:** Sharper inequities in rural peripheral zones; even urban Sahel showed low predicted SBA probabilities
- **Class imbalance:** Without SMOTE, AUROC ranged 0.51–0.59; SMOTE substantially improved minority class detection

| Model              | Accuracy | F1   | MCC  | AUROC |
|--------------------|----------|------|------|-------|
| Random Forest      | 0.89     | 0.94 | 0.31 | 0.71  |
| SVM                | 0.88     | 0.93 | 0.27 | 0.69  |
| Logistic Regression| 0.71     | 0.82 | 0.19 | 0.69  |
| KNN                | 0.76     | 0.86 | 0.19 | 0.67  |
| Decision Tree      | 0.85     | 0.91 | 0.19 | 0.64  |

---

## 📁 Data Source

- **Survey:** 2021 Burkina Faso Demographic and Health Survey (BF-DHS)
- **Access:** Publicly available at [https://dhsprogram.com](https://dhsprogram.com) (registration required)
- **Sample:** 5,111 ever-married women aged 15–49 with at least one live birth in the five years preceding the survey

> ⚠️ The raw DHS microdata are not redistributed in this repository in compliance with DHS data use agreements. Request access directly from the DHS Program.

---

## ♻️ Reproducibility

1. Download BF-DHS 2021 individual recode (`IR`) dataset from [dhsprogram.com](https://dhsprogram.com)
2. Run `Salek_data manegments_SBA.do` in Stata 17 to clean and prepare the dataset → exports `DataDHS_cleaned_descriptive.dta`
3. Run `Salek_ML(BF)_SBA.R` in R (>= 4.2) for full ML pipeline, SHAP analysis, and spatial maps
4. Run `Correltaion Heatmaps.R` for Cramér's V heatmap (Supplementary Figure S7)
5. Run `Precision _recall curve.R` for PR curves (Supplementary Figure S5)
6. Run `Svy_LR(Sensistivity).do` in Stata 17 for survey-weighted sensitivity analysis (Supplementary Table S4)

---

## 📄 Citation

If you use this code or analysis, please cite:

> Miah, M. S. (2025). *Machine Learning Analysis of Factors Influencing Skilled Birth Attendance in Burkina Faso: Assessing Spatial Inequalities Using Imbalanced Survey Data*. [Manuscript under review].

```bibtex
@article{miah2025sba,
  author  = {Miah, Md Salek},
  title   = {Machine Learning Analysis of Factors Influencing Skilled Birth Attendance in Burkina Faso: Assessing Spatial Inequalities Using Imbalanced Survey Data},
  year    = {2025},
  note    = {Manuscript under review},
  url     = {https://github.com/muhammadsalek/SBA-BurkinaFaso-ML-DHS}
}
```

---

## 📬 Contact

**Md Salek Miah**  
Department of Statistics, Shahjalal University of Science and Technology, Sylhet-3114, Bangladesh  
📧 saleksta@gmail.com  
🔗 ORCID: [0009-0005-5973-461X](https://orcid.org/0009-0005-5973-461X)

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).

---

> *This study adopts a predictive modeling framework. Variables identified should be interpreted as predictive factors associated with the outcome, not causal determinants.*
```

This README covers everything: study objective, DHS source, full workflow diagram, package requirements, reproducibility steps, key findings table, and citation info — all matching the style of your BDHS example.
