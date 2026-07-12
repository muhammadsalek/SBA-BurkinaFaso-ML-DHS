






#### Sensitivity Analysis: Random Forest Strategies ####

#### Load required libraries ####
library(caret)
library(pROC)
library(randomForest)
library(Boruta)
library(themis)
library(tidymodels)
library(dplyr)
library(ggplot2)
library(scales)
library(mccr)
library(ranger)
library(gridExtra)

#### Set seed for reproducibility ####
set.seed(123)

#### 1. Data Preparation (Assuming data_imputed exists) ####

#### Ensure SBA is factor with proper levels ####
data_imputed$SBA <- factor(data_imputed$SBA, levels = c("Unskilled", "Skilled"))

#### 2. Train-Test Split (80:20) ####

library(caret)
set.seed(123)

#### Stratified split to maintain class proportions ####
train_index <- createDataPartition(data_imputed$SBA, p = 0.8, list = FALSE)
train_data <- data_imputed[train_index, ]
test_data <- data_imputed[-train_index, ]

#### Check distribution in training set ####
cat("Original training set distribution:\n")
print(prop.table(table(train_data$SBA)) * 100)

#### 3. Feature Selection with Boruta (Training Set Only) ####

library(Boruta)
library(caret)
library(dplyr)

#### Ensure outcome is factor ####
train_data$SBA <- as.factor(train_data$SBA)

#### Identify numeric predictors ####
num_vars <- names(train_data)[sapply(train_data, is.numeric)]

#### Only scale numeric predictors if >1 numeric column exists ####
if(length(num_vars) > 1){
  train_data[num_vars] <- scale(train_data[num_vars])
  
  #### Compute correlation matrix ####
  cor_mat <- cor(train_data[, num_vars])
  
  #### Remove highly correlated numeric predictors (cutoff = 0.9) ####
  highCor <- findCorrelation(cor_mat, cutoff = 0.9)
  
  if(length(highCor) > 0){
    cat("\nRemoving highly correlated numeric predictors:\n")
    print(num_vars[highCor])
    train_data <- train_data[, -which(names(train_data) %in% num_vars[highCor])]
  }
} else {
  cat("\nNot enough numeric variables to compute correlation. Skipping correlation removal.\n")
}

#### Run Boruta ####
set.seed(123)
boruta_result <- Boruta(SBA ~ ., data = train_data, doTrace = 2, maxRuns = 200)

#### Tentative rough fix ####
boruta_final <- TentativeRoughFix(boruta_result)

#### Selected predictors ####
final_vars <- getSelectedAttributes(boruta_final, withTentative = FALSE)
cat("\nBoruta-selected features:\n")
print(final_vars)

#### Reduce training set to Boruta-selected predictors + outcome ####
train_boruta <- train_data[, c(final_vars, "SBA")]
test_boruta <- test_data[, c(final_vars, "SBA")]

#### Ensure both have same columns ####
test_boruta <- test_boruta[, colnames(train_boruta)]

#### 4. Model 1: SMOTE-based Random Forest ####

cat("\n========================================\n")
cat("MODEL 1: SMOTE + Random Forest\n")
cat("========================================\n")

#### Prepare data with SMOTE ####
train_boruta$SBA <- factor(train_boruta$SBA, levels = c("Unskilled", "Skilled"))
test_boruta$SBA <- factor(test_boruta$SBA, levels = c("Unskilled", "Skilled"))

#### Recipe with SMOTE ####
rec_smote <- recipe(SBA ~ ., data = train_boruta) %>%
  step_dummy(all_nominal_predictors(), -all_outcomes()) %>%
  step_zv(all_predictors()) %>%
  step_smote(SBA, over_ratio = 1)

#### Prepare and bake ####
train_prep_smote <- prep(rec_smote)
train_smote <- bake(train_prep_smote, new_data = NULL)
test_dummy <- bake(train_prep_smote, new_data = test_boruta)

#### Ensure SBA is factor ####
train_smote$SBA <- factor(train_smote$SBA, levels = c("Unskilled", "Skilled"))
test_dummy$SBA <- factor(test_dummy$SBA, levels = c("Unskilled", "Skilled"))

cat("\nSMOTE-applied training set distribution:\n")
print(prop.table(table(train_smote$SBA)) * 100)

#### Train Random Forest with SMOTE data ####
set.seed(123)
rf_smote <- randomForest(
  SBA ~ .,
  data = train_smote,
  ntree = 500,
  mtry = floor(sqrt(ncol(train_smote) - 1)),
  importance = TRUE,
  keep.forest = TRUE
)

#### Predictions for SMOTE model ####
pred_smote <- predict(rf_smote, test_dummy)
prob_smote <- predict(rf_smote, test_dummy, type = "prob")[, "Skilled"]

#### 5. Model 2: Class-weighted Random Forest ####

cat("\n========================================\n")
cat("MODEL 2: Class-weighted Random Forest\n")
cat("========================================\n")

#### Calculate class weights (inverse proportion) ####
class_counts <- table(train_boruta$SBA)
class_weights <- 1 / class_counts
class_weights <- class_weights / sum(class_weights) * length(class_weights)

cat("\nClass weights:\n")
print(class_weights)


table(train_boruta$SBA)
prop.table(table(train_boruta$SBA))*100










#### Train Random Forest with class weights ####
set.seed(123)
rf_weighted <- randomForest(
  SBA ~ .,
  data = train_boruta,
  ntree = 500,
  mtry = floor(sqrt(ncol(train_boruta) - 1)),
  importance = TRUE,
  keep.forest = TRUE,
  classwt = class_weights
)

#### Predictions for weighted model ####
pred_weighted <- predict(rf_weighted, test_boruta)
prob_weighted <- predict(rf_weighted, test_boruta, type = "prob")[, "Skilled"]

#### 6. Model 3: Balanced Random Forest (using ranger) - FIXED ####

cat("\n========================================\n")
cat("MODEL 3: Balanced Random Forest\n")
cat("========================================\n")

#### Check factor levels for correct sample.fraction order ####
cat("\nFactor levels for SBA:\n")
print(levels(train_boruta$SBA))

#### Using ranger with balanced sampling - CORRECT ORDER ####
library(ranger)

set.seed(123)

#### Calculate sample fractions based on factor level order ####
minority_prop <- sum(train_boruta$SBA == "Unskilled") / nrow(train_boruta)
majority_prop <- sum(train_boruta$SBA == "Skilled") / nrow(train_boruta)

#### Balanced sampling (both classes sampled equally) ####
balanced_sample_fraction <- c(
  minority_prop,  # For "Unskilled" - keeps all minority class
  minority_prop   # For "Skilled" - downsamples majority to match minority proportion
)

cat("\nSample fractions (in order of factor levels):\n")
cat("Unskilled:", round(balanced_sample_fraction[1], 4), "\n")
cat("Skilled:", round(balanced_sample_fraction[2], 4), "\n")

rf_balanced <- ranger(
  SBA ~ .,
  data = train_boruta,
  num.trees = 500,
  mtry = floor(sqrt(ncol(train_boruta) - 1)),
  importance = "permutation",
  probability = TRUE,
  sample.fraction = balanced_sample_fraction,
  replace = TRUE,
  seed = 123
)

#### Predictions for balanced model - FIXED ####
pred_balanced <- predict(rf_balanced, test_boruta)

#### Extract probabilities correctly ####
# When probability = TRUE, predictions are a matrix with columns for each class
prob_balanced <- pred_balanced$predictions[, "Skilled"]

#### Create class predictions ####
pred_balanced_class <- factor(ifelse(prob_balanced > 0.5, "Skilled", "Unskilled"),
                              levels = c("Unskilled", "Skilled"))

