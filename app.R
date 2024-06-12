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

# Helper function to create the header
headerUI <- function() {
  tags$head(
    includeHTML("google-analytics.html"),
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  )
}



# Helper function to create the main panel content
mainPanelUI <- function(id) {
  ns <- NS(id)
  mainPanel(
    width = 12,
    tabsetPanel(
      type = "tabs",
      tabPanel("Plot",
               h1(textOutput(ns("title"))),
               h2(align = "center", highchartOutput(ns("line_chart"))),
               h2("Note:"),
               p("To remove a crop from the chart, either deselect from the sidebar menu or click on its legend."),
               p("You can see data values for a specific year by hovering your mouse over the line.")
      ),
      tabPanel("Data Table",
               dataTableOutput(ns("pay_table")),
               downloadButton(ns("downloadData"), "Download Data")
      )
    )
  )
}
# Helper function to create the sidebar
sidebarUI <- function(id, default_chart_type) {
  ns <- NS(id)
  sidebarPanel(
    width = 3,
    div(class = "hidden-radio-buttons",  # Assigning the custom class to the div
        radioButtons(ns("chart_type"), "",
                     choices = c("Total Emissions", "Subsector Emissions", "Gas Emissions"),
                     selected = default_chart_type)),
    uiOutput(ns("variable_select")),
    actionButton(ns("select_all_button"), "Select All"),
    actionButton(ns("deselect_all_button"), "Deselect All"),
    div(chooseSliderSkin("Flat"),
        sliderInput(ns("year"), "Select year range", value = c(1990, 2023), min = 1990, max = 2023, step = 1, sep = "", ticks = TRUE)),
    tags$style(".hidden-radio-buttons { position: absolute; left: -9999px; }")  # CSS to position the radio button group off the screen
  )
}





# UI
ui <- navbarPage(
  theme = shinytheme("flatly"),
  headerUI(),
  tabPanel("Total Emissions", 
           sidebarLayout(
             sidebarUI("total_emissions", default_chart_type = "Total Emissions"),
             mainPanelUI("total_emissions")
           )),
  tabPanel("Subsector Emissions", 
           sidebarLayout(
             sidebarUI("subsector_emissions", default_chart_type = "Subsector Emissions"),
             mainPanelUI("subsector_emissions")
           )),
  tabPanel("Gas Emissions", 
           sidebarLayout(
             sidebarUI("gas_emissions", default_chart_type = "Gas Emissions"),
             mainPanelUI("gas_emissions")
           ))
)

# Set up server
server <- function(input, output, session) {
  # Function to handle the logic for each tab
  server_logic <- function(id, default_chart_type) {
    moduleServer(id, function(input, output, session) {
      # Reactive for variables based on chart type
      variables <- reactive({
        get_variables(input$chart_type)
      })
      
      # Output for variable selection
      output$variable_select <- renderUI({
        checkboxGroupInput(session$ns("variables"), "Choose variables to add to chart", choices = variables(), selected = variables())
      })
      
      # Event handler for "Select All" button
      observeEvent(input$select_all_button, {
        updateCheckboxGroupInput(session, "variables", selected = variables())
      })
      
      # Event handler for "Deselect All" button
      observeEvent(input$deselect_all_button, {
        updateCheckboxGroupInput(session, "variables", selected = character(0))  # Deselect all
      })
      
      # Function to get the appropriate dataset based on the chart type
      get_chart_data <- function(chart_type) {
        switch(chart_type,
               "Total Emissions" = national_total,
               "Subsector Emissions" = subsector_total,
               "Gas Emissions" = agri_gas)
      }
      
      # Reactive expression for chart data
      chart_data <- reactive({
        data <- get_chart_data(input$chart_type)
        data <- filter(data, Year >= min(input$year) & Year <= max(input$year))
        data <- filter(data, !!sym(names(data)[1]) %in% input$variables)  # Dynamically reference the first column
        data
      })
      
      # Reactive expression for column names
      column_name <- reactive({
        names(chart_data())[1]
      })
      
      # Render line chart
      lineChartServer("line_chart", chart_data, column_name, output$title, yAxisTitle)
      
      # Render titles for each tab
      output$title <- renderText({
        paste(input$chart_type, "in Agriculture,", min(input$year), "to", max(input$year))
      })
      
      # Reactive expression for yAxisTitle
      yAxisTitle <- reactive({
        switch(input$chart_type,
               "Total Emissions" = "Total Emissions (MtCO2e)",
               "Subsector Emissions" = "Emissions by Subsector (MtCO2e)",
               "Gas Emissions" = "Emissions by Gas (MtCO2e)")
      })
      
      # Reactive expression for data table
      pay_table_data <- reactive({
        chart_data()
      })
      
      # Rendering the Data Table
      output$pay_table <- renderDataTable({
        data <- pay_table_data()
        data$Year <- as.character(data$Year)
        # Get the name of the first column
        first_column_name <- names(data)[1]
        # Pivot the data frame based on the first column's name
        data <- pivot_wider(data, names_from = !!sym(first_column_name), values_from = Value)
        data <- data %>% mutate(across(where(is.numeric), ~ formatC(.x, format = "f", digits = 2)))
        as_tibble(data)
      })
      
      # Download the data link beneath data table
      output$downloadData <- downloadHandler(
        filename = function() {
          paste("Agricultural Emissions Data -", input$chart_type, min(input$year), "to", max(input$year), ".csv", sep = " ")
        },
        content = function(file) { 
          data <- pay_table_data()
          # Get the name of the first column
          first_column_name <- names(data)[1]
          # Pivot the data frame based on the first column's name
          data <- pivot_wider(data, names_from = !!sym(first_column_name), values_from = Value)
          data <- data %>% mutate(across(where(is.numeric), ~ formatC(.x, format = "f", digits = 5)))
          write.csv(data, file, row.names = FALSE)
        }
      )
    })
  }
  
  
  
  # Apply server logic to each tab using lapply
  lapply(list(c("total_emissions", "Total Emissions"), 
              c("subsector_emissions", "Subsector Emissions"), 
              c("gas_emissions", "Gas Emissions")), 
         function(x) server_logic(x[1], x[2]))
}
# Load the app
shinyApp(ui, server)