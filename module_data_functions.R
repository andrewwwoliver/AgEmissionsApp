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
  # Filter data based on the selected year range
  data <- filter(data, Year >= min(input[[year_input]]) & Year <= max(input[[year_input]]))
  # Filter data based on the selected variables
  data <- filter(data, !!sym(names(data)[1]) %in% input[[variables_input]])
  data
}

# Function to assign colors to variables
assign_colors <- function(data) {
  first_col_name <- names(data)[1]
  variables <- unique(data[[first_col_name]])
  colors <- brewer.pal(length(variables), "Set3")
  names(colors) <- variables
  return(colors)
}