


















############################################################
#### Q1 Journal Style ML Analysis (WITHOUT SMOTE) ##########
############################################################

#### 0️⃣ Load Required Libraries ####

library(tidymodels)
library(caret)
library(pROC)
library(Boruta)
library(mccr)
library(dplyr)
library(purrr)
library(e1071)
library(randomForest)
library(kernlab)

set.seed(123)

############################################################
#### 1️⃣ Prepare Boruta-selected Training & Test Data ######
############################################################

# Ensure same factor levels
train_boruta$SBA <- factor(
  train_boruta$SBA,
  levels = c("Unskilled", "Skilled")
)

test_data$SBA <- factor(
  test_data$SBA,
  levels = c("Unskilled", "Skilled")
)

# Keep only Boruta-selected predictors
train_model <- train_boruta[, c(final_vars, "SBA")]
test_model  <- test_data[, c(final_vars, "SBA")]

############################################################
#### 2️⃣ Preprocessing #####################################
############################################################

# Create recipe WITHOUT SMOTE
rec <- recipe(SBA ~ ., data = train_model) %>%
  
  # Convert categorical predictors to dummy variables
  step_dummy(all_nominal_predictors(), -all_outcomes()) %>%
  
  # Remove zero variance predictors
  step_zv(all_predictors()) %>%
  
  # Normalize numeric predictors
  step_normalize(all_predictors())

# Prepare recipe
prep_rec <- prep(rec)

# Apply preprocessing
train_processed <- bake(prep_rec, new_data = NULL)
test_processed  <- bake(prep_rec, new_data = test_model)

# Ensure outcome variable remains factor
train_processed$SBA <- factor(
  train_processed$SBA,
  levels = c("Unskilled", "Skilled")
)

test_processed$SBA <- factor(
  test_processed$SBA,
  levels = c("Unskilled", "Skilled")
)

############################################################
#### 3️⃣ Cross-validation Setup ############################
############################################################

ctrl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 3,
  classProbs = TRUE,
  savePredictions = "final",
  summaryFunction = twoClassSummary
)

############################################################
#### 4️⃣ Define Machine Learning Models ####################
############################################################



models <- list(
  "Random Forest"          = "rf",
  "K-Nearest Neighbor"     = "knn",
  "Logistic Regression"    = "glm",
  "Support Vector Machine" = "svmRadial",
  "Decision Tree"          = "rpart"
)

results <- list()




############################################################
#### 5️⃣ Train Models ######################################
############################################################

for(model_name in names(models)) {
  
  set.seed(123)
  
  cat("\n============================\n")
  cat("Training:", model_name, "\n")
  cat("============================\n")
  
  # Logistic Regression
  if(models[[model_name]] == "glm") {
    
    results[[model_name]] <- train(
      SBA ~ .,
      data = train_processed,
      method = "glm",
      family = binomial(),
      trControl = ctrl,
      metric = "ROC"
    )
    
  } else {
    
    results[[model_name]] <- train(
      SBA ~ .,
      data = train_processed,
      method = models[[model_name]],
      trControl = ctrl,
      metric = "ROC",
      tuneLength = 5
    )
  }
}

############################################################
#### 6️⃣ Evaluate Models on Test Set #######################
############################################################

performance <- map_dfr(names(results), function(name) {
  
  model <- results[[name]]
  
  # Predicted class
  pred <- predict(model, test_processed)
  
  # Predicted probability
  prob <- predict(
    model,
    test_processed,
    type = "prob"
  )[, "Skilled"]
  
  # Confusion matrix
  cm <- confusionMatrix(
    pred,
    test_processed$SBA,
    positive = "Skilled"
  )
  
  # MCC
  MCC_val <- mccr::mccr(
    test_processed$SBA == "Skilled",
    pred == "Skilled"
  )
  
  # ROC-AUC
  roc_obj <- roc(
    response = test_processed$SBA,
    predictor = prob,
    levels = c("Unskilled", "Skilled")
  )
  
  # Final metrics table
  data.frame(
    Model      = name,
    Accuracy   = round(cm$overall["Accuracy"], 4),
    Precision  = round(cm$byClass["Precision"], 4),
    Recall     = round(cm$byClass["Recall"], 4),
    F1_Score   = round(cm$byClass["F1"], 4),
    MCC        = round(MCC_val, 4),
    Kappa      = round(cm$overall["Kappa"], 4),
    AUROC      = round(as.numeric(roc_obj$auc), 4)
  )
})

############################################################
#### 7️⃣ Final Performance Table ###########################
############################################################

