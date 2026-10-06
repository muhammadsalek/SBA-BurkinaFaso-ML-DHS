











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
  labs(title = "SBA Prevalence (3D style)", fill = "SBA Status") +
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

# -------------------------------
# 1️⃣ Prepare train-test split
# -------------------------------
set.seed(123)
split <- initial_split(train_boruta, prop = 0.8, strata = SBA)
train <- training(split)
test  <- testing(split)

# Ensure Boruta-selected variables + outcome
train <- train %>% select(all_of(final_vars), SBA)
test  <- test  %>% select(all_of(final_vars), SBA)

# -------------------------------
# 2️⃣ SMOTE on training set (after dummy encoding)
# -------------------------------
rec <- recipe(SBA ~ ., data = train) %>%
  step_dummy(all_nominal_predictors(), -all_outcomes()) %>% # convert factors to numeric
  step_smote(SBA)                                           # handle class imbalance

train_smote <- prep(rec) %>% bake(new_data = NULL)

# Bake test set (apply same preprocessing but no SMOTE)
test_dummy <- prep(rec) %>% bake(new_data = test)

# Check class balance
table(train_smote$SBA)
prop.table(table(train_smote$SBA)) * 100

# -------------------------------
# 3️⃣ Cross-validation setup
# -------------------------------
ctrl <- trainControl(
  method = "cv",
  number = 5,
  summaryFunction = twoClassSummary,
  classProbs = TRUE,
  savePredictions = "final"
)

# -------------------------------
# 4️⃣ Define models
# -------------------------------
models <- list(
  "Random Forest"       = "rf",
  "Decision Tree"       = "rpart",
  "KNN"                 = "knn",
  "Logistic Regression" = "glm",
  "SVM"                 = "svmRadial",
  "XGBoost"             = "xgbTree",
  "Neural Network"      = "nnet"
)

results <- list()
formula_model <- as.formula("SBA ~ .")

# -------------------------------
# 5️⃣ Train models
# -------------------------------
for (model_name in names(models)) {
  set.seed(123)
  
  if (models[[model_name]] == "glm") {
    results[[model_name]] <- train(
      formula_model,
      data = train_smote,
      method = "glm",
      family = binomial(),
      trControl = ctrl,
      metric = "ROC"
    )
  } else {
    results[[model_name]] <- train(
      formula_model,
      data = train_smote,
      method = models[[model_name]],
      trControl = ctrl,
      metric = "ROC",
      tuneLength = 5
    )
  }
}

