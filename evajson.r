library(tidyverse)
library(jsonlite)

json_data <- fromJSON("data/ProjectAnalysis.json")
df <- as.data.frame(json_data)

df <- filter(df, isLeaf == "True")
df <- filter(df, grepl("04-05-07-01-03", code))

# convert the data to a longer format to import to google sheets
eva_pcl_longer <- df %>%
  select(name, code, plannedCost, periods, actualCost,
         actualCostPeriod, actualProgress) %>%
  separate_longer_delim(c(periods, actualCost, actualCostPeriod,
                          actualProgress), delim = ",") %>%
  mutate(across(c(periods, actualCost, actualCostPeriod, actualProgress),
                ~ as.numeric(as.character(.)))) %>%
  filter(actualCostPeriod != 0) %>%
  arrange(periods)

write.csv(eva_pcl_longer, "eva_pcl_longer.csv", row.names = FALSE)

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