#### 7. Evaluation Function ####

evaluate_model <- function(pred_class, prob_score, true_class, model_name) {
  #### Confusion matrix ####
  cm <- confusionMatrix(pred_class, true_class, positive = "Skilled")
  
  #### Compute metrics ####
  accuracy <- cm$overall["Accuracy"]
  sensitivity <- cm$byClass["Sensitivity"]
  specificity <- cm$byClass["Specificity"]
  precision <- cm$byClass["Precision"]
  f1 <- cm$byClass["F1"]
  kappa <- cm$overall["Kappa"]
  
  #### MCC ####
  mcc_val <- mccr::mccr(true_class == "Skilled", pred_class == "Skilled")
  
  #### AUROC ####
  roc_obj <- roc(true_class, prob_score, levels = c("Unskilled", "Skilled"))
  auroc <- as.numeric(roc_obj$auc)
  
  #### Brier Score (calibration) ####
  true_numeric <- as.numeric(true_class == "Skilled")
  brier <- mean((true_numeric - prob_score)^2)
  
  #### Return results ####
  data.frame(
    Model = model_name,
    Accuracy = accuracy,
    Sensitivity = sensitivity,
    Specificity = specificity,
    Precision = precision,
    F1 = f1,
    MCC = mcc_val,
    Kappa = kappa,
    AUROC = auroc,
    Brier_Score = brier
  )
}

#### 8. Compare All Three Models ####

#### Evaluate each model ####
results_smote <- evaluate_model(pred_smote, prob_smote, test_dummy$SBA, "SMOTE + RF")
results_weighted <- evaluate_model(pred_weighted, prob_weighted, test_boruta$SBA, "Class-weighted RF")
results_balanced <- evaluate_model(pred_balanced_class, prob_balanced, test_boruta$SBA, "Balanced RF")

#### Combine results ####
comparison_df <- rbind(results_smote, results_weighted, results_balanced)

#### Round numeric columns ####
comparison_df[, -1] <- round(comparison_df[, -1], 4)

cat("\n========================================\n")
cat("COMPARISON OF RANDOM FOREST STRATEGIES\n")
cat("========================================\n")
print(comparison_df)



#### Save Results ####
comparison_df_export <- comparison_df

comparison_df_export[] <- lapply(comparison_df_export, function(x) {
  if (is.numeric(x)) sprintf("%.2f", x) else x
})

write.csv(
  comparison_df_export,
  "D:/Research/BDHS Research/Nepal/SBA/Burkina Faso/Analysis/Salek_ML(BF)/Table/comparison_df.csv",
  row.names = FALSE
)



#### 9. Visualization ####

#### 9.1 Performance Comparison Bar Plot ####
library(tidyr)

#### Reshape data for plotting ####
plot_data <- comparison_df %>%
  pivot_longer(cols = -Model, names_to = "Metric", values_to = "Value")

#### Create performance comparison plot ####
p1 <- ggplot(plot_data, aes(x = Metric, y = Value, fill = Model)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8), width = 0.7) +
  labs(title = "Performance Comparison of RF Strategies",
       x = "Metric", y = "Value") +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "top") +
  scale_fill_manual(values = c("SMOTE + RF" = "#0072B2", 
                               "Class-weighted RF" = "#D55E00", 
                               "Balanced RF" = "#009E73")) +
  coord_cartesian(ylim = c(0, 1))

print(p1)










#### 9.1 Performance Comparison Bar Plot ####
library(tidyr)
library(ggplot2)
library(scales)

#### Reshape data for plotting ####
plot_data <- comparison_df %>%
  pivot_longer(cols = -Model, names_to = "Metric", values_to = "Value")

#### Nature-inspired color palette ####
nature_palette <- c(
  "SMOTE + RF"       = "#2E8B57",    # Sea Green
  "Class-weighted RF" = "#E67E22",    # Burnt Orange  
  "Balanced RF"       = "#3498DB"     # Sky Blue
)

#### Create polished performance comparison plot ####
p1 <- ggplot(plot_data, aes(x = Metric, y = Value, fill = Model)) +
  # Clean bars
  geom_bar(stat = "identity", 
           position = position_dodge(width = 0.85), 
           width = 0.7,
           color = "white",
           linewidth = 0.3) +
  
  # Value labels on bars
  geom_text(aes(label = round(Value, 3)),
            position = position_dodge(width = 0.85),
            vjust = -0.7,
            size = 4,
            color = "#2C3E50",
            fontface = "bold") +
  
  # Clean labels
  labs(title = " Performance Comparison of RF Strategies",
       subtitle = "Evaluation metrics across different resampling approaches",
       x = NULL,
       y = "Performance Score",
       fill = NULL) +
  
  # Refined theme
  theme_minimal(base_size = 14) +
  theme(
    # Title styling
    plot.title = element_text(size = 20, 
                              face = "bold", 
                              color = "#1A3A2B"),
    plot.subtitle = element_text(size = 13, 
                                 color = "#5A7A6B"),
    
    # Axis styling - removed margin to avoid errors
    axis.title.y = element_text(size = 13, 
                                color = "#34495E"),
    axis.text.x = element_text(size = 12, 
                               color = "#2C3E50",
                               angle = 45, 
                               hjust = 1),
    axis.text.y = element_text(size = 11, 
                               color = "#5D6D7E"),
    
    # Grid lines - subtle and clean
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(color = "#ECF0F1", 
                                      linewidth = 0.5),
    
    # Legend styling
    legend.position = "top",
    legend.text = element_text(size = 12, 
                               color = "#2C3E50"),
    legend.spacing.x = unit(0.5, "cm"),
    legend.key.size = unit(1.2, "lines"),
    
    # Background
    plot.background = element_rect(fill = "#F8F9FA", 
                                   color = NA)
  ) +
  
  # Color scale
  scale_fill_manual(values = nature_palette) +
  
  # Axis scales
  scale_y_continuous(limits = c(0, 1.12),
                     expand = expansion(mult = c(0, 0.05)),
                     labels = label_number(accuracy = 0.01))

# Display the plot
print(p1)

#### Horizontal Version ####
p1_horizontal <- ggplot(plot_data, aes(x = Value, y = Metric, fill = Model)) +
  # Bars
  geom_bar(stat = "identity", 
           position = position_dodge(width = 0.85), 
           width = 0.7,
           color = "white",
           linewidth = 0.3) +
  
  # Value labels
  geom_text(aes(label = round(Value, 3)),
            position = position_dodge(width = 0.85),
            hjust = -0.3,
            size = 4,
            color = "#2C3E50",
            fontface = "bold") +
  
  # Labels
  labs(title = " Performance Comparison of RF Strategies",
       subtitle = "Evaluation metrics across different resampling approaches",
       x = "Performance Score",
       y = NULL,
       fill = NULL) +
  
  # Clean theme
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(size = 20, 
                              face = "bold", 
                              color = "#1A3A2B"),
    plot.subtitle = element_text(size = 13, 
                                 color = "#5A7A6B"),
    axis.title.x = element_text(size = 13, 
                                color = "#34495E"),
    axis.text = element_text(size = 12, 
                             color = "#2C3E50"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "#ECF0F1", 
                                      linewidth = 0.5),
    legend.position = "top",
    legend.text = element_text(size = 12, 
                               color = "#2C3E50"),
    legend.spacing.x = unit(0.5, "cm"),
    plot.background = element_rect(fill = "#F8F9FA", 
                                   color = NA)
  ) +
  
  # Colors and scales
  scale_fill_manual(values = nature_palette) +
  scale_x_continuous(limits = c(0, 1.15),
                     expand = expansion(mult = c(0, 0.05)),
                     labels = label_number(accuracy = 0.01))

