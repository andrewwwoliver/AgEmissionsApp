#module_data_functions.R

# Function to get data based on the chart type
get_variables <- function(chart_type) {
  switch(chart_type,
         "Total Emissions" = national_total,
         "Subsector Emissions" = subsector_total,
         "Gas Emissions" = agri_gas)
}

# Function to create reactive chart data based on user inputs
create_chart_data <- function(chart_type, year_input, variables_input, input) {
  data <- get_variables(chart_type)
  first_col_name <- names(data)[1]
  data %>% filter(Year >= min(input[[year_input]]) & Year <= max(input[[year_input]])) %>%
    filter(!!sym(first_col_name) %in% input[[variables_input]])
}

# Preset list of colors
preset_colors <- c("#002d54", "#2b9c93", "#6a2063", "#e5682a", "#0b4c0b", "#5d9f3c", "#592c20", "#ca72a2")

# Function to assign colors to variables
assign_colors <- function(data, colors) {
  first_col_name <- names(data)[1]
  variables <- unique(data[[first_col_name]])
  setNames(colors[1:length(variables)], variables)
}

# Function to handle variable select and button events
handle_variable_select_and_buttons <- function(id_prefix, variables, input, output, session) {
  selected_variables <- reactive({ vars <- variables(); vars[vars != "Total"] })
  
  output[[paste0("variable_select_", id_prefix)]] <- renderUI({
    checkboxGroupInput(paste0("variables_", id_prefix), "Choose variables to add to chart", choices = variables(), selected = selected_variables())
  })
  
  observeEvent(input[[paste0("select_all_button_", id_prefix)]], {
    updateCheckboxGroupInput(session, paste0("variables_", id_prefix), selected = variables())
  })
  
  observeEvent(input[[paste0("deselect_all_button_", id_prefix)]], {
    updateCheckboxGroupInput(session, paste0("variables_", id_prefix), selected = character(0))
  })
}
