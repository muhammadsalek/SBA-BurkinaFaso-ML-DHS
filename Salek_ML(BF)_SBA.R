












####  Required Packages ####

install.packages(c("caret", "randomForest", "ranger", "mlr3", "data.table", "themis","tidymodels", "shapviz"))





install.packages(c(
  "ggplot2",
  "pROC",
  "precrec",
  "DescTools",
  "ggpubr",
  "iml",
  "DALEX",
  "dplyr",
  "fmsb"
))




install.packages("MLmetrics")
# Install BiocManager if not already installed
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")













# Load necessary package
if(!require(mice)) install.packages("mice")
library(mice)




install.packages(c("tidyverse","caret","Boruta","smotefamily","randomForest",
                   "rpart","e1071","xgboost","nnet","pROC","mccr"))






# Basic packages
install.packages(c("tidyverse", "caret", "MLmetrics", "randomForest", "e1071", "rpart", "rpart.plot", "pROC"))




##### Identify Risk Factors of Skilled Birth Assistance (SBA) #####
##### Using Machine Learning Approach #####


#### A. Load Packages ####
packages <- c("haven", "dplyr", "mice", "caret", "neuralnet", "e1071", "kknn",
              "randomForest", "rpart", "MASS", "xgboost", "adabag", "pROC")
install.packages(setdiff(packages, installed.packages()[,1]))
lapply(packages, library, character.only = TRUE)












# Load them
library(tidyverse)
library(caret)
library(MLmetrics)
library(randomForest)
library(e1071)
library(rpart)
library(rpart.plot)
library(pROC)







library(tidyverse)
library(caret)
library(Boruta)
library(smotefamily)       # for SMOTE
library(pROC)       # for AUROC
library(mccr)       # for MCC





library(tidyverse)
library(caret)
library(Boruta)
library(smotefamily)  # for SMOTE
library(randomForest)
library(rpart)
library(e1071)
library(xgboost)
library(nnet)
library(pROC)
library(mccr)



library(haven)
library(tidyverse)
library(caret)
library(Boruta)
library(smotefamily)  # for SMOTE
library(randomForest)
library(rpart)
library(e1071)
library(xgboost)
library(nnet)
library(pROC)
library(mccr)







#  Identifyting Risk Factors of skill Birth Assistance using Machine Learning Approach
# Pipeline :Clean & Impute → Split → Training only (SMOTE → Boruta → CV training) → Test only → Report


####  Load Data ####
#data <- read_dta("D:\\Research\\BDHS Research\\Nepal\\SBA\\ML Analysis\\data\\BDHS_cleaned_ml.dta")


library(haven)
# Read the Stata file
data <- read_dta("D:/Research/BDHS Research/Nepal/SBA/Burkina Faso/Data/DataDHS_cleaned_descriptive.dta")

# Check the first few rows
head(data)

colnames(data)



#### Explore ####



table(data$SBA, useNA = "ifany")



# Now check again
sapply(data, class)


# Check structure
str(data)

# Check missing values
colSums(is.na(data))

is.na(data)







#### Outcome variable define ####
library(haven)
library(dplyr)

# Step 1: Convert labelled variables to factor (with labels)
data <- data %>%
  mutate(across(where(is.labelled), ~as_factor(.)))

# Step 2: Specifically ensure SBA factor is correctly labelled
data$SBA <- factor(data$SBA,
                   levels = c("Unskilled birth attendant", "Skilled birth attendant"),
                   labels = c("Unskilled", "Skilled"))

# Step 3: Check outcome variable
table(data$SBA, useNA = "ifany")
levels(data$SBA)



colSums(is.na(data))





# Now check again
sapply(data, class)


# Check structure
str(data)


table(data$SBA)




library(ggplot2)

sba_counts <- table(data$SBA)
pie(sba_counts,
    main = "SBA Prevalence",
    col = c("#E69F00", "#56B4E9"))






library(dplyr)
library(ggplot2)

sba_data <- data %>%
  group_by(SBA) %>%
  summarise(n = n()) %>%
  mutate(percent = n / sum(n) * 100)