# -------------------------------
# 6️⃣ Evaluate on test set
# -------------------------------
performance <- map_dfr(names(results), function(name) {
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













# SMOTE + Model Training on Boruta-selected (without MCC)

library(tidymodels)
library(themis)
library(dplyr)
library(purrr)
library(caret)
library(pROC)

#  Prepare train-test split

set.seed(123)
split <- initial_split(train_boruta, prop = 0.8, strata = SBA)
train <- training(split)
test  <- testing(split)

# Ensure Boruta-selected variables + outcome
train <- train %>% select(all_of(final_vars), SBA)
test  <- test  %>% select(all_of(final_vars), SBA)


#  SMOTE on training set (after dummy encoding)

rec <- recipe(SBA ~ ., data = train) %>%
  step_dummy(all_nominal_predictors(), -all_outcomes()) %>% # convert factors to numeric
  step_smote(SBA)                                           # handle class imbalance

train_smote <- prep(rec) %>% bake(new_data = NULL)

# Bake test set (apply same preprocessing but no SMOTE)
test_dummy <- prep(rec) %>% bake(new_data = test)

# Check class balance
table(train_smote$SBA)
prop.table(table(train_smote$SBA)) * 100


#  Cross-validation setup

ctrl <- trainControl(
  method = "cv",
  number = 5,
  summaryFunction = twoClassSummary,
  classProbs = TRUE,
  savePredictions = "final"
)



#  Define models

models <- list(
  "Random Forest"       = "rf",
  "Decision Tree"       = "rpart",
  "KNN"                 = "knn",
  "Logistic Regression" = "glm",
  "SVM"                 = "svmRadial",
  "XGBoost"             = "xgbTree",
  "Neural Network"      = "nnet"
)

results <- list()
formula_model <- as.formula("SBA ~ .")

#  Train models

for (model_name in names(models)) {
  set.seed(123)
  
  if (models[[model_name]] == "glm") {
    results[[model_name]] <- train(
      formula_model,
      data = train_smote,
      method = "glm",
      family = binomial(),
      trControl = ctrl,
      metric = "ROC"
    )
  } else {
    results[[model_name]] <- train(
      formula_model,
      data = train_smote,
      method = models[[model_name]],
      trControl = ctrl,
      metric = "ROC",
      tuneLength = 5
    )
  }
}

#  Evaluate on test set

performance <- map_dfr(names(results), function(name) {
  model <- results[[name]]
  
  pred <- predict(model, test_dummy)
  prob <- predict(model, test_dummy, type = "prob")[, "Skilled"]
  
  cm <- confusionMatrix(pred, test_dummy$SBA, positive = "Skilled")
  
  data.frame(
    Model     = name,
    Accuracy  = cm$overall["Accuracy"],
    Precision = cm$byClass["Precision"],
    Recall    = cm$byClass["Recall"],
    F1        = cm$byClass["F1"],
    Kappa     = cm$overall["Kappa"],
    AUROC     = as.numeric(pROC::roc(test_dummy$SBA == "Skilled", prob)$auc)
  )
})


#  Print results

print(performance)







# -------------------------------
# Save performance results
# -------------------------------
output_path <- "D:/Research/BDHS Research/Nepal/SBA/ML Analysis/Table/performance_results.csv"

write.csv(performance, file = output_path, row.names = FALSE)

cat("Performance table saved to:", output_path)





















#### Tuning ####


#### SMOTE + Boruta-selected Model Training + Tuning #### 

library(tidymodels)
library(themis)
library(dplyr)
library(purrr)
library(mccr)
library(caret)
library(pROC)
library(readr)

library(tidymodels)
library(themis)
library(dplyr)
library(purrr)
library(caret)
library(pROC)
library(readr)
library(glmnet)  # for Lasso logistic regression

# -------------------------------
# Train-test split (Boruta-selected)
# -------------------------------
set.seed(123)
split <- initial_split(train_boruta, prop = 0.8, strata = SBA)
train <- training(split)
test  <- testing(split)

# -------------------------------
#  Recipe: dummy vars + SMOTE on training
# -------------------------------
rec <- recipe(SBA ~ ., data = train) %>%
  step_dummy(all_nominal_predictors(), -all_outcomes()) %>%  # convert factors to numeric
  step_smote(SBA)                                           # balance classes on train

rec_prep <- prep(rec)

train_smote   <- bake(rec_prep, new_data = NULL)
test_prepped  <- bake(rec_prep, new_data = test)  # apply same preprocessing, NO SMOTE

# Ensure outcome factor levels
train_smote$SBA  <- factor(train_smote$SBA, levels = c("Unskilled", "Skilled"))
test_prepped$SBA <- factor(test_prepped$SBA, levels = c("Unskilled", "Skilled"))

# -------------------------------
#  Cross-validation setup
# -------------------------------
ctrl <- trainControl(
  method = "cv",
  number = 5,
  summaryFunction = twoClassSummary,
  classProbs = TRUE,
  savePredictions = "final"
)

# -------------------------------
#  Model tuning grids
# -------------------------------
rf_grid <- expand.grid(mtry = seq(2, length(final_vars), by = 1))
svm_grid <- expand.grid(C = 2^(-1:2), sigma = 0.01)
xgb_grid <- expand.grid(
  nrounds = 500,
  max_depth = c(2,3,4),
  eta = c(0.01, 0.1),
  gamma = 0,
  colsample_bytree = 0.7,
  min_child_weight = 1,
  subsample = 0.7
)
knn_grid <- expand.grid(k = seq(3, 15, 2))
nnet_grid <- expand.grid(size = c(3,5,7), decay = c(0.1, 0.01))
lasso_grid <- expand.grid(alpha = 1, lambda = seq(0.001, 0.1, length.out = 10))

# -------------------------------
# Define models
# -------------------------------
models <- list(
  "Random Forest"       = list(method="rf", tune=rf_grid),
  "Decision Tree"       = list(method="rpart", tune=NULL),
  "KNN"                 = list(method="knn", tune=knn_grid),
  "Logistic Regression (Lasso)" = list(method="glmnet", tune=lasso_grid),
  "SVM"                 = list(method="svmRadial", tune=svm_grid),
  "XGBoost"             = list(method="xgbTree", tune=xgb_grid),
  "Neural Network"      = list(method="nnet", tune=nnet_grid)
)

formula_model <- as.formula("SBA ~ .")

# -------------------------------
#  Train models
# -------------------------------
results <- list()

for (model_name in names(models)) {
  set.seed(123)
  
  if (models[[model_name]]$method %in% c("glm", "glmnet")) {
    results[[model_name]] <- train(
      formula_model,
      data = train_smote,
      method = models[[model_name]]$method,
      family = binomial(),
      trControl = ctrl,
      metric = "ROC",
      tuneGrid = models[[model_name]]$tune
    )
  } else {
    results[[model_name]] <- train(
      formula_model,
      data = train_smote,
      method = models[[model_name]]$method,
      trControl = ctrl,
      metric = "ROC",
      tuneGrid = models[[model_name]]$tune,
      tuneLength = ifelse(is.null(models[[model_name]]$tune), 5, NULL)
    )
  }
}

# -------------------------------
#  Evaluate on test set
# -------------------------------
performance <- map_dfr(names(results), function(name) {
  model <- results[[name]]
  
  pred <- predict(model, test_prepped)
  prob <- predict(model, test_prepped, type = "prob")[, "Skilled"]
  
  cm <- confusionMatrix(pred, test_prepped$SBA, positive = "Skilled")
  
  data.frame(
    Model     = name,
    Accuracy  = cm$overall["Accuracy"],
    Precision = cm$byClass["Precision"],
    Recall    = cm$byClass["Recall"],
    F1        = cm$byClass["F1"],
    Kappa     = cm$overall["Kappa"],
    AUROC     = as.numeric(pROC::roc(test_prepped$SBA == "Skilled", prob)$auc)
  )
})

# -------------------------------
#  Save performance table
# -------------------------------
write_csv(performance, "D:/Research/BDHS Research/Nepal/SBA/ML Analysis/Table/performance_tuned_noMCC.csv")

# -------------------------------
#  Print results
# -------------------------------
print(performance)








#### Visualization ####























# -------------------------------
# 3️⃣ Radar plot of model performance
# -------------------------------
# Normalize metrics (Accuracy, Precision, Recall, F1, AUROC)
perf_scaled <- performance %>%
  mutate(
    Accuracy  = rescale(Accuracy, to = c(0,1)),
    Precision = rescale(Precision, to = c(0,1)),
    Recall    = rescale(Recall, to = c(0,1)),
    F1        = rescale(F1, to = c(0,1)),
    AUROC     = rescale(AUROC, to = c(0,1))
  ) %>%
  select(Model, Accuracy, Precision, Recall, F1, AUROC) %>%
  pivot_longer(cols = -Model, names_to = "Metric", values_to = "Value")

# Radar plot using ggplot2
ggplot(perf_scaled, aes(x = Metric, y = Value, group = Model, color = Model)) +
  geom_polygon(fill = NA, size = 1, alpha = 0.5) +
  geom_point(size = 2) +
  coord_polar() +
  theme_minimal(base_size = 14) +
  labs(title = "Radar Plot: Model Performance Comparison") +
  theme(legend.position = "bottom")















library(ggplot2)
library(dplyr)
library(tidyr)
library(scales)

# -------------------------------
# Normalize metrics for radar plot
# -------------------------------
perf_scaled <- performance %>%
  mutate(
    Accuracy  = rescale(Accuracy, to = c(0,1)),
    Precision = rescale(Precision, to = c(0,1)),
    Recall    = rescale(Recall, to = c(0,1)),
    F1        = rescale(F1, to = c(0,1)),
    AUROC     = rescale(AUROC, to = c(0,1))
  ) %>%
  select(Model, Accuracy, Precision, Recall, F1, AUROC) %>%
  pivot_longer(cols = -Model, names_to = "Metric", values_to = "Value")

# -------------------------------
# Bright & clean radar plot
# -------------------------------
ggplot(perf_scaled, aes(x = Metric, y = Value, group = Model, color = Model, fill = Model)) +
  geom_polygon(alpha = 0.2, size = 1.2, show.legend = TRUE) +
  geom_point(size = 3) +
  coord_polar(start = 0) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
  scale_color_brewer(palette = "Dark2") +
  scale_fill_brewer(palette = "Dark2") +
  theme_minimal(base_size = 14) +
  theme(
    axis.title = element_blank(),
    panel.grid.major = element_line(color = "grey80"),
    panel.grid.minor = element_blank(),
    legend.position = "bottom",
    legend.title = element_blank(),
    plot.title = element_text(face = "bold", hjust = 0.5)
  ) +
  labs(title = "Radar Plot: Model Performance Comparison")

















library(ggplot2)
library(dplyr)
library(tidyr)
library(scales)

# Normalize metrics for radar plot
perf_scaled <- performance %>%
  mutate(
    Accuracy  = rescale(Accuracy, to = c(0,1)),
    Precision = rescale(Precision, to = c(0,1)),
    Recall    = rescale(Recall, to = c(0,1)),
    F1        = rescale(F1, to = c(0,1)),
    AUROC     = rescale(AUROC, to = c(0,1))
  ) %>%
  select(Model, Accuracy, Precision, Recall, F1, AUROC) %>%
  pivot_longer(cols = -Model, names_to = "Metric", values_to = "Value")

# Radar plot
ggplot(perf_scaled, aes(x = Metric, y = Value, group = Model, color = Model)) +
  geom_polygon(fill = NA, size = 1.2, alpha = 0.6) +
  geom_point(size = 3) +
  coord_polar() +
  theme_minimal(base_size = 14) +
  labs(title = "Radar Plot: Model Performance Comparison") +
  theme(legend.position = "bottom")












library(caret)
set.seed(123)

xgb_caret <- train(
  SBA ~ .,
  data = train_smote,
  method = "xgbTree",
  trControl = ctrl,
  metric = "ROC",
  tuneGrid = xgb_grid  # or reduce grid size to avoid errors
)

# Now varImp works
xgb_imp <- varImp(xgb_caret, scale = TRUE)$importance
xgb_imp$Feature <- rownames(xgb_imp)

library(ggplot2)
ggplot(xgb_imp, aes(x = reorder(Feature, Overall), y = Overall)) +
  geom_col(fill = "#0072B2") +
  coord_flip() +
  theme_minimal(base_size = 14) +
  labs(title = "XGBoost Feature Importance", y = "Importance", x = "")



























library(ggplot2)
library(dplyr)
library(stringr)

# Optionally shorten long feature names for clean display
xgb_imp <- xgb_imp %>%
  mutate(Feature_short = str_wrap(Feature, width = 20))  # wrap long names to 2 lines

# Order features by importance
xgb_imp <- xgb_imp %>% arrange(Overall)

# Polished plot
ggplot(xgb_imp, aes(x = reorder(Feature_short, Overall), y = Overall)) +
  geom_col(fill = "#0072B2", alpha = 0.8) +
  coord_flip() +
  theme_minimal(base_size = 14) +
  labs(
    title = "XGBoost Feature Importance",
    subtitle = "Based on trained model on Boruta-selected features",
    y = "Importance",
    x = NULL
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 12, color = "gray30"),
    axis.text.y = element_text(size = 10),
    axis.text.x = element_text(size = 10),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank()
  )















library(xgboost)
library(dplyr)

# Assuming you already trained plain XGBoost
# xgb_model, train_matrix

# Extract feature importance
shap_values <- xgb.importance(feature_names = colnames(train_matrix), model = xgb_model)

# View as dataframe
shap_df <- shap_values %>%
  as.data.frame() %>%
  arrange(desc(Gain))  # Sort by importance

# Optional: just select main columns
shap_df <- shap_df %>% select(Feature, Gain, Cover, Frequency)

# Print
print(shap_df)



























library(ggplot2)
library(dplyr)
library(stringr)

# Exclude unwanted feature
xgb_imp_clean <- shap_df %>%
  filter(Feature != "husb_edu_Don.t.know.Missing") %>%
  # Shorten feature names
  mutate(Feature_short = str_replace_all(Feature, "_", " "),
         Feature_short = str_trunc(Feature_short, 25, "right"))  # truncate long names

# Polished horizontal bar plot
ggplot(xgb_imp_clean, aes(x = reorder(Feature_short, Gain), y = Gain)) +
  geom_col(fill = "#0072B2", alpha = 0.8) +
  coord_flip() +
  theme_minimal(base_size = 14) +
  labs(
    title = "XGBoost Feature Importance",
    subtitle = "Based on trained model on Boruta-selected features",
    y = "Importance (Gain)",
    x = NULL
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 12, color = "gray30"),
    axis.text.y = element_text(size = 10),
    axis.text.x = element_text(size = 10),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank()
  )



















