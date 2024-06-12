library(shiny)
library(shinythemes)
library(dplyr)
library(tidyr)

source("line_chart_module.R")
source("options.R")
source("action_buttons.R")

# Function to get unique variables for chart type
get_variables <- function(chart_type) {
  data <- switch(chart_type,
                 "Total Emissions" = national_total,
                 "Subsector Emissions" = subsector_total,
                 "Gas Emissions" = agri_gas)
  unique(data[[1]])  # First column is the variable column
}

# Set up the UI with navbarPage
ui <- navbarPage(
  title = "Agricultural Emissions",
  theme = shinytheme("flatly"),
  id = "navbar",
  tabPanel("Total Emissions", value = "total",
           sidebarLayout(
             sidebarPanel(
               width = 3,
               uiOutput("variable_select_total"),
               actionButton("select_all_button_total", "Select All"),
               actionButton("deselect_all_button_total", "Deselect All"),
               div(chooseSliderSkin("Flat"),
                   sliderInput("year_total", "Select year range", value = c(1990, 2023), min = 1990, max = 2023, step = 1, sep = "", ticks = TRUE))
             ),
             mainPanel(
               width = 9,
               tabsetPanel(
                 tabPanel("Line Chart", lineChartUI("lineChart_total")),
                 tabPanel("Data Table", 
                          dataTableOutput("pay_table_total"),
                          downloadButton("downloadData_total", "Download Data")
                 )
               )
             )
           )
  ),
  tabPanel("Subsector Emissions", value = "subsector",
           sidebarLayout(
             sidebarPanel(
               width = 3,
               uiOutput("variable_select_subsector"),
               actionButton("select_all_button_subsector", "Select All"),
               actionButton("deselect_all_button_subsector", "Deselect All"),
               div(chooseSliderSkin("Flat"),
                   sliderInput("year_subsector", "Select year range", value = c(1990, 2023), min = 1990, max = 2023, step = 1, sep = "", ticks = TRUE))
             ),
             mainPanel(
               width = 9,
               tabsetPanel(
                 tabPanel("Line Chart", lineChartUI("lineChart_subsector")),
                 tabPanel("Data Table", 
                          dataTableOutput("pay_table_subsector"),
                          downloadButton("downloadData_subsector", "Download Data")
                 )
               )
             )
           )
  ),
  tabPanel("Gas Emissions", value = "gas",
           sidebarLayout(
             sidebarPanel(
               width = 3,
               uiOutput("variable_select_gas"),
               actionButton("select_all_button_gas", "Select All"),
               actionButton("deselect_all_button_gas", "Deselect All"),
               div(chooseSliderSkin("Flat"),
                   sliderInput("year_gas", "Select year range", value = c(1990, 2023), min = 1990, max = 2023, step = 1, sep = "", ticks = TRUE))
             ),
             mainPanel(
               width = 9,
               tabsetPanel(
                 tabPanel("Line Chart", lineChartUI("lineChart_gas")),
                 tabPanel("Data Table", 
                          dataTableOutput("pay_table_gas"),
                          downloadButton("downloadData_gas", "Download Data")
                 )
               )
             )
           )
  )
)