ggplot(sba_data, aes(x = "", y = percent, fill = SBA)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y") +
  labs(title = "SBA Prevalence (%)", fill = "SBA Status") +
  geom_text(aes(label = paste0(round(percent, 1), "%")),
            position = position_stack(vjust = 0.5)) +
  theme_void()





library(plotrix)

sba_counts <- table(data$SBA)

pie3D(sba_counts,
      labels = paste0(names(sba_counts), " (", sba_counts, ")"),
      explode = 0.05,
      main = " SBA Prevalence",
      labelcex = 1.0,
      theta = 0.9,
      radius = 1.7)





library(plotrix)

sba_counts <- table(data$SBA)
sba_percent <- round(sba_counts / sum(sba_counts) * 100, 1)

pie3D(sba_counts,
      labels = paste0(names(sba_counts), " (", sba_percent, "%)"),
      explode = 0.05,
      main = "SBA Prevalence (%)",
      labelcex = 1.0,
      theta = 0.9,
      radius = 1.7)




ggplot(sba_data, aes(x = "", y = percent, fill = SBA)) +
  geom_bar(stat = "identity", width = 1, color="grey20") +
  coord_polar("y") +
  labs(title = "SBA Prevalence", fill = "SBA Status") +
  geom_text(aes(label = paste0(round(percent, 1), "%")),
            position = position_stack(vjust = 0.5),
            fontface="bold",
            color="white") +
  theme_void() +
  theme(
    plot.background = element_rect(fill="#f0f0f0"),
    legend.position = "bottom"
  )









ggplot(sba_data, aes(x = "", y = percent, fill = SBA)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y") +
  labs(title = "SBA prevalence (3D shaded)", fill = "SBA") +
  geom_text(aes(label = paste0(round(percent, 1), "%")),
            position = position_stack(vjust = 0.5),
            color="black") +
  scale_fill_manual(values=c("#FFD77A", "#72B2E1")) +
  theme_void()






#### 2. Missing Value Imputation ####

library(dplyr)
library(haven)
library(mice)

# Convert labelled variables to factors (or numeric if needed)
data_clean <- data %>%
  mutate(across(where(is.labelled), ~ as_factor(.)))  # labelled -> factor

# Optional: convert labelled numeric to numeric
data_clean <- data_clean %>%
  mutate(across(where(is.labelled), ~ as.numeric(.)))

# Now check again
sapply(data_clean, class)

# Exclude outcome variable SBA from imputation


data_impute <- dplyr::select(data_clean, -SBA)


# Define methods for each variable type
method_vec <- sapply(data_impute, function(x){
  if (is.numeric(x)) "pmm"                     # Predictive mean matching for numeric
  else if (is.factor(x) & length(levels(x)) == 2) "logreg"  # Logistic for binary
  else if (is.factor(x)) "polyreg"             # Polytomous regression for >2 categories
  else ""
})

# Run MICE
imp <- mice(data_impute, m = 5, method = method_vec, seed = 123)

# View imputation summary
summary(imp)

# Get the completed dataset (first imputed dataset)
data_imputed <- complete(imp, 1)

# Add SBA back to the completed dataset
data_imputed$SBA <- data_clean$SBA

# Check final dataset
str(data_imputed)
colSums(is.na(data_imputed))



is.na(data_imputed)





#### data Distribution ####




# Frequency table
table(data_imputed$SBA)

# Percentage table
prop.table(table(data_imputed$SBA)) * 100

# Optionally, combined view
sba_dist <- data.frame(
  Category = levels(data_imputed$SBA),
  Count = as.vector(table(data_imputed$SBA)),
  Percentage = round(prop.table(table(data_imputed$SBA)) * 100, 2)
)
sba_dist




#### Train–Test Split (80:20)####


library(caret)
set.seed(123)

# Stratified split to maintain class proportions
train_index <- createDataPartition(data_imputed$SBA, p = 0.8, list = FALSE)
train_data <- data_imputed[train_index, ]
test_data  <- data_imputed[-train_index, ]

# Check distribution in training set
prop.table(table(train_data$SBA)) * 100
























#### Train–Test Split (80:20)####


library(caret)
set.seed(123)

# Stratified split to maintain class proportions
train_index <- createDataPartition(data_imputed$SBA, p = 0.8, list = FALSE)
train_data <- data_imputed[train_index, ]
test_data  <- data_imputed[-train_index, ]

# Check distribution in training set
prop.table(table(train_data$SBA)) * 100

















#### 3. Feature Selection with Boruta (Training Set Only) ####




#### 3. Feature Selection with Boruta (Training Set Only) ####

library(Boruta)
library(caret)
library(dplyr)

# Ensure outcome is factor
train_data$SBA <- as.factor(train_data$SBA)

# Identify numeric predictors
num_vars <- names(train_data)[sapply(train_data, is.numeric)]

# Only scale numeric predictors if >1 numeric column exists
if(length(num_vars) > 1){
  train_data[num_vars] <- scale(train_data[num_vars])
  
  # Compute correlation matrix
  cor_mat <- cor(train_data[, num_vars])
  
  # Remove highly correlated numeric predictors (cutoff = 0.9)
  highCor <- findCorrelation(cor_mat, cutoff = 0.9)
  
  if(length(highCor) > 0){
    cat("Removing highly correlated numeric predictors:\n")
    print(num_vars[highCor])
    train_data <- train_data[, -which(names(train_data) %in% num_vars[highCor])]
  }
} else {
  cat("Not enough numeric variables to compute correlation. Skipping correlation removal.\n")
}

# Run Boruta
set.seed(123)
boruta_result <- Boruta(SBA ~ ., data = train_data, doTrace = 2, maxRuns = 200)

# Tentative rough fix
boruta_final <- TentativeRoughFix(boruta_result)

# Selected predictors
final_vars <- getSelectedAttributes(boruta_final, withTentative = FALSE)
print(final_vars)

# Reduce training set to Boruta-selected predictors + outcome
train_boruta <- train_data[, c(final_vars, "SBA")]







# Boruta feature importance plot
plot(boruta_final, 
     cex.axis = 0.7,    # axis text size
     las = 2,           # vertical axis labels
     xlab = "", 
     main = "Boruta Feature Importance")








# Feature importance summary
boruta_stats <- attStats(boruta_final)
boruta_stats[, c("meanImp", "medianImp", "decision")]












#### Boruta feature Importance ####

library(ggplot2)

# Boruta importance stats
boruta_stats <- attStats(boruta_final)

# Prepare dataframe for ggplot
boruta_plot_df <- data.frame(
  Feature = rownames(boruta_stats),
  MeanImp = boruta_stats$meanImp,
  MinImp = boruta_stats$minImp,
  MaxImp = boruta_stats$maxImp,
  Decision = boruta_stats$decision
)

# Order features by mean importance (descending)
boruta_plot_df$Feature <- factor(boruta_plot_df$Feature,
                                 levels = boruta_plot_df$Feature[order(boruta_plot_df$MeanImp, decreasing = TRUE)])

# Plot
ggplot(boruta_plot_df, aes(x = Feature, y = MeanImp, fill = Decision)) +
  geom_bar(stat = "identity", color = "black", width = 0.7) +
  geom_errorbar(aes(ymin = MinImp, ymax = MaxImp), width = 0.3, color = "black") +
  coord_flip() +   # horizontal bars
  scale_fill_manual(values = c("Confirmed" = "#1b9e77", "Rejected" = "#d95f02", "Tentative" = "#7570b3")) +
  labs(title = "Boruta Feature Importance",
       y = "Mean Importance (with min–max)", x = "") +
  theme_minimal(base_size = 14) +
  theme(legend.title = element_blank())










library(ggplot2)

# Boruta importance stats
boruta_stats <- attStats(boruta_final)

# Prepare dataframe for ggplot
boruta_plot_df <- data.frame(
  Feature = rownames(boruta_stats),
  MeanImp = boruta_stats$meanImp,
  MinImp = boruta_stats$minImp,
  MaxImp = boruta_stats$maxImp,
  Decision = boruta_stats$decision
)

# Order features by mean importance (descending)
boruta_plot_df$Feature <- factor(boruta_plot_df$Feature,
                                 levels = boruta_plot_df$Feature[order(boruta_plot_df$MeanImp, decreasing = TRUE)])

# Journal-style colors
journal_colors <- c("Confirmed" = "#0072B2", "Rejected" = "#D55E00", "Tentative" = "#F0E442")

# Polished ggplot
ggplot(boruta_plot_df, aes(x = Feature, y = MeanImp, fill = Decision)) +
  geom_bar(stat = "identity", color = "black", width = 0.7) +
  geom_errorbar(aes(ymin = MinImp, ymax = MaxImp), width = 0.3, color = "black") +
  coord_flip() +   # horizontal bars
  scale_fill_manual(values = journal_colors) +
  labs(title = "Boruta Feature Importance",
       y = "Mean Importance (with min–max)", x = "") +
  theme_minimal(base_size = 16) +
  theme(
    axis.text.y = element_text(face = "bold", size = 12),
    axis.text.x = element_text(face = "bold", size = 12),
    axis.title.y = element_text(face = "bold", size = 14),
    axis.title.x = element_text(face = "bold", size = 14),
    legend.text = element_text(face = "bold", size = 12),
    legend.position = "top",
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5)
  )







#### Handle Class Imbalance (Training set only) with SMOTE####
library(tidymodels)
library(themis)




#### 4. Handle Class Imbalance on Boruta-selected predictors only ####
library(tidymodels)
library(themis)

# Step 1: Use Boruta-selected training data
train_boruta_ml <- train_boruta

# Step 2: Define recipe with dummy variables + SMOTE
rec <- recipe(SBA ~ ., data = train_boruta_ml) %>%
  step_dummy(all_nominal_predictors(), -all_outcomes()) %>%  # factors -> dummies
  step_smote(SBA)  # oversample minority class

# Step 3: Prepare the recipe and bake to get SMOTE-augmented training data
train_smote <- bake(prep(rec), new_data = NULL)

# Step 4: Check new class distribution
table(train_smote$SBA)
prop.table(table(train_smote$SBA)) * 100



prop.table(table(train_boruta$SBA)) * 100
# Unskilled   Skilled 
#   ~27.5      ~72.5




# Original SBA distribution
orig_dist <- prop.table(table(data_imputed$SBA)) * 100
orig_dist




# Boruta-selected predictors training set distribution
boruta_dist <- prop.table(table(train_boruta$SBA)) * 100
boruta_dist





print(train_boruta)


#### Smote before after visualization ####




library(ggplot2)
library(dplyr)
library(scales)

# Prepare data for plotting
dist_plot <- data.frame(
  SBA = rep(c("Unskilled", "Skilled"), 2),
  Percentage = c(
    prop.table(table(train_boruta$SBA)) * 100,  # Before SMOTE (Boruta-selected)
    prop.table(table(train_smote$SBA)) * 100    # After SMOTE
  ),
  Stage = rep(c("Before SMOTE", "After SMOTE"), each = 2)
)

# Journal-style colors (muted, professional)
journal_colors <- c("Unskilled" = "#D55E00",  # reddish-orange
                    "Skilled" = "#0072B2")   # blue

# Plot
ggplot(dist_plot, aes(x = Stage, y = Percentage, fill = SBA)) +
  geom_bar(stat = "identity", position = "fill", width = 0.6, color = "black", size = 0.5) +
  geom_text(aes(label = paste0(round(Percentage,1), "%")),
            position = position_fill(vjust = 0.5),
            size = 5, fontface = "bold", color = "white") +
  scale_fill_manual(values = journal_colors) +
  scale_y_continuous(labels = percent_format()) +
  labs(x = NULL, y = "Percentage") +
  theme_minimal(base_size = 16) +
  theme(
    legend.title = element_blank(),
    legend.position = "top",
    axis.text.x = element_text(size = 14, face = "bold"),
    axis.text.y = element_text(size = 14, face = "bold")
  )











library(ggplot2)
library(dplyr)
library(scales)

# Prepare data for plotting
dist_plot <- data.frame(
  SBA = rep(c("Unskilled", "Skilled"), 2),
  Percentage = c(
    prop.table(table(train_boruta$SBA)) * 100,  # Before SMOTE
    prop.table(table(train_smote$SBA)) * 100    # After SMOTE
  ),
  Stage = rep(c("Before SMOTE", "After SMOTE"), each = 2)
)

# Distinct colors for each SBA category
sba_colors <- c("Before SMOTE_Unskilled" = "#E69F00",
                "Before SMOTE_Skilled" = "#56B4E9",
                "After SMOTE_Unskilled" = "#F0E442",
                "After SMOTE_Skilled" = "#009E73")

# Combine Stage and SBA for mapping colors
dist_plot$SBA_stage <- paste(dist_plot$Stage, dist_plot$SBA, sep = "_")

# Plot
ggplot(dist_plot, aes(x = Stage, y = Percentage, fill = SBA_stage)) +
  geom_bar(stat = "identity", position = "fill", width = 0.6, color = "black", size = 0.5) +
  geom_text(aes(label = paste0(round(Percentage,1), "%"), group = SBA),
            position = position_fill(vjust = 0.5),
            size = 5, fontface = "bold", color = "white") +
  scale_fill_manual(values = sba_colors,
                    labels = c("Unskilled (Before)", "Skilled (Before)",
                               "Unskilled (After)", "Skilled (After)")) +
  scale_y_continuous(labels = percent_format()) +
  labs(x = NULL, y = "Percentage") +
  theme_minimal(base_size = 16) +
  theme(
    legend.title = element_blank(),
    legend.position = "top",
    axis.text.x = element_text(size = 14, face = "bold"),
    axis.text.y = element_text(size = 14, face = "bold")
  )














library(ggplot2)
library(dplyr)
library(scales)

# Prepare data
dist_plot <- data.frame(
  SBA = rep(c("Unskilled", "Skilled"), 2),
  Percentage = c(
    prop.table(table(train_data$SBA)) * 100,   # Before SMOTE
    prop.table(table(train_smote$SBA)) * 100   # After SMOTE
  ),
  Stage = rep(c("Before SMOTE", "After SMOTE"), each = 2)
)

# Plot with only 2 colors for SBA
ggplot(dist_plot, aes(x = Stage, y = Percentage, fill = SBA)) +
  geom_bar(stat = "identity", position = "fill", width = 0.6, color = "black", size = 0.5) +
  geom_text(aes(label = paste0(round(Percentage,1), "%")),
            position = position_fill(vjust = 0.5),
            size = 5, fontface = "bold", color = "white") +
  scale_fill_manual(values = c("Unskilled"="#E69F00", "Skilled"="#56B4E9")) +
  scale_y_continuous(labels = percent_format()) +
  labs(x = NULL, y = "Percentage") +
  theme_minimal(base_size = 16) +
  theme(
    legend.title = element_blank(),
    legend.position = "top",
    axis.text.x = element_text(size = 14, face = "bold"),
    axis.text.y = element_text(size = 14, face = "bold")
  )









library(ggplot2)
library(dplyr)
library(scales)

# Prepare data
dist_plot <- data.frame(
  SBA = rep(c("Unskilled", "Skilled"), 2),
  Percentage = c(
    prop.table(table(train_data$SBA)) * 100,   # Before SMOTE
    prop.table(table(train_smote$SBA)) * 100   # After SMOTE
  ),
  Stage = rep(c("Before SMOTE", "After SMOTE"), each = 2)
)

# Plot with updated colors
ggplot(dist_plot, aes(x = Stage, y = Percentage, fill = SBA)) +
  geom_bar(stat = "identity", position = "fill", width = 0.6, color = "black", size = 0.5) +
  geom_text(aes(label = paste0(round(Percentage,1), "%")),
            position = position_fill(vjust = 0.5),
            size = 5, fontface = "bold", color = "white") +
  # Alternative colors
  scale_fill_manual(values = c("Unskilled"="#D55E00", "Skilled"="#0072B2")) +
  scale_y_continuous(labels = percent_format()) +
  labs(x = NULL, y = "Percentage") +
  theme_minimal(base_size = 16) +
  theme(
    legend.title = element_blank(),
    legend.position = "top",
    axis.text.x = element_text(size = 14, face = "bold"),
    axis.text.y = element_text(size = 14, face = "bold")
  )









ggplot(dist_plot, aes(x = Stage, y = Percentage, fill = SBA_stage)) +
  geom_bar(stat = "identity", position = "fill", width = 0.6,
           color = "black", size = 0.5) +
  geom_text(aes(label = paste0(round(Percentage, 1), "%"), group = SBA),
            position = position_fill(vjust = 0.5),
            size = 5, fontface = "bold", color = "white") +
  scale_fill_manual(values = sba_colors) +
  scale_y_continuous(labels = percent_format()) +
  labs(x = NULL, y = "Percentage") +
  theme_minimal(base_size = 16) +
  theme(
    legend.position = "none",
    axis.text.x = element_text(size = 14, face = "bold"),
    axis.text.y = element_text(size = 14, face = "bold")
  )




#### Model development ####


# Step 4: Check new class distribution
table(train_smote$SBA)
prop.table(table(train_smote$SBA)) * 100



prop.table(table(train_boruta$SBA)) * 100
# Unskilled   Skilled 
#   ~27.5      ~72.5








#### SMOTE + Model Training on Boruta-selected #### 

library(tidymodels)
library(themis)
library(dplyr)
library(purrr)
library(mccr)
library(caret)
library(pROC)






# =========================================
# SMOTE + Model Training on Boruta-selected
# =========================================
library(tidymodels)
library(themis)
library(dplyr)
library(purrr)
library(mccr)
library(caret)
library(pROC)



print(final_vars)
class(final_vars)





levels(train_smote$SBA)
# [1] "Unskilled" "Skilled"








str(train_smote$SBA)



#### 0️⃣ Load required libraries ####
library(tidymodels)
library(themis)
library(caret)
library(pROC)
library(Boruta)
library(mccr)

set.seed(123)

#### 1️⃣ Prepare Boruta-selected training and test set ####
train_boruta$SBA <- factor(train_boruta$SBA, levels = c("Unskilled", "Skilled"))
test_data$SBA     <- factor(test_data$SBA, levels = c("Unskilled", "Skilled"))

train_data <- train_boruta[, c(final_vars, "SBA")]
test_data  <- test_data[, c(final_vars, "SBA")]

#### 2️⃣ Preprocess with recipe (dummy variables + SMOTE) ####
rec <- recipe(SBA ~ ., data = train_data) %>%
  step_dummy(all_nominal_predictors(), -all_outcomes()) %>%  # factor -> dummy
  step_zv(all_predictors()) %>%                               # remove zero-variance predictors
  step_smote(SBA)                                             # handle class imbalance

train_prep <- prep(rec)
train_smote <- bake(train_prep, new_data = NULL)
test_dummy  <- bake(train_prep, new_data = test_data)

# Ensure SBA is factor
train_smote$SBA <- factor(train_smote$SBA, levels = c("Unskilled", "Skilled"))
test_dummy$SBA  <- factor(test_dummy$SBA, levels = c("Unskilled", "Skilled"))

#### 3️⃣ Cross-validation setup ####
ctrl <- trainControl(
  method = "cv",
  number = 5,
  classProbs = TRUE,
  savePredictions = "final",
  summaryFunction = defaultSummary  # Accuracy, Kappa
)

#### 4️⃣ Define stable models ####
models <- list(
  "Random Forest"       = "rf",
  "Decision Tree"       = "rpart",
  "KNN"                 = "knn",
  "Logistic Regression" = "glm",
  "SVM"                 = "svmRadial"
)

results <- list()
formula_model <- as.formula("SBA ~ .")

#### 5️⃣ Train models ####
for (model_name in names(models)) {
  set.seed(123)
  
  if (models[[model_name]] == "glm") {
    results[[model_name]] <- train(
      formula_model,
      data = train_smote,
      method = "glm",
      family = binomial(),
      trControl = ctrl,
      metric = "Accuracy"
    )
  } else {
    results[[model_name]] <- train(
      formula_model,
      data = train_smote,
      method = models[[model_name]],
      trControl = ctrl,
      metric = "Accuracy",
      tuneLength = 5
    )
  }
}

#### 6️⃣ Evaluate models on test set ####
performance <- purrr::map_dfr(names(results), function(name) {
  model <- results[[name]]
  
  pred <- predict(model, test_dummy)
  prob <- predict(model, test_dummy, type = "prob")[, "Skilled"]
  
  cm <- confusionMatrix(pred, test_dummy$SBA, positive = "Skilled")
  MCC_val <- mccr::mccr(test_dummy$SBA == "Skilled", pred == "Skilled")
  
  data.frame(
    Model     = name,
    Accuracy  = cm$overall["Accuracy"],
    Precision = cm$byClass["Precision"],
    Recall    = cm$byClass["Recall"],
    F1        = cm$byClass["F1"],
    MCC       = MCC_val,
    Kappa     = cm$overall["Kappa"],
    AUROC     = as.numeric(pROC::roc(test_dummy$SBA == "Skilled", prob)$auc)
  )
})

print(performance)




#### Tuning ####
#### 3️⃣ Cross-validation setup (10-fold CV) ####
ctrl <- trainControl(
  method = "cv",
  number = 10,              # 10-fold CV
  classProbs = TRUE,
  savePredictions = "final",
  summaryFunction = defaultSummary,
  verboseIter = TRUE        # show progress during training
)

#### 4️⃣ Define stable models ####
models <- list(
  "Random Forest"       = "rf",
  "Decision Tree"       = "rpart",
  "KNN"                 = "knn",
  "Logistic Regression" = "glm",
  "SVM"                 = "svmRadial"
)

results <- list()
formula_model <- as.formula("SBA ~ .")

#### 5️⃣ Train models with tuning ####
for (model_name in names(models)) {
  set.seed(123)
  
  if (models[[model_name]] == "glm") {
    results[[model_name]] <- train(
      formula_model,
      data = train_smote,
      method = "glm",
      family = binomial(),
      trControl = ctrl,
      metric = "Accuracy"
    )
  } else {
    results[[model_name]] <- train(
      formula_model,
      data = train_smote,
      method = models[[model_name]],
      trControl = ctrl,
      metric = "Accuracy",
      tuneLength = 10  # increase tuning grid
    )
  }
}

#### 6️⃣ Evaluate models on test set ####
performance <- purrr::map_dfr(names(results), function(name) {
  model <- results[[name]]
  
  pred <- predict(model, test_dummy)
  prob <- predict(model, test_dummy, type = "prob")[, "Skilled"]
  
  cm <- confusionMatrix(pred, test_dummy$SBA, positive = "Skilled")
  MCC_val <- mccr::mccr(test_dummy$SBA == "Skilled", pred == "Skilled")
  
  data.frame(
    Model     = name,
    Accuracy  = cm$overall["Accuracy"],
    Precision = cm$byClass["Precision"],
    Recall    = cm$byClass["Recall"],
    F1        = cm$byClass["F1"],
    MCC       = MCC_val,
    Kappa     = cm$overall["Kappa"],
    AUROC     = as.numeric(pROC::roc(test_dummy$SBA == "Skilled", prob)$auc)
  )
})

print(performance)










# Round numeric columns to 2 digits
performance_round <- performance %>%
  dplyr::mutate(
    dplyr::across(where(is.numeric), ~ round(.x, 2))
  )

# Define output path
out_path <- "D:/Research/BDHS Research/Nepal/SBA/Burkina Faso/Analysis/Salek_ML(BF)/Table"

# Create folder if needed
if (!dir.exists(out_path)) {
  dir.create(out_path, recursive = TRUE)
}

# Save rounded output
write.csv(
  performance_round,
  file = file.path(out_path, "ML_model_performance_10foldCV_round2.csv"),
  row.names = FALSE
)




# Round numeric columns to 2 digits
performance_round <- performance %>%
  dplyr::mutate(
    dplyr::across(where(is.numeric), ~ round(.x, 2))




#### Visualizations ####
library(pROC)
library(ggplot2)

# Create empty list to store ROC objects
roc_list <- list()

# Compute ROC for each model
for (name in names(results)) {
  prob <- predict(results[[name]], test_dummy, type = "prob")[, "Skilled"]
  roc_list[[name]] <- roc(
    response = test_dummy$SBA,
    predictor = prob,
    levels = c("Unskilled", "Skilled"),
    direction = "<"
  )
}

# Plot all ROC curves together
ggroc(roc_list, legacy.axes = TRUE, size = 1.1) +
  geom_abline(linetype = "dashed", color = "grey50") +
  theme_minimal(base_size = 13) +
  labs(
    title = "ROC Curves for Machine Learning Models",
    x = "False Positive Rate (1 − Specificity)",
    y = "True Positive Rate (Sensitivity)",
    color = "Model"
  )












library(pROC)
library(ggplot2)
library(scales)

# Store ROC objects
roc_list <- list()

for (name in names(results)) {
  prob <- predict(results[[name]], test_dummy, type = "prob")[, "Skilled"]
  roc_list[[name]] <- roc(
    response = test_dummy$SBA,
    predictor = prob,
    levels = c("Unskilled", "Skilled"),
    direction = "<"
  )
}

# Custom bright color palette (color-blind friendly)
roc_colors <- c(
  "#0072B2",  # blue
  "#D55E00",  # orange
  "#009E73",  # green
  "#CC79A7",  # pink
  "#56B4E9"   # sky blue
)

# Stylish ROC plot
ggroc(roc_list, legacy.axes = TRUE, size = 1.3) +
  geom_abline(
    linetype = "dashed",
    linewidth = 0.9,
    color = "grey60"
  ) +
  scale_color_manual(values = roc_colors) +
  coord_equal() +
  theme_classic(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    axis.title = element_text(face = "bold"),
    legend.title = element_text(face = "bold"),
    legend.position = "right",
    legend.key.height = unit(0.9, "cm"),
    legend.key.width  = unit(0.9, "cm")
  ) +
  labs(
    title = "ROC Curves of Machine Learning Models for Skilled Birth Attendance",
    x = "False Positive Rate (1 − Specificity)",
    y = "True Positive Rate (Sensitivity)",
    color = "Model"
  )





library(pROC)
library(ggplot2)
library(scales)

# Store ROC objects
roc_list <- list()

for (name in names(results)) {
  prob <- predict(results[[name]], test_dummy, type = "prob")[, "Skilled"]
  roc_list[[name]] <- roc(
    response  = test_dummy$SBA,
    predictor = prob,
    levels    = c("Unskilled", "Skilled"),
    direction = "<"
  )
}

# Clean, muted, color-blind friendly palette
roc_colors <- c(
  "#1B9E77",  # teal
  "#D95F02",  # muted orange
  "#7570B3",  # soft purple
  "#E7298A",  # rose
  "#66A61E",  # olive green
  "#A6761D",  # brown (if extra model)
  "#666666"   # neutral gray (fallback)
)

# Stylish & clean ROC plot
ggroc(roc_list, legacy.axes = TRUE, size = 1.25) +
  geom_abline(
    linetype = "dashed",
    linewidth = 0.8,
    color = "grey70"
  ) +
  scale_color_manual(values = roc_colors) +
  coord_equal() +
  theme_classic(base_size = 14) +
  theme(
    plot.title   = element_text(face = "bold", size = 16, hjust = 0.5),
    axis.title   = element_text(face = "bold"),
    axis.text    = element_text(color = "black"),
    legend.title = element_text(face = "bold"),
    legend.text  = element_text(size = 11),
    legend.position = "right",
    legend.key.height = unit(0.8, "cm"),
    legend.key.width  = unit(0.8, "cm")
  ) +
  labs(
    title = "ROC Curves of Machine Learning Models for Skilled Birth Attendance",
    x = "False Positive Rate (1 − Specificity)",
    y = "True Positive Rate (Sensitivity)",
    color = "Model"
  )





library(pROC)
library(ggplot2)

# Store ROC objects and AUC values
roc_list  <- list()
auc_vals  <- numeric()

for (name in names(results)) {
  prob <- predict(results[[name]], test_dummy, type = "prob")[, "Skilled"]
  
  roc_obj <- roc(
    response = test_dummy$SBA,
    predictor = prob,
    levels = c("Unskilled", "Skilled"),
    direction = "<"
  )
  
  roc_list[[name]] <- roc_obj
  auc_vals[name]  <- round(as.numeric(auc(roc_obj)), 2)
}

# Create legend labels with AUROC
legend_labels <- paste0(names(auc_vals), " (AUROC = ", auc_vals, ")")

# Bright, color-blind friendly palette
roc_colors <- c(
  "#0072B2",
  "#D55E00",
  "#009E73",
  "#CC79A7",
  "#56B4E9"
)

# Stylish ROC plot
ggroc(roc_list, legacy.axes = TRUE, size = 1.3) +
  geom_abline(
    linetype = "dashed",
    linewidth = 0.9,
    color = "grey60"
  ) +
  scale_color_manual(
    values = roc_colors,
    labels = legend_labels
  ) +
  coord_equal() +
  theme_classic(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    axis.title = element_text(face = "bold"),
    legend.title = element_text(face = "bold"),
    legend.position = "right"
  ) +
  labs(
    title = "ROC Curves of Machine Learning Models for Skilled Birth Attendance",
    x = "False Positive Rate (1 − Specificity)",
    y = "True Positive Rate (Sensitivity)",
    color = "Model"
  )







#### Callibration ####
library(dplyr)

calibration_data <- purrr::map_dfr(names(results), function(name) {
  
  prob <- predict(results[[name]], test_dummy, type = "prob")[, "Skilled"]
  
  data.frame(
    SBA   = test_dummy$SBA,
    prob  = prob,
    Model = name
  ) %>%
    mutate(
      bin = cut(prob, breaks = seq(0, 1, by = 0.1), include.lowest = TRUE)
    ) %>%
    group_by(Model, bin) %>%
    summarise(
      mean_pred = mean(prob),
      obs_rate  = mean(SBA == "Skilled"),
      .groups = "drop"
    )
})

# Calibration plot
ggplot(calibration_data,
       aes(x = mean_pred, y = obs_rate, color = Model)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  geom_abline(linetype = "dashed", color = "grey40") +
  theme_minimal(base_size = 13) +
  labs(
    title = "Calibration Plots for Machine Learning Models",
    x = "Mean Predicted Probability",
    y = "Observed Proportion of Skilled Birth Attendance",
    color = "Model"
  )











library(dplyr)
library(ggplot2)
library(purrr)

# -----------------------------
# Create calibration data (bins)
# -----------------------------
calibration_data <- map_dfr(names(results), function(name) {
  
  prob <- predict(results[[name]], test_dummy, type = "prob")[, "Skilled"]
  
  tibble(
    SBA   = test_dummy$SBA,
    prob  = prob,
    Model = name
  ) %>%
    mutate(
      bin = cut(
        prob,
        breaks = seq(0, 1, by = 0.1),
        include.lowest = TRUE,
        labels = FALSE
      )
    ) %>%
    group_by(Model, bin) %>%
    summarise(
      mean_pred = mean(prob, na.rm = TRUE),
      obs_rate  = mean(SBA == "Skilled"),
      .groups = "drop"
    )
})

# Color-blind safe, bright palette (IEEE / Nature)
calib_colors <- c(
  "#0072B2",
  "#D55E00",
  "#009E73",
  "#CC79A7",
  "#56B4E9"
)

# -----------------------------
# Calibration plot
# -----------------------------
ggplot(calibration_data,
       aes(x = mean_pred, y = obs_rate, color = Model)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2.6, alpha = 0.9) +
  geom_abline(
    intercept = 0,
    slope = 1,
    linetype = "dashed",
    linewidth = 1,
    color = "grey45"
  ) +
  scale_color_manual(values = calib_colors) +
  coord_equal(xlim = c(0, 1), ylim = c(0, 1)) +
  theme_classic(base_size = 14) +
  theme(
    plot.title   = element_text(face = "bold", size = 16, hjust = 0.5),
    axis.title   = element_text(face = "bold"),
    legend.title = element_text(face = "bold"),
    legend.position = "right",
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  ) +
  labs(
    title = "Calibration Curves of Machine Learning Models",
    x = "Mean Predicted Probability",
    y = "Observed Proportion of Skilled Birth Attendance",
    color = "Model"
  )








#### SHAP ####
library(randomForest)
library(fastshap)
library(shapviz)
library(ggplot2)





rf_model <- results[["Random Forest"]]



rf_fit <- rf_model$finalModel


X_train <- train_smote %>% dplyr::select(-SBA)




pred_fun <- function(object, newdata) {
  predict(object, newdata, type = "prob")[, "Skilled"]
}


 #### Compute SHAP values (Monte-Carlo)####
set.seed(123)

shap_values <- fastshap::explain(
  object       = rf_fit,
  X            = X_train,
  pred_wrapper = pred_fun,
  nsim         = 100,        # stable & fast
  adjust       = TRUE
)






sv <- shapviz(shap_values, X = X_train)








# --- SHAP for Random Forest (500-sample, simple & fast) ---

library(dplyr)
library(fastshap)
library(shapviz)

set.seed(123)

# Extract trained Random Forest model
rf_fit <- results[["Random Forest"]]$finalModel

# Predictor matrix (remove outcome)
X_train <- train_smote %>% dplyr::select(-SBA)

# Randomly sample 500 observations for SHAP
X_sample <- X_train %>% dplyr::slice_sample(n = 500)

# Prediction wrapper: probability of "Skilled"
pred_fun <- function(object, newdata) {
  predict(object, newdata, type = "prob")[, "Skilled"]
}

# Compute SHAP values (Monte Carlo)
shap_values <- fastshap::explain(
  object       = rf_fit,
  X            = X_sample,
  pred_wrapper = pred_fun,
  nsim         = 100,
  adjust       = TRUE
)

# Create SHAP object
sv <- shapviz(shap_values, X = X_sample)







sv_importance(sv, kind = "bar")       # Mean |SHAP| (global)
sv_importance(sv, kind = "beeswarm")  # SHAP summary (local)




#### New ####

set.seed(123)

# Use 100 samples
X_sample <- X_train %>% slice_sample(n = 100)

# Prediction wrapper
pred_fun <- function(object, newdata) {
  predict(object, newdata, type = "prob")[, "Skilled"]
}

# SHAP computation
shap_values <- fastshap::explain(
  object       = rf_fit,
  X            = X_sample,
  pred_wrapper = pred_fun,
  nsim         = 25,  # fast, stable
  adjust       = TRUE
)

# SHAP object
sv <- shapviz(shap_values, X = X_sample)











library(ggplot2)
library(shapviz)

# --- 1️⃣ Global feature importance (Mean |SHAP|) ---
sv_importance(sv, kind = "bar") +
  theme_classic(base_size = 14) +
  labs(
    title = "Random Forest: Global Feature Importance (Mean |SHAP|)",
    x = "Mean |SHAP| Value",
    y = "Features"
  )

# --- 2️⃣ Local explanation summary (beeswarm) ---
sv_importance(sv, kind = "beeswarm") +
  theme_minimal(base_size = 13) +
  labs(
    title = "Random Forest: Local SHAP Summary (Beeswarm)",
    x = "SHAP Value",
    y = "Features"
  )

# --- 3️⃣ Cumulative SHAP contribution (Pareto-style) ---
shap_imp <- data.frame(
  Feature = colnames(X_sample),
  MeanAbsSHAP = colMeans(abs(shap_values))
) %>%
  arrange(desc(MeanAbsSHAP)) %>%
  mutate(
    CumSHAP = cumsum(MeanAbsSHAP),
    CumPercent = 100 * CumSHAP / sum(MeanAbsSHAP)
  )

ggplot(shap_imp,
       aes(x = reorder(Feature, -CumPercent),
           y = CumPercent,
           group = 1)) +
  geom_line(linewidth = 1.2, color = "#0072B2") +
  geom_point(size = 2.5, color = "#D55E00") +
  geom_hline(yintercept = c(50, 80, 90), linetype = "dashed", color = "grey50") +
  coord_flip() +
  theme_classic(base_size = 14) +
  labs(
    title = "Random Forest: Cumulative SHAP Contribution",
    x = "Features (Ordered by Importance)",
    y = "Cumulative Explained Contribution (%)"
  )






#### SHAP Advance Figure ####

library(ggplot2)
library(shapviz)
library(patchwork)   # For side-by-side layout

# --- 1️⃣ Global feature importance (Mean |SHAP|) ---
p1 <- sv_importance(sv, kind = "bar") +
  theme_minimal(base_size = 13) +
  labs(
    title = "Global Feature Importance (Mean |SHAP|)",
    x = "Mean |SHAP| Value",
    y = NULL
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    axis.text.y = element_text(face = "bold")
  )

# --- 2️⃣ Local explanation summary (Beeswarm) ---
p2 <- sv_importance(sv, kind = "beeswarm") +
  theme_minimal(base_size = 13) +
  labs(
    title = "Local SHAP Summary (Beeswarm)",
    x = "SHAP Value",
    y = NULL
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    axis.text.y = element_text(face = "bold")
  )

# --- Combine side by side ---
p_combined <- p1 + p2 + plot_layout(ncol = 2) +
  plot_annotation(
    title = "Random Forest SHAP Analysis",
    subtitle = "Global Feature Importance and Local Explanation Summary",
    theme = theme(plot.title = element_text(size = 16, face = "bold"),
                  plot.subtitle = element_text(size = 13))
  )

# --- Display ---
p_combined















library(ggplot2)
library(shapviz)
library(patchwork)
library(viridis)   # nice continuous colors

# --- 1️⃣ Global feature importance (Mean |SHAP|) ---
p1 <- sv_importance(sv, kind = "bar") +
  scale_fill_manual(values = "#0072B2") +   # blue
  theme_minimal(base_size = 13) +
  labs(
    title = "Global Feature Importance (Mean |SHAP|)",
    x = "Mean |SHAP| Value",
    y = NULL
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    axis.text.y = element_text(face = "bold", color = "black"),
    axis.text.x = element_text(face = "bold", color = "black")
  )

# --- 2️⃣ Local explanation summary (Beeswarm) ---
p2 <- sv_importance(sv, kind = "beeswarm") +
  scale_color_viridis_c(option = "plasma") +   # continuous color for SHAP
  theme_minimal(base_size = 13) +
  labs(
    title = "Local SHAP Summary (Beeswarm)",
    x = "SHAP Value",
    y = NULL
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    axis.text.y = element_text(face = "bold", color = "black"),
    axis.text.x = element_text(face = "bold", color = "black")
  )

# --- Combine side by side ---
p_combined <- p1 + p2 + plot_layout(ncol = 2) +
  plot_annotation(
    title = "Random Forest SHAP Analysis",
    subtitle = "Global Feature Importance and Local Explanation Summary",
    theme = theme(
      plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = 13, hjust = 0.5)
    )
  )

# --- Display ---
p_combined

# --- Optional: Save figure ---
# ggsave("RF_SHAP_IEEE.png", p_combined, width = 14, height = 7, dpi = 300)









#### CUMULative SHap ####
library(ggplot2)
library(dplyr)

# Prepare SHAP importance data
shap_imp <- data.frame(
  Feature = colnames(X_sample),
  MeanAbsSHAP = colMeans(abs(shap_values))
) %>%
  arrange(desc(MeanAbsSHAP)) %>%
  mutate(
    CumSHAP = cumsum(MeanAbsSHAP),
    CumPercent = 100 * CumSHAP / sum(MeanAbsSHAP)
  )

# --- IEEE-style Cumulative SHAP plot ---
ggplot(shap_imp, aes(x = reorder(Feature, -CumPercent), y = CumPercent, group = 1)) +
  geom_line(linewidth = 1.2, color = "#0072B2") +         # blue line
  geom_point(size = 3, color = "#D55E00") +               # orange points
  geom_hline(yintercept = c(50, 80, 90), 
             linetype = "dashed", color = "grey50") +    # thresholds
  coord_flip() +
  theme_classic(base_size = 14) +
  labs(
    title = "Random Forest: Cumulative SHAP Contribution",
    x = "Features (Ordered by Importance)",
    y = "Cumulative Explained Contribution (%)"
  ) +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    axis.title = element_text(face = "bold"),
    axis.text = element_text(face = "bold", color = "black")
  )






















#### Confusion Matrix ####
library(ggplot2)
cm_df <- as.data.frame(cm$table)
ggplot(cm_df, aes(Prediction, Reference, fill=Freq)) +
  geom_tile(color="white") +
  geom_text(aes(label=Freq), color="black", size=5) +
  scale_fill_gradient(low="#FEE0D2", high="#DE2D26") +
  theme_minimal(base_size = 14) +
  labs(title="Confusion Matrix", x="Predicted", y="Actual")








library(ggplot2)
library(dplyr)

# Convert confusion matrix to data frame
cm_df <- as.data.frame(cm$table)

# IEEE-style Confusion Matrix plot
ggplot(cm_df, aes(x = Prediction, y = Reference, fill = Freq)) +
  geom_tile(color = "white", linewidth = 0.5) +          # tiles with white borders
  geom_text(aes(label = Freq), color = "black", size = 5, fontface = "bold") +  # counts
  scale_fill_gradient(low = "#D0E1F9", high = "#08306B") +  # blue gradient IEEE-style
  theme_minimal(base_size = 14) +
  labs(
    title = "Random Forest Confusion Matrix",
    x = "Predicted Class",
    y = "Actual Class",
    fill = "Count"
  ) +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    axis.title = element_text(face = "bold", size = 14),
    axis.text = element_text(face = "bold", color = "black"),
    legend.title = element_text(face = "bold"),
    legend.text = element_text(size = 12)
  )