library(ggplot2)
library(dplyr)

# Exclude only the unwanted feature
xgb_imp_clean <- shap_df %>%
  filter(Feature != "husb_edu_Don.t.know.Missing")

# Polished horizontal bar plot
ggplot(xgb_imp_clean, aes(x = reorder(Feature, Gain), y = Gain)) +
  geom_col(fill = "#0072B2", alpha = 0.8) +
  coord_flip() +
  theme_minimal(base_size = 14) +
  labs(
    title = "XGBoost Feature Importance",
    y = "Importance (Gain)",
    x = NULL
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 12, color = "gray30"),
    axis.text.y = element_text(size = 10),
    axis.text.x = element_text(size = 10),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank()
  )


























library(ggplot2)
library(dplyr)

# Exclude the unwanted feature
xgb_imp_clean <- shap_df %>%
  filter(Feature != "husb_edu_Don.t.know.Missing")

# Polished horizontal bar plot with error bars
ggplot(xgb_imp_clean, aes(x = reorder(Feature, Gain), y = Gain)) +
  geom_col(fill = "#0072B2", alpha = 0.8) +
  geom_errorbar(aes(ymin = Gain - Frequency, ymax = Gain + Frequency), 
                width = 0.4, color = "gray40", alpha = 0.7) +
  coord_flip() +
  theme_minimal(base_size = 14) +
  labs(
    title = "XGBoost Feature Importance",
    y = "Importance (Gain)",
    x = NULL
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 12, color = "gray30"),
    axis.text.y = element_text(size = 10),
    axis.text.x = element_text(size = 10),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank()
  )
















































































































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
boruta_result <- Boruta(SBA ~ ., data = train_data, doTrace = 2, maxRuns = 100)

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

