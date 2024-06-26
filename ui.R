library(shiny)
library(shinyjs)
library(shinythemes)
library(highcharter)

# Source UI modules
source("panels.R")
source("module_line_chart.R")
source("module_data_table.R")
source("options.R")
source("module_area_chart.R")
source("module_bar_chart.R")
source("module_summary.R")
source("hc_theme.R")

# Function to create the footer panel
create_footer <- function() {
  div(
    class = "footer",
    span("Last Updated: ", Sys.Date()),
    img(src = "sg.png", alt = "SG Logo", style = "height: 30px; margin-left: 10px;")
  )
}

# Function to generate the sidebar layout for each tab
generate_sidebar_layout <- function(id_prefix, chart_type) {
  sidebarLayout(
    sidebarPanel(
      id = "sidebar",
      width = 3,
      uiOutput(paste0("variable_select_", id_prefix)),
      actionButton(paste0("select_all_button_", id_prefix), "Select All"),
      actionButton(paste0("deselect_all_button_", id_prefix), "Deselect All"),
      div(chooseSliderSkin("Flat"),
          sliderInput(paste0("year_", id_prefix), "Select year range", value = c(1990, 2022), min = 1990, max = 2022, step = 1, sep = "", ticks = TRUE))
    ),
    mainPanel(
      id = "mainpanel",
      width = 9,
      tabsetPanel(
        id = paste0(id_prefix, "_tabs"),
        tabPanel("Summary Page",
                 fluidRow(
                   column(width = 4, sliderInput(paste0("summary_current_year_", id_prefix), "Current Year", min = 1990, max = 2022, value = 2022, step = 1)),
                   column(width = 4, sliderInput(paste0("summary_comparison_year_", id_prefix), "Comparison Year", min = 1990, max = 2022, value = 2021, step = 1))
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
        tabPanel("Bar Chart", barChartUI(paste0("barChart_", id_prefix))),
        tabPanel("Line Chart", lineChartUI(paste0("lineChart_", id_prefix))),
        tabPanel("Area Chart", areaChartUI(paste0("areaChart_", id_prefix))),
        tabPanel("Data Table",
                 dataTableOutput(paste0("pay_table_", id_prefix)),
                 downloadButton(paste0("downloadData_", id_prefix), "Download Data")
        )
      )
    )
  )
}

# Generate the UI
ui <- fluidPage(
  useShinyjs(),  # Initialize shinyjs
  theme = shinytheme("flatly"),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
    tags$script(HTML("
      $(document).ready(function() {
        $('#toggleSidebar').on('click', function() {
          $('#sidebar').toggle();
          $('#mainpanel').toggleClass('col-sm-9 col-sm-12');
          setTimeout(function() {
            $(window).trigger('resize');
            Highcharts.charts.forEach(function(chart) {
              if (chart) {
                chart.reflow();
              }
            });
          }, 300); // Delay to ensure the toggle animation is complete
        });
      });
    "))
  ),
  div(class = "container-fluid full-height",
      div(class = "content",
          navbarPage(
            title = div(
              div("Agricultural Emissions Dashboard", style = "flex-grow: 1;"),
              img(src = "RESAS Logo.png", class = "header-logo")
            ),
            id = "navbar",
            header = tags$li(class = "dropdown",
                             tags$a(href = "#", id = "toggleSidebar", class = "dropdown-toggle", `data-toggle` = "dropdown",
                                    tags$i(class = "fa fa-bars"), "Toggle Sidebar"
                             )
            ),
            tabPanel("Agriculture Emissions", value = "subsector", generate_sidebar_layout("subsector", "Subsector Emissions")),
            tabPanel("Industry Emissions", value = "total", generate_sidebar_layout("total", "Total Emissions")),
            tabPanel("Gas Emissions", value = "gas", generate_sidebar_layout("gas", "Gas Emissions"))
          )
      ),
      create_footer()
  )
)