#### DCA ####
# Install if not already
install.packages("rmda")

library(rmda)
library(dplyr)









# Example: Random Forest predicted probabilities
rf_prob <- predict(results[["Random Forest"]], test_dummy, type = "prob")[, "Skilled"]

dca_data <- data.frame(
  SBA = ifelse(test_dummy$SBA == "Skilled", 1, 0),  # Outcome: 1 = Skilled
  RF  = rf_prob
)

# You can also add other model predictions:
# LR_prob <- predict(results[["Logistic Regression"]], test_dummy, type="prob")[, "Skilled"]
# dca_data$LR <- LR_prob






# Decision Curve Analysis
dca_res <- decision_curve(
  formula = SBA ~ RF,         # can include multiple models: SBA ~ RF + LR + SVM
  data = dca_data,
  family = binomial(link = "logit"),
  thresholds = seq(0, 1, by = 0.01),  # probability thresholds
  confidence.intervals = 0.95,
  bootstraps = 100               # bootstrap for CI, can increase
)



plot_decision_curve(
  dca_res,
  curve.names = "Random Forest",
  xlab = "Threshold Probability",
  ylab = "Net Benefit",
  legend.position = "topright",
  col = "#0072B2",      # IEEE-style blue
  lwd = 2
)









# Random Forest predicted probabilities
rf_prob <- predict(results[["Random Forest"]], test_dummy, type = "prob")[, "Skilled"]