# Plot with updated colors
ggplot(boruta_plot_df, aes(x = Feature, y = MeanImp, fill = Decision)) +
  geom_bar(stat = "identity", color = "black", width = 0.7) +
  geom_errorbar(aes(ymin = MinImp, ymax = MaxImp), width = 0.3, color = "black") +
  coord_flip() +
  scale_fill_manual(values = c(
    "Confirmed" = "#00BFC4",   # bright cyan-blue
    "Rejected" = "#F8766D",    # bright coral red
    "Tentative" = "#7CAE00"    # bright lime green
  )) +
  labs(title = "Boruta Feature Importance",
       y = "Mean Importance (with min–max)", x = "") +
  theme_minimal(base_size = 14) +
  theme(legend.title = element_blank())







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

# Plot with more distinct colors
ggplot(boruta_plot_df, aes(x = Feature, y = MeanImp, fill = Decision)) +
  geom_bar(stat = "identity", color = "black", width = 0.7) +
  geom_errorbar(aes(ymin = MinImp, ymax = MaxImp), width = 0.3, color = "black") +
  coord_flip() +
  scale_fill_manual(values = c(
    "Confirmed" = "#E69F00",   # bright orange
    "Rejected"  = "#56B4E9",   # sky blue
    "Tentative" = "#009E73"    # deep green
  )) +
  labs(title = "Boruta Feature Importance",
       y = "Mean Importance (with min–max)", x = "") +
  theme_minimal(base_size = 14) +
  theme(legend.title = element_blank())











