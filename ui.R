# ui.R

# Source UI modules
source("panels.R")
source("module_line_chart.R")
source("module_data_table.R")
source("options.R")
source("module_area_chart.R")
source("module_bar_chart.R")
source("module_summary.R")
source("hc_theme.R")
library(shinyjs)

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
                   column(width = 4, sliderInput(paste0("summary_current_year_", id_prefix), "Current Year", min = 1990, max = 2022, value = 2022, step = 1, sep = "")),
                   column(width = 4, sliderInput(paste0("summary_comparison_year_", id_prefix), "Comparison Year", min = 1990, max = 2022, value = 2021, step = 1, sep = ""))
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
        tabPanel("Bar Chart", div(id = "chartArea", barChartUI(paste0("barChart_", id_prefix))), value = paste0(id_prefix, "_bar")),
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

# Generate the UI
ui <- fluidPage(
  useShinyjs(),  # Initialize shinyjs
  theme = shinytheme("flatly"),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
    tags$script(HTML("
      $(document).ready(function() {
        $('#toggleSidebar').on('click', function() {
          var isVisible = $('#sidebar_total, #sidebar_subsector, #sidebar_gas').is(':visible');
          $('#sidebar_total, #sidebar_subsector, #sidebar_gas').toggle();
          if (isVisible) {
            $('#mainpanel_total, #mainpanel_subsector, #mainpanel_gas').removeClass('col-sm-9').addClass('col-sm-12');
          } else {
            $('#mainpanel_total, #mainpanel_subsector, #mainpanel_gas').removeClass('col-sm-12').addClass('col-sm-9');
          }
          setTimeout(function() {
            $(window).trigger('resize');
            Highcharts.charts.forEach(function(chart) {
              if (chart) {
                chart.reflow();
              }
            });
          }, 300); // Delay to ensure the toggle animation is complete
        });

        Shiny.addCustomMessageHandler('sidebarState', function(message) {
          if (message === 'close') {
            $('#sidebar_total, #sidebar_subsector, #sidebar_gas').hide();
            $('#mainpanel_total, #mainpanel_subsector, #mainpanel_gas').removeClass('col-sm-9').addClass('col-sm-12');
          } else {
            $('#sidebar_total, #sidebar_subsector, #sidebar_gas').show();
            $('#mainpanel_total, #mainpanel_subsector, #mainpanel_gas').removeClass('col-sm-12').addClass('col-sm-9');
          }
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
              div("Agricultural Emissions Dashboard", style = "display: inline-block; margin-right: 20px;"),
              actionLink("toggleSidebar", icon("bars"), class = "nav-link", style = "display: inline-block; vertical-align: middle;"),
              tags$li(class = "nav-item", img(src = "RESAS Logo.png", class = "header-logo"))
            ),
            id = "navbar",
            tabPanel("Agriculture Emissions", value = "subsector", generate_sidebar_layout("subsector", "Subsector Emissions")),
            tabPanel("Industry Emissions", value = "total", generate_sidebar_layout("total", "Total Emissions")),
            tabPanel("Gas Emissions", value = "gas", generate_sidebar_layout("gas", "Gas Emissions"))
          )
      ),
      create_footer()
  )
)