# Logistic Regression predicted probabilities
lr_prob <- predict(results[["Logistic Regression"]], test_dummy, type = "prob")[, "Skilled"]

# SVM predicted probabilities
svm_prob <- predict(results[["SVM"]], test_dummy, type = "prob")[, "Skilled"]

# Combine into one dataframe
dca_data <- data.frame(
  SBA = ifelse(test_dummy$SBA == "Skilled", 1, 0),  # Outcome: 1 = Skilled
  RF  = rf_prob,
  LR  = lr_prob,
  SVM = svm_prob
)

# Now DCA will work
dca_res <- decision_curve(
  formula = SBA ~ RF + LR + SVM,
  data = dca_data,
  family = binomial(link = "logit"),
  thresholds = seq(0, 1, by = 0.01)
)










# Basic plot
plot_decision_curve(
  dca_res,
  curve.names = c("Random Forest", "Logistic Regression", "SVM"),
  xlab = "Threshold Probability",
  ylab = "Net Benefit",
  legend.position = "topright",
  col = c("#0072B2", "#E69F00", "#009E73"),  # IEEE-style colors
  lwd = 2
)




dca_res <- decision_curve(
  formula = SBA ~ RF + LR + SVM,
  data = dca_data,
  family = binomial(link = "logit"),
  thresholds = seq(0, 1, by = 0.01),
  confidence.intervals = 0.95,
  bootstraps = 100  # Increase for more stable CI
)
plot_decision_curve(dca_res)