#### Model development after boruta ####

train_boruta_ml <- train_boruta

train_boruta_ml[] <- lapply(train_boruta_ml, function(x) {
  if(is.factor(x)) {
    x <- factor(iconv(as.character(x), from = "UTF-8", to = "ASCII//TRANSLIT"))
    x <- factor(gsub("≤", "le_", x))
    x <- factor(gsub("≥", "ge_", x))
    x <- factor(gsub("/", "_",  x))
    x <- factor(gsub(" ", "_",  x))
  }
  x
})
















###############################################
### 4. CLEAN FACTOR LABELS (AFTER BORUTA)   ###
###############################################

train_boruta_ml <- train_boruta

train_boruta_ml[] <- lapply(train_boruta_ml, function(x) {
  if(is.factor(x)) {
    x <- factor(iconv(as.character(x), from = "UTF-8", to = "ASCII//TRANSLIT"))
    x <- factor(gsub("≤", "le_", x))
    x <- factor(gsub("≥", "ge_", x))
    x <- factor(gsub("/", "_", x))
    x <- factor(gsub(" ", "_", x))
  }
  x
})

# Clean column names
colnames(train_boruta_ml) <- iconv(colnames(train_boruta_ml), from = "UTF-8", to = "ASCII//TRANSLIT")
colnames(train_boruta_ml) <- make.names(colnames(train_boruta_ml), unique = TRUE)



###############################################
### 5. TRAIN–TEST SPLIT (STRATIFIED)        ###
###############################################

library(tidymodels)

set.seed(123)
split <- initial_split(train_boruta_ml, prop = 0.8, strata = SBA)
train <- training(split)
test  <- testing(split)



###############################################
### 6. CLEAN TRAIN/TEST FACTORS              ###
###############################################

train[] <- lapply(train, function(x) {
  if(is.factor(x)) {
    x <- factor(iconv(as.character(x), from = "UTF-8", to = "ASCII//TRANSLIT"))
    x <- factor(gsub("≤", "le_", x))
    x <- factor(gsub("≥", "ge_", x))
    x <- factor(gsub("/", "_", x))
    x <- factor(gsub(" ", "_", x))
  }
  x
})

test[] <- lapply(test, function(x) {
  if(is.factor(x)) {
    x <- factor(iconv(as.character(x), from = "UTF-8", to = "ASCII//TRANSLIT"))
    x <- factor(gsub("≤", "le_", x))
    x <- factor(gsub("≥", "ge_", x))
    x <- factor(gsub("/", "_",  x))
    x <- factor(gsub(" ", "_",  x))
  }
  x
})

# Make names ASCII
colnames(train) <- make.names(iconv(colnames(train), from="UTF-8", to="ASCII//TRANSLIT"), unique = TRUE)
colnames(test)  <- make.names(iconv(colnames(test),  from="UTF-8", to="ASCII//TRANSLIT"), unique = TRUE)



###############################################
### 7. RECIPE (NO SMOTE)                    ###
###############################################

rec <- recipe(SBA ~ ., data = train) %>%
  step_unknown(all_nominal_predictors(), new_level = "unknown") %>% 
  step_dummy(all_nominal_predictors(), -all_outcomes())

train_prep <- prep(rec, training = train) %>% bake(new_data = NULL)
test_prep  <- prep(rec, training = train) %>% bake(new_data = test)

# Check class balance
table(train_prep$SBA)



###############################################
### 8. TRAIN MULTIPLE MODELS (NO SMOTE)     ###
###############################################

library(caret)
library(pROC)
library(mccr)
library(purrr)
library(tidymodels)

ctrl <- trainControl(
  method = "cv",
  number = 5,
  summaryFunction = twoClassSummary,
  classProbs = TRUE,
  savePredictions = "final"
)

models <- list(
  "Random Forest"       = "rf",
  "Decision Tree"       = "rpart",
  "KNN"                 = "knn",
  "Logistic Regression" = "glm",
  "SVM"                 = "svmRadial",
  "XGBoost"             = "xgbTree",
  "Neural Network"      = "nnet"
)