# Display horizontal version
print(p1_horizontal)

#### Alternative: Using element_text with vjust for spacing ####
# If you need extra spacing, you can add plot margins like this:
p1_with_margins <- p1 +
  theme(
    plot.margin = unit(c(1, 1, 1, 1), "cm")
  )

print(p1_with_margins)


















#### 9.1 Performance Comparison Bar Plot ####
library(tidyr)
library(ggplot2)
library(scales)

#### Reshape data for plotting ####
plot_data <- comparison_df %>%
  pivot_longer(cols = -Model, names_to = "Metric", values_to = "Value")

#### Nature-inspired color palette - Enhanced medicinal tones ####
nature_palette <- c(
  "SMOTE + RF"       = "#2ECC71",    # Fresh Herbal Green
  "Class-weighted RF" = "#E67E22",    # Golden Turmeric  
  "Balanced RF"       = "#3498DB"     # Calming Blue
)

#### Create polished performance comparison plot ####
p1 <- ggplot(plot_data, aes(x = Metric, y = Value, fill = Model)) +
  # Clean bars with soft edges
  geom_bar(stat = "identity", 
           position = position_dodge(width = 0.85), 
           width = 0.7,
           color = "white",
           linewidth = 0.4,
           alpha = 0.92) +
  
  # Value labels on bars
  geom_text(aes(label = round(Value, 3)),
            position = position_dodge(width = 0.85),
            vjust = -0.7,
            size = 4.5,
            color = "#2C3E50",
            fontface = "bold") +
  
  # Clean labels with nature touch
  labs(title = " Performance Comparison of RF Strategies",
       subtitle = "Evaluation metrics across different resampling approaches",
       x = NULL,
       y = "Performance Score",
       fill = NULL) +
  
  # Refined theme with natural aesthetics
  theme_minimal(base_size = 14, base_family = "sans") +
  theme(
    # Title styling - earthy tones (NO margin() calls)
    plot.title = element_text(size = 22, 
                              face = "bold", 
                              color = "#1A3A2B"),
    plot.subtitle = element_text(size = 14, 
                                 color = "#5A7A6B"),
    
    # Axis styling - clean and natural
    axis.title.y = element_text(size = 14, 
                                color = "#2C3E50",
                                face = "bold"),
    axis.text.x = element_text(size = 12.5, 
                               color = "#34495E",
                               angle = 45, 
                               hjust = 1,
                               face = "bold"),
    axis.text.y = element_text(size = 11.5, 
                               color = "#5D6D7E"),
    
    # Grid lines - very subtle
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(color = "#E8ECEF", 
                                      linewidth = 0.4,
                                      linetype = "dashed"),
    
    # Legend styling - natural placement
    legend.position = "top",
    legend.text = element_text(size = 12.5, 
                               color = "#2C3E50",
                               face = "bold"),
    legend.spacing.x = unit(0.6, "cm"),
    legend.key.size = unit(1.3, "lines"),
    legend.background = element_rect(fill = "transparent"),
    
    # Background - soft natural
    plot.background = element_rect(fill = "#FAFCFD", 
                                   color = NA),
    panel.background = element_rect(fill = "#FAFCFD", 
                                    color = NA),
    
    # Use plot.margin instead of margin()
    plot.margin = unit(c(1, 1.5, 1, 1), "cm")
  ) +
  
  # Color scale with nature palette
  scale_fill_manual(values = nature_palette) +
  
  # Axis scales with natural limits
  scale_y_continuous(limits = c(0, 1.12),
                     expand = expansion(mult = c(0, 0.05)),
                     labels = label_number(accuracy = 0.01),
                     breaks = seq(0, 1, 0.2))

# Display the plot
print(p1)

#### Horizontal Version - Herbal Twist ####
p1_horizontal <- ggplot(plot_data, aes(x = Value, y = Metric, fill = Model)) +
  # Bars with natural feel
  geom_bar(stat = "identity", 
           position = position_dodge(width = 0.85), 
           width = 0.7,
           color = "white",
           linewidth = 0.4,
           alpha = 0.92) +
  
  # Value labels with clarity
  geom_text(aes(label = round(Value, 3)),
            position = position_dodge(width = 0.85),
            hjust = -0.3,
            size = 4.5,
            color = "#2C3E50",
            fontface = "bold") +
  
  # Labels with natural theme
  labs(title = " Performance Comparison of RF Strategies",
       subtitle = "Evaluation metrics across different resampling approaches",
       x = "Performance Score",
       y = NULL,
       fill = NULL) +
  
  # Clean theme with natural elements
  theme_minimal(base_size = 14, base_family = "sans") +
  theme(
    plot.title = element_text(size = 22, 
                              face = "bold", 
                              color = "#1A3A2B"),
    plot.subtitle = element_text(size = 14, 
                                 color = "#5A7A6B"),
    axis.title.x = element_text(size = 14, 
                                color = "#2C3E50",
                                face = "bold"),
    axis.text = element_text(size = 12.5, 
                             color = "#34495E",
                             face = "bold"),
    axis.text.y = element_text(size = 12, 
                               color = "#5D6D7E"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "#E8ECEF", 
                                      linewidth = 0.4,
                                      linetype = "dashed"),
    legend.position = "top",
    legend.text = element_text(size = 12.5, 
                               color = "#2C3E50",
                               face = "bold"),
    legend.spacing.x = unit(0.6, "cm"),
    legend.background = element_rect(fill = "transparent"),
    plot.background = element_rect(fill = "#FAFCFD", 
                                   color = NA),
    panel.background = element_rect(fill = "#FAFCFD", 
                                    color = NA),
    plot.margin = unit(c(1, 1.5, 1, 1), "cm")
  ) +
  
  # Colors and scales with nature theme
  scale_fill_manual(values = nature_palette) +
  scale_x_continuous(limits = c(0, 1.15),
                     expand = expansion(mult = c(0, 0.05)),
                     labels = label_number(accuracy = 0.01),
                     breaks = seq(0, 1, 0.2))

# Display horizontal version
print(p1_horizontal)



# Display summary
print("Nature-inspired performance plots created successfully!")
print(" Color palette: Herbal Green, Golden Turmeric, Calming Blue")
print("Both vertical and horizontal versions are ready")





#### 9.2 ROC Curves ####
roc_smote <- roc(test_dummy$SBA, prob_smote, levels = c("Unskilled", "Skilled"))
roc_weighted <- roc(test_boruta$SBA, prob_weighted, levels = c("Unskilled", "Skilled"))
roc_balanced <- roc(test_boruta$SBA, prob_balanced, levels = c("Unskilled", "Skilled"))

#### ROC plot ####
p2 <- ggplot() +
  geom_line(data = data.frame(sensitivity = roc_smote$sensitivities, 
                              specificity = roc_smote$specificities),
            aes(x = 1 - specificity, y = sensitivity, color = "SMOTE + RF"), 
            size = 1.2) +
  geom_line(data = data.frame(sensitivity = roc_weighted$sensitivities,
                              specificity = roc_weighted$specificities),
            aes(x = 1 - specificity, y = sensitivity, color = "Class-weighted RF"),
            size = 1.2) +
  geom_line(data = data.frame(sensitivity = roc_balanced$sensitivities,
                              specificity = roc_balanced$specificities),
            aes(x = 1 - specificity, y = sensitivity, color = "Balanced RF"),
            size = 1.2) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "gray") +
  labs(title = "ROC Curves Comparison",
       x = "1 - Specificity", y = "Sensitivity") +
  theme_minimal(base_size = 12) +
  scale_color_manual(values = c("SMOTE + RF" = "#0072B2", 
                                "Class-weighted RF" = "#D55E00", 
                                "Balanced RF" = "#009E73")) +
  theme(legend.position = "top") +
  coord_equal()