library(rmda)

# Define IEEE-inspired colors
model_colors <- c(
  "Random Forest"       = "#0072B2",  # blue
  "Logistic Regression" = "#E69F00",  # orange
  "SVM"                 = "#009E73"   # green
)

# Plot Decision Curve
plot_decision_curve(
  dca_res,
  curve.names = c("Random Forest", "Logistic Regression", "SVM"),
  xlab = "Threshold Probability",
  ylab = "Net Benefit",
  legend.position = "topright",
  col = model_colors,
  lwd = c(3, 2, 2),       # Highlight RF with thicker line
  lty = c(1, 2, 3),       # Solid RF, dashed others
  confidence.intervals = TRUE,
  ci.style = "bands"      # shaded CI bands
)

# Optional: add reference lines for Treat All / Treat None
abline(h = 0, lty = 3, col = "grey50")        # Treat None
abline(a = 0, b = 1, lty = 3, col = "grey70") # Treat All diagonal
























#### Spatial

# Predicted probabilities for "Skilled" births
rf_prob <- predict(results[["Random Forest"]], test_dummy, type = "prob")[, "Skilled"]

# Add predictions to the test dataset
test_data$pred_prob <- rf_prob



library(dplyr)

province_preds <- test_data %>%
  group_by(province) %>%
  summarise(mean_prob = mean(pred_prob))









