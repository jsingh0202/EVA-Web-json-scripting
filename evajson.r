library(tidyverse)
library(jsonlite)

# Convert the JSON data to a df.
# ------------------------------------------------------------------------------
json_data <- fromJSON("data/ProjectAnalysis.json")
df <- as.data.frame(json_data)

df <- df %>% filter(isLeaf == "True")

# Take PCL Main Contract (04-05-07-01-03) and output as CSV.
# ------------------------------------------------------------------------------
df_pcl <- df %>% filter(grepl("04-05-07-01-03", code))
# export only current eva codes
codes <- df_pcl$code
write.csv(codes, "eva_codes.csv", row.names = FALSE)



# convert the data to a longer format to import to Google sheets
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



# Take SAP Invoice codes and output as a CSV.
# ------------------------------------------------------------------------------
sap_codes <- read.delim("SAP Invoice Codes.txt")
df_sap <- df %>% filter(code %in% sap_codes$X04.03.11.01)

# convert the data to a longer format to import to Google sheets
eva_sap_longer <- df_sap %>%
  select(name, code, plannedCost, periods, actualCostPeriod) %>%
  separate_longer_delim(c(periods, actualCostPeriod), delim = ",") %>%
  mutate(across(c(periods, actualCostPeriod),
                ~ as.numeric(as.character(.)))) %>%
  filter(actualCostPeriod != 0) %>%
  arrange(periods)

write.csv(eva_sap_longer, "eva_sap_longer.csv", row.names = FALSE)

# graph the planned costs of the summary tasks
# ------------------------------------------------------------------------------
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

# function to convert to longer
# ------------------------------------------------------------------------------
to_longer <- function(df_in, col_list, longer_list){
  df_out <- df_in %>%
    select(col_list) %>%
    # filter(actualCostPeriod != 0) %>%
    separate_longer_delim(longer_list, delim = ",") %>%
    mutate(across(longer_list, ~ as.numeric(as.character(.)))) 
  # %>%
  #   arrange(periods)
  
  return(df_out)
}

# 
# ------------------------------------------------------------------------------
col_list <- c("title", 
              "code", 
              # "periods", 
              "actualCostPeriod", 
              "actualCost")
longer_list <- c("actualCostPeriod", 
                 # "periods", 
                 "actualCost")

root <- df %>% 
  filter(title == "CP-008169-01 15-5785Lewis Farms CRC Library/DP Design")

root_longer <- to_longer(root, col_list, longer_list)
calcCostRoot <- sum(root_longer$actualCostPeriod)


concept_longer <- to_longer(df %>% filter(code == "01"), 
                            col_list, 
                            longer_list)
write.csv(concept_longer, "concept_longer.csv", row.names = FALSE)

dev_design_longer <- to_longer(df %>% filter(code == "02"), 
                               col_list, 
                               longer_list)
write.csv(dev_design_longer, "dev_design_longer.csv", row.names = FALSE)


det_design_longer <- to_longer(df %>% filter(code == "03"),
                               col_list, 
                               longer_list)
write.csv(det_design_longer, "det_design_longer.csv", row.names = FALSE)


build_longer <- to_longer(df %>% filter(code == "04"), 
                          col_list, 
                          longer_list)
write.csv(build_longer, "build_longer.csv", row.names = FALSE)


post_build <- to_longer(df %>% filter(code == "05"), 
                        col_list,
                        longer_list)
write.csv(post_build, "post_build.csv", row.names = FALSE)


non_phase_dev <- to_longer(df %>% filter(code == "06"),
                           col_list,
                           longer_list)
write.csv(non_phase_dev, "non_phase_dev.csv", row.names = FALSE)


unallocated <- to_longer(df %>% filter(code == "99"),
                         col_list,
                         longer_list)
write.csv(unallocated, "unallocated.csv", row.names = FALSE)