print(performance)

############################################################
#### 8️⃣ Best Model ########################################
############################################################

best_model <- performance %>%
  arrange(desc(AUROC)) %>%
  slice(1)

cat("\n====================================\n")
cat("Best Performing Model:\n")
print(best_model)
cat("====================================\n")








#### Smote ####




############################################################
#### 3️⃣ Cross-validation Setup ############################
############################################################

ctrl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 3,
  classProbs = TRUE,
  savePredictions = "final",
  summaryFunction = twoClassSummary
)

############################################################
#### 4️⃣ Define Machine Learning Models ####################
############################################################

models <- list(
  "Random Forest"          = "rf",
  "Decision Tree"          = "rpart",
  "K-Nearest Neighbor"     = "knn",
  "Logistic Regression"    = "glm",
  "Support Vector Machine" = "svmRadial"
)

results <- list()

formula_model <- as.formula("SBA ~ .")

############################################################
#### 5️⃣ Train Models with Tuning ##########################
############################################################

for(model_name in names(models)) {
  
  set.seed(123)
  
  cat("\n============================\n")
  cat("Training:", model_name, "\n")
  cat("============================\n")
  
  # Logistic Regression (no tuning grid)
  if(models[[model_name]] == "glm") {
    
    results[[model_name]] <- train(
      formula_model,
      data = train_processed,
      method = "glm",
      family = binomial(),
      trControl = ctrl,
      metric = "ROC"
    )
    
  } else {
    
    results[[model_name]] <- train(
      formula_model,
      data = train_processed,
      method = models[[model_name]],
      trControl = ctrl,
      metric = "ROC",
      tuneLength = 10
    )
  }
}

############################################################
#### 6️⃣ Evaluate Models on Test Set #######################
############################################################

performance <- purrr::map_dfr(names(results), function(name) {
  
  model <- results[[name]]
  
  pred <- predict(model, test_processed)
  
  prob <- predict(
    model,
    test_processed,
    type = "prob"
  )[, "Skilled"]
  
  cm <- confusionMatrix(
    pred,
    test_processed$SBA,
    positive = "Skilled"
  )
  
  MCC_val <- mccr::mccr(
    test_processed$SBA == "Skilled",
    pred == "Skilled"
  )
  
  roc_obj <- pROC::roc(
    response = test_processed$SBA,
    predictor = prob,
    levels = c("Unskilled", "Skilled")
  )
  
  data.frame(
    Model     = name,
    Accuracy  = round(cm$overall["Accuracy"], 4),
    Precision = round(cm$byClass["Precision"], 4),
    Recall    = round(cm$byClass["Recall"], 4),
    F1_Score  = round(cm$byClass["F1"], 4),
    MCC       = round(MCC_val, 4),
    Kappa     = round(cm$overall["Kappa"], 4),
    AUROC     = round(as.numeric(roc_obj$auc), 4)
  )
})

############################################################
#### 7️⃣ Final Performance Table ###########################
############################################################

print(performance)

############################################################
#### 8️⃣ Best Model ########################################
############################################################

best_model <- performance %>%
  dplyr::arrange(dplyr::desc(AUROC)) %>%
  dplyr::slice(1)

cat("\n====================================\n")
cat("Best Performing Model:\n")
print(best_model)
cat("====================================\n")






# Round numeric columns to 2 digits
performance_round <- performance %>%
  dplyr::mutate(
    dplyr::across(where(is.numeric), ~ round(.x, 2))
  )

# Define output path (UPDATED)
out_path <- "D:/Research/BDHS Research/Nepal/SBA/Burkina Faso/Analysis/Table new"

# Create folder if it does not exist
if (!dir.exists(out_path)) {
  dir.create(out_path, recursive = TRUE)
}

# Save rounded output
write.csv(
  performance_round,
  file = file.path(out_path, "ML_model_performance_10foldCV_round2.csv"),
  row.names = FALSE
)









#### Figure (ROC) ####





############################################################
#### 📊 ROC Curve Visualization (Final Clean Version) ######
############################################################

library(pROC)
library(ggplot2)

# Store ROC objects and AUC values
roc_list <- list()
auc_vals <- numeric()

# Compute ROC for each model
for (name in names(results)) {
  
  prob <- predict(results[[name]], test_processed, type = "prob")[, "Skilled"]
  
  roc_obj <- pROC::roc(
    response  = test_processed$SBA,
    predictor = prob,
    levels    = c("Unskilled", "Skilled"),
    direction = "<"
  )
  
  roc_list[[name]] <- roc_obj
  auc_vals[name] <- round(as.numeric(pROC::auc(roc_obj)), 3)
}

