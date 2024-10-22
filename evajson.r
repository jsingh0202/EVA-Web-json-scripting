library(tidyverse)
library(jsonlite)

json_data <- fromJSON("data/ProjectAnalysis.json")
df <- as.data.frame(json_data)
df <- df %>% filter(isLeaf == "True")

# ------------------------------------------------------------------------------
df_pcl <- df %>% filter(grepl("04-05-07-01-03", code))

# convert the data to a longer format to import to google sheets
eva_pcl_longer <- df_pcl %>%
  select(name, code, plannedCost, periods, actualCost,
         actualCostPeriod, actualProgress) %>%
  separate_longer_delim(c(periods, actualCost, actualCostPeriod,
                          actualProgress), delim = ",") %>%
  mutate(across(c(periods, actualCost, actualCostPeriod, actualProgress),
                ~ as.numeric(as.character(.)))) %>%
  filter(actualCostPeriod != 0) %>%
  arrange(periods)

write.csv(eva_pcl_longer, "eva_pcl_longer.csv", row.names = FALSE)

# ------------------------------------------------------------------------------

sap_codes <- read.delim("SAP Invoice Codes.txt")
df_sap <- df %>% filter(code %in% sap_codes$X04.03.11.01)

# convert the data to a longer format to import to google sheets
eva_sap_longer <- df_sap %>%
  select(name, code, plannedCost, periods, actualCostPeriod) %>%
  separate_longer_delim(c(periods, actualCostPeriod,), delim = ",") %>%
  mutate(across(c(periods, actualCostPeriod), 
                ~ as.numeric(as.character(.)))) %>%
  filter(actualCostPeriod != 0) %>%
  arrange(periods)

write.csv(eva_sap_longer, "eva_sap_longer.csv", row.names = FALSE)

# ------------------------------------------------------------------------------
# graph the planned costs of the summary tasks
order_list <- aggregate(list(plannedCost = df$plannedCost),
                        by = list(parentName = df$parentName),
                        FUN = sum)
p <- order_list %>%
  ggplot(aes(x = reorder(parentName, plannedCost),
             y = plannedCost)) +
  geom_col() + scale_y_continuous(labels = scales::label_dollar()) +
  coord_flip() +
  labs(title = "Planned Cost of Task Summaries under PCL Main Contract",
       x = "Task Summaries",
       y = "Planned Cost")
p

# Define the range of column names
nested_col_names <- colnames(df)[14:ncol(df)]
