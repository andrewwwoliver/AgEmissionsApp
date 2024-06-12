library(readxl)
library(openxlsx)
library(dplyr)
library(tidyr)



# Load  data from the Excel file
file_path <- "ghg_data.xlsx"
agri_gas <- read_excel(file_path, sheet = "agri_gas")
national_total <- read_excel(file_path, sheet = "national_total")
subsector_total <- read_excel(file_path, sheet = "subsector_total")

agri_gas <- agri_gas %>% 
  rename(Gas = ...1)

# Reshape the data to long format
agri_gas <- agri_gas %>% pivot_longer(cols = -Gas, names_to = "Year", values_to = "Value")
national_total <- national_total %>% pivot_longer(cols = -Industry, names_to = "Year", values_to = "Value")
subsector_total <- subsector_total %>% pivot_longer(cols = -Subsector, names_to = "Year", values_to = "Value")

# Convert Year to numeric
agri_gas$Year <- as.numeric(agri_gas$Year)
national_total$Year <- as.numeric(national_total$Year)
subsector_total$Year <- as.numeric(subsector_total$Year)

# Filter out TOTAL 
national_total <- filter(national_total, !(Industry == "TOTAL"))

# Rename Total (RHS) to total
national_total <- national_total %>%
  mutate(Industry = if_else(Industry == "Total (RHS)", "Total", Industry))

save(subsector_total, agri_gas, national_total, file = "ghg_data.RData")

# load data
load("ghg_data.RData")