# Create legend labels with AUROC
legend_labels <- paste0(names(auc_vals), " (AUC = ", auc_vals, ")")

# Color-blind friendly palette (safe for 5–7 models)
roc_colors <- c(
  "#0072B2",  # blue
  "#D55E00",  # orange
  "#009E73",  # green
  "#CC79A7",  # pink
  "#56B4E9",  # sky blue
  "#F0E442",  # yellow (extra)
  "#999999"   # grey fallback
)

# ROC Plot
ggroc(roc_list, legacy.axes = TRUE, size = 1.2) +
  geom_abline(
    linetype = "dashed",
    linewidth = 0.8,
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
    legend.text = element_text(size = 11),
    legend.position = "right"
  ) +
  labs(
    title = "ROC Curves of Machine Learning Models for Skilled Birth Attendance",
    x = "False Positive Rate (1 − Specificity)",
    y = "True Positive Rate (Sensitivity)",
    color = "Model"
  )










############################################################
#### 📊 ROC Curve Visualization (2-digit AUC) ##############
############################################################

library(pROC)
library(ggplot2)

# Store ROC objects and AUC values
roc_list <- list()
auc_vals <- numeric()

# Compute ROC for each model
for (name in names(results)) {
  
  prob <- predict(results[[name]], test_processed, type = "prob")[, "Skilled"]
  
  roc_obj <- pROC::roc(
    response  = test_processed$SBA,
    predictor = prob,
    levels    = c("Unskilled", "Skilled"),
    direction = "<"
  )
  
  roc_list[[name]] <- roc_obj
  auc_vals[name] <- round(as.numeric(pROC::auc(roc_obj)), 2)
}

# Legend labels with 2-digit AUROC
legend_labels <- paste0(names(auc_vals), " (AUC = ", sprintf("%.2f", auc_vals), ")")

# Color-blind friendly palette
roc_colors <- c(
  "#0072B2",
  "#D55E00",
  "#009E73",
  "#CC79A7",
  "#56B4E9",
  "#F0E442",
  "#999999"
)

# ROC Plot
ggroc(roc_list, legacy.axes = TRUE, size = 1.2) +
  geom_abline(
    linetype = "dashed",
    linewidth = 0.8,
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
    legend.text = element_text(size = 11),
    legend.position = "right"
  ) +
  labs(
    title = "ROC Curves of Machine Learning Models for Skilled Birth Attendance",
    x = "False Positive Rate (1 − Specificity)",
    y = "True Positive Rate (Sensitivity)",
    color = "Model"
  )






#### precision recall ####
############################################################
#### 📈 Precision–Recall Curve (PRC) #######################
############################################################

library(PRROC)
library(ggplot2)

# Store PR objects
pr_list <- list()

# Compute PR curve for each model
for (name in names(results)) {
  
  prob <- predict(results[[name]], test_processed, type = "prob")[, "Skilled"]
  
  pr_obj <- pr.curve(
    scores.class0 = prob[test_processed$SBA == "Skilled"],
    scores.class1 = prob[test_processed$SBA == "Unskilled"],
    curve = TRUE
  )
  
  pr_list[[name]] <- pr_obj
}

# Prepare data for ggplot
pr_data <- do.call(rbind, lapply(names(pr_list), function(name) {
  
  data.frame(
    Recall = pr_list[[name]]$curve[, 1],
    Precision = pr_list[[name]]$curve[, 2],
    Model = name
  )
}))

# Color palette (consistent with ROC plot)
pr_colors <- c(
  "#0072B2",
  "#D55E00",
  "#009E73",
  "#CC79A7",
  "#56B4E9",
  "#F0E442",
  "#999999"
)

# Plot PR Curves
ggplot(pr_data, aes(x = Recall, y = Precision, color = Model)) +
  geom_line(size = 1.2) +
  theme_classic(base_size = 14) +
  scale_color_manual(values = pr_colors) +
  labs(
    title = "Precision–Recall Curves of Machine Learning Models",
    x = "Recall (Sensitivity)",
    y = "Precision",
    color = "Model"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    axis.title = element_text(face = "bold"),
    legend.title = element_text(face = "bold"),
    legend.position = "right"
  )










#### pR+AUC ####


############################################################
#### 📊 ROC + Precision–Recall Combined Figure #############
############################################################

library(pROC)
library(PRROC)
library(ggplot2)
library(dplyr)
library(patchwork)

############################################################
#### 1️⃣ ROC Curves ########################################
############################################################

