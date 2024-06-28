# Function to generate the sidebar panel
generate_sidebar_panel <- function(id_prefix) {
  sidebarPanel(
    width = 3,
    uiOutput(paste0("variable_select_", id_prefix)),  # Placeholder for variable selection UI
    actionButton(paste0("select_all_button_", id_prefix), "Select All"),  # 'Select All' button
    actionButton(paste0("deselect_all_button_", id_prefix), "Deselect All"),  # 'Deselect All' button
    div(chooseSliderSkin("Flat"),
        # Slider input for selecting the year range
        sliderInput(paste0("year_", id_prefix), "Select year range", value = c(1990, 2022), min = 1990, max = 2022, step = 1, sep = "", ticks = TRUE))
  )
}

# Function to generate the value boxes for the top 3 industries
generate_top_industries <- function(id_prefix) {
  fluidRow(
    column(width = 4, valueBoxUI(paste0("totalIndustry1_", id_prefix)), style = "padding-right: 0; padding-left: 0;"),
    column(width = 4, valueBoxUI(paste0("totalIndustry2_", id_prefix)), style = "padding-right: 0; padding-left: 0;"),
    column(width = 4, valueBoxUI(paste0("totalIndustry3_", id_prefix)), style = "padding-right: 0; padding-left: 0;")
  )
}

# Function to generate the bottom row of the summary page
generate_summary_bottom_row <- function(id_prefix, chart_type) {
  tagList(
    fluidRow(
      column(width = 4, 
             valueBoxUI(paste0("totalValue_", id_prefix)), 
             div(
               div(class = "header-text", style = "padding-left: 15px;", "Publications:"), # Adjust padding as needed
               box(
                 title = NULL, 
                 width = 12, 
                 solidHeader = TRUE, 
                 "insert text here",
                 style = "margin-top: 10px; padding-left: 15px;" # Adjust padding and margin as needed
               )
             ),
             style = "padding-right: 0; padding-left: 0;"
      ),
      column(width = 4,
             if (chart_type == "Total Emissions") {
               chartUI(paste0("industryLineChart_", id_prefix), "Industry Emissions Over Time")
             } else {
               chartUI(paste0("industryPieChart_", id_prefix), "Category Breakdown")
             },
             style = "padding-right: 0; padding-left: 0;"
      ),
      column(width = 4, 
             chartUI(paste0("industryBarChart_", id_prefix), "Emissions by Category"), 
             style = "padding-right: 0; padding-left: 0;"
      )
    )
  )
}


# Function to generate the sidebar layout for each tab
generate_sidebar_layout <- function(id_prefix, chart_type) {
  sidebarLayout(
    sidebarPanel(
      id = paste0("sidebar_", id_prefix),
      width = 3,
      uiOutput(paste0("variable_select_", id_prefix)),
      actionButton(paste0("select_all_button_", id_prefix), "Select All"),
      actionButton(paste0("deselect_all_button_", id_prefix), "Deselect All"),
      div(chooseSliderSkin("Flat"),
          sliderInput(paste0("year_", id_prefix), "Select year range", value = c(1990, 2022), min = 1990, max = 2022, step = 1, sep = "", ticks = TRUE))
    ),
    mainPanel(
      id = paste0("mainpanel_", id_prefix),
      width = 9,
      tabsetPanel(
        id = paste0(id_prefix, "_tabs"),
        tabPanel("Summary Page",
                 value = paste0(id_prefix, "_summary"),
                 fluidRow(
                   column(width = 4, sliderInput(paste0("summary_current_year_", id_prefix), "Current Year", min = 1990, max = 2022, value = 2022, step = 1)),
                   column(width = 4, sliderInput(paste0("summary_comparison_year_", id_prefix), "Comparison Year", min = 1990, max = 2022, value = 2021, step = 1)),
                   column(width = 4,
                          div(
                            style = "margin-top: 25px; text-align: center; border: 10px solid #e3e3e3", # Add border style
                            h5("Adjust the sliders to compare data from different years.", style = "padding: 0px; font-weight: bold;")
                          )
                   )
                 ),
                 fluidRow(
                   column(width = 12, div(class = "header-text", "Top 3 Categories:"))
                 ),
                 generate_top_industries(id_prefix),
                 fluidRow(
                   column(width = 12, div(class = "header-text", "Summary Analysis:"))
                 ),
                 generate_summary_bottom_row(id_prefix, chart_type)
        ),
        tabPanel("Timelapse", div(id = "chartArea", barChartUI(paste0("barChart_", id_prefix))), value = paste0(id_prefix, "_bar")),
        tabPanel("Line Chart", div(id = "chartArea", lineChartUI(paste0("lineChart_", id_prefix))), value = paste0(id_prefix, "_line")),
        tabPanel("Area Chart", div(id = "chartArea", areaChartUI(paste0("areaChart_", id_prefix))), value = paste0(id_prefix, "_area")),
        tabPanel("Data Table",
                 dataTableOutput(paste0("pay_table_", id_prefix)),
                 downloadButton(paste0("downloadData_", id_prefix), "Download Data"),
                 value = paste0(id_prefix, "_data"))       
      )
    )
  )
}