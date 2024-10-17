library(tidyverse)
library(jsonlite)

jsonData = fromJSON("data/ProjectAnalysis.json")
df = as.data.frame(jsonData)

df <- filter(df, isLeaf == "True")
df <- filter(df, grepl("04-05-07-01-03", code))

# Define the range of column names
nested_col_names <- colnames(df)[14:ncol(df)]

# Function to clean a single column
clean_column <- function(col) {
  data_list <- as.numeric(unlist(strsplit(col, ",")))
  # Return only non-zero values as a list
  return(list(data_list[data_list != 0]))
}

# Apply the function to the specified columns using mutate and across
dfx <- df %>%
  mutate(across(all_of(nested_col_names), ~ clean_column(.)))

# Apply the function to the specified columns using mutate and across
dfx <- dfx %>%
  mutate(across(all_of(nested_col_names), ~ unnest_longer(.)))
