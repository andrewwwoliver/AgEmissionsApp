# Function to get data based on the chart type
get_variables <- function(chart_type) {
  data <- switch(chart_type,
                 "Total Emissions" = national_total,
                 "Subsector Emissions" = subsector_total,
                 "Gas Emissions" = agri_gas)
  return(data)
}

# Function to create reactive chart data based on user inputs
create_chart_data <- function(chart_type, year_input, variables_input, input) {
  data <- get_variables(chart_type)  # Get the relevant data
  first_col_name <- names(data)[1]  # Get the first column name dynamically
  # Filter data based on the selected year range
  data <- data %>%
    filter(Year >= min(input[[year_input]]) & Year <= max(input[[year_input]])) %>%
    filter(!!sym(first_col_name) %in% input[[variables_input]])
  data
}

# Preset list of colors
preset_colors <- c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", 
                   "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf")

# Function to assign colors to variables
assign_colors <- function(data, colors) {
  first_col_name <- names(data)[1]
  variables <- unique(data[[first_col_name]])
  color_mapping <- setNames(colors[1:length(variables)], variables)
  return(color_mapping)
}