# Set up server
server <- function(input, output, session) {
  # Reactive for chart type based on selected tab
  chart_type <- reactive({
    switch(input$navbar,
           "total" = "Total Emissions",
           "subsector" = "Subsector Emissions",
           "gas" = "Gas Emissions")
  })
  
  # Reactive for variables based on chart type
  variables <- reactive({
    get_variables(chart_type())
  })
  
  # Output for variable selection for each tab
  output$variable_select_total <- renderUI({
    checkboxGroupInput("variables_total", "Choose variables to add to chart", choices = variables(), selected = variables())
  })
  
  output$variable_select_subsector <- renderUI({
    checkboxGroupInput("variables_subsector", "Choose variables to add to chart", choices = variables(), selected = variables())
  })
  
  output$variable_select_gas <- renderUI({
    checkboxGroupInput("variables_gas", "Choose variables to add to chart", choices = variables(), selected = variables())
  })
  
  # Event handler for "Select All" button
  observeEvent(input$select_all_button_total, {
    updateCheckboxGroupInput(session, "variables_total", selected = variables())
  })
  
  observeEvent(input$select_all_button_subsector, {
    updateCheckboxGroupInput(session, "variables_subsector", selected = variables())
  })
  
  observeEvent(input$select_all_button_gas, {
    updateCheckboxGroupInput(session, "variables_gas", selected = variables())
  })
  
  # Event handler for "Deselect All" button
  observeEvent(input$deselect_all_button_total, {
    updateCheckboxGroupInput(session, "variables_total", selected = character(0))  # Deselect all
  })
  
  observeEvent(input$deselect_all_button_subsector, {
    updateCheckboxGroupInput(session, "variables_subsector", selected = character(0))  # Deselect all
  })
  
  observeEvent(input$deselect_all_button_gas, {
    updateCheckboxGroupInput(session, "variables_gas", selected = character(0))  # Deselect all
  })
  
  # Function to get the appropriate dataset based on the chart type
  get_chart_data <- function(chart_type) {
    switch(chart_type,
           "Total Emissions" = national_total,
           "Subsector Emissions" = subsector_total,
           "Gas Emissions" = agri_gas)
  }
  
  # Reactive expression for chart data for each tab
  chart_data_total <- reactive({
    data <- get_chart_data("Total Emissions")
    data <- filter(data, Year >= min(input$year_total) & Year <= max(input$year_total))
    data <- filter(data, !!sym(names(data)[1]) %in% input$variables_total)  # Dynamically reference the first column
    data
  })
  
  chart_data_subsector <- reactive({
    data <- get_chart_data("Subsector Emissions")
    data <- filter(data, Year >= min(input$year_subsector) & Year <= max(input$year_subsector))
    data <- filter(data, !!sym(names(data)[1]) %in% input$variables_subsector)  # Dynamically reference the first column
    data
  })
  
  chart_data_gas <- reactive({
    data <- get_chart_data("Gas Emissions")
    data <- filter(data, Year >= min(input$year_gas) & Year <= max(input$year_gas))
    data <- filter(data, !!sym(names(data)[1]) %in% input$variables_gas)  # Dynamically reference the first column
    data
  })
  
  # Reactive expression for column names
  column_name_total <- reactive({
    names(chart_data_total())[1]
  })
  
  column_name_subsector <- reactive({
    names(chart_data_subsector())[1]
  })
  
  column_name_gas <- reactive({
    names(chart_data_gas())[1]
  })
  
  # Render titles for each tab
  output$title_total <- renderText({
    paste("Total Emissions in Agriculture,", min(input$year_total), "to", max(input$year_total))
  })
  
  output$title_subsector <- renderText({
    paste("Subsector Emissions in Agriculture,", min(input$year_subsector), "to", max(input$year_subsector))
  })
  
  output$title_gas <- renderText({
    paste("Gas Emissions in Agriculture,", min(input$year_gas), "to", max(input$year_gas))
  })
  
  # Reactive expression for yAxisTitle
  yAxisTitle_total <- reactive({
    "Total Emissions (MtCO2e)"
  })
  
  yAxisTitle_subsector <- reactive({
    "Emissions by Subsector (MtCO2e)"
  })
  
  yAxisTitle_gas <- reactive({
    "Emissions by Gas (MtCO2e)"
  })
  
  # Render line chart
  lineChartServer("lineChart_total", chart_data_total, column_name_total, output$title_total, yAxisTitle_total)
  lineChartServer("lineChart_subsector", chart_data_subsector, column_name_subsector, output$title_subsector, yAxisTitle_subsector)
  lineChartServer("lineChart_gas", chart_data_gas, column_name_gas, output$title_gas, yAxisTitle_gas)
  
  # Reactive expression for data table
  pay_table_data_total <- reactive({
    chart_data_total()
  })
  
  pay_table_data_subsector <- reactive({
    chart_data_subsector()
  })
  
  pay_table_data_gas <- reactive({
    chart_data_gas()
  })
  
  # Rendering the Data Table
  output$pay_table_total <- renderDataTable({
    data <- pay_table_data_total()
    data$Year <- as.character(data$Year)
    # Get the name of the first column
    first_column_name <- names(data)[1]
    # Pivot the data frame based on the first column's name
    data <- pivot_wider(data, names_from = !!sym(first_column_name), values_from = Value)
    data <- data %>% mutate(across(where(is.numeric), ~ formatC(.x, format = "f", digits = 2)))
    as_tibble(data)
  })
  
  output$pay_table_subsector <- renderDataTable({
    data <- pay_table_data_subsector()
    data$Year <- as.character(data$Year)
    # Get the name of the first column
    first_column_name <- names(data)[1]
    # Pivot the data frame based on the first column's name
    data <- pivot_wider(data, names_from = !!sym(first_column_name), values_from = Value)
    data <- data %>% mutate(across(where(is.numeric), ~ formatC(.x, format = "f", digits = 2)))
    as_tibble(data)
  })
  
  output$pay_table_gas <- renderDataTable({
    data <- pay_table_data_gas()
    data$Year <- as.character(data$Year)
    # Get the name of the first column
    first_column_name <- names(data)[1]
    # Pivot the data frame based on the first column's name
    data <- pivot_wider(data, names_from = !!sym(first_column_name), values_from = Value)
    data <- data %>% mutate(across(where(is.numeric), ~ formatC(.x, format = "f", digits = 2)))
    as_tibble(data)
  })
  
  # Download the data link beneath data table
  output$downloadData_total <- downloadHandler(
    filename = function() {
      paste("Agricultural Emissions Data - Total Emissions", min(input$year_total), "to", max(input$year_total), ".csv", sep = " ")
    },
    content = function(file) { 
      data <- pay_table_data_total()
      # Get the name of the first column
      first_column_name <- names(data)[1]
      # Pivot the data frame based on the first column's name
      data <- pivot_wider(data, names_from = !!sym(first_column_name), values_from = Value)
      data <- data %>% mutate(across(where(is.numeric), ~ formatC(.x, format = "f", digits = 5)))
      write.csv(data, file, row.names = FALSE)
    }
  )
  
  output$downloadData_subsector <- downloadHandler(
    filename = function() {
      paste("Agricultural Emissions Data - Subsector Emissions", min(input$year_subsector), "to", max(input$year_subsector), ".csv", sep = " ")
    },
    content = function(file) { 
      data <- pay_table_data_subsector()
      # Get the name of the first column
      first_column_name <- names(data)[1]
      # Pivot the data frame based on the first column's name
      data <- pivot_wider(data, names_from = !!sym(first_column_name), values_from = Value)
      data <- data %>% mutate(across(where(is.numeric), ~ formatC(.x, format = "f", digits = 5)))
      write.csv(data, file, row.names = FALSE)
    }
  )
  
  output$downloadData_gas <- downloadHandler(
    filename = function() {
      paste("Agricultural Emissions Data - Gas Emissions", min(input$year_gas), "to", max(input$year_gas), ".csv", sep = " ")
    },
    content = function(file) { 
      data <- pay_table_data_gas()
      # Get the name of the first column
      first_column_name <- names(data)[1]
      # Pivot the data frame based on the first column's name
      data <- pivot_wider(data, names_from = !!sym(first_column_name), values_from = Value)
      data <- data %>% mutate(across(where(is.numeric), ~ formatC(.x, format = "f", digits = 5)))
      write.csv(data, file, row.names = FALSE)
    }
  )
}

# Load the app
shinyApp(ui, server)