print(p2)







#### 9.2 ROC Curves - Nature Medicine Style ####
library(pROC)
library(ggplot2)
library(scales)

#### Calculate ROC curves ####
roc_smote <- roc(test_dummy$SBA, prob_smote, levels = c("Unskilled", "Skilled"))
roc_weighted <- roc(test_boruta$SBA, prob_weighted, levels = c("Unskilled", "Skilled"))
roc_balanced <- roc(test_boruta$SBA, prob_balanced, levels = c("Unskilled", "Skilled"))

#### Extract AUC values for annotations ####
auc_smote <- round(auc(roc_smote), 3)
auc_weighted <- round(auc(roc_weighted), 3)
auc_balanced <- round(auc(roc_balanced), 3)

#### Create ROC data frames ####
roc_data <- data.frame(
  fpr = c(1 - roc_smote$specificities, 
          1 - roc_weighted$specificities,
          1 - roc_balanced$specificities),
  tpr = c(roc_smote$sensitivities,
          roc_weighted$sensitivities,
          roc_balanced$sensitivities),
  Model = rep(c("SMOTE + RF", "Class-weighted RF", "Balanced RF"),
              times = c(length(roc_smote$sensitivities),
                        length(roc_weighted$sensitivities),
                        length(roc_balanced$sensitivities)))
)

#### Nature-inspired color palette ####
roc_palette <- c(
  "SMOTE + RF"       = "#2ECC71",    # Fresh Herbal Green
  "Class-weighted RF" = "#E67E22",    # Golden Turmeric  
  "Balanced RF"       = "#3498DB"     # Calming Blue
)

#### Create polished ROC plot ####
p2 <- ggplot(roc_data, aes(x = fpr, y = tpr, color = Model)) +
  # ROC curves with smooth lines
  geom_line(linewidth = 1.5, alpha = 0.95) +
  
  # Diagonal reference line
  geom_abline(intercept = 0, slope = 1, 
              linetype = "dashed", 
              color = "#95A5A6",
              linewidth = 0.6) +
  
  # Add AUC annotations with nature feel
  annotate("text", x = 0.75, y = 0.25,
           label = paste0("AUC:\n",
                          " SMOTE + RF: ", auc_smote, "\n",
                          " Class-weighted: ", auc_weighted, "\n",
                          " Balanced: ", auc_balanced),
           hjust = 0, vjust = 1,
           size = 4.5,
           color = "#2C3E50",
           fontface = "bold",
           family = "sans") +
  
  # Clean labels with nature touch
  labs(title = " ROC Curves - Model Performance Comparison",
       subtitle = "True Positive Rate vs False Positive Rate across resampling strategies",
       x = "False Positive Rate (1 - Specificity)",
       y = "True Positive Rate (Sensitivity)",
       color = NULL) +
  
  # Refined theme with natural aesthetics
  theme_minimal(base_size = 14, base_family = "sans") +
  theme(
    # Title styling
    plot.title = element_text(size = 22, 
                              face = "bold", 
                              color = "#1A3A2B"),
    plot.subtitle = element_text(size = 14, 
                                 color = "#5A7A6B"),
    
    # Axis styling
    axis.title = element_text(size = 14, 
                              color = "#2C3E50",
                              face = "bold"),
    axis.text = element_text(size = 12, 
                             color = "#34495E"),
    axis.text.x = element_text(face = "bold"),
    axis.text.y = element_text(face = "bold"),
    
    # Grid lines - subtle
    panel.grid.major = element_line(color = "#E8ECEF", 
                                    linewidth = 0.4,
                                    linetype = "dashed"),
    panel.grid.minor = element_blank(),
    
    # Legend styling
    legend.position = c(0.22, 0.78),
    legend.background = element_rect(fill = "#FAFCFD", 
                                     color = "#E8ECEF",
                                     linewidth = 0.5),
    legend.text = element_text(size = 12, 
                               color = "#2C3E50",
                               face = "bold"),
    legend.key.size = unit(1.2, "lines"),
    legend.spacing.y = unit(0.2, "cm"),
    
    # Background - soft natural
    plot.background = element_rect(fill = "#FAFCFD", 
                                   color = NA),
    panel.background = element_rect(fill = "#FAFCFD", 
                                    color = NA),
    plot.margin = unit(c(1, 1.5, 1, 1.2), "cm")
  ) +
  
  # Color scale with nature palette
  scale_color_manual(values = roc_palette) +
  
  # Equal aspect ratio for ROC
  coord_equal() +
  
  # Scales
  scale_x_continuous(limits = c(0, 1), 
                     breaks = seq(0, 1, 0.2),
                     labels = label_number(accuracy = 0.1)) +
  scale_y_continuous(limits = c(0, 1), 
                     breaks = seq(0, 1, 0.2),
                     labels = label_number(accuracy = 0.1))

# Display the plot
print(p2)

#### Alternative: Compact ROC with AUC in legend ####
p2_compact <- ggplot(roc_data, aes(x = fpr, y = tpr, color = Model)) +
  geom_line(linewidth = 1.5, alpha = 0.95) +
  geom_abline(intercept = 0, slope = 1, 
              linetype = "dashed", 
              color = "#95A5A6",
              linewidth = 0.6) +
  
  labs(title = " ROC Curves Comparison",
       subtitle = paste0("AUC: SMOTE+RF=", auc_smote, 
                         ", Weighted=", auc_weighted, 
                         ", Balanced=", auc_balanced),
       x = "False Positive Rate",
       y = "True Positive Rate",
       color = NULL) +
  
  theme_minimal(base_size = 14, base_family = "sans") +
  theme(
    plot.title = element_text(size = 22, 
                              face = "bold", 
                              color = "#1A3A2B"),
    plot.subtitle = element_text(size = 13, 
                                 color = "#5A7A6B"),
    axis.title = element_text(size = 14, 
                              color = "#2C3E50",
                              face = "bold"),
    axis.text = element_text(size = 12, 
                             color = "#34495E"),
    panel.grid.major = element_line(color = "#E8ECEF", 
                                    linewidth = 0.4,
                                    linetype = "dashed"),
    panel.grid.minor = element_blank(),
    legend.position = "top",
    legend.text = element_text(size = 12, 
                               color = "#2C3E50",
                               face = "bold"),
    legend.spacing.x = unit(0.6, "cm"),
    legend.background = element_rect(fill = "transparent"),
    plot.background = element_rect(fill = "#FAFCFD", 
                                   color = NA),
    panel.background = element_rect(fill = "#FAFCFD", 
                                    color = NA),
    plot.margin = unit(c(1, 1.5, 1, 1.2), "cm")
  ) +
  scale_color_manual(values = roc_palette) +
  coord_equal() +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2))

print(p2_compact)


# Display summary
print("ROC curves with nature medicine styling created successfully!")
print(paste(" AUC Values - SMOTE+RF:", auc_smote, 
            "| Weighted:", auc_weighted, 
            "| Balanced:", auc_balanced))














#### 10. Feature Importance Comparison ####

#### Extract feature importance ####
imp_smote <- importance(rf_smote)
imp_weighted <- importance(rf_weighted)
imp_balanced <- rf_balanced$variable.importance