results <- list()
formula_model <- SBA ~ .

for (m in names(models)) {
  set.seed(123)
  
  if (models[[m]] == "glm") {
    results[[m]] <- train(
      formula_model,
      data = train_prep,
      method = "glm",
      family = binomial(),
      trControl = ctrl,
      metric = "ROC"
    )
  } else {
    results[[m]] <- train(
      formula_model,
      data = train_prep,
      method = models[[m]],
      trControl = ctrl,
      metric = "ROC",
      tuneLength = 5
    )
  }
}



###############################################
### 9. EVALUATE ON TEST SET                 ###
###############################################

performance <- purrr::map_dfr(names(results), function(m) {
  model <- results[[m]]
  
  pred <- predict(model, test_prep)
  prob <- predict(model, test_prep, type = "prob")[, "Skilled"]
  
  cm <- confusionMatrix(pred, test_prep$SBA, positive = "Skilled")
  MCC_val <- mccr::mccr(test_prep$SBA == "Skilled", pred == "Skilled")
  
  data.frame(
    Model     = m,
    Accuracy  = cm$overall["Accuracy"],
    Precision = cm$byClass["Precision"],
    Recall    = cm$byClass["Recall"],
    F1        = cm$byClass["F1"],
    MCC       = MCC_val,
    Kappa     = cm$overall["Kappa"],
    AUROC     = as.numeric(roc(test_prep$SBA == "Skilled", prob)$auc)
  )
})

print(performance)







# Round numeric columns to 2 decimals
performance_round <- performance
numeric_cols <- sapply(performance_round, is.numeric)
performance_round[numeric_cols] <- lapply(performance_round[numeric_cols], function(x) round(x, 2))

# Save as CSV
output_path <- "D:/Research/BDHS Research/Nepal/SBA/Angola/Table"
if(!dir.exists(output_path)) dir.create(output_path, recursive = TRUE)

write.csv(performance_round, 
          file = file.path(output_path, "SBA_model_performance.csv"), 
          row.names = FALSE)









#### Tuning ####
library(caret)
library(pROC)
library(mccr)
library(purrr)
library(tidymodels)











#### 9. TUNING AND MODEL TRAINING ####

library(caret)
library(pROC)
library(mccr)
library(purrr)
library(tidymodels)
library(kernlab)   # needed for sigest (SVM)

# 1️⃣ Cross-validation setup
ctrl <- trainControl(
  method = "cv",
  number = 5,
  summaryFunction = twoClassSummary,
  classProbs = TRUE,
  savePredictions = "final"
)

# 2️⃣ Define models
models <- list(
  "Random Forest"       = "rf",
  "Decision Tree"       = "rpart",
  "KNN"                 = "knn",
  "Logistic Regression" = "glm",
  "SVM"                 = "svmRadial",
  "XGBoost"             = "xgbTree",
  "Neural Network"      = "nnet"
)

results <- list()
formula_model <- SBA ~ .

# 3️⃣ Train and tune models
for (m in names(models)) {
  set.seed(123)
  
  # Default tuning grid
  tuneGrid <- NULL
  
  if (models[[m]] == "rf") {
    tuneGrid <- expand.grid(mtry = c(2, 3, 4, 5, 6))
  } else if (models[[m]] == "rpart") {
    tuneGrid <- expand.grid(cp = seq(0.01, 0.1, by = 0.01))
  } else if (models[[m]] == "knn") {
    tuneGrid <- expand.grid(k = seq(3, 15, by = 2))
  } else if (models[[m]] == "svmRadial") {
    tuneGrid <- expand.grid(
      sigma = sigest(SBA ~ ., data = train_prep)[1],
      C = 2^(-2:2)
    )
  } else if (models[[m]] == "xgbTree") {
    tuneGrid <- expand.grid(
      nrounds = c(100, 200),
      max_depth = c(3, 5, 7),
      eta = c(0.01, 0.1),
      gamma = 0,
      colsample_bytree = 0.8,
      min_child_weight = 1,
      subsample = 0.8
    )
  } else if (models[[m]] == "nnet") {
    tuneGrid <- expand.grid(size = c(3, 5, 7), decay = c(0, 0.1, 0.5))
  }
  
  # Train model
  if (models[[m]] == "glm") {
    results[[m]] <- train(
      formula_model,
      data = train_prep,
      method = "glm",
      family = binomial,
      trControl = ctrl,
      metric = "ROC"
    )
  } else {
    results[[m]] <- train(
      formula_model,
      data = train_prep,
      method = models[[m]],
      trControl = ctrl,
      metric = "ROC",
      tuneGrid = tuneGrid
    )
  }
}

