












#### 📊 Precision-Recall Curve with Proper Alignment ####

# 0️⃣ Load required libraries for PR curve
library(PRROC)      # For PR curve
library(ggplot2)
library(purrr)

# 1️⃣ Function to compute PR curve for each model
compute_pr_curve <- function(model, test_data, model_name) {
  # Get predicted probabilities for "Skilled" class
  prob <- predict(model, test_data, type = "prob")[, "Skilled"]
  
  # Compute PR curve using PRROC
  pr <- pr.curve(scores.class0 = prob, 
                 weights.class0 = test_data$SBA == "Skilled",
                 curve = TRUE)
  
  # Extract curve data
  pr_data <- data.frame(
    Recall = pr$curve[, 1],
    Precision = pr$curve[, 2],
    Model = model_name,
    AUPR = pr$auc.integral  # Area under PR curve
  )
  
  return(pr_data)
}

# 2️⃣ Compute PR curves for all models
pr_curves <- list()

for (model_name in names(results)) {
  pr_curves[[model_name]] <- compute_pr_curve(
    results[[model_name]], 
    test_dummy, 
    model_name
  )
}

# 3️⃣ Combine all PR curves
all_pr_curves <- do.call(rbind, pr_curves)

# 4️⃣ Get AUPR values for legend labels
aupr_values <- performance %>%
  select(Model, AUROC) %>%
  mutate(Model = as.character(Model)) %>%
  left_join(
    all_pr_curves %>% 
      group_by(Model) %>% 
      summarise(AUPR = first(AUPR)),
    by = "Model"
  ) %>%
  mutate(LegendLabel = paste0(Model, " (AUPR = ", round(AUPR, 3), ")"))

# 5️⃣ Create aligned Precision-Recall curve plot
pr_plot <- ggplot(all_pr_curves, aes(x = Recall, y = Precision, color = Model)) +
  geom_line(size = 1.2) +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
  labs(
    title = "Precision-Recall Curves for Skilled Class Prediction",
    subtitle = "Comparison of Classification Models",
    x = "Recall (Sensitivity)",
    y = "Precision (Positive Predictive Value)",
    caption = "AUPR values shown in legend"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5, size = 11, color = "gray40"),
    legend.title = element_text(face = "bold"),
    legend.position = c(0.75, 0.25),  # Align to top-right
    legend.background = element_rect(fill = "white", color = "gray80", size = 0.3),
    legend.key.size = unit(0.8, "cm"),
    panel.grid.minor = element_line(color = "gray95"),
    panel.grid.major = element_line(color = "gray90"),
    axis.line = element_line(color = "gray50", size = 0.3),
    axis.ticks = element_line(color = "gray50")
  ) +
  scale_color_brewer(palette = "Set1")

# 6️⃣ Display the plot
print(pr_plot)

# 7️⃣ Save high-resolution plot for journal
ggsave(
  filename = "Precision_Recall_Curve_Journal_Ready.png",
  plot = pr_plot,
  width = 8,
  height = 6,
  dpi = 300,
  units = "in",
  bg = "white"
)

# 8️⃣ Alternative: Faceted PR curves (if models are too many)
pr_plot_faceted <- ggplot(all_pr_curves, aes(x = Recall, y = Precision)) +
  geom_line(size = 1.2, aes(color = Model)) +
  facet_wrap(~Model, ncol = 3) +
  scale_x_continuous(limits = c(0, 1)) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(
    title = "Precision-Recall Curves by Model",
    x = "Recall", 
    y = "Precision"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    strip.background = element_rect(fill = "gray90", color = NA),
    strip.text = element_text(face = "bold")
  )

# 9️⃣ Print faceted version if needed
print(pr_plot_faceted)
ggsave("Precision_Recall_Curve_Faceted.png", pr_plot_faceted, width = 10, height = 8, dpi = 300)

# 🔟 Summary table with both AUROC and AUPR
performance_enhanced <- performance %>%
  left_join(
    all_pr_curves %>% 
      group_by(Model) %>% 
      summarise(AUPR = round(first(AUPR), 4)),
    by = "Model"
  ) %>%
  select(Model, AUROC, AUPR, Accuracy, Precision, Recall, F1, MCC, Kappa) %>%
  arrange(desc(AUPR))

print(performance_enhanced)

# Export metrics table for journal
write.csv(performance_enhanced, "Model_Performance_Metrics_with_AUPR.csv", row.names = FALSE)




















# Install if needed
 install.packages(c("rcompanion", "corrplot", "dplyr"))

library(rcompanion)
library(corrplot)
library(dplyr)






 # Install packages if not already installed
 # install.packages(c("rcompanion", "corrplot", "dplyr"))
 
 
 
 
 
 
 
 # Install if needed
 # install.packages(c("DescTools", "corrplot", "dplyr"))
 
 library(dplyr)
 library(DescTools)   # ✅ use this instead
 library(corrplot)
 
 # 1️⃣ Keep only categorical variables
 cat_data <- train_data %>%
   select(where(is.factor))
 
 # 2️⃣ Function for Cramér’s V matrix
 cramers_v_matrix <- function(data) {
   n <- ncol(data)
   mat <- matrix(NA, n, n)
   colnames(mat) <- colnames(data)
   rownames(mat) <- colnames(data)
   
   for (i in 1:n) {
     for (j in 1:n) {
       mat[i, j] <- suppressWarnings(
         DescTools::CramerV(data[[i]], data[[j]])
       )
     }
   }
   return(mat)
 }
 
 # 3️⃣ Compute matrix
 cv_matrix <- cramers_v_matrix(cat_data)
 
 # 4️⃣ Plot (clean scientific style)
 corrplot(cv_matrix,
          method = "color",
          type = "upper",
          col = colorRampPalette(c("white", "#2c7fb8"))(100),
          tl.col = "black",
          tl.cex = 0.8,
          addCoef.col = NULL,
          diag = FALSE)
 
 #The Cramér’s V correlation matrix indicated predominantly weak to moderate associations among predictors, suggesting no substantial multicollinearity.