#### Create data frames ####
imp_df_smote <- data.frame(
  Feature = rownames(imp_smote),
  Importance = imp_smote[, "MeanDecreaseGini"],
  Model = "SMOTE + RF"
)

imp_df_weighted <- data.frame(
  Feature = rownames(imp_weighted),
  Importance = imp_weighted[, "MeanDecreaseGini"],
  Model = "Class-weighted RF"
)

imp_df_balanced <- data.frame(
  Feature = names(imp_balanced),
  Importance = as.numeric(imp_balanced),
  Model = "Balanced RF"
)





















#### 10. Feature Importance Comparison - FIXED FOR RANGER ####

#### Extract feature importance ####
imp_smote <- randomForest::importance(rf_smote, type = 2)  # MeanDecreaseGini
imp_weighted <- randomForest::importance(rf_weighted, type = 2)  # MeanDecreaseGini

#### For ranger, importance is already calculated but may need scaling ####
imp_balanced <- rf_balanced$variable.importance

#### Scale ranger importance to match randomForest scale for visualization ####
if(!is.null(imp_balanced)) {
  # Scale to 0-100 range for better visualization
  imp_balanced_scaled <- scales::rescale(imp_balanced, to = c(0, 100))
} else {
  # If no importance, you need to train ranger with importance = "permutation"
  cat("Re-training ranger with importance calculation...\n")
  rf_balanced <- ranger(
    SBA ~ .,
    data = train_boruta,
    num.trees = 500,
    mtry = floor(sqrt(ncol(train_boruta) - 1)),
    importance = "permutation",  # THIS IS CRITICAL
    probability = TRUE,
    sample.fraction = balanced_sample_fraction,
    replace = TRUE,
    seed = 123
  )
  imp_balanced <- rf_balanced$variable.importance
  imp_balanced_scaled <- scales::rescale(imp_balanced, to = c(0, 100))
}

#### Create data frames ####
imp_df_smote <- data.frame(
  Feature = rownames(imp_smote),
  Importance = imp_smote[, "MeanDecreaseGini"],
  Model = "SMOTE + RF"
)

imp_df_weighted <- data.frame(
  Feature = rownames(imp_weighted),
  Importance = imp_weighted[, "MeanDecreaseGini"],
  Model = "Class-weighted RF"
)

imp_df_balanced <- data.frame(
  Feature = names(imp_balanced_scaled),
  Importance = as.numeric(imp_balanced_scaled),
  Model = "Balanced RF"
)

#### Combine and get top features ####
imp_combined <- rbind(imp_df_smote, imp_df_weighted, imp_df_balanced)

#### Plot feature importance comparison ####
p3 <- ggplot(imp_combined, aes(x = reorder(Feature, Importance), y = Importance, fill = Model)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8), width = 0.7) +
  facet_wrap(~Model, scales = "free_y") +
  coord_flip() +
  labs(title = "Feature Importance Comparison",
       x = "Feature", y = "Importance") +
  theme_minimal(base_size = 11) +
  theme(legend.position = "bottom",
        axis.text.y = element_text(size = 8))

print(p3)






#### 10. Feature Importance Comparison Journal Style ####
library(randomForest)
library(ranger)
library(ggplot2)
library(scales)
library(dplyr)

#### Extract feature importance ####
imp_smote <- randomForest::importance(rf_smote, type = 2)  # MeanDecreaseGini
imp_weighted <- randomForest::importance(rf_weighted, type = 2)  # MeanDecreaseGini

#### For ranger, importance is already calculated but may need scaling ####
imp_balanced <- rf_balanced$variable.importance

#### Scale ranger importance to match randomForest scale for visualization ####
if(!is.null(imp_balanced)) {
  # Scale to 0-100 range for better visualization
  imp_balanced_scaled <- scales::rescale(imp_balanced, to = c(0, 100))
} else {
  # If no importance, you need to train ranger with importance = "permutation"
  cat("Re-training ranger with importance calculation...\n")
  rf_balanced <- ranger(
    SBA ~ .,
    data = train_boruta,
    num.trees = 500,
    mtry = floor(sqrt(ncol(train_boruta) - 1)),
    importance = "permutation",  # THIS IS CRITICAL
    probability = TRUE,
    sample.fraction = balanced_sample_fraction,
    replace = TRUE,
    seed = 123
  )
  imp_balanced <- rf_balanced$variable.importance
  imp_balanced_scaled <- scales::rescale(imp_balanced, to = c(0, 100))
}

#### Create data frames ####
imp_df_smote <- data.frame(
  Feature = rownames(imp_smote),
  Importance = imp_smote[, "MeanDecreaseGini"],
  Model = "SMOTE + RF"
)

imp_df_weighted <- data.frame(
  Feature = rownames(imp_weighted),
  Importance = imp_weighted[, "MeanDecreaseGini"],
  Model = "Class-weighted RF"
)

imp_df_balanced <- data.frame(
  Feature = names(imp_balanced_scaled),
  Importance = as.numeric(imp_balanced_scaled),
  Model = "Balanced RF"
)

#### Combine data ####
imp_combined <- rbind(imp_df_smote, imp_df_weighted, imp_df_balanced)

#### Nature-inspired color palette ####
nature_palette <- c(
  "SMOTE + RF"       = "#2ECC71",    # Fresh Herbal Green
  "Class-weighted RF" = "#E67E22",    # Golden Turmeric  
  "Balanced RF"       = "#3498DB"     # Calming Blue
)

#### Get top 10 features for cleaner visualization ####
top_features <- imp_combined %>%
  group_by(Model) %>%
  arrange(desc(Importance)) %>%
  slice_head(n = 10) %>%
  ungroup()