# 4️⃣ Evaluate models on test set
performance <- purrr::map_dfr(names(results), function(m) {
  model <- results[[m]]
  
  pred <- predict(model, test_prep)
  prob <- predict(model, test_prep, type = "prob")[, "Skilled"]
  
  cm <- confusionMatrix(pred, test_prep$SBA, positive = "Skilled")
  MCC_val <- mccr::mccr(test_prep$SBA == "Skilled", pred == "Skilled")
  
  data.frame(
    Model     = m,
    Accuracy  = round(cm$overall["Accuracy"], 2),
    Precision = round(cm$byClass["Precision"], 2),
    Recall    = round(cm$byClass["Recall"], 2),
    F1        = round(cm$byClass["F1"], 2),
    MCC       = round(MCC_val, 2),
    Kappa     = round(cm$overall["Kappa"], 2),
    AUROC     = round(as.numeric(roc(test_prep$SBA == "Skilled", prob)$auc), 2)
  )
})




print(performance)






# 5️⃣ Save performance table (2-decimal for journal style)
output_path <- "D:/Research/BDHS Research/Nepal/SBA/Angola/Table"
if(!dir.exists(output_path)) dir.create(output_path, recursive = TRUE)

# Round numeric columns to 2 decimals
performance_round <- performance
numeric_cols <- sapply(performance_round, is.numeric)
performance_round[numeric_cols] <- lapply(performance_round[numeric_cols], function(x) round(x, 2))

# Save CSV
write.csv(performance_round, 
          file = file.path(output_path, "SBA_model_performance_tuned.csv"), 
          row.names = FALSE)

cat("Tuned performance table saved (2-decimal) in:", output_path, "\n")







#### Visualization ####


library(pROC)
library(ggplot2)

# Initialize an empty list to store ROC objects
roc_list <- list()

# Loop over models to calculate ROC curves
for (m in names(results)) {
  model <- results[[m]]
  
  # Predict probabilities for the positive class ("Skilled")
  prob <- predict(model, test_prep, type = "prob")[, "Skilled"]
  
  # ROC curve
  roc_obj <- roc(test_prep$SBA == "Skilled", prob)
  roc_list[[m]] <- roc_obj
}

# Plot all ROC curves together
colors <- rainbow(length(roc_list))
plot(roc_list[[1]], col = colors[1], lwd = 2, main = "ROC Curves for All Models")
for(i in 2:length(roc_list)) {
  plot(roc_list[[i]], col = colors[i], lwd = 2, add = TRUE)
}

# Add legend with AUC values
legend("bottomright",
       legend = paste0(names(roc_list), " (AUC = ", 
                       sapply(roc_list, function(x) round(x$auc, 2)), ")"),
       col = colors, lwd = 2)



library(pROC)
library(ggplot2)
library(dplyr)
library(purrr)

# 1️⃣ Compute ROC curves and AUCs
roc_list <- lapply(names(results), function(m) {
  model <- results[[m]]
  prob <- predict(model, test_prep, type = "prob")[, "Skilled"]
  roc_obj <- roc(test_prep$SBA == "Skilled", prob)
  list(model = m, roc = roc_obj, auc = round(auc(roc_obj), 2))
})

# 2️⃣ Prepare dataframe for ggplot
roc_df <- purrr::map_dfr(roc_list, function(x) {
  coords_df <- coords(x$roc, x = "all", ret = c("specificity", "sensitivity"), transpose = FALSE)
  coords_df$model <- x$model
  coords_df
})

# 3️⃣ Create a lookup table for AUCs
auc_lookup <- data.frame(
  model = sapply(roc_list, `[[`, "model"),
  auc = sapply(roc_list, `[[`, "auc")
)

# 4️⃣ Plot ROC curves
ggplot(roc_df, aes(x = 1 - specificity, y = sensitivity, color = model)) +
  geom_line(linewidth = 1.2) +   # ggplot2 >= 3.4.0 uses 'linewidth'
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "grey50") +
  scale_color_brewer(palette = "Set1",
                     labels = paste0(auc_lookup$model, " (AUC=", auc_lookup$auc, ")")) +
  labs(
    title = "ROC Curves for All Models",
    x = "1 - Specificity",
    y = "Sensitivity",
    color = "Model"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    plot.title = element_text(face = "bold", hjust = 0.5)
  )











#### Recall curve plot of model performance ####

# -------------------------------
# 1️⃣ Load required libraries
# -------------------------------
library(ggplot2)
library(PRROC)
library(dplyr)

# -------------------------------
# 2️⃣ Compute PR curves for all models
# -------------------------------
pr_list <- lapply(names(results), function(m) {
  model <- results[[m]]
  
  # Predicted probabilities for the positive class
  prob <- predict(model, test_prep, type = "prob")[, "Skilled"]
  label <- ifelse(test_prep$SBA == "Skilled", 1, 0)
  
  # PR curve using PRROC package
  pr <- pr.curve(scores.class0 = prob[label == 1],
                 scores.class1 = prob[label == 0],
                 curve = TRUE)
  
  # Return dataframe with precision, recall, model
  data.frame(
    Recall = pr$curve[,1],
    Precision = pr$curve[,2],
    Model = m
  )
})