roc_list <- list()
auc_vals <- numeric()

for (name in names(results)) {
  
  prob <- predict(results[[name]], test_processed, type = "prob")[, "Skilled"]
  
  roc_obj <- pROC::roc(
    response  = test_processed$SBA,
    predictor = prob,
    levels    = c("Unskilled", "Skilled"),
    direction = "<"
  )
  
  roc_list[[name]] <- roc_obj
  auc_vals[name] <- round(as.numeric(pROC::auc(roc_obj)), 2)
}

roc_labels <- paste0(names(auc_vals), " (AUC = ", auc_vals, ")")

roc_colors <- c(
  "#0072B2",
  "#D55E00",
  "#009E73",
  "#CC79A7",
  "#56B4E9",
  "#F0E442",
  "#999999"
)

p1 <- ggroc(roc_list, legacy.axes = TRUE, size = 1.1) +
  geom_abline(linetype = "dashed", linewidth = 0.7, color = "grey60") +
  scale_color_manual(values = roc_colors, labels = roc_labels) +
  coord_equal() +
  theme_classic(base_size = 13) +
  labs(
    title = "A) ROC Curves",
    x = "False Positive Rate",
    y = "True Positive Rate",
    color = "Model"
  ) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    legend.position = "bottom"
  )

############################################################
#### 2️⃣ Precision–Recall Curves ###########################
############################################################

pr_data <- do.call(rbind, lapply(names(results), function(name) {
  
  prob <- predict(results[[name]], test_processed, type = "prob")[, "Skilled"]
  
  pr_obj <- pr.curve(
    scores.class0 = prob[test_processed$SBA == "Skilled"],
    scores.class1 = prob[test_processed$SBA == "Unskilled"],
    curve = TRUE
  )
  
  data.frame(
    Recall = pr_obj$curve[, 1],
    Precision = pr_obj$curve[, 2],
    Model = name
  )
}))

p2 <- ggplot(pr_data, aes(x = Recall, y = Precision, color = Model)) +
  geom_line(size = 1.1) +
  theme_classic(base_size = 13) +
  scale_color_manual(values = roc_colors) +
  labs(
    title = "B) Precision–Recall Curves",
    x = "Recall",
    y = "Precision",
    color = "Model"
  ) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    legend.position = "bottom"
  )

############################################################
#### 3️⃣ Combine Side-by-Side ##############################
############################################################

final_plot <- p1 + p2 + plot_layout(ncol = 2)

final_plot




































################################################################
#### 📊 ROC + Precision–Recall Combined Figure — Clean Edition #
#### 🌿 Nature Medicine Standard Polish & Brightness         ####
################################################################

library(pROC)
library(PRROC)
library(ggplot2)
library(dplyr)
library(patchwork)

################################################################
#### 1️⃣ ROC Curves — Enhanced Styling       ##################
################################################################

roc_list <- list()
auc_vals <- numeric()

for (name in names(results)) {
  
  prob <- predict(results[[name]], test_processed, type = "prob")[, "Skilled"]
  
  roc_obj <- pROC::roc(
    response  = test_processed$SBA,
    predictor = prob,
    levels    = c("Unskilled", "Skilled"),
    direction = "<"
  )
  
  roc_list[[name]] <- roc_obj
  auc_vals[name] <- round(as.numeric(pROC::auc(roc_obj)), 3)
}

roc_labels <- paste0(names(auc_vals), " (AUC = ", sprintf("%.3f", auc_vals), ")")

# Nature-inspired bright color palette
roc_colors <- c(
  "#0072B2",  # deep blue
  "#E69F00",  # vibrant orange
  "#009E73",  # teal
  "#CC79A7",  # soft pink
  "#56B4E9",  # sky blue
  "#F0E442",  # sunny yellow
  "#999999"   # neutral gray
)

p1 <- ggroc(roc_list, legacy.axes = TRUE, size = 1.2) +
  geom_abline(linetype = "dashed", linewidth = 0.5, color = "gray50", alpha = 0.8) +
  scale_color_manual(values = roc_colors, labels = roc_labels) +
  coord_equal() +
  theme_classic(base_size = 13) +
  labs(
    title = "A | ROC Curves",
    x = "False Positive Rate (1 – Specificity)",
    y = "True Positive Rate (Sensitivity)",
    color = "Model"
  ) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 14),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 11),
    legend.text = element_text(size = 10),
    axis.title = element_text(face = "bold", size = 12),
    axis.text = element_text(size = 10, color = "gray30"),
    panel.background = element_rect(fill = "white"),
    plot.background = element_rect(fill = "white", color = NA),
    panel.grid.major = element_line(linewidth = 0.3, color = "gray90"),
    panel.grid.minor = element_blank()
  )