#### Create polished feature importance plot - Version 1: Faceted ####
p3_faceted <- ggplot(top_features, aes(x = reorder(Feature, Importance), 
                                       y = Importance, 
                                       fill = Model)) +
  # Clean bars with soft edges
  geom_bar(stat = "identity", 
           position = position_dodge(width = 0.85), 
           width = 0.7,
           color = "white",
           linewidth = 0.3,
           alpha = 0.92) +
  
  # Value labels on bars
  geom_text(aes(label = round(Importance, 1)),
            position = position_dodge(width = 0.85),
            hjust = -0.2,
            size = 3.5,
            color = "#2C3E50",
            fontface = "bold") +
  
  # Facet by model
  facet_wrap(~Model, scales = "free_y", ncol = 1) +
  
  # Flip coordinates for horizontal bars
  coord_flip(clip = "off") +
  
  # Clean labels with nature touch
  labs(title = "Feature Importance Comparison",
       subtitle = "Top 10 features by importance across resampling strategies",
       x = NULL,
       y = "Importance Score",
       fill = NULL) +
  
  # Refined theme with natural aesthetics
  theme_minimal(base_size = 13, base_family = "sans") +
  theme(
    # Title styling
    plot.title = element_text(size = 22, 
                              face = "bold", 
                              color = "#1A3A2B"),
    plot.subtitle = element_text(size = 14, 
                                 color = "#5A7A6B"),
    
    # Axis styling
    axis.title.y = element_text(size = 13, 
                                color = "#2C3E50",
                                face = "bold"),
    axis.text.y = element_text(size = 11, 
                               color = "#34495E",
                               face = "bold"),
    axis.text.x = element_text(size = 11, 
                               color = "#5D6D7E"),
    
    # Grid lines - subtle
    panel.grid.major.x = element_line(color = "#E8ECEF", 
                                      linewidth = 0.4,
                                      linetype = "dashed"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    
    # Facet styling - NO margin() calls
    strip.text = element_text(size = 14, 
                              face = "bold", 
                              color = "#1A3A2B"),
    strip.placement = "outside",
    
    # Legend styling - hidden (colors shown in facets)
    legend.position = "none",
    
    # Background - soft natural
    plot.background = element_rect(fill = "#FAFCFD", 
                                   color = NA),
    panel.background = element_rect(fill = "#FAFCFD", 
                                    color = NA),
    plot.margin = unit(c(1, 1.5, 1, 1.2), "cm")
  ) +
  
  # Color scale with nature palette
  scale_fill_manual(values = nature_palette) +
  
  # Scales
  scale_y_continuous(expand = expansion(mult = c(0, 0.1)))

# Display faceted version
print(p3_faceted)

#### Version 2: Grouped comparison (all models together) ####
p3_grouped <- ggplot(imp_combined, aes(x = reorder(Feature, Importance, 
                                                   FUN = mean), 
                                       y = Importance, 
                                       fill = Model)) +
  # Bars
  geom_bar(stat = "identity", 
           position = position_dodge(width = 0.85), 
           width = 0.7,
           color = "white",
           linewidth = 0.3,
           alpha = 0.92) +
  
  # Labels
  labs(title = "Feature Importance - All Models Comparison",
       subtitle = "Comparing feature importance across different resampling strategies",
       x = NULL,
       y = "Importance Score",
       fill = NULL) +
  
  # Flip coordinates
  coord_flip() +
  
  # Clean theme
  theme_minimal(base_size = 13, base_family = "sans") +
  theme(
    plot.title = element_text(size = 22, 
                              face = "bold", 
                              color = "#1A3A2B"),
    plot.subtitle = element_text(size = 14, 
                                 color = "#5A7A6B"),
    axis.title.y = element_text(size = 13, 
                                color = "#2C3E50",
                                face = "bold"),
    axis.text.y = element_text(size = 10, 
                               color = "#34495E",
                               face = "bold"),
    axis.text.x = element_text(size = 11, 
                               color = "#5D6D7E"),
    panel.grid.major.x = element_line(color = "#E8ECEF", 
                                      linewidth = 0.4,
                                      linetype = "dashed"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "top",
    legend.text = element_text(size = 12, 
                               color = "#2C3E50",
                               face = "bold"),
    legend.spacing.x = unit(0.6, "cm"),
    legend.background = element_rect(fill = "transparent"),
    plot.background = element_rect(fill = "#FAFCFD", 
                                   color = NA),
    panel.background = element_rect(fill = "#FAFCFD", 
                                    color = NA),
    plot.margin = unit(c(1, 1.5, 1, 1.2), "cm")
  ) +
  
  # Colors and scales
  scale_fill_manual(values = nature_palette) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.05)))

# Display grouped version
print(p3_grouped)

#### Version 3: Heatmap-style for top features ####
# Get top 15 features overall
top15_features <- imp_combined %>%
  group_by(Feature) %>%
  summarise(avg_importance = mean(Importance)) %>%
  arrange(desc(avg_importance)) %>%
  slice_head(n = 15) %>%
  pull(Feature)

imp_top15 <- imp_combined %>%
  filter(Feature %in% top15_features)

p3_heatmap <- ggplot(imp_top15, aes(x = Model, y = Feature, fill = Importance)) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = round(Importance, 1)),
            color = "#2C3E50",
            size = 3.5,
            fontface = "bold") +
  
  labs(title = "Feature Importance Heatmap",
       subtitle = "Importance values across models (top 15 features)",
       x = NULL,
       y = NULL,
       fill = "Importance") +
  
  theme_minimal(base_size = 13, base_family = "sans") +
  theme(
    plot.title = element_text(size = 22, 
                              face = "bold", 
                              color = "#1A3A2B"),
    plot.subtitle = element_text(size = 14, 
                                 color = "#5A7A6B"),
    axis.text = element_text(size = 11, 
                             color = "#34495E",
                             face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "top",
    legend.text = element_text(size = 11, color = "#2C3E50"),
    legend.title = element_text(size = 12, 
                                color = "#2C3E50",
                                face = "bold"),
    panel.grid = element_blank(),
    plot.background = element_rect(fill = "#FAFCFD", color = NA),
    plot.margin = unit(c(1, 1.5, 1, 1.2), "cm")
  ) +
  
  # Natural color gradient
  scale_fill_gradient2(low = "#FDF6E3", 
                       mid = "#2ECC71", 
                       high = "#1A3A2B",
                       midpoint = 50,
                       labels = label_number(accuracy = 1))

# Display heatmap version
print(p3_heatmap)

# Display summary
print("Feature importance plots with nature medicine styling created successfully!")
print("Three versions available: Faceted, Grouped, and Heatmap")








#### Combine and get top features ####
imp_combined <- rbind(imp_df_smote, imp_df_weighted, imp_df_balanced)

#### Plot feature importance comparison ####
p3 <- ggplot(imp_combined, aes(x = reorder(Feature, Importance), y = Importance, fill = Model)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8), width = 0.7) +
  facet_wrap(~Model, scales = "free_y") +
  coord_flip() +
  labs(title = "Feature Importance Comparison",
       x = "Feature", y = "Importance") +
  theme_minimal(base_size = 11) +
  theme(legend.position = "bottom",
        axis.text.y = element_text(size = 8))

print(p3)

#### 11. Calibration Plots ####

#### Function to create calibration plot data ####
create_calibration_data <- function(prob, true_class, model_name, n_bins = 10) {
  df <- data.frame(prob = prob, true = as.numeric(true_class == "Skilled"))
  df$bin <- cut(df$prob, breaks = seq(0, 1, length.out = n_bins + 1), include.lowest = TRUE)
  
  cal_data <- df %>%
    group_by(bin) %>%
    summarise(
      mean_pred = mean(prob),
      mean_obs = mean(true),
      n = n(),
      .groups = "drop"
    ) %>%
    mutate(Model = model_name)
  
  return(cal_data)
}

#### Create calibration data for each model ####
cal_smote <- create_calibration_data(prob_smote, test_dummy$SBA, "SMOTE + RF")
cal_weighted <- create_calibration_data(prob_weighted, test_boruta$SBA, "Class-weighted RF")
cal_balanced <- create_calibration_data(prob_balanced, test_boruta$SBA, "Balanced RF")

cal_combined <- rbind(cal_smote, cal_weighted, cal_balanced)

#### Calibration plot ####
p4 <- ggplot(cal_combined, aes(x = mean_pred, y = mean_obs, color = Model)) +
  geom_point(size = 3) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "gray50") +
  geom_smooth(method = "loess", se = FALSE, span = 1) +
  labs(title = "Calibration Plots",
       x = "Mean Predicted Probability",
       y = "Observed Proportion") +
  theme_minimal(base_size = 12) +
  scale_color_manual(values = c("SMOTE + RF" = "#0072B2", 
                                "Class-weighted RF" = "#D55E00", 
                                "Balanced RF" = "#009E73")) +
  theme(legend.position = "top") +
  coord_equal(xlim = c(0, 1), ylim = c(0, 1))

print(p4)





#### 11. Calibration Plots - Nature Medicine Style ####
library(ggplot2)
library(dplyr)
library(scales)

#### Function to create calibration plot data ####
create_calibration_data <- function(prob, true_class, model_name, n_bins = 10) {
  df <- data.frame(prob = prob, true = as.numeric(true_class == "Skilled"))
  df$bin <- cut(df$prob, breaks = seq(0, 1, length.out = n_bins + 1), include.lowest = TRUE)
  
  cal_data <- df %>%
    group_by(bin) %>%
    summarise(
      mean_pred = mean(prob),
      mean_obs = mean(true),
      n = n(),
      se = sqrt(mean_obs * (1 - mean_obs) / n),  # Standard error for error bars
      .groups = "drop"
    ) %>%
    mutate(Model = model_name)
  
  return(cal_data)
}