# Combine all models into one dataframe
pr_df <- bind_rows(pr_list)

# -------------------------------
# 3️⃣ Plot PR curves (polished)
# -------------------------------
ggplot(pr_df, aes(x = Recall, y = Precision, color = Model)) +
  geom_line(size = 1.2) +
  scale_color_brewer(palette = "Set1") +
  labs(
    title = "Precision-Recall Curves for All Models",
    x = "Recall (Sensitivity)",
    y = "Precision (Positive Predictive Value)",
    color = "Model"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16),
    axis.title = element_text(face = "bold", size = 14),
    axis.text = element_text(size = 12),
    legend.position = "bottom",
    legend.title = element_text(face = "bold")
  )








#### Diagnostics ####
library(stats)

# Store predictions for each model
pred_list <- list()
for (m in names(results)) {
  pred_list[[m]] <- predict(results[[m]], test_prep)
}

# Run McNemar Tests — comparing each model vs XGBoost
cat("\n===== McNemar Test Results (vs XGBoost) =====\n")
for (m in names(pred_list)) {
  if (m != "XGBoost") {
    tbl <- table(pred_list[[m]] == test_prep$SBA, 
                 pred_list[["XGBoost"]] == test_prep$SBA)
    mc <- mcnemar.test(tbl)
    cat("\n", m, "vs XGBoost → p-value:", mc$p.value)
  }
}



#### McNemar Tests for ALL MODELS####


library(stats)

# Collect predictions
pred_list <- list()
for (m in names(results)) {
  pred_list[[m]] <- predict(results[[m]], test_prep)
}

cat("\n===== McNemar Test: Model vs XGBoost =====\n")
for (m in names(pred_list)) {
  if (m != "XGBoost") {
    tbl <- table(pred_list[[m]] == test_prep$SBA,
                 pred_list[["XGBoost"]] == test_prep$SBA)
    mc <- mcnemar.test(tbl)
    cat("\n", m, "vs XGBoost → p-value:", mc$p.value)
  }
}

cat("\n\n===== McNemar Test: Model vs Neural Network =====\n")
for (m in names(pred_list)) {
  if (m != "Neural Network") {
    tbl <- table(pred_list[[m]] == test_prep$SBA,
                 pred_list[["Neural Network"]] == test_prep$SBA)
    mc <- mcnemar.test(tbl)
    cat("\n", m, "vs Neural Network → p-value:", mc$p.value)
  }
}





#### Calibration plot ####
library(ggplot2)
library(dplyr)
library(scales)

calibration_plot <- function(model, model_name) {
  prob <- predict(model, test_prep, type = "prob")[, "Skilled"]
  df <- data.frame(prob = prob, actual = test_prep$SBA == "Skilled")
  
  df <- df %>%
    mutate(bin = cut(prob, breaks = seq(0, 1, by = 0.1), include.lowest = TRUE)) %>%
    group_by(bin) %>%
    summarize(
      mean_pred = mean(prob),
      mean_actual = mean(actual),
      n = n()
    )
  
  ggplot(df, aes(x = mean_pred, y = mean_actual)) +
    geom_line(color = "blue", linewidth = 1.2) +
    geom_abline(intercept = 0, slope = 1, linetype = "dashed") +
    labs(
      title = paste("Calibration Plot —", model_name),
      x = "Predicted Probability",
      y = "Observed Proportion (True Skilled)"
    ) +
    theme_minimal(base_size = 14)
}

# Run calibration for best model:
calibration_plot(results[["XGBoost"]], "XGBoost")












library(ggplot2)
library(dplyr)

calibration_data <- function(model) {
  prob <- predict(model, test_prep, type = "prob")[, "Skilled"]
  df <- data.frame(prob = prob, actual = test_prep$SBA == "Skilled")
  
  df %>%
    mutate(bin = cut(prob, breaks = seq(0, 1, 0.1), include.lowest = TRUE)) %>%
    group_by(bin) %>%
    summarise(
      mean_pred = mean(prob),
      mean_actual = mean(actual),
      n = n()
    )
}

cal_list <- lapply(names(results), function(m) {
  x <- calibration_data(results[[m]])
  x$model <- m
  x
})

cal_all <- bind_rows(cal_list)

ggplot(cal_all, aes(x = mean_pred, y = mean_actual, color = model)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed") +
  labs(
    title = "Calibration Curves for All Models",
    x = "Predicted Probability",
    y = "Observed Probability",
    color = "Model"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5)
  )






ggplot(cal_all, aes(x = mean_pred, y = mean_actual)) +
  geom_line(color = "blue", size = 1.2) +
  geom_point(size = 2, color = "blue") +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed") +
  facet_wrap(~model, scales = "free") +
  labs(
    title = "Calibration Curves per Model",
    x = "Predicted Probability",
    y = "Observed Probability"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5)
  )



















































