library(sf)

# Read shapefile
shp_path <- "D:/Research/BDHS Research/Nepal/SBA/Burkina Faso/Data/bfa_admin_boundaries.shp/bfa_admin1.shp"
bfa_shp <- st_read(shp_path)

# View first few rows and structure
head(bfa_shp)
str(bfa_shp)

# Check column names and unique province names
colnames(bfa_shp)
unique(bfa_shp$NAME_1)  # Replace NAME_1 with the actual column containing province names











# Example predicted probabilities per province
rf_prov <- data.frame(
  adm1_name_ = c("Boucle du Mouhoun", "Sud-Ouest", "Est", "Hauts-Bassins", "Centre", "Centre-Nord"),
  RF_pred = c(0.85, 0.73, 0.65, 0.78, 0.82, 0.70)  # replace with actual predictions
)

# Merge shapefile with RF predictions
bfa_map <- merge(bfa_shp, rf_prov, by = "adm1_name_", all.x = TRUE)







library(ggplot2)
library(sf)

ggplot(bfa_map) +
  geom_sf(aes(fill = RF_pred), color = "white", size = 0.3) +
  scale_fill_gradient(low = "#FEE08B", high = "#D73027", na.value = "grey90",
                      name = "Predicted\nSBA Probability") +
  theme_minimal(base_size = 14) +
  labs(title = "Provincial-level Predicted Probabilities of Skilled Birth Attendance") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16),
    legend.title = element_text(face = "bold"),
    legend.position = "right"
  )










library(ggplot2)
library(sf)
library(dplyr)
library(ggrepel)

# Ensure all provinces have predictions
bfa_map <- bfa_shp %>%
  left_join(rf_prov, by = "adm1_name_")  # merge predictions

# Plot map with province names
ggplot(bfa_map) +
  geom_sf(aes(fill = RF_pred), color = "white", size = 0.3) +
  geom_sf_text(aes(label = adm1_name_), size = 3, fontface = "bold") +
  scale_fill_gradient(low = "#FEE08B", high = "#D73027", na.value = "grey90",
                      name = "Predicted\nSBA Probability") +
  theme_minimal(base_size = 14) +
  labs(title = "Provincial-level Predicted Probabilities of Skilled Birth Attendance") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16),
    legend.title = element_text(face = "bold"),
    legend.position = "right"
  )












# Replace spaces with hyphens for consistency
bfa_shp$adm1_name_ <- gsub(" ", "-", bfa_shp$adm1_name_)
rf_prov$Province   <- gsub(" ", "-", rf_prov$Province)







library(sf)
library(dplyr)
library(ggplot2)

# --- 1️⃣ Read shapefile ---
shp_path <- "D:/Research/BDHS Research/Nepal/SBA/Burkina Faso/Data/bfa_admin_boundaries.shp/bfa_admin1.shp"
bfa_shp <- st_read(shp_path)

# Harmonize province names (replace spaces with hyphens)
bfa_shp$adm1_name_ <- gsub(" ", "-", bfa_shp$adm1_name_)

# --- 2️⃣ Example predicted probabilities per province ---
rf_prov <- data.frame(
  adm1_name_ = c("Boucle-du-Mouhoun", "Sud-Ouest", "Est", "Hauts-Bassins", 
                 "Centre", "Centre-Nord", "Sahel", "Nord", "Centre-Ouest", 
                 "Centre-Sud", "Centre-Est", "Cascades"),
  RF_pred = c(0.85, 0.73, 0.65, 0.78, 0.82, 0.70, NA, NA, NA, NA, NA, NA)  # replace with actual predictions
)

# Harmonize names in rf_prov
rf_prov$adm1_name_ <- gsub(" ", "-", rf_prov$adm1_name_)

# --- 3️⃣ Merge shapefile with RF predictions ---
bfa_map <- bfa_shp %>%
  left_join(rf_prov, by = "adm1_name_")

# --- 4️⃣ Plot map ---
ggplot(bfa_map) +
  geom_sf(aes(fill = RF_pred), color = "white", size = 0.3) +
  scale_fill_gradient(low = "#FEE08B", high = "#D73027", na.value = "grey80",
                      name = "Predicted\nSBA Probability") +
  theme_minimal(base_size = 14) +
  labs(title = "Provincial-level Predicted Probabilities of Skilled Birth Attendance",
       subtitle = "Grey regions indicate missing predictions") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16),
    plot.subtitle = element_text(face = "italic", hjust = 0.5, size = 12),
    legend.title = element_text(face = "bold"),
    legend.position = "right"
  )






























# Shapefile province names
unique(bfa_shp$adm1_name_)



colnames(full_data)








library(dplyr)

# List of province dummy columns
province_cols <- grep("^province_", colnames(full_data), value = TRUE)

# Map full_data to shapefile-style province names
province_map <- c(
  "province_cascades"        = "Cascades",
  "province_centre"          = "Centre",
  "province_centre.est"      = "Centre-Est",
  "province_centre.nord"     = "Centre-Nord",
  "province_centre.ouest"    = "Centre-Ouest",
  "province_centre.sud"      = "Centre-Sud",
  "province_est"             = "Est",
  "province_hauts.bassins"   = "Hauts-Bassins",
  "province_nord"            = "Nord",
  "province_plateau.central" = "Plateau-Central",
  "province_sahel"           = "Sahel",
  "province_sud.ouest"       = "Sud-Ouest",
  "province_boucle.du.mouhoun" = "Boucle-du-Mouhoun"  # add if exists
)

# Create a Province column
full_data <- full_data %>%
  rowwise() %>%
  mutate(Province = province_map[province_cols[which(c_across(all_of(province_cols)) == 1)[1]]]) %>%
  ungroup()






rf_prov <- full_data %>%
  group_by(Province) %>%
  summarise(RF_pred = mean(RF_prob, na.rm = TRUE)) %>%
  ungroup() %>%
  rename(adm1_name_ = Province)  # for merging with shapefile








library(ggplot2)
library(sf)

bfa_map <- bfa_shp %>%
  left_join(rf_prov, by = "adm1_name_")

ggplot(bfa_map) +
  geom_sf(aes(fill = RF_pred), color = "white", size = 0.3) +
  scale_fill_gradient(low = "#FEE08B", high = "#D73027", na.value = "grey90",
                      name = "Predicted\nSBA Probability") +
  theme_minimal(base_size = 14) +
  labs(title = "Provincial-level Predicted Probabilities of Skilled Birth Attendance") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16),
    legend.title = element_text(face = "bold"),
    legend.position = "right"
  )











province_map <- c(
  "province_cascades"        = "Cascades",
  "province_centre"          = "Centre",
  "province_centre.est"      = "Centre-Est",
  "province_centre.nord"     = "Centre-Nord",
  "province_centre.ouest"    = "Centre-Ouest",
  "province_centre.sud"      = "Centre-Sud",
  "province_est"             = "Est",
  "province_hauts.bassins"   = "Hauts-Bassins",
  "province_nord"            = "Nord",
  "province_plateau.central" = "Plateau-Central",
  "province_sahel"           = "Sahel",
  "province_sud.ouest"       = "Sud-Ouest",
  "province_boucle.du.mouhoun" = "Boucle-du-Mouhoun"
)












library(dplyr)
library(sf)

# Already read shapefile
unique_provs <- bfa_shp$adm1_name_
unique_provs
# [1] "Boucle-du-Mouhoun" "Sud-Ouest" "Est" "Hauts-Bassins" ...









library(dplyr)
library(sf)
library(ggplot2)

# 1️⃣ Deduplicate shapefile by province
bfa_shp_unique <- bfa_shp %>%
  group_by(adm1_name_) %>%
  summarise(geometry = st_union(geometry), .groups = "drop")

# 2️⃣ Ensure full_data has harmonized province names
full_data$Province <- gsub(" ", "-", full_data$province_raw)  # replace with your province column

# 3️⃣ Aggregate RF predicted probabilities by province
rf_prov <- full_data %>%
  group_by(Province) %>%
  summarise(RF_pred = mean(RF_prob, na.rm = TRUE)) %>%
  ungroup()

# 4️⃣ Merge shapefile with RF predictions
bfa_map <- bfa_shp_unique %>%
  left_join(rf_prov, by = c("adm1_name_" = "Province"))

# 5️⃣ Plot
ggplot(bfa_map) +
  geom_sf(aes(fill = RF_pred), color = "white", size = 0.3) +
  scale_fill_gradient(low = "#FEE08B", high = "#D73027", na.value = "grey90",
                      name = "Predicted\nSBA Probability") +
  theme_minimal(base_size = 14) +
  labs(title = "Provincial-level Predicted Probabilities of Skilled Birth Attendance") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16),
    legend.title = element_text(face = "bold"),
    legend.position = "right"
  )












library(dplyr)

# Combine dummy province columns into a single "Province" column
full_data <- full_data %>%
  mutate(Province = case_when(
    province_cascades == 1      ~ "Cascades",
    province_centre == 1        ~ "Centre",
    province_centre.est == 1    ~ "Centre-Est",
    province_centre.nord == 1   ~ "Centre-Nord",
    province_centre.ouest == 1  ~ "Centre-Ouest",
    province_centre.sud == 1    ~ "Centre-Sud",
    province_est == 1           ~ "Est",
    province_hauts.bassins == 1 ~ "Hauts-Bassins",
    province_nord == 1          ~ "Nord",
    province_plateau.central == 1 ~ "Plateau-Central",
    province_sahel == 1         ~ "Sahel",
    province_sud.ouest == 1     ~ "Sud-Ouest",
    TRUE                        ~ NA_character_  # for missing
  ))

# Harmonize names with shapefile
full_data$Province <- gsub(" ", "-", full_data$Province)


















rf_prov <- full_data %>%
  group_by(Province) %>%
  summarise(RF_pred = mean(RF_prob, na.rm = TRUE)) %>%
  ungroup()





library(sf)
library(ggplot2)

bfa_shp_unique <- bfa_shp %>%
  group_by(adm1_name_) %>%
  summarise(geometry = st_union(geometry), .groups = "drop")

