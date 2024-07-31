#module_sidebar.R

# Function to generate the sidebar panel
generate_sidebar_panel <- function(id_prefix) {
  div(
    id = paste0("sidebar_", id_prefix),
    sidebarPanel(
      width = 3,
      uiOutput(paste0("variable_select_", id_prefix)),  # Placeholder for variable selection UI
      actionButton(paste0("select_all_button_", id_prefix), "Select All"),  # 'Select All' button
      actionButton(paste0("deselect_all_button_", id_prefix), "Deselect All"),  # 'Deselect All' button
      div(chooseSliderSkin("Flat"),
          # Slider input for selecting the year range
          sliderInput(paste0("year_", id_prefix), "Select year range", value = c(1990, 2022), min = 1990, max = 2022, step = 1, sep = "", ticks = TRUE))
    )
  )
}

# Function to generate the main panel
generate_main_panel <- function(id_prefix) {
  div(
    id = paste0("main_", id_prefix),
    mainPanel(
      width = 9,
      tabsetPanel(
        tabPanel("Summary Page", 
                 fluidRow(
                   column(width = 12, div(class = "header-text", "Top 3 Categories:"))
                 ),
                 fluidRow(
                   column(width = 4, valueBoxUI(paste0("totalIndustry1_", id_prefix)), style = "padding-right: 0; padding-left: 0;"),
                   column(width = 4, valueBoxUI(paste0("totalIndustry2_", id_prefix)), style = "padding-right: 0; padding-left: 0;"),
                   column(width = 4, valueBoxUI(paste0("totalIndustry3_", id_prefix)), style = "padding-right: 0; padding-left: 0;")
                 ),
                 fluidRow(
                   column(width = 12, div(class = "header-text", "Summary Analysis:"))
                 ),
                 fluidRow(
                   column(width = 4, valueBoxUI(paste0("totalValue_", id_prefix)), style = "padding-right: 0; padding-left: 0;"),
                   column(width = 4, chartUI(paste0("industryPieChart_", id_prefix), "Category Breakdown"), style = "padding-right: 0; padding-left: 0;"),
                   column(width = 4, chartUI(paste0("industryBarChart_", id_prefix), "Emissions by Category"), style = "padding-right: 0; padding-left: 0;")
                 )
        ),
        tabPanel("Bar Chart", barChartUI(paste0("barChart_", id_prefix))),  # Bar chart tab
        tabPanel("Line Chart", lineChartUI(paste0("lineChart_", id_prefix))),  # Line chart tab
        tabPanel("Area Chart", areaChartUI(paste0("areaChart_", id_prefix))),  # Area chart tab
        tabPanel("Data Table", 
                 dataTableOutput(paste0("pay_table_", id_prefix)),  # Data table output
                 downloadButton(paste0("downloadData_", id_prefix), "Download Data")  # Download button
        )
      )
    )
  )
}

# Function to generate the sidebar layout for each tab
generate_sidebar_layout <- function(id_prefix) {
  sidebarLayout(
    generate_sidebar_panel(id_prefix),  # Generate sidebar panel
    generate_main_panel(id_prefix)  # Generate main panel
  )
}