#### Create calibration data for each model ####
cal_smote <- create_calibration_data(prob_smote, test_dummy$SBA, "SMOTE + RF")
cal_weighted <- create_calibration_data(prob_weighted, test_boruta$SBA, "Class-weighted RF")
cal_balanced <- create_calibration_data(prob_balanced, test_boruta$SBA, "Balanced RF")

cal_combined <- rbind(cal_smote, cal_weighted, cal_balanced)

#### Nature-inspired color palette ####
nature_palette <- c(
  "SMOTE + RF"       = "#2ECC71",    # Fresh Herbal Green
  "Class-weighted RF" = "#E67E22",    # Golden Turmeric  
  "Balanced RF"       = "#3498DB"     # Calming Blue
)

#### Create polished calibration plot ####
p4 <- ggplot(cal_combined, aes(x = mean_pred, y = mean_obs, color = Model)) +
  # Perfect calibration reference line
  geom_abline(intercept = 0, slope = 1, 
              linetype = "dashed", 
              color = "#95A5A6",
              linewidth = 0.8) +
  
  # Error bars for uncertainty
  geom_errorbar(aes(ymin = mean_obs - se, ymax = mean_obs + se),
                width = 0.02,
                alpha = 0.3,
                linewidth = 0.5) +
  
  # Points with size based on bin count
  geom_point(aes(size = n), 
             alpha = 0.9) +
  
  # Loess smoothing line
  geom_smooth(method = "loess", 
              se = TRUE,
              span = 1,
              alpha = 0.2,
              linewidth = 0.8) +
  
  # Clean labels
  labs(title = "Calibration Plots",
       subtitle = "Predicted probabilities vs observed outcomes across resampling strategies",
       x = "Mean Predicted Probability",
       y = "Observed Proportion",
       color = NULL,
       size = "Sample Size") +
  
  # Refined theme with natural aesthetics
  theme_minimal(base_size = 14, base_family = "sans") +
  theme(
    # Title styling
    plot.title = element_text(size = 22, 
                              face = "bold", 
                              color = "#1A3A2B"),
    plot.subtitle = element_text(size = 14, 
                                 color = "#5A7A6B"),
    
    # Axis styling
    axis.title = element_text(size = 14, 
                              color = "#2C3E50",
                              face = "bold"),
    axis.text = element_text(size = 12, 
                             color = "#34495E",
                             face = "bold"),
    
    # Grid lines - subtle
    panel.grid.major = element_line(color = "#E8ECEF", 
                                    linewidth = 0.4,
                                    linetype = "dashed"),
    panel.grid.minor = element_blank(),
    
    # Legend styling
    legend.position = "top",
    legend.text = element_text(size = 12, 
                               color = "#2C3E50",
                               face = "bold"),
    legend.spacing.x = unit(0.6, "cm"),
    legend.background = element_rect(fill = "transparent"),
    legend.key.size = unit(1.2, "lines"),
    
    # Background - soft natural
    plot.background = element_rect(fill = "#FAFCFD", 
                                   color = NA),
    panel.background = element_rect(fill = "#FAFCFD", 
                                    color = NA),
    plot.margin = unit(c(1, 1.5, 1, 1.2), "cm")
  ) +
  
  # Color scale with nature palette
  scale_color_manual(values = nature_palette) +
  
  # Size scale for points
  scale_size_continuous(range = c(2, 6),
                        breaks = pretty_breaks(4)) +
  
  # Equal aspect ratio with limits
  coord_equal(xlim = c(0, 1), ylim = c(0, 1)) +
  
  # Scales with clean formatting
  scale_x_continuous(limits = c(0, 1), 
                     breaks = seq(0, 1, 0.2),
                     labels = label_number(accuracy = 0.1)) +
  scale_y_continuous(limits = c(0, 1), 
                     breaks = seq(0, 1, 0.2),
                     labels = label_number(accuracy = 0.1))

# Display the plot
print(p4)

#### Version 2: Faceted calibration plot ####
p4_faceted <- ggplot(cal_combined, aes(x = mean_pred, y = mean_obs, color = Model)) +
  # Perfect calibration reference line
  geom_abline(intercept = 0, slope = 1, 
              linetype = "dashed", 
              color = "#95A5A6",
              linewidth = 0.8) +
  
  # Error bars
  geom_errorbar(aes(ymin = mean_obs - se, ymax = mean_obs + se),
                width = 0.02,
                alpha = 0.3,
                linewidth = 0.5) +
  
  # Points
  geom_point(aes(size = n), 
             alpha = 0.9) +
  
  # Smoothing line
  geom_smooth(method = "loess", 
              se = TRUE,
              span = 1,
              alpha = 0.2,
              linewidth = 0.8) +
  
  # Facet by model
  facet_wrap(~Model, ncol = 3) +
  
  # Labels
  labs(title = "Calibration Plots - Model Comparison",
       subtitle = "Each panel shows calibration performance for each resampling strategy",
       x = "Mean Predicted Probability",
       y = "Observed Proportion",
       size = "Sample Size") +
  
  # Refined theme
  theme_minimal(base_size = 13, base_family = "sans") +
  theme(
    plot.title = element_text(size = 22, 
                              face = "bold", 
                              color = "#1A3A2B"),
    plot.subtitle = element_text(size = 14, 
                                 color = "#5A7A6B"),
    axis.title = element_text(size = 13, 
                              color = "#2C3E50",
                              face = "bold"),
    axis.text = element_text(size = 11, 
                             color = "#34495E"),
    panel.grid.major = element_line(color = "#E8ECEF", 
                                    linewidth = 0.4,
                                    linetype = "dashed"),
    panel.grid.minor = element_blank(),
    strip.text = element_text(size = 13, 
                              face = "bold", 
                              color = "#1A3A2B"),
    legend.position = "top",
    legend.text = element_text(size = 11, 
                               color = "#2C3E50",
                               face = "bold"),
    legend.spacing.x = unit(0.6, "cm"),
    legend.background = element_rect(fill = "transparent"),
    plot.background = element_rect(fill = "#FAFCFD", 
                                   color = NA),
    panel.background = element_rect(fill = "#FAFCFD", 
                                    color = NA),
    plot.margin = unit(c(1, 1.5, 1, 1.2), "cm")
  ) +
  
  # Colors and scales
  scale_color_manual(values = nature_palette) +
  scale_size_continuous(range = c(2, 6)) +
  coord_equal(xlim = c(0, 1), ylim = c(0, 1)) +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2))

# Display faceted version
print(p4_faceted)

