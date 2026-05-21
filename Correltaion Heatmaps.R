library(dplyr)
library(DescTools)
library(reshape2)
library(ggplot2)

#################################################
# 1️⃣ Remove outcome variable (SBA)
#################################################

cat_data <- data %>%
  select(-SBA)

#################################################
# 2️⃣ Convert labelled variables to factors
#################################################

cat_data <- cat_data %>%
  mutate(across(where(is.labelled), as_factor))

#################################################
# 3️⃣ Function to calculate Cramér's V
#################################################

cramers_v_matrix <- function(data){
  
  vars <- names(data)
  
  mat <- matrix(NA,
                nrow = length(vars),
                ncol = length(vars))
  
  for(i in 1:length(vars)){
    
    for(j in 1:length(vars)){
      
      tbl <- table(data[[i]], data[[j]])
      
      mat[i, j] <- CramerV(tbl)
    }
  }
  
  colnames(mat) <- vars
  rownames(mat) <- vars
  
  return(mat)
}

#################################################
# 4️⃣ Create correlation matrix
#################################################

cv_matrix <- cramers_v_matrix(cat_data)

#################################################
# 5️⃣ Convert matrix for plotting
#################################################

cv_melt <- melt(cv_matrix)

#################################################
# 6️⃣ Draw heatmap
#################################################

ggplot(cv_melt,
       aes(x = Var1,
           y = Var2,
           fill = value)) +
  
  geom_tile(color = "white") +
  
  geom_text(aes(label = round(value, 2)),
            size = 3) +
  
  scale_fill_gradient(
    low = "white",
    high = "darkred",
    limits = c(0,1)
  ) +
  
  theme_minimal() +
  
  labs(
    title = "Cramér's V Correlation Heatmap",
    x = "",
    y = "",
    fill = "Cramér's V"
  ) +
  
  theme(
    axis.text.x = element_text(
      angle = 45,
      hjust = 1
    ),
    panel.grid = element_blank()
  )



















#################################################
# Nature Medicine–style Cramér’s V Heatmap
# Only Boruta-confirmed predictors
#################################################

# Packages
library(dplyr)
library(haven)
library(DescTools)
library(reshape2)
library(ggplot2)
library(viridis)

#################################################
# 1️⃣ Select Boruta-confirmed predictors
#################################################

cat_data <- data %>%
  select(
    province,
    ethnicity,
    wealth_cat,
    ANC_visit,
    working_status,
    religion_cat,
    media,
    internet_use,
    mat_age1st,
    residence,
    age_first_sex,
    parity,
    sex_active,
    child_cat,
    hh_size_group,
    fert_pref,
    deci_make
  )

#################################################
# 2️⃣ Convert labelled variables to factors
#################################################

cat_data <- cat_data %>%
  mutate(across(where(is.labelled), as_factor))

#################################################
# 3️⃣ Function to compute Cramér’s V matrix
#################################################

cramers_v_matrix <- function(data){
  
  vars <- names(data)
  
  mat <- matrix(
    NA,
    nrow = length(vars),
    ncol = length(vars),
    dimnames = list(vars, vars)
  )
  
  for(i in seq_along(vars)){
    
    for(j in seq_along(vars)){
      
      tbl <- table(data[[i]], data[[j]])
      
      mat[i, j] <- DescTools::CramerV(tbl)
    }
  }
  
  return(mat)
}

#################################################
# 4️⃣ Create correlation matrix
#################################################

cv_matrix <- cramers_v_matrix(cat_data)

#################################################
# 5️⃣ Keep only upper triangle
#################################################

cv_matrix[lower.tri(cv_matrix)] <- NA

#################################################
# 6️⃣ Convert matrix for plotting
#################################################

cv_melt <- melt(cv_matrix, na.rm = TRUE)

#################################################
# 7️⃣ Publication-quality heatmap
#################################################

ggplot(
  cv_melt,
  aes(
    x = Var1,
    y = Var2,
    fill = value
  )
) +
  
  geom_tile(
    color = "white",
    linewidth = 0.5
  ) +
  
  geom_text(
    aes(label = sprintf("%.2f", value)),
    size = 3
  ) +
  
  scale_fill_viridis(
    option = "magma",
    direction = -1,
    limits = c(0, 1),
    name = "Cramér's V"
  ) +
  
  coord_fixed() +
  
  labs(
    title = "Correlation Heatmap of Boruta-Selected Predictors",
    subtitle = "Cramér’s V association matrix among categorical predictors",
    x = NULL,
    y = NULL
  ) +
  
  theme_minimal(base_size = 13) +
  
  theme(
    
    plot.title = element_text(
      face = "bold",
      size = 18,
      hjust = 0
    ),
    
    plot.subtitle = element_text(
      size = 11,
      color = "grey35"
    ),
    
    axis.text.x = element_text(
      angle = 45,
      hjust = 1,
      vjust = 1,
      size = 10,
      color = "black"
    ),
    
    axis.text.y = element_text(
      size = 10,
      color = "black"
    ),
    
    legend.title = element_text(
      face = "bold",
      size = 11
    ),
    
    legend.text = element_text(
      size = 10
    ),
    
    panel.grid = element_blank(),
    
    plot.background = element_rect(
      fill = "white",
      color = NA
    ),
    
    panel.background = element_rect(
      fill = "white",
      color = NA
    )
  )









#################################################
# Calculate only Cramér’s V values
# Boruta-selected predictors
#################################################

# Packages
library(dplyr)
library(haven)
library(DescTools)

#################################################
# 1️⃣ Select variables
#################################################

cat_data <- data %>%
  select(
    province,
    ethnicity,
    wealth_cat,
    ANC_visit,
    working_status,
    religion_cat,
    media,
    internet_use,
    mat_age1st,
    residence,
    age_first_sex,
    parity,
    sex_active,
    child_cat,
    hh_size_group,
    fert_pref,
    deci_make
  )

#################################################
# 2️⃣ Convert labelled variables to factors
#################################################

cat_data <- cat_data %>%
  mutate(across(where(is.labelled), as_factor))

#################################################
# 3️⃣ Create Cramér’s V matrix
#################################################

vars <- names(cat_data)

cv_matrix <- matrix(
  NA,
  nrow = length(vars),
  ncol = length(vars),
  dimnames = list(vars, vars)
)

for(i in seq_along(vars)){
  
  for(j in seq_along(vars)){
    
    tbl <- table(cat_data[[i]], cat_data[[j]])
    
    cv_matrix[i, j] <- CramerV(tbl)
  }
}

#################################################
# 4️⃣ Show rounded values
#################################################

round(cv_matrix, 2)