################################################################
#### 2️⃣ Precision–Recall Curves — Clean & Bright  ############
################################################################

pr_data <- do.call(rbind, lapply(names(results), function(name) {
  
  prob <- predict(results[[name]], test_processed, type = "prob")[, "Skilled"]
  
  pr_obj <- pr.curve(
    scores.class0 = prob[test_processed$SBA == "Skilled"],
    scores.class1 = prob[test_processed$SBA == "Unskilled"],
    curve = TRUE
  )
  
  data.frame(
    Recall = pr_obj$curve[, 1],
    Precision = pr_obj$curve[, 2],
    Model = name
  )
}))

# Calculate AUCPR for legend
aucpr_vals <- sapply(names(results), function(name) {
  prob <- predict(results[[name]], test_processed, type = "prob")[, "Skilled"]
  pr_obj <- pr.curve(
    scores.class0 = prob[test_processed$SBA == "Skilled"],
    scores.class1 = prob[test_processed$SBA == "Unskilled"],
    curve = FALSE
  )
  return(round(pr_obj$auc.integral, 3))
})

pr_labels <- paste0(names(aucpr_vals), " (AUCPR = ", sprintf("%.3f", aucpr_vals), ")")

p2 <- ggplot(pr_data, aes(x = Recall, y = Precision, color = Model)) +
  geom_line(size = 1.2) +
  scale_color_manual(values = roc_colors, labels = pr_labels) +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1)) +
  theme_classic(base_size = 13) +
  labs(
    title = "B | Precision–Recall Curves",
    x = "Recall (Sensitivity)",
    y = "Precision (Positive Predictive Value)",
    color = "Model"
  ) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 14),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 11),
    legend.text = element_text(size = 10),
    axis.title = element_text(face = "bold", size = 12),
    axis.text = element_text(size = 10, color = "gray30"),
    panel.background = element_rect(fill = "white"),
    plot.background = element_rect(fill = "white", color = NA),
    panel.grid.major = element_line(linewidth = 0.3, color = "gray90"),
    panel.grid.minor = element_blank()
  )

################################################################
#### 3️⃣ Combine Side-by-Side — Publication Ready   ###########
################################################################

final_plot <- p1 + p2 + 
  plot_layout(ncol = 2, guides = "collect") &
  theme(
    legend.position = "bottom",
    legend.box = "horizontal"
  )

# Display
print(final_plot)







#### Callibration ####

############################################################
#### 📉 Calibration Curves of ML Models ####################
############################################################

library(dplyr)
library(ggplot2)
library(purrr)

############################################################
#### 1️⃣ Create Calibration Data ###########################
############################################################

calibration_data <- purrr::map_dfr(
  names(results),
  function(name) {
    
    prob <- predict(
      results[[name]],
      test_processed,
      type = "prob"
    )[, "Skilled"]
    
    tibble(
      SBA   = test_processed$SBA,
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
  }
)

############################################################
#### 2️⃣ Color-Blind Friendly Palette ######################
############################################################

calib_colors <- c(
  "#0072B2",  # blue
  "#D55E00",  # orange
  "#009E73",  # green
  "#CC79A7",  # pink
  "#56B4E9",  # sky blue
  "#F0E442",  # yellow
  "#999999"   # grey fallback
)

############################################################
#### 3️⃣ Calibration Plot ##################################
############################################################

ggplot(
  calibration_data,
  aes(
    x = mean_pred,
    y = obs_rate,
    color = Model
  )
) +
  
  geom_line(
    linewidth = 1.2
  ) +
  
  geom_point(
    size = 2.6,
    alpha = 0.9
  ) +
  
  # Perfect calibration line
  geom_abline(
    intercept = 0,
    slope = 1,
    linetype = "dashed",
    linewidth = 1,
    color = "grey45"
  ) +
  
  scale_color_manual(
    values = calib_colors
  ) +
  
  coord_equal(
    xlim = c(0, 1),
    ylim = c(0, 1)
  ) +
  
  theme_classic(base_size = 14) +
  
  theme(
    plot.title = element_text(
      face = "bold",
      size = 16,
      hjust = 0.5
    ),
    
    axis.title = element_text(
      face = "bold"
    ),
    
    axis.text = element_text(
      color = "black"
    ),
    
    legend.title = element_text(
      face = "bold"
    ),
    
    legend.text = element_text(
      size = 10
    ),
    
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