#### Version 3: Calibration plot with density bars ####
p4_density <- ggplot(cal_combined, aes(x = mean_pred, y = mean_obs, color = Model)) +
  # Perfect calibration line
  geom_abline(intercept = 0, slope = 1, 
              linetype = "dashed", 
              color = "#95A5A6",
              linewidth = 0.8) +
  
  # Points
  geom_point(aes(size = n), 
             alpha = 0.8) +
  
  # Smoothing line
  geom_smooth(method = "loess", 
              se = TRUE,
              span = 1,
              alpha = 0.15,
              linewidth = 0.8) +
  
  # Labels
  labs(title = "Calibration Performance",
       subtitle = "Comparing predicted probability calibration across models",
       x = "Mean Predicted Probability",
       y = "Observed Proportion",
       color = NULL,
       size = "Bin Size") +
  
  # Theme
  theme_minimal(base_size = 14, base_family = "sans") +
  theme(
    plot.title = element_text(size = 22, 
                              face = "bold", 
                              color = "#1A3A2B"),
    plot.subtitle = element_text(size = 14, 
                                 color = "#5A7A6B"),
    axis.title = element_text(size = 14, 
                              color = "#2C3E50",
                              face = "bold"),
    axis.text = element_text(size = 12, 
                             color = "#34495E",
                             face = "bold"),
    panel.grid.major = element_line(color = "#E8ECEF", 
                                    linewidth = 0.4,
                                    linetype = "dashed"),
    panel.grid.minor = element_blank(),
    legend.position = "top",
    legend.text = element_text(size = 12, 
                               color = "#2C3E50",
                               face = "bold"),
    legend.spacing.x = unit(0.6, "cm"),
    legend.background = element_rect(fill = "transparent"),
    plot.background = element_rect(fill = "#FAFCFD", 
                                   color = NA),
    panel.background = element_rect(fill = "#FAFCFD", 
                                    color = NA),
    plot.margin = unit(c(1, 1.5, 1, 1.2), "cm")
  ) +
  
  # Colors and scales
  scale_color_manual(values = nature_palette) +
  scale_size_continuous(range = c(2, 6)) +
  coord_equal(xlim = c(0, 1), ylim = c(0, 1)) +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2))

# Display density version
print(p4_density)

# Display summary
print("Calibration plots with nature medicine styling created successfully!")
print("Three versions available: Combined, Faceted, and Density")












#### 12. Summary Table with Ranking ####

#### Add ranking for each metric ####
ranking_df <- comparison_df %>%
  mutate(
    Acc_Rank = rank(-Accuracy),
    Sens_Rank = rank(-Sensitivity),
    Spec_Rank = rank(-Specificity),
    F1_Rank = rank(-F1),
    MCC_Rank = rank(-MCC),
    AUROC_Rank = rank(-AUROC),
    Brier_Rank = rank(Brier_Score)
  )

cat("\n========================================\n")
cat("RANKING SUMMARY (Lower rank is better)\n")
cat("========================================\n")
print(ranking_df)




# Create a copy
ranking_df_export <- ranking_df

# Round all numeric columns to 2 decimal places
ranking_df_export[] <- lapply(ranking_df_export, function(x) {
  if (is.numeric(x)) round(x, 2) else x
})

# Save as CSV
write.csv(
  ranking_df_export,
  "D:/Research/BDHS Research/Nepal/SBA/Burkina Faso/Analysis/Salek_ML(BF)/New tables and Figures/ranking_df.csv",
  row.names = FALSE
)

cat("ranking_df.csv saved successfully!\n")



#### Calculate average rank ####
ranking_df$Avg_Rank <- rowMeans(ranking_df[, c("Acc_Rank", "Sens_Rank", "Spec_Rank", 
                                               "F1_Rank", "MCC_Rank", "AUROC_Rank", 
                                               "Brier_Rank")])

ranking_df <- ranking_df[order(ranking_df$Avg_Rank), ]
cat("\nModels ranked by average performance:\n")
print(ranking_df[, c("Model", "Avg_Rank")])

#### 13. Export Results ####



#### Save comparison results to CSV ####
write.csv(
  comparison_df,
  "D:/Research/BDHS Research/Nepal/SBA/Burkina Faso/Analysis/Salek_ML(BF)/New tables and Figures/rf_imbalance_comparison.csv",
  row.names = FALSE
)

#### Save ranking results ####
write.csv(
  ranking_df,
  "D:/Research/BDHS Research/Nepal/SBA/Burkina Faso/Analysis/Salek_ML(BF)/New tables and Figures/rf_imbalance_ranking.csv",
  row.names = FALSE
)

cat("\n========================================\n")
cat("SENSITIVITY ANALYSIS COMPLETE\n")
cat("========================================\n")
cat("Results saved to:\n")
cat("D:/Research/BDHS Research/Nepal/SBA/Burkina Faso/Analysis/Salek_ML(BF)/New tables and Figures/rf_imbalance_comparison.csv\n")
cat("D:/Research/BDHS Research/Nepal/SBA/Burkina Faso/Analysis/Salek_ML(BF)/New tables and Figures/rf_imbalance_ranking.csv\n")



#### 14. Optional: Check Feature Importance Stability (Reviewer's Question) ####

cat("\n========================================\n")
cat("FEATURE IMPORTANCE STABILITY CHECK\n")
cat("========================================\n")

#### Get top 10 features from each model ####
top10_smote <- imp_df_smote %>%
  arrange(desc(Importance)) %>%
  head(10) %>%
  pull(Feature)

top10_weighted <- imp_df_weighted %>%
  arrange(desc(Importance)) %>%
  head(10) %>%
  pull(Feature)

top10_balanced <- imp_df_balanced %>%
  arrange(desc(Importance)) %>%
  head(10) %>%
  pull(Feature)

#### Check overlap ####
cat("\nTop 10 Feature Overlap:\n")
cat("SMOTE vs Weighted:", length(intersect(top10_smote, top10_weighted)), "features overlap\n")
cat("SMOTE vs Balanced:", length(intersect(top10_smote, top10_balanced)), "features overlap\n")
cat("Weighted vs Balanced:", length(intersect(top10_weighted, top10_balanced)), "features overlap\n")

#### Calculate rank correlation (Spearman) ####
imp_wide <- imp_combined %>%
  pivot_wider(names_from = Model, values_from = Importance) %>%
  na.omit()

if(nrow(imp_wide) > 1) {
  cor_smote_weighted <- cor(imp_wide$`SMOTE + RF`, imp_wide$`Class-weighted RF`, 
                            method = "spearman", use = "pairwise")
  cor_smote_balanced <- cor(imp_wide$`SMOTE + RF`, imp_wide$`Balanced RF`, 
                            method = "spearman", use = "pairwise")
  
  cat("\nSpearman rank correlation of feature importance:\n")
  cat("SMOTE vs Weighted:", round(cor_smote_weighted, 3), "\n")
  cat("SMOTE vs Balanced:", round(cor_smote_balanced, 3), "\n")
}

#### 15. Create Supplementary Table for Manuscript ####

cat("\n========================================\n")
cat("SUPPLEMENTARY TABLE FOR MANUSCRIPT\n")
cat("========================================\n")

#### Format for publication ####
supp_table <- comparison_df %>%
  mutate(
    Accuracy = paste0(round(Accuracy * 100, 1), "%"),
    Sensitivity = paste0(round(Sensitivity * 100, 1), "%"),
    Specificity = paste0(round(Specificity * 100, 1), "%"),
    Precision = paste0(round(Precision * 100, 1), "%"),
    F1 = round(F1, 3),
    MCC = round(MCC, 3),
    AUROC = round(AUROC, 3),
    Brier_Score = round(Brier_Score, 3)
  ) %>%
  select(Model, Accuracy, Sensitivity, Specificity, Precision, F1, MCC, AUROC, Brier_Score)

#### Print as markdown table ####
print(supp_table)



#### Save as CSV for manuscript ####
write.csv(
  supp_table,
  "D:/Research/BDHS Research/Nepal/SBA/Burkina Faso/Analysis/Salek_ML(BF)/New tables and Figures/Supplementary_Table1_RF_Comparison.csv",
  row.names = FALSE
)

cat("\nSupplementary table saved to:\n")
cat("D:/Research/BDHS Research/Nepal/SBA/Burkina Faso/Analysis/Salek_ML(BF)/New tables and Figures/Supplementary_Table1_RF_Comparison.csv\n")

#### End of Script ####


