bfa_map <- bfa_shp_unique %>%
  left_join(rf_prov, by = c("adm1_name_" = "Province"))

ggplot(bfa_map) +
  geom_sf(aes(fill = RF_pred), color = "white", size = 0.3) +
  scale_fill_gradient(low = "#FEE08B", high = "#D73027", na.value = "grey90",
                      name = "Predicted\nSBA Probability") +
  theme_minimal(base_size = 14) +
  labs(title = "Provincial-level Predicted Probabilities of Skilled Birth Attendance") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16),
    legend.title = element_text(face = "bold"),
    legend.position = "right"
  )





library(dplyr)

# Aggregate by province
rf_prov <- full_data %>%
  group_by(Province) %>%
  summarise(RF_pred = mean(RF_prob, na.rm = TRUE)) %>%
  ungroup()

# List all provinces in shapefile
all_provs <- unique(bfa_shp$adm1_name_)

# Identify missing provinces
missing_provs <- setdiff(all_provs, rf_prov$Province)

# Add missing provinces with mean RF probability
rf_prov <- rf_prov %>%
  bind_rows(
    data.frame(
      Province = missing_provs,
      RF_pred = mean(full_data$RF_prob, na.rm = TRUE)
    )
  )












library(sf)
library(ggplot2)

# Deduplicate shapefile by province (if needed)
bfa_shp_unique <- bfa_shp %>%
  group_by(adm1_name_) %>%
  summarise(geometry = st_union(geometry), .groups = "drop")

# Merge RF predictions with shapefile
bfa_map <- bfa_shp_unique %>%
  left_join(rf_prov, by = c("adm1_name_" = "Province"))





ggplot(bfa_map) +
  geom_sf(aes(fill = RF_pred), color = "white", size = 0.3) +
  scale_fill_gradient(low = "#FEE08B", high = "#D73027", na.value = "grey90",
                      name = "Predicted\nSBA Probability") +
  theme_minimal(base_size = 14) +
  labs(title = "Provincial-level Predicted Probabilities of Skilled Birth Attendance") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16),
    legend.title = element_text(face = "bold"),
    legend.position = "right"
  )
















library(ggplot2)
library(sf)
library(ggspatial)  # for north arrow and scale bar
library(dplyr)

# Ensure centroids for labels
bfa_map <- bfa_map %>%
  mutate(centroid = st_centroid(geometry)) %>%
  mutate(
    lon = st_coordinates(centroid)[,1],
    lat = st_coordinates(centroid)[,2]
  )

ggplot(bfa_map) +
  geom_sf(aes(fill = RF_pred), color = "white", size = 0.3) +
  geom_text(aes(x = lon, y = lat, label = adm1_name_), 
            size = 3.5, fontface = "bold", color = "black") +
  scale_fill_gradient(low = "#FEE08B", high = "#D73027", na.value = "grey90",
                      name = "Predicted\nSBA Probability") +
  annotation_north_arrow(location = "tr", which_north = "true",
                         style = north_arrow_fancy_orienteering()) +
  annotation_scale(location = "bl", width_hint = 0.3) +
  theme_minimal(base_size = 14) +
  labs(title = "Provincial-level Predicted Probabilities of Skilled Birth Attendance") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16),
    legend.title = element_text(face = "bold"),
    legend.position = "right"
  )








library(ggplot2)
library(sf)
library(ggspatial)
library(dplyr)

# Compute centroids for labels
bfa_map <- bfa_map %>%
  mutate(centroid = st_centroid(geometry)) %>%
  mutate(
    lon = st_coordinates(centroid)[,1],
    lat = st_coordinates(centroid)[,2]
  )

# Nature/Medicine style color palette
fill_colors <- c("#FFFFCC", "#FED976", "#FC4E2A", "#B10026")  # soft yellow -> red

ggplot(bfa_map) +
  geom_sf(aes(fill = RF_pred), color = "black", size = 0.4) +  # frame border around provinces
  geom_text(aes(x = lon, y = lat, label = adm1_name_), 
            size = 3.5, fontface = "bold", color = "#333333") +
  scale_fill_gradientn(colors = fill_colors, na.value = "grey90",
                       name = "Predicted\nSBA Probability") +
  annotation_north_arrow(location = "tr", which_north = "true",
                         style = north_arrow_fancy_orienteering()) +
  annotation_scale(location = "bl", width_hint = 0.3) +
  theme_minimal(base_size = 14) +
  theme(
    plot.background = element_rect(fill = "white", color = "black", size = 1.2),  # frame around the whole plot
    panel.background = element_rect(fill = "white"),
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16),
    legend.title = element_text(face = "bold"),
    legend.position = "right",
    axis.text = element_blank(),
    axis.ticks = element_blank()
  ) +
  labs(title = "Provincial-level Predicted Probabilities of Skilled Birth Attendance")

















#### Sub group ####
table(full_data$residence_Rural)
# Or create a factor if not already
full_data$residence <- ifelse(full_data$residence_Rural == 1, "Rural", "Urban")
full_data$residence <- factor(full_data$residence)







# Random Forest example
urban_data <- full_data %>% filter(residence == "Urban")
rural_data <- full_data %>% filter(residence == "Rural")

urban_data$RF_prob <- predict(results[["Random Forest"]], urban_data, type = "prob")[, "Skilled"]
rural_data$RF_prob <- predict(results[["Random Forest"]], rural_data, type = "prob")[, "Skilled"]










# Create a unified province column based on your existing province columns
full_data <- full_data %>%
  mutate(
    province = case_when(
      province_centre == 1 ~ "Centre",
      province_centre.est == 1 ~ "Centre-Est",
      province_centre.nord == 1 ~ "Centre-Nord",
      province_centre.ouest == 1 ~ "Centre-Ouest",
      province_centre.sud == 1 ~ "Centre-Sud",
      province_est == 1 ~ "Est",
      province_hauts.bassins == 1 ~ "Hauts-Bassins",
      province_nord == 1 ~ "Nord",
      province_plateau.central == 1 ~ "Plateau-Central",
      province_sahel == 1 ~ "Sahel",
      province_sud.ouest == 1 ~ "Sud-Ouest",
      province_cascades == 1 ~ "Cascades",
      TRUE ~ NA_character_
    )
  )

# Check
table(full_data$province)






# Create Urban/Rural factor
full_data$residence <- ifelse(full_data$residence_Rural == 1, "Rural", "Urban")
full_data$residence <- factor(full_data$residence)

# Split by residence
urban_data <- full_data %>% filter(residence == "Urban")
rural_data <- full_data %>% filter(residence == "Rural")

# Random Forest predicted probabilities already exist in RF_prob

# Aggregate by province
urban_prov <- urban_data %>%
  group_by(province) %>%
  summarise(RF_prob = mean(RF_prob, na.rm = TRUE)) %>%
  ungroup()

rural_prov <- rural_data %>%
  group_by(province) %>%
  summarise(RF_prob = mean(RF_prob, na.rm = TRUE)) %>%
  ungroup()

# Merge with shapefile for mapping
urban_map <- merge(bfa_shp, urban_prov, by.x = "adm1_name_", by.y = "province", all.x = TRUE)
rural_map <- merge(bfa_shp, rural_prov, by.x = "adm1_name_", by.y = "province", all.x = TRUE)









library(ggplot2)
library(sf)

ggplot() +
  geom_sf(data = urban_map, aes(fill = RF_prob), color = "white", size = 0.3) +
  geom_sf(data = rural_map, aes(fill = RF_prob), color = "white", size = 0.3, alpha = 0.5) +
  scale_fill_gradient(low = "#FEE08B", high = "#D73027", na.value = "grey90",
                      name = "Predicted\nSBA Probability") +
  theme_minimal(base_size = 14) +
  labs(title = "Urban vs Rural Provincial Predicted Probabilities of SBA") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16),
    legend.title = element_text(face = "bold"),
    legend.position = "right"
  )














library(ggplot2)
library(sf)
library(gridExtra)  # for side-by-side layout

# --- Urban map ---
p_urban <- ggplot() +
  geom_sf(data = urban_map, aes(fill = RF_prob), color = "white", size = 0.3) +
  scale_fill_gradient(low = "#FEE08B", high = "#D73027", na.value = "grey90",
                      name = "Predicted\nSBA Probability") +
  theme_minimal(base_size = 14) +
  labs(title = "Urban") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 14),
    legend.title = element_text(face = "bold"),
    legend.position = "right",
    panel.border = element_rect(color = "black", fill = NA, size = 1)
  )

# --- Rural map ---
p_rural <- ggplot() +
  geom_sf(data = rural_map, aes(fill = RF_prob), color = "white", size = 0.3) +
  scale_fill_gradient(low = "#FEE08B", high = "#D73027", na.value = "grey90",
                      name = "Predicted\nSBA Probability") +
  theme_minimal(base_size = 14) +
  labs(title = "Rural") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 14),
    legend.title = element_text(face = "bold"),
    legend.position = "right",
    panel.border = element_rect(color = "black", fill = NA, size = 1)
  )

# --- Side-by-side layout ---
grid.arrange(p_urban, p_rural, ncol = 2)



















library(dplyr)
library(ggplot2)
library(sf)
library(gridExtra)

# --- Step 1: Aggregate RF predictions per province (full dataset) ---
full_data$province <- case_when(
  full_data$province_centre == 1 ~ "Centre",
  full_data$province_centre.est == 1 ~ "Centre-Est",
  full_data$province_centre.nord == 1 ~ "Centre-Nord",
  full_data$province_centre.ouest == 1 ~ "Centre-Ouest",
  full_data$province_centre.sud == 1 ~ "Centre-Sud",
  full_data$province_est == 1 ~ "Est",
  full_data$province_hauts.bassins == 1 ~ "Hauts-Bassins",
  full_data$province_nord == 1 ~ "Nord",
  full_data$province_plateau.central == 1 ~ "Plateau-Central",
  full_data$province_sahel == 1 ~ "Sahel",
  full_data$province_sud.ouest == 1 ~ "Sud-Ouest",
  full_data$province_cascades == 1 ~ "Cascades",
  TRUE ~ NA_character_
)

full_data$RF_prob <- predict(results[["Random Forest"]], full_data, type = "prob")[, "Skilled"]

# --- Step 2: Impute missing provinces ---
rf_prov <- full_data %>%
  group_by(province) %>%
  summarise(RF_prob = mean(RF_prob, na.rm = TRUE)) %>%
  ungroup()

# List all provinces in shapefile
all_provs <- unique(bfa_shp$adm1_name_)

# Identify missing provinces
missing_provs <- setdiff(all_provs, rf_prov$province)

# Add missing provinces with overall mean
rf_prov <- rf_prov %>%
  bind_rows(
    data.frame(
      province = missing_provs,
      RF_prob = mean(full_data$RF_prob, na.rm = TRUE)
    )
  )

# --- Step 3: Urban vs Rural subsets ---
full_data$residence <- ifelse(full_data$residence_Rural == 1, "Rural", "Urban")
full_data$residence <- factor(full_data$residence)

urban_data <- full_data %>% filter(residence == "Urban")
rural_data <- full_data %>% filter(residence == "Rural")

urban_prov <- urban_data %>%
  group_by(province) %>%
  summarise(RF_prob = mean(RF_prob, na.rm = TRUE)) %>%
  ungroup() %>%
  bind_rows(
    data.frame(
      province = missing_provs,
      RF_prob = mean(urban_data$RF_prob, na.rm = TRUE)
    )
  )

rural_prov <- rural_data %>%
  group_by(province) %>%
  summarise(RF_prob = mean(RF_prob, na.rm = TRUE)) %>%
  ungroup() %>%
  bind_rows(
    data.frame(
      province = missing_provs,
      RF_prob = mean(rural_data$RF_prob, na.rm = TRUE)
    )
  )

# --- Step 4: Merge with shapefile ---
bfa_shp_unique <- bfa_shp %>%
  group_by(adm1_name_) %>%
  summarise(geometry = st_union(geometry), .groups = "drop")

urban_map <- merge(bfa_shp_unique, urban_prov, by.x = "adm1_name_", by.y = "province", all.x = TRUE)
rural_map <- merge(bfa_shp_unique, rural_prov, by.x = "adm1_name_", by.y = "province", all.x = TRUE)

# --- Step 5: Plot maps ---
p_urban <- ggplot() +
  geom_sf(data = urban_map, aes(fill = RF_prob), color = "white", size = 0.3) +
  scale_fill_gradient(low = "#FEE08B", high = "#D73027", na.value = "grey90",
                      name = "Predicted\nSBA Probability") +
  theme_minimal(base_size = 14) +
  labs(title = "Urban") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 14),
    legend.title = element_text(face = "bold"),
    legend.position = "right",
    panel.border = element_rect(color = "black", fill = NA, size = 1)
  )

p_rural <- ggplot() +
  geom_sf(data = rural_map, aes(fill = RF_prob), color = "white", size = 0.3) +
  scale_fill_gradient(low = "#FEE08B", high = "#D73027", na.value = "grey90",
                      name = "Predicted\nSBA Probability") +
  theme_minimal(base_size = 14) +
  labs(title = "Rural") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 14),
    legend.title = element_text(face = "bold"),
    legend.position = "right",
    panel.border = element_rect(color = "black", fill = NA, size = 1)
  )

grid.arrange(p_urban, p_rural, ncol = 2)










library(ggplot2)
library(sf)
library(gridExtra)
library(ggspatial)

# --- Get centroids for province labels ---
urban_map$centroid <- st_centroid(urban_map$geometry)
urban_map_coords <- cbind(urban_map, st_coordinates(urban_map$centroid))

rural_map$centroid <- st_centroid(rural_map$geometry)
rural_map_coords <- cbind(rural_map, st_coordinates(rural_map$centroid))

# --- Urban map with labels and north arrow ---
p_urban <- ggplot() +
  geom_sf(data = urban_map, aes(fill = RF_prob), color = "white", size = 0.3) +
  geom_text(data = urban_map_coords, aes(X, Y, label = adm1_name_), 
            size = 3, fontface = "bold", color = "black") +
  annotation_north_arrow(location = "tl", which_north = "true", 
                         style = north_arrow_fancy_orienteering()) +
  annotation_scale(location = "bl", width_hint = 0.3) +
  scale_fill_gradient(low = "#FEE08B", high = "#D73027", na.value = "grey90",
                      name = "Predicted\nSBA Probability") +
  theme_minimal(base_size = 14) +
  labs(title = "Urban") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 14),
    legend.title = element_text(face = "bold"),
    legend.position = "right",
    panel.border = element_rect(color = "black", fill = NA, size = 1)
  )

# --- Rural map with labels and north arrow ---
p_rural <- ggplot() +
  geom_sf(data = rural_map, aes(fill = RF_prob), color = "white", size = 0.3) +
  geom_text(data = rural_map_coords, aes(X, Y, label = adm1_name_), 
            size = 3, fontface = "bold", color = "black") +
  annotation_north_arrow(location = "tl", which_north = "true", 
                         style = north_arrow_fancy_orienteering()) +
  annotation_scale(location = "bl", width_hint = 0.3) +
  scale_fill_gradient(low = "#FEE08B", high = "#D73027", na.value = "grey90",
                      name = "Predicted\nSBA Probability") +
  theme_minimal(base_size = 14) +
  labs(title = "Rural") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 14),
    legend.title = element_text(face = "bold"),
    legend.position = "right",
    panel.border = element_rect(color = "black", fill = NA, size = 1)
  )

# --- Combine side by side ---
grid.arrange(p_urban, p_rural, ncol = 2)


















library(ggplot2)
library(sf)
library(gridExtra)
library(ggspatial)

# --- Get centroids for province labels ---
urban_map$centroid <- st_centroid(urban_map$geometry)
urban_map_coords <- cbind(urban_map, st_coordinates(urban_map$centroid))

rural_map$centroid <- st_centroid(rural_map$geometry)
rural_map_coords <- cbind(rural_map, st_coordinates(rural_map$centroid))

# --- Urban map with bigger labels, no border ---
p_urban <- ggplot() +
  geom_sf(data = urban_map, aes(fill = RF_prob), color = "white", size = 0.3) +
  geom_text(data = urban_map_coords, aes(X, Y, label = adm1_name_), 
            size = 4, fontface = "bold", color = "black") +
  annotation_north_arrow(location = "tl", which_north = "true", 
                         style = north_arrow_fancy_orienteering()) +
  annotation_scale(location = "bl", width_hint = 0.3) +
  scale_fill_gradient(low = "#FEE08B", high = "#D73027", na.value = "grey90",
                      name = "Predicted\nSBA Probability") +
  theme_minimal(base_size = 16) +
  labs(title = "Urban") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16),
    legend.title = element_text(face = "bold"),
    legend.position = "right",
    panel.border = element_blank()  # Removed border
  )

# --- Rural map with bigger labels, no border ---
p_rural <- ggplot() +
  geom_sf(data = rural_map, aes(fill = RF_prob), color = "white", size = 0.3) +
  geom_text(data = rural_map_coords, aes(X, Y, label = adm1_name_), 
            size = 4, fontface = "bold", color = "black") +
  annotation_north_arrow(location = "tl", which_north = "true", 
                         style = north_arrow_fancy_orienteering()) +
  annotation_scale(location = "bl", width_hint = 0.3) +
  scale_fill_gradient(low = "#FEE08B", high = "#D73027", na.value = "grey90",
                      name = "Predicted\nSBA Probability") +
  theme_minimal(base_size = 16) +
  labs(title = "Rural") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16),
    legend.title = element_text(face = "bold"),
    legend.position = "right",
    panel.border = element_blank()  # Removed border
  )

# --- Combine side by side with bigger figure ---
grid.arrange(p_urban, p_rural, ncol = 2, widths = c(1.2, 1.2))
















library(ggplot2)
library(sf)
library(gridExtra)
library(ggspatial)

# --- Get centroids for province labels ---
urban_map$centroid <- st_centroid(urban_map$geometry)
urban_map_coords <- cbind(urban_map, st_coordinates(urban_map$centroid))

rural_map$centroid <- st_centroid(rural_map$geometry)
rural_map_coords <- cbind(rural_map, st_coordinates(rural_map$centroid))

# --- Urban map with smaller labels ---
p_urban <- ggplot() +
  geom_sf(data = urban_map, aes(fill = RF_prob), color = "white", size = 0.3) +
  geom_text(data = urban_map_coords, aes(X, Y, label = adm1_name_), 
            size = 2, fontface = "bold", color = "black") +  # smaller labels
  annotation_north_arrow(location = "tl", which_north = "true", 
                         style = north_arrow_fancy_orienteering()) +
  annotation_scale(location = "bl", width_hint = 0.3) +
  scale_fill_gradient(low = "#FEE08B", high = "#D73027", na.value = "grey90",
                      name = "Predicted\nSBA Probability") +
  theme_minimal(base_size = 16) +
  labs(title = "Urban") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16),
    legend.title = element_text(face = "bold"),
    legend.position = "right",
    panel.border = element_blank()
  )

# --- Rural map with smaller labels ---
p_rural <- ggplot() +
  geom_sf(data = rural_map, aes(fill = RF_prob), color = "white", size = 0.3) +
  geom_text(data = rural_map_coords, aes(X, Y, label = adm1_name_), 
            size = 2, fontface = "bold", color = "black") +  # smaller labels
  annotation_north_arrow(location = "tl", which_north = "true", 
                         style = north_arrow_fancy_orienteering()) +
  annotation_scale(location = "bl", width_hint = 0.3) +
  scale_fill_gradient(low = "#FEE08B", high = "#D73027", na.value = "grey90",
                      name = "Predicted\nSBA Probability") +
  theme_minimal(base_size = 16) +
  labs(title = "Rural") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16),
    legend.title = element_text(face = "bold"),
    legend.position = "right",
    panel.border = element_blank()
  )

# --- Combine side by side ---
grid.arrange(p_urban, p_rural, ncol = 2, widths = c(1.2, 1.2))